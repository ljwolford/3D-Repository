﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using System.Xml;
using System.Xml.Serialization;
using System.Net;
using vwarDAL.FedoraAPIA;
using System.Xml.Linq;

namespace vwarDAL
{
    public class FedoraCommonsRepo : IDataRepository
    {
        private readonly System.Net.NetworkCredential _Credantials;
        private const string DUBLINCOREID = "Dublin Core Record for this object";
        private readonly string _BaseUrl;
        private static readonly string BASECONTENTURL = "{0}objects/{1}/datastreams/{2}/";
        private static readonly string DOWNLOADURL = BASECONTENTURL + "content";
        private static readonly string REVIEWNAMESPACE = "review";
        internal FedoraCommonsRepo(string url, string userName, string password)
        {
            _BaseUrl = url;
            _Credantials = new System.Net.NetworkCredential(userName, password);
        }
        private FedoraAPIA.FedoraAPIAService GetAccessService()
        {
            FedoraAPIA.FedoraAPIAService svc = new FedoraAPIA.FedoraAPIAService();
            svc.Credentials = _Credantials;
            return svc;
        }
        private FedoraAPIM.FedoraAPIMService GetManagementService()
        {
            FedoraAPIM.FedoraAPIMService svc = new FedoraAPIM.FedoraAPIMService();
            svc.Credentials = _Credantials;
            return svc;
        }
        public IEnumerable<ContentObject> GetAllContentObjects()
        {
            return QueryContentObjects("pid", "adl:*", ComparisonOperator.has);
        }
        private IEnumerable<ContentObject> QueryContentObjects(string field, string value, ComparisonOperator op, string count = "100000")
        {

            string[] fieldsToSearch = new string[] { "pid" };

            using (var asrv = GetAccessService())
            {
                FieldSearchQuery fsq = new FieldSearchQuery();


                FieldSearchQueryConditions fsqConditions = new FieldSearchQueryConditions();

                Condition c = new Condition();

                Condition c2 = new Condition();
                c2.property = field;
                c2.@operator = op;
                c2.value = value;

                fsqConditions.condition = new Condition[] { c2 };

                fsq.Item = fsqConditions;

                FieldSearchResult results = asrv.findObjects(fieldsToSearch, count, fsq);
                List<ContentObject> cos = new List<ContentObject>();
                foreach (var result in results.resultList)
                {
                    cos.Add(GetContentObjectById(result.pid, false));
                }
                return cos;
            }
        }
        public IEnumerable<ContentObject> GetContentObjectsByCollectionName(string collectionName)
        {

            return QueryContentObjects("CollectionName", collectionName, ComparisonOperator.eq);
        }

        public IEnumerable<ContentObject> GetHighestRated(int count)
        {
            var cos =(from c in GetAllContentObjects()
                    orderby c.Reviews.Sum( (Review r) => r.Rating) descending
                    select c); 
            return cos.Take(count);
        }

        public IEnumerable<ContentObject> GetMostPopular(int count)
        {
            return (from c in GetAllContentObjects()
                    orderby c.Views descending
                    select c).Take(count);
        }

        public IEnumerable<ContentObject> GetRecentlyUpdated(int count)
        {
            return (from c in GetAllContentObjects()
                    orderby c.LastModified descending
                    select c).Take(count);
        }

        public void InsertReview(int rating, string text, string submitterEmail, string contentObjectId)
        {
            Review review = new Review()
            {
                Rating = rating,
                Text = text,
                SubmittedBy = submitterEmail,
                SubmittedDate = DateTime.Now
            };
            using (var srv = GetManagementService())
            {
                contentObjectId = contentObjectId.Replace("~", ":");
                var contentId = srv.getNextPID("1", REVIEWNAMESPACE)[0].Replace(":", "");
                srv.addDatastream(contentObjectId,
                    contentId,
                    new string[0],
                    contentId,
                    true,
                    "text/xml",
                    "",
                    GetContentUrl(contentObjectId, "Dublin Core Record for this object"),
                    "X",
                    "A",
                    "Disabled",
                    "none",
                    "Add Review"
                    );
                string requestURL = String.Format(BASECONTENTURL, _BaseUrl, contentObjectId, contentId);
                try
                {
                    using (WebClient client = new WebClient())
                    {
                        client.Credentials = _Credantials;
                        client.Headers.Add("Content-Type", "text/xml");
                        client.UploadString(requestURL, review.Serialize());
                    }
                }
                catch (WebException exception)
                {

                    var rs = exception.Response.GetResponseStream();
                    using (StreamReader reader = new StreamReader(rs))
                    {
                        var error = reader.ReadToEnd();
                        Console.WriteLine(error);
                    }
                }
            }
        }

