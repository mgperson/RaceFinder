using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;

public partial class Default2 : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {                
        string method = Request["method"] ?? string.Empty;     

        if (!string.IsNullOrEmpty(method))
        {
            switch (method.ToUpper())
            {
                case "SEARCHRACES":
                    this.SearchRaces();
                    break;
            }
        }
    }

    private void SearchRaces()
    {
        string category = Request["category"].ToString();
        string latitude = Request["lat"].ToString();
        string longitude = Request["long"].ToString();
        
        string parameterNames = "k,v,l,api_key";
        string parameterValues = category + ",xml," + latitude + ";" + longitude + ",wuhmn9ye94xn3xnteudxsavw";

        //string response = HttpPost("http://api.amp.active.com/search", parameterNames.Split(','), parameterValues.Split(','));

        string response = HttpGet("http://api.amp.active.com/search?" + "k=" + category + "&v=xml&l=" + latitude + ";" + longitude + "&api_key=wuhmn9ye94xn3xnteudxsavw");

        string racesHTML = GenerateRacesHTML(response);

        Response.Clear();

        Response.Write(racesHTML);

        Response.End();
    }

    private string GenerateRacesHTML(string response)
    {
        StringBuilder racesHTML = new StringBuilder();

        int raceNumber = 0;
        string nodeTitle = string.Empty;
        string nodeDescription = string.Empty;
        string nodeImageURL = string.Empty;
        string nodeRegistrationURL = string.Empty;
        string nodeCity = string.Empty;
        string nodeAddress = string.Empty;

        XmlDocument xmlDocument = new XmlDocument();

        xmlDocument.LoadXml(response);

        XmlNodeList parentNodes = xmlDocument.GetElementsByTagName("result");

        foreach (XmlNode resultNode in parentNodes)
        {            
            nodeTitle = resultNode.SelectSingleNode("title").InnerText;

            XmlNode metaNode = resultNode.SelectSingleNode("meta");
            
            XmlNode xmlNodeDescription = metaNode.SelectSingleNode("allText");
            if (xmlNodeDescription != null) nodeDescription = xmlNodeDescription.InnerText;

            XmlNode xmlNodeImage = metaNode.SelectSingleNode("image1");
            if (xmlNodeImage != null) nodeImageURL = xmlNodeImage.InnerText;
            XmlNode xmlNodeRegistration = metaNode.SelectSingleNode("seoUrl");
            if (xmlNodeRegistration != null) nodeRegistrationURL = xmlNodeRegistration.InnerText;

            XmlNode xmlNodecity = metaNode.SelectSingleNode("city");
            if (xmlNodecity != null) nodeAddress = xmlNodecity.InnerText;

            XmlNode xmlNodeaddress = metaNode.SelectSingleNode("address");
            if (xmlNodeaddress != null) nodeAddress = xmlNodeaddress.InnerText;


            racesHTML.Append("<div id='race" + (raceNumber++).ToString() + "' style='display:none'>");
            racesHTML.Append("<span class='title'>" + nodeTitle + "</span>");
            racesHTML.Append("<img class='raceImage' src='" + nodeImageURL + "' alt='" + nodeTitle + "' />");
            racesHTML.Append("<div class='title'>" + nodeAddress + nodeCity + "</div>");
            racesHTML.Append("<div class='information'>" + nodeDescription + "</div>");
            racesHTML.Append("<a href='" + nodeRegistrationURL + "' target='blank'>Register Now!</a>");
            racesHTML.Append("</div>");
        }

        return racesHTML.ToString();
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