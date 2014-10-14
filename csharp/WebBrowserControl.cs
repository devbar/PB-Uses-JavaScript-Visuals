using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Drawing;
using System.Data;
using System.Text;
using System.Windows.Forms;
using System.Security.Permissions;

namespace ComInteropWebbrowser {

    [PermissionSet(SecurityAction.Demand, Name = "FullTrust")]
    [System.Runtime.InteropServices.ComVisibleAttribute(true)]
    public partial class WebBrowserControl : UserControl {

        public delegate void JsEventHandler(string data);
        public event JsEventHandler JsTriggered;

        public bool ScrollBarsEnabled{
            get {
                return this.webBrowser1.ScrollBarsEnabled;
            }
            set {
                this.webBrowser1.ScrollBarsEnabled = value;
            } 
        }

        /// <summary>
        /// Constructor
        /// </summary>
        public WebBrowserControl() {
            InitializeComponent();

            webBrowser1.AllowWebBrowserDrop = false;
            webBrowser1.IsWebBrowserContextMenuEnabled = false;
            webBrowser1.WebBrowserShortcutsEnabled = false;
            webBrowser1.ObjectForScripting = this;
            webBrowser1.ScriptErrorsSuppressed = true;
        }

        /// <summary>
        /// Inject JavaScript to the current application
        /// </summary>
        /// <param name="source">Current JS code</param>
        public void JsInject(string source) {
            HtmlDocument document = webBrowser1.Document;
            HtmlElement head = document.GetElementsByTagName("head")[0];
            HtmlElement script = document.CreateElement("script");
            script.SetAttribute("text", source);
            head.AppendChild(script);
        }

        /// <summary>
        /// Invoke JavaScript method of te current application
        /// </summary>
        /// <param name="method">method to call</param>
        public void JsInvoke(string method) {
            this.webBrowser1.Document.InvokeScript(method);
        }

        /// <summary>
        /// Trigger JavaScript method
        /// </summary>
        /// <param name="data">payload</param>
        public void JsTrigger(string data) {
            if (this.JsTriggered != null) this.JsTriggered(data);
        }

        /// <summary>
        /// Navigate to the given url
        /// </summary>
        /// <param name="url"></param>
        public void Navigate(string url) {
            this.webBrowser1.Navigate(url);
        }
    }
}
