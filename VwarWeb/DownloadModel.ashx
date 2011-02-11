﻿<%@ WebHandler Language="C#" Class="DownloadModel" %>

using System;
using System.Web;
using System.Configuration;
public class DownloadModel : IHttpHandler {

    private string FedoraUserName
    {
        get
        {
            return (ConfigurationManager.AppSettings["fedoraUserName"]);
        }
    }
    private string FedoraPasswrod
    {
        get
        {
            return (ConfigurationManager.AppSettings["fedoraPassword"]);
        }
    }
    
    public void ProcessRequest (HttpContext context) {
        //context.Response.ContentType = "text/plain";
        //context.Response.Write("Hello World");


        var pid = context.Request.QueryString["PID"];
        var format = context.Request.QueryString["Format"];
        
            var factory = new vwarDAL.DataAccessFactory();
            vwarDAL.IDataRepository vd = factory.CreateDataRepositorProxy();

            var url = "";
            vwarDAL.ContentObject co = vd.GetContentObjectById(pid, false);

            string fileName = "";
            if (format == "o3dtgz" || format == "o3d")
            {
                fileName = co.DisplayFile;
            }
                
            
            if (format == "dae" || format == "collada")
            {
                fileName = co.Location;
               
            }
        
            url = vd.GetContentUrl(pid, fileName);

            if (format == "o3dtgz" || format == "o3d")
            {
                fileName = co.DisplayFile + "tgz";
            }
        
            if (String.IsNullOrEmpty(url)) return;

            var creds = new System.Net.NetworkCredential(FedoraUserName, FedoraPasswrod);
            context.Response.Clear();
            context.Response.AppendHeader("content-disposition", "attachment; filename=" + fileName );
            context.Response.ContentType = vwarDAL.FedoraCommonsRepo.GetMimeType(fileName);
            // string localPath = Path.GetTempFileName();
            using (System.Net.WebClient client = new System.Net.WebClient())
            {
                try
                {
                    client.Credentials = creds;
                    //client.DownloadFile(url, localPath);
                    context.Response.BinaryWrite(client.DownloadData(url));
                }
                catch { }

            }

         
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}