using System.ComponentModel;
using System.Runtime.InteropServices;
using Microsoft.VisualBasic;
using System.Windows.Forms;
using System.Security.Permissions;
using System.Drawing;

namespace ComInteropWebbrowser {

    #region Interfaces

    [ComVisible(true), Guid("800E1F84-8C4A-4854-B350-8B116F8DF080"), InterfaceType(ComInterfaceType.InterfaceIsIDispatch)]
    public interface IEventsWebbrowser {
        [DispId(1)]
        void JsTriggered(string arguments);
    }

    [Guid(Webbrowser.InterfaceId), ComVisible(true)]
    public interface IWebbrowser {
        [DispId(1)]
        bool Visible { [DispId(1)] get; [DispId(1)] set; }
        [DispId(2)]
        bool Enabled { [DispId(2)] get; [DispId(2)] set; }
        [DispId(3)]
        int ForegroundColor { [DispId(3)] get; [DispId(3)] set; }
        [DispId(4)]
        int BackgroundColor { [DispId(4)] get; [DispId(4)] set; }
        [DispId(5)]
        Image BackgroundImage { [DispId(5)] get; [DispId(5)] set; }
        [DispId(6)]
        void Refresh();
        [DispId(8)]
        void Navigate(string url);
        [DispId(9)]
        void JsInject(string source);
        [DispId(10)]
        void JsInvoke(string method);
        [DispId(11)]
        bool ScrollBarsEnabled { [DispId(12)] get; [DispId(13)] set; }
    }
    #endregion

    [Guid(Webbrowser.ClassId), ClassInterface(ClassInterfaceType.None)]
    [ComSourceInterfaces("ComInteropWebbrowser.IEventsWebbrowser")]
    [ComClass(Webbrowser.ClassId, Webbrowser.InterfaceId, Webbrowser.EventsId)]
    public partial class Webbrowser : UserControl, IWebbrowser {
        #region VB6 Interop Code

#if COM_INTEROP_ENABLED

        #region "COM Registration"

        //These  GUIDs provide the COM identity for this class 
        //and its COM interfaces. If you change them, existing 
        //clients will no longer be able to access the class.

        public const string ClassId = "29D72998-8734-4ACA-AD5D-EF4E566FA6B4";
        public const string InterfaceId = "06DF8E2D-C27A-41BC-B677-6AD909760AC7";
        public const string EventsId = "E9297657-60AA-47FB-AC01-35461A930F0A";

        //These routines perform the additional COM registration needed by ActiveX controls
        [EditorBrowsable(EditorBrowsableState.Never)]
        [ComRegisterFunction]
        private static void Register(System.Type t) {
            ComRegistration.RegisterControl(t);
        }

        [EditorBrowsable(EditorBrowsableState.Never)]
        [ComUnregisterFunction]
        private static void Unregister(System.Type t) {
            ComRegistration.UnregisterControl(t);
        }


        #endregion

        #region "VB6 Events"

        //This section shows some examples of exposing a UserControl's events to VB6.  Typically, you just
        //1) Declare the event as you want it to be shown in VB6
        //2) Raise the event in the appropriate UserControl event.
        public delegate void ClickEventHandler();
        public delegate void DblClickEventHandler();
        public new event ClickEventHandler Click; //Event must be marked as new since .NET UserControls have the same name.
        public event DblClickEventHandler DblClick;

        private void Webbrowser_Click(object sender, System.EventArgs e) {
            if (null != Click)
                Click();
        }

        private void Webbrowser_DblClick(object sender, System.EventArgs e) {
            if (null != DblClick)
                DblClick();
        }

        public delegate void JsEventHandler(string data);
        public event JsEventHandler JsTriggered;

        #endregion

        #region "VB6 Properties"

        //The following are examples of how to expose typical form properties to VB6.  
        //You can also use these as examples on how to add additional properties.

        //Must Shadow this property as it exists in Windows.Forms and is not overridable
        public new bool Visible {
            get { return base.Visible; }
            set { base.Visible = value; }
        }

        public new bool Enabled {
            get { return base.Enabled; }
            set { base.Enabled = value; }
        }

        public int ForegroundColor {
            get {
                return ActiveXControlHelpers.GetOleColorFromColor(base.ForeColor);
            }
            set {
                base.ForeColor = ActiveXControlHelpers.GetColorFromOleColor(value);
            }
        }

