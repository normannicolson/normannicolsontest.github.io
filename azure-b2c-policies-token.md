# Azure B2c Custom Policy TechnicalProfile return bearer token

Jun 2025

> Obtain client_credentials access token to call api  

TechnicalProfile

``` xml 
<TechnicalProfile Id="RestApi-GetBearerToken">
    <DisplayName>Get BearerToken for Api</DisplayName>
    <Protocol Name="Proprietary" Handler="Web.TPEngine.Providers.RestfulProvider, Web.TPEngine, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null" />
    <Metadata>
        <Item Key="AuthenticationType">Basic</Item>
        <Item Key="SendClaimsIn">Form</Item>
        <Item Key="ServiceUrl">https://login.microsoftonline.com/{TenantId}/oauth2/v2.0/token</Item>
        <Item Key="DebugMode">{DeveloperMode}</Item>
        <Item Key="DefaultUserMessageIfRequestFailed"> Bearer Sorry, something went wrong and we couldn’t complete your request. Please try again later.</Item>
        <Item Key="UserMessageIfCircuitOpen">Bearer Sorry, something went wrong and we couldn’t complete your request. Please try again later.</Item>
        <Item Key="UserMessageIfDnsResolutionFailed">Bearer Sorry, something went wrong and we couldn’t complete your request. Please try again later.</Item>
        <Item Key="UserMessageIfRequestTimeout">Bearer Sorry, something went wrong and we couldn’t complete your request. Please try again later.</Item>
    </Metadata>
    <CryptographicKeys>
        <Key Id="BasicAuthenticationUsername" StorageReferenceId="B2C_1A_RestApiClientId" />
        <Key Id="BasicAuthenticationPassword" StorageReferenceId="B2C_1A_RestApiClientSecret" />
    </CryptographicKeys>
    <InputClaims>
        <InputClaim ClaimTypeReferenceId="Api_Bearer_GrantType" PartnerClaimType="grant_type" DefaultValue="client_credentials" />
        <InputClaim ClaimTypeReferenceId="Api_Bearer_Scope" PartnerClaimType="scope" DefaultValue="https://{TenantId}/{ApiId}/.default" />
    </InputClaims>
    <OutputClaims>
        <OutputClaim ClaimTypeReferenceId="BearerToken" PartnerClaimType="access_token"/>
    </OutputClaims>
    <UseTechnicalProfileForSessionManagement ReferenceId="SM-Noop" />
</TechnicalProfile>
```

Use in orchestration step

``` xml
<OrchestrationStep Order="1" Type="ClaimsExchange">
  <ClaimsExchanges>
    <ClaimsExchange Id="GetBearerToken" TechnicalProfileReferenceId="RestApi-GetBearerToken" />
  </ClaimsExchanges>
</OrchestrationStep>
```

``` xml
<TechnicalProfile Id="RestApi-GetProfile">
    <DisplayName></DisplayName>
    <Protocol Name="Proprietary" Handler="Web.TPEngine.Providers.RestfulProvider, Web.TPEngine, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null" />
    <Metadata>
        <Item Key="AuthenticationType">Bearer</Item>
        <Item Key="IncludeClaimResolvingInClaimsHandling">true</Item>
        <Item Key="UseClaimAsBearerToken">BearerToken</Item>
        <Item Key="SendClaimsIn">Url</Item>
        <Item Key="ServiceUrl">{ApiBaseUrl}/profile/{objectId}</Item>
        <Item Key="DebugMode">{DeveloperMode}</Item>
        <Item Key="ResolveJsonPathsInJsonTokens">true</Item>
        <Item Key="DefaultUserMessageIfRequestFailed">Sorry, something went wrong and we couldn’t complete your request. Please try again later.</Item>
        <Item Key="UserMessageIfCircuitOpen">Sorry, something went wrong and we couldn’t complete your request. Please try again later.</Item>
        <Item Key="UserMessageIfDnsResolutionFailed">Sorry, something went wrong and we couldn’t complete your request. Please try again later.</Item>
        <Item Key="UserMessageIfRequestTimeout">Sorry, something went wrong and we couldn’t complete your request. Please try again later.</Item>
    </Metadata>
    <InputClaims>
        <InputClaim ClaimTypeReferenceId="BearerToken"/>
        <InputClaim ClaimTypeReferenceId="ObjectId" PartnerClaimType="id" />
    </InputClaims>
    <OutputClaims>
        <OutputClaim ClaimTypeReferenceId="Name" PartnerClaimType="name"/>
        <OutputClaim ClaimTypeReferenceId="FeatureGroup" PartnerClaimType="featureGroup"/>
    </OutputClaims>
    <UseTechnicalProfileForSessionManagement ReferenceId="SM-Noop" />
</TechnicalProfile>
```