        public void UpdateContentObject(ContentObject co)
        {
            co.PID = co.PID.Replace("~", ":");
            if (_Memory.ContainsKey(co.PID))
            {
                _Memory[co.PID] = co;
            }
            var metadataUrl = GetContentUrl(co.PID, DUBLINCOREID);
            using (var srv = GetManagementService())
            {
                srv.modifyObject(co.PID, "A", co.Title, "", "update");
            }
            using (WebClient client = new WebClient())
            {
                client.Credentials = _Credantials;
                var dublicCoreData = client.DownloadString(metadataUrl);
                dublicCoreData = dublicCoreData.Replace("\r", "").Replace("\n", "");
                var match = System.Text.RegularExpressions.Regex.Replace(dublicCoreData, "<ContentObjectMetadata.*</ContentObjectMetadata>", co._Metadata.Serialize().Replace("<?xml version=\"1.0\"?>", "").Trim());
                client.UploadString(metadataUrl.Replace("content", ""), "PUT", match);
            }

        }

        public IEnumerable<ContentObject> GetRecentlyViewed(int count)
        {
            return (from c in GetAllContentObjects()
                    orderby c.LastViewed
                    select c).Take(count);
        }

        public IEnumerable<ContentObject> SearchContentObjects(string searchTerm)
        {
            var svc = GetAccessService();
            FedoraAPIA.FieldSearchQuery query = new FedoraAPIA.FieldSearchQuery();
            query.Item = searchTerm;
            var results = svc.findObjects(new String[] { "pid" }, "5000000", query);
            List<ContentObject> objects = new List<ContentObject>();
            foreach (var result in results.resultList)
            {
                objects.Add(GetContentObjectById(result.pid, false));
            }
            return objects;
        }

        public IEnumerable<ContentObject> GetContentObjectsBySubmitterEmail(string email)
        {
            return GetAllContentObjects();
        }

        private Dictionary<String, ContentObject> _Memory = new Dictionary<string, ContentObject>();
        public ContentObject GetContentObjectById(string pid, bool updateViews)
        {
            var co = new ContentObject()
            {
                PID = pid.Replace(':', '~'),
                Reviews = new List<Review>()
            };
            if (_Memory.ContainsKey(co.PID))
            {
                co = _Memory[co.PID];
            }
            else
            {
                using (var svc = GetManagementService())
                {
                    pid = pid.Replace('~', ':');
                    var bytes = svc.getObjectXML(pid);


                    var dataStreams = svc.getDatastreams(pid, DateTime.Now.ToString(), "A");
                    var reviews = from r in dataStreams
                                  where r.ID.StartsWith(REVIEWNAMESPACE, StringComparison.InvariantCultureIgnoreCase)
                                  select r;

                    WebClient client = new WebClient();
                    client.Credentials = _Credantials;
                    foreach (var r in reviews)
                    {
                        var url = string.Format(DOWNLOADURL, _BaseUrl, pid, r.ID);
                        var data = client.DownloadString(url);
                        var review = new Review();
                        review.Deserialize(data);
                        co.Reviews.Add(review);
                    }
                    var dublicCoreData = client.DownloadString(GetContentUrl(co.PID, DUBLINCOREID));
                    var dublicCoreDocument = new XmlDocument();
                    dublicCoreDocument.LoadXml(dublicCoreData);
                    var coMetaData = ((XmlElement)dublicCoreDocument.FirstChild).GetElementsByTagName("ContentObjectMetadata")[0];
                    co._Metadata = new ContentObjectMetadata();
                    co._Metadata.Deserialize(coMetaData.OuterXml);


                }
                _Memory.Add(co.PID, co);
            }
            if (updateViews)
            {
                co.Views++;
                UpdateContentObject(co);
            }
            return co;
        }

        public void DeleteContentObject(string id)
        {
            using (var srv = GetManagementService())
            {
                var co = GetContentObjectById(id, false);
                srv.modifyObject(id, "D", co.Label, "", "");
            }
        }