        public int BackgroundColor {
            get {
                return ActiveXControlHelpers.GetOleColorFromColor(base.BackColor);
            }
            set {
                base.BackColor = ActiveXControlHelpers.GetColorFromOleColor(value);
            }
        }

        public override System.Drawing.Image BackgroundImage {
            get { return null; }
            set {
                if (null != value) {
                    MessageBox.Show("Setting the background image of an Interop UserControl is not supported, please use a PictureBox instead.", "Information");
                }
                base.BackgroundImage = null;
            }
        }

        public bool ScrollBarsEnabled {
            get {
                return this.webBrowserControl1.ScrollBarsEnabled;
            }
            set {
                this.webBrowserControl1.ScrollBarsEnabled = value;
            }
        }

        #endregion

        #region "VB6 Methods"

        /// <summary>
        /// Refresh all controls in this control
        /// </summary>
        public override void Refresh() {
            base.Refresh();
        }

        /// <summary>
        /// Inject JavaScript to the current application
        /// </summary>
        /// <param name="source">Current JS code</param>
        public void JsInject(string source) {
            this.webBrowserControl1.JsInject(source);
        }

        /// <summary>
        /// Invoke JavaScript method of te current application
        /// </summary>
        /// <param name="method">method to call</param>
        public void JsInvoke(string method) {
            this.webBrowserControl1.JsInvoke(method);
        }

        /// <summary>
        /// Navigate to the given url
        /// </summary>
        /// <param name="url"></param>
        public void Navigate(string url) {
            this.webBrowserControl1.Navigate(url);
        }

        //Ensures that tabbing across VB6 and .NET controls works as expected
        private void Webbrowser_LostFocus(object sender, System.EventArgs e) {
            ActiveXControlHelpers.HandleFocus(this);
        }

        public Webbrowser() {
            //This call is required by the Windows Form Designer.
            InitializeComponent();

            //' Add any initialization after the InitializeComponent() call.
            this.DoubleClick += new System.EventHandler(this.Webbrowser_DblClick);
            base.Click += new System.EventHandler(this.Webbrowser_Click);
            this.LostFocus += new System.EventHandler(Webbrowser_LostFocus);
            this.ControlAdded += new ControlEventHandler(Webbrowser_ControlAdded);

            //'Raise custom Load event
            this.OnCreateControl();

            this.webBrowserControl1.JsTriggered += webBrowserControl1_JsTriggered;
        }

        public void webBrowserControl1_JsTriggered(string data) {
            if (this.JsTriggered != null) this.JsTriggered(data);
        }

        [SecurityPermission(SecurityAction.LinkDemand, Flags = SecurityPermissionFlag.UnmanagedCode)]
        protected override void WndProc(ref System.Windows.Forms.Message m) {

            const int WM_SETFOCUS = 0x7;
            const int WM_PARENTNOTIFY = 0x210;
            const int WM_DESTROY = 0x2;
            const int WM_LBUTTONDOWN = 0x201;
            const int WM_RBUTTONDOWN = 0x204;

            if (m.Msg == WM_SETFOCUS) {
                //Raise Enter event
                this.OnEnter(System.EventArgs.Empty);
            } else if (m.Msg == WM_PARENTNOTIFY && (m.WParam.ToInt32() == WM_LBUTTONDOWN || m.WParam.ToInt32() == WM_RBUTTONDOWN)) {

                if (!this.ContainsFocus) {
                    //Raise Enter event
                    this.OnEnter(System.EventArgs.Empty);
                }
            } else if (m.Msg == WM_DESTROY && !this.IsDisposed && !this.Disposing) {
                //Used to ensure that VB6 will cleanup control properly
                this.Dispose();
            }

            base.WndProc(ref m);
        }



        //This event will hook up the necessary handlers
        private void Webbrowser_ControlAdded(object sender, ControlEventArgs e) {
            ActiveXControlHelpers.WireUpHandlers(e.Control, ValidationHandler);
        }

        //Ensures that the Validating and Validated events fire appropriately
        internal void ValidationHandler(object sender, System.EventArgs e) {
            if (this.ContainsFocus) return;

            //Raise Leave event
            this.OnLeave(e);

            if (this.CausesValidation) {
                CancelEventArgs validationArgs = new CancelEventArgs();
                this.OnValidating(validationArgs);

                if (validationArgs.Cancel && this.ActiveControl != null)
                    this.ActiveControl.Focus();
                else {
                    //Raise Validated event
                    this.OnValidated(e);
                }
            }

        }

        #endregion

#endif

        #endregion

        //Please enter any new code here, below the Interop code
    }
}
