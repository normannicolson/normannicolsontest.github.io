# Azure B2c Custom Policy TechnicalProfile return static output claims

Jun 2025

> Custom policy that always returns the same token useful for testing

TechnicalProfile

``` xml 
<TechnicalProfiles>
  <TechnicalProfile Id="StaticClaimsProvider">
    <DisplayName>Static Claims</DisplayName>
    <Protocol Name="Proprietary" Handler="Web.TPEngine.Providers.ClaimsTransformationProtocolProvider, Web.TPEngine, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null"/>
    <OutputClaims>
      <OutputClaim ClaimTypeReferenceId="objectId" DefaultValue="objectId default value" AlwaysUseDefaultValue="true" />
      <OutputClaim ClaimTypeReferenceId="displayName" DefaultValue="displayName default value" AlwaysUseDefaultValue="true" />
      <OutputClaim ClaimTypeReferenceId="email" DefaultValue="email default value" AlwaysUseDefaultValue="true" />
    </OutputClaims>
  </TechnicalProfile>
</TechnicalProfiles>
```

Use in orchestration step

``` xml
<OrchestrationStep Order="1" Type="ClaimsExchange">
  <ClaimsExchanges>
    <ClaimsExchange Id="GetStaticClaims" TechnicalProfileReferenceId="StaticClaimsProvider" />
  </ClaimsExchanges>
</OrchestrationStep>
```

Commplete Example

``` xml
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<TrustFrameworkPolicy xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:xsd="http://www.w3.org/2001/XMLSchema"
	xmlns="http://schemas.microsoft.com/online/cpim/schemas/2013/06" 
  PolicySchemaVersion="0.3.0.0" TenantId="{{__TenantId__}}" 
  PolicyId="B2C_1A_{{__FileName__}}{{__Environment__}}" 
  PublicPolicyUri="http://{{__TenantId__}}/B2C_1A_{{__FileName__}}{{__Environment__}}" 
  DeploymentMode="{{__DeploymentMode__}}" UserJourneyRecorderEndpoint="urn:journeyrecorder:applicationinsights">
	<BasePolicy>
		<TenantId>{{__TenantId__}}</TenantId>
		<PolicyId>B2C_1A_TrustFrameworkLocalization{{__Environment__}}</PolicyId>
	</BasePolicy>

  <ClaimsProviders>
    <ClaimsProvider>
      <DisplayName>InitializeJourneyClaims</DisplayName>

      <TechnicalProfiles>
        <TechnicalProfile Id="StaticClaimsProvider">
          <DisplayName>Static Claims</DisplayName>
          <Protocol Name="Proprietary" Handler="Web.TPEngine.Providers.ClaimsTransformationProtocolProvider, Web.TPEngine, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null"/>
          <OutputClaims>
            <OutputClaim ClaimTypeReferenceId="objectId" DefaultValue="objectId myDefaultValue" AlwaysUseDefaultValue="true" />
            <OutputClaim ClaimTypeReferenceId="displayName" DefaultValue="displayName myDefaultValue" AlwaysUseDefaultValue="true" />
              <OutputClaim ClaimTypeReferenceId="email" DefaultValue="emailmyDefaultValue" AlwaysUseDefaultValue="true" />
          </OutputClaims>
        </TechnicalProfile>
      </TechnicalProfiles>
    </ClaimsProvider>
  </ClaimsProviders>

  <UserJourneys>
    <UserJourney Id="StaticTokenJourney">
      <OrchestrationSteps>
        <OrchestrationStep Order="1" Type="ClaimsExchange">
          <ClaimsExchanges>
            <ClaimsExchange Id="GetStaticClaims" TechnicalProfileReferenceId="StaticClaimsProvider" />
          </ClaimsExchanges>
        </OrchestrationStep>

        <OrchestrationStep Order="2" Type="SendClaims" CpimIssuerTechnicalProfileReferenceId="JwtIssuer" />
      </OrchestrationSteps>
    </UserJourney>
  </UserJourneys>

  <RelyingParty>
    <DefaultUserJourney ReferenceId="SimpleHardcodedTokenJourney" />

    <TechnicalProfile Id="PolicyProfile">
      <DisplayName>PolicyProfile</DisplayName>
      <Protocol Name="OpenIdConnect" />
      <OutputClaims>
        <OutputClaim ClaimTypeReferenceId="objectId" PartnerClaimType="sub" />
        <OutputClaim ClaimTypeReferenceId="displayName" PartnerClaimType="name" />
        <OutputClaim ClaimTypeReferenceId="email" PartnerClaimType="email" />
      </OutputClaims>
      <SubjectNamingInfo ClaimType="sub" />
    </TechnicalProfile>
  </RelyingParty>

</TrustFrameworkPolicy>
```