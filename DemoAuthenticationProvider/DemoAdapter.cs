using System;
using System.Net;
using System.Security.Claims;
using Microsoft.IdentityServer.Web.Authentication.External;

namespace DemoAuthenticationProvider
{
	public class DemoAdapter : IAuthenticationAdapter
	{
		/// <summary>
		/// This method is called by ADFS once ADFS decides that Multi-Factor Authentication is required (and available) 
		/// for a user.
		/// </summary>
		/// <param name="identityClaim"></param>
		/// <param name="request"></param>
		/// <param name="context"></param>
		/// <returns></returns>
		public IAdapterPresentation BeginAuthentication(System.Security.Claims.Claim identityClaim, HttpListenerRequest request,
			IAuthenticationContext context)
		{
			return new DemoPresentationForm();
		}

		/// <summary>
		/// Indication to ADFS that this Authentication Adapter can actually perform Multi-Factor Authentication 
		/// for the user.
		/// </summary>
		/// <param name="identityClaim"></param>
		/// <param name="context"></param>
		/// <returns></returns>
		public bool IsAvailableForUser(System.Security.Claims.Claim identityClaim, IAuthenticationContext context)
		{
			return true;
		}

		/// <summary>
		/// This is called whenever something goes wrong in the authentication process. To be more precise; if anything 
		/// goes wrong in the BeginAuthentication or TryEndAuthentication methods of this authentication adapter, and 
		/// either of these methods throw an ExternalAuthenticationException, the OnError method is called.
		/// </summary>
		/// <param name="request"></param>
		/// <param name="ex"></param>
		/// <returns></returns>
		public IAdapterPresentation OnError(HttpListenerRequest request, ExternalAuthenticationException ex)
		{
			return new DemoPresentationForm();
		}

		/// <summary>
		/// This is where AD FS passes us the config data, if such data was supplied at registration of the adapter.
		/// </summary>
		/// <param name="configData">Contains a single property called Data and is of type Stream</param>
		public void OnAuthenticationPipelineLoad(IAuthenticationMethodConfigData configData)
		{
			//throw new NotImplementedException();
		}

		/// <summary>
		/// This is called by AD FS whenever the Authentication Provider is unloaded from the AD FS pipeline and allows 
		/// the Authentication Adapter to clean up anything it has to clean up.
		/// </summary>
		public void OnAuthenticationPipelineUnload()
		{
			//throw new NotImplementedException();
		}

		/// <summary>
		/// Used by ADFS to learn about your Authentication Provider
		/// </summary>
		public IAuthenticationAdapterMetadata Metadata { get { return new DemoMetadata(); } }

		/// <summary>
		/// This method is called by ADFS when this Authentication Adapter should perform the actual authentication. 
		/// </summary>
		/// <param name="context"></param>
		/// <param name="proofData">
		/// Dictionary of strings to objects, that represents whatever you have asked the client for during 
		/// the BeginAuthentication method
		/// </param>
		/// <param name="request"></param>
		/// <param name="claims">
		/// If the Authentication Adapter has successfully performed the authentication, this variable should contain
		/// at least one claim with type http://schemas.microsoft.com/ws/2008/06/identity/claims/authenticationmethod. 
		/// The value of this claim should contain the method of authentication used. It must be one of the values 
		/// listed in the AuthenticationMethods parameter of <see cref="DemoMetadata"/>. 
		/// </param>
		/// <returns></returns>
		public IAdapterPresentation TryEndAuthentication(IAuthenticationContext context, IProofData proofData,
			HttpListenerRequest request, out System.Security.Claims.Claim[] claims)
		{
			claims = new Claim[0];
			return new DemoPresentationForm();
		}
	}
}
