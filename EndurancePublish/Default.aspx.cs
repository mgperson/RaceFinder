using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.IO;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class _Default : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        string param = "K,v,api_key";
        string paramVals = "triathlon,xml,wuhmn9ye94xn3xnteudxsavw";
        string result = HttpPost("http://api.amp.active.com/search", param.Split(','), paramVals.Split(','));
        /*string param = "";
        string paramVals = "";
        string result = HttpPost("http://api.athlinks.com/athletes/details/10000", param.Split(','), paramVals.Split(','));
        string result = HttpGet("api.athlinks.com/athletes/details/10000");        */        
    }

    static string HttpGet(string url)
    {
        HttpWebRequest req = WebRequest.Create(url)
                             as HttpWebRequest;
        string result = null;
        using (HttpWebResponse resp = req.GetResponse()
                                      as HttpWebResponse)
        {
            StreamReader reader =
                new StreamReader(resp.GetResponseStream());
            result = reader.ReadToEnd();
        }
        return result;
    }

    static string HttpPost(string url,
    string[] paramName, string[] paramVal)
    {
        HttpWebRequest req = WebRequest.Create(new Uri(url))
                             as HttpWebRequest;
        req.Method = "POST";
        req.ContentType = "application/x-www-form-urlencoded";

        // Build a string with all the params, properly encoded.
        // We assume that the arrays paramName and paramVal are
        // of equal length:
        StringBuilder paramz = new StringBuilder();
        for (int i = 0; i < paramName.Length; i++)
        {
            paramz.Append(paramName[i]);
            paramz.Append("=");
            paramz.Append(HttpUtility.UrlEncode(paramVal[i]));
            paramz.Append("&");
        }

        // Encode the parameters as form data:
        byte[] formData =
            UTF8Encoding.UTF8.GetBytes(paramz.ToString());
        req.ContentLength = formData.Length;

        // Send the request:
        using (Stream post = req.GetRequestStream())
        {
            post.Write(formData, 0, formData.Length);
        }

        // Pick up the response:
        string result = null;
        using (HttpWebResponse resp = req.GetResponse()
                                      as HttpWebResponse)
        {
            StreamReader reader =
                new StreamReader(resp.GetResponseStream());
            result = reader.ReadToEnd();
        }

        return result;
    } 
}