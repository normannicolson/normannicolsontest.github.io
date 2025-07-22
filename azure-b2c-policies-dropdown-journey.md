# Azure B2c Custom Policy for Static Test Users

Jun 2025

> Azure B2c Custom Policy that creates user based on selected value 

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

  <BuildingBlocks>
    <ClaimsSchema>
      <ClaimType Id="account_type">
				<DisplayName>Cust Type</DisplayName>
				<DataType>string</DataType>
				<UserInputType>DropdownSingleSelect</UserInputType>
				<Restriction>
					<Enumeration Text="Gold" Value="gold" SelectByDefault="false" />
					<Enumeration Text="Silver" Value="silver" SelectByDefault="false" />
					<Enumeration Text="Bronze" Value="bronze" SelectByDefault="false" />
				</Restriction>
			</ClaimType>
		</ClaimsSchema> 
  </BuildingBlocks>

  <ClaimsProviders>
    <ClaimsProvider>
      <DisplayName>InitializeJourneyClaims</DisplayName>
      <TechnicalProfiles>
        <TechnicalProfile Id="select_account_type">
          <DisplayName>Select account_type</DisplayName>
          <Protocol Name="Proprietary" Handler="Web.TPEngine.Providers.SelfAssertedAttributeProvider, Web.TPEngine, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null" />
          <Metadata>
            <Item Key="ContentDefinitionReferenceId">api.selfasserted.account_type</Item>
          </Metadata>
          <DisplayClaims>
            <DisplayClaim ClaimTypeReferenceId="account_type" Required="true"/>
          </DisplayClaims>
          <OutputClaims>
            <OutputClaim ClaimTypeReferenceId="account_type" />
          </OutputClaims>
          <UseTechnicalProfileForSessionManagement ReferenceId="SM-AAD" />
        </TechnicalProfile>
        <TechnicalProfile Id="get_gold_static_claims">
          <DisplayName>Static Claims</DisplayName>
          <Protocol Name="Proprietary" Handler="Web.TPEngine.Providers.ClaimsTransformationProtocolProvider, Web.TPEngine, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null"/>
          <OutputClaims>
            <OutputClaim ClaimTypeReferenceId="objectId" DefaultValue="00000000-0000-0000-0000-000000000001" AlwaysUseDefaultValue="true" />
            <OutputClaim ClaimTypeReferenceId="displayName" DefaultValue="Gold Test User" AlwaysUseDefaultValue="true" />
            <OutputClaim ClaimTypeReferenceId="email" DefaultValue="gold@example.com" AlwaysUseDefaultValue="true" />
            <OutputClaim ClaimTypeReferenceId="account_type" DefaultValue="gold" AlwaysUseDefaultValue="true" />
          </OutputClaims>
        </TechnicalProfile>
        <TechnicalProfile Id="get_silver_static_claims">
          <DisplayName>Static Claims</DisplayName>
          <Protocol Name="Proprietary" Handler="Web.TPEngine.Providers.ClaimsTransformationProtocolProvider, Web.TPEngine, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null"/>
          <OutputClaims>
            <OutputClaim ClaimTypeReferenceId="objectId" DefaultValue="00000000-0000-0000-0000-000000000002" AlwaysUseDefaultValue="true" />
            <OutputClaim ClaimTypeReferenceId="displayName" DefaultValue="Silver Test User" AlwaysUseDefaultValue="true" />
            <OutputClaim ClaimTypeReferenceId="email" DefaultValue="silver@example.com" AlwaysUseDefaultValue="true" />
            <OutputClaim ClaimTypeReferenceId="account_type" DefaultValue="silver" AlwaysUseDefaultValue="true" />
          </OutputClaims>
        </TechnicalProfile>
        <TechnicalProfile Id="get_bronse_static_claims">
          <DisplayName>Static Claims</DisplayName>
          <Protocol Name="Proprietary" Handler="Web.TPEngine.Providers.ClaimsTransformationProtocolProvider, Web.TPEngine, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null"/>
          <OutputClaims>
            <OutputClaim ClaimTypeReferenceId="objectId" DefaultValue="00000000-0000-0000-0000-000000000003" AlwaysUseDefaultValue="true" />
            <OutputClaim ClaimTypeReferenceId="displayName" DefaultValue="Bronze Test User" AlwaysUseDefaultValue="true" />
            <OutputClaim ClaimTypeReferenceId="email" DefaultValue="bronze@example.com" AlwaysUseDefaultValue="true" />
            <OutputClaim ClaimTypeReferenceId="account_type" DefaultValue="bronze" AlwaysUseDefaultValue="true" />
          </OutputClaims>
        </TechnicalProfile>
      </TechnicalProfiles>
    </ClaimsProvider>
  </ClaimsProviders>