        public void InsertContentObject(ContentObject co)
        {
            using (var srv = GetManagementService())
            {
                var pid = string.IsNullOrEmpty(co.PID) ? srv.getNextPID("1", "adl")[0] : co.PID;
                co.PID = pid;
                var dataObject = CreateDigitalObject(co);
                var data = SerializeObject(dataObject);
                srv.ingest(data, "info:fedora/fedora-system:FOXML-1.1", "add file");
                var dsId = srv.getNextPID("1", "metadata")[0].Replace(":", "");
                var metadataUrl = GetContentUrl(pid, DUBLINCOREID);
                WebClient client = new WebClient();
                client.Credentials = _Credantials;
                var dublinCoreMetadata = client.DownloadString(metadataUrl);
                var dublinCoreXmlDoc = new XmlDataDocument();
                dublinCoreXmlDoc.LoadXml(dublinCoreMetadata);
                var root = dublinCoreXmlDoc.FirstChild;
                var objectMetadata = co._Metadata.Serialize();
                root.InnerXml += objectMetadata.Replace("<?xml version=\"1.0\"?>", "").Trim();
                metadataUrl = metadataUrl.Replace("/content", "");
                client.UploadString(metadataUrl, "PUT", dublinCoreXmlDoc.OuterXml);
            }
        }

        private static byte[] SerializeObject(object dataObject)
        {
            XmlSerializer s = new XmlSerializer(dataObject.GetType());
            using (MemoryStream stream = new MemoryStream())
            {
                s.Serialize(stream, dataObject);
                stream.Position = 0;
                byte[] data = new byte[stream.Length];
                stream.Read(data, 0, data.Length);
                return data;
            }
        }

        private static digitalObject CreateDigitalObject(ContentObject co)
        {
            var dObj = new digitalObject();
            dObj.PID = co.PID;
            dObj.objectProperties = new objectPropertiesType();
            dObj.objectProperties.property = new propertyType[1];
            var label = new propertyType();
            label.NAME = propertyTypeNAME.infofedorafedorasystemdefmodellabel;
            label.VALUE = co.Title;
            dObj.objectProperties.property[0] = label;
            return dObj;
        }
        public void UploadFile(string data, string pid, string fileName)
        {
            var mimeType = GetMimeType(fileName);
            using (var srv = GetManagementService())
            {
                string dsid = srv.getNextPID("1", "content")[0].Replace(":", "");
                var output = srv.addDatastream(pid,
                    dsid,
                    new string[] { },
                    fileName,
                    true,
                    mimeType,
                    "",
                    GetContentUrl(pid, "Dublin Core Record for this object"),
                    "M",
                    "A",
                    "Disabled",
                    "none",
                    "add");
                string requestURL = String.Format(BASECONTENTURL, _BaseUrl, pid, output);
                try
                {
                    using (WebClient client = new WebClient())
                    {
                        client.Credentials = _Credantials;
                        client.Headers.Add("Content-Type", mimeType);
                        client.UploadFile(requestURL, data);
                    }
                }
                catch (WebException exception)
                {

                    var rs = exception.Response.GetResponseStream();
                    using (StreamReader reader = new StreamReader(rs))
                    {
                        Console.WriteLine(reader.ReadToEnd());
                    }
                }
            }
        }
        public static string GetMimeType(string fileName)
        {
            if (String.IsNullOrEmpty(fileName)) return "";
            string mimeType = "text/plain";
            string ext = System.IO.Path.GetExtension(fileName).ToLower();
            Microsoft.Win32.RegistryKey regKey = Microsoft.Win32.Registry.ClassesRoot.OpenSubKey(ext);
            if (regKey != null && regKey.GetValue("Content Type") != null)
                mimeType = regKey.GetValue("Content Type").ToString();
            return mimeType;
        }
        public void IncrementDownloads(string id)
        {
            ContentObject co = GetContentObjectById(id, false);
            co.Downloads++;
            UpdateContentObject(co);
        }
        public string GetContentUrl(string pid, string fileName)
        {
            if (String.IsNullOrEmpty(pid) || String.IsNullOrEmpty(fileName)) return "";
            pid = pid.Replace("~", ":");
            string dsid = "";
            using (var srv = GetManagementService())
            {
                var streams = srv.getDatastreams(pid, DateTime.Now.ToString(), "A");
                var dss = (from s in streams
                           where s.label.Equals(fileName, StringComparison.InvariantCultureIgnoreCase)
                           select s);
                if (dss != null && dss.Count() > 0)
                {
                    var ds = dss.First();
                    dsid = ds.ID;
                    return string.Format(DOWNLOADURL, _BaseUrl, pid, dsid);
                }
                return "";

            }
        }
        public byte[] GetContentFileData(string pid, string fileName)
        {
            var url = GetContentUrl(pid, fileName);
            using (var client = new WebClient())
            {
                client.Credentials = _Credantials;
                return client.DownloadData(url);
            }
        }
    }
}
