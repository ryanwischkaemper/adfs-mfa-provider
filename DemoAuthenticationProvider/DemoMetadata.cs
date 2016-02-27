using System.Collections.Generic;
using System.Globalization;
using Microsoft.IdentityServer.Web.Authentication.External;

namespace DemoAuthenticationProvider
{
	public class DemoMetadata : IAuthenticationAdapterMetadata
	{
		/// <summary>
		/// Returns an array of strings containing URIs indicating the set of authentication methods implemented by the adapter
		/// AD FS requires that, if authentication is successful, the method actually employed will be returned by the
		/// final call to TryEndAuthentication(). If no authentication method is returnd, or the method returned is not
		/// one of the methods listed in this property, the authentication attempt will fail.
		/// </summary>
		public string[] AuthenticationMethods
		{
			get
			{
				return new[] { "http://www.Demo.net/mfa/sms", "http://www.Demo.net/mfa/email" };
			}
		}

		/// <summary>
		/// Returns an array indicating the type of claim that that the adapter uses to identify the user being authenticated.
		/// Note that although the property is an array, only the first element is currently used.
		/// MUST BE ONE OF THE FOLLOWING
		/// "http://schemas.microsoft.com/ws/2008/06/identity/claims/windowsaccountname"
		/// "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/upn"
		/// "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress"
		/// "http://schemas.microsoft.com/ws/2008/06/identity/claims/primarysid"
		/// </summary>
		public string[] IdentityClaims
		{
			get { return new[] { "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/upn" }; }
		}

		/// <summary>
		/// Returns the name of the provider that will be shown in the AD FS management UI (not visible to end users)
		/// </summary>
		public string AdminName
		{
			get { return "Demo Mfa Adapter"; }
		}

		/// <summary>
		/// Returns an array indicating which languages are supported by the provider. AD FS uses this information
		/// to determine the best language\locale to display to the user.
		/// </summary>
		public int[] AvailableLcids
		{
			get
			{
				return new[] { new CultureInfo("en-us").LCID };
			}
		}

		/// <summary>
		/// Returns a Dictionary containing the set of localized descriptions (hover over help) of the provider, indexed by lcid. 
		/// These descriptions are displayed in the "choice page" offered to the user when there is more than one 
		/// secondary authentication provider available.
		/// </summary>
		public Dictionary<int, string> Descriptions
		{
			get
			{
				Dictionary<int, string> _descriptions = new Dictionary<int, string>();
				_descriptions.Add(new CultureInfo("en-us").LCID, "Demo Multi-Factor authentication using sms or email");
				return _descriptions;
			}
		}

		/// <summary>
		/// Returns a Dictionary containg the set of localized friendy names of the provider, indexed by lcid. 
		/// These Friendly Names are displayed in the "choice page" offered to the user when there is more than 
		/// one secondary authentication provider available.
		/// </summary>
		public Dictionary<int, string> FriendlyNames
		{
			get
			{
				Dictionary<int, string> _friendlyNames = new Dictionary<int, string>();
				_friendlyNames.Add(new CultureInfo("en-us").LCID, "Demo Multi-Factor authentication using SMS or email");
				return _friendlyNames;
			}
		}

		/// <summary>
		/// This is an indication whether or not the Authentication Adapter requires an Identity Claim or not. 
		/// If you require an Identity Claim, the claim type must be presented through the IdentityClaims property.
		/// All external providers must return a value of "true" for this property.
		/// </summary>
		public bool RequiresIdentity
		{
			get
			{
				return true;
			}
		}
	}
}