```


``` xml 


  <UserJourneys>
    <UserJourney Id="StaticTokenJourney">
      <OrchestrationSteps>

        <OrchestrationStep Order="1" Type="ClaimsExchange">
					<ClaimsExchanges>
						<ClaimsExchange Id="SelectAccountType" TechnicalProfileReferenceId="SelectAccountType" />
					</ClaimsExchanges>
				</OrchestrationStep>

        <OrchestrationStep Order="2" Type="ClaimsExchange">
          <Preconditions>
            <Precondition Type="ClaimEquals" ExecuteActionsIf="false">
              <Value>account_type</Value>
              <Value>gold</Value>
              <Action>SkipThisOrchestrationStep</Action>
            </Precondition>
          </Preconditions>
          <ClaimsExchanges>
            <ClaimsExchange Id="get_gold_static_claims" TechnicalProfileReferenceId="get_gold_static_claims" />
          </ClaimsExchanges>
        </OrchestrationStep>

        <OrchestrationStep Order="3" Type="ClaimsExchange">
          <Preconditions>
            <Precondition Type="ClaimEquals" ExecuteActionsIf="false">
              <Value>account_type</Value>
              <Value>silver</Value>
              <Action>SkipThisOrchestrationStep</Action>
            </Precondition>
          </Preconditions>
          <ClaimsExchanges>
            <ClaimsExchange Id="get_silver_static_claims" TechnicalProfileReferenceId="get_silver_static_claims" />
          </ClaimsExchanges>
        </OrchestrationStep>

        <OrchestrationStep Order="4" Type="ClaimsExchange">
          <Preconditions>
            <Precondition Type="ClaimEquals" ExecuteActionsIf="false">
              <Value>account_type</Value>
              <Value>bronze</Value>
              <Action>SkipThisOrchestrationStep</Action>
            </Precondition>
          </Preconditions>
          <ClaimsExchanges>
            <ClaimsExchange Id="get_bronze_static_claims" TechnicalProfileReferenceId="get_bronze_static_claims" />
          </ClaimsExchanges>
        </OrchestrationStep>

        <OrchestrationStep Order="8" Type="SendClaims" CpimIssuerTechnicalProfileReferenceId="JwtIssuer" />
      </OrchestrationSteps>
    </UserJourney>
  </UserJourneys>

  <RelyingParty>
	  <DefaultUserJourney ReferenceId="StaticTokenJourney" />
		<Endpoints>
			<Endpoint Id="UserInfo" UserJourneyReferenceId="UserInfoJourney" />
			<Endpoint Id="Token" UserJourneyReferenceId="RedeemRefreshToken" /> 
		</Endpoints>
		<UserJourneyBehaviors>
			<SingleSignOn Scope="{{__SingleSignOnScope__}}" EnforceIdTokenHintOnLogout="true"/>
			<SessionExpiryType>{{__SessionExpiryType__}}</SessionExpiryType>
			<SessionExpiryInSeconds>{{__SessionExpiryInSeconds__}}</SessionExpiryInSeconds>
			<JourneyInsights TelemetryEngine="ApplicationInsights" InstrumentationKey="{{__AppInsightsKey__}}" DeveloperMode="true" ClientEnabled="true" ServerEnabled="true" TelemetryVersion="1.0.0" />
			<ContentDefinitionParameters>
				<Parameter Name="domain_hint">{OAUTH-KV:domain_hint}</Parameter>
			</ContentDefinitionParameters>
			<ScriptExecution>Allow</ScriptExecution>
		</UserJourneyBehaviors>

		<TechnicalProfile Id="PolicyProfile">
			<DisplayName>PolicyProfile</DisplayName>
			<Protocol Name="OpenIdConnect" />
			<OutputClaims>
				<OutputClaim ClaimTypeReferenceId="tfp" DefaultValue="{Policy:PolicyId}" AlwaysUseDefaultValue="true"/>
				<OutputClaim ClaimTypeReferenceId="objectId" PartnerClaimType="sub"/>
				<OutputClaim ClaimTypeReferenceId="tenantId" AlwaysUseDefaultValue="true" DefaultValue="{Policy:TenantObjectId}" />
				<OutputClaim ClaimTypeReferenceId="account_type" PartnerClaimType="account_type"/>
			</OutputClaims>
			<SubjectNamingInfo ClaimType="sub" />
		</TechnicalProfile>
	</RelyingParty>
</TrustFrameworkPolicy>