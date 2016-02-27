using Microsoft.IdentityServer.Web.Authentication.External;

namespace DemoAuthenticationProvider
{
	public class DemoPresentationForm : IAdapterPresentationForm
	{
		/// <summary>
		/// Returns the title string for the web page which presents the HTML form content to the end user
		/// </summary>
		/// <param name="lcid"></param>
		/// <returns></returns>		
		public string GetPageTitle(int lcid)
		{
			return "Demo MFA Adapter";
		}

		/// <summary>
		/// Return any external resources, ie references to libraries etc., that should be included in 
		/// the HEAD section of the presentation form html. 
		/// </summary>
		public string GetFormPreRenderHtml(int lcid)
		{
			return null;
		}

		/// <summary>
		/// Returns the HTML Form fragment that contains the adapter user interface. This data will be included in the web page that is presented
		/// to the cient.
		/// </summary>
		public string GetFormHtml(int lcid)
		{
			string htmlTemplate = Resources.DemoPresentationForm;
			return htmlTemplate;
		}
	}
}
