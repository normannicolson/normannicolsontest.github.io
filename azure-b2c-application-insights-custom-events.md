# Azure B2c Application Insights Custom Events

Aug 2023

> Application insights b2c custom policies integration.

B2c Custom policies application insights custom events

User Journey SignInComplete event 

```
<OrchestrationStep Order="10" Type="ClaimsExchange">
    <ClaimsExchanges>
        <ClaimsExchange Id="TrackSignInComplete" TechnicalProfileReferenceId="AppInsights-SignInComplete" />
    </ClaimsExchanges>
</OrchestrationStep>
```

User Journey ChangePassword event

```
<OrchestrationStep Order="5" Type="ClaimsExchange">
    <ClaimsExchanges>
        <ClaimsExchange Id="TrackChangePassword" TechnicalProfileReferenceId="AppInsights-ChangePassword" />
    </ClaimsExchanges>
</OrchestrationStep>
```

AppInsights Technical Profile provides connectivity to Application Insights  

```
<TechnicalProfile Id="AppInsights-Common">
    <DisplayName>Application Insights</DisplayName>
    <Protocol Name="Proprietary" Handler="Web.TPEngine.Providers.Insights.AzureApplicationInsightsProvider, Web.TPEngine, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null" />
    <Metadata>
        <!-- The ApplicationInsights instrumentation key, which you use for logging the events -->
        <Item Key="InstrumentationKey">__PolicyInstrumentationKey__</Item>
        <Item Key="DeveloperMode">false</Item>
        <Item Key="DisableTelemetry">false</Item>
    </Metadata>
    <InputClaims>
        <!-- Properties of an event are added through the syntax {property:NAME}, where NAME is the property being added to the event. DefaultValue can be either a static value or a value that's resolved by one of the supported DefaultClaimResolvers. -->
        <InputClaim ClaimTypeReferenceId="EventTimestamp" PartnerClaimType="{property:EventTimestamp}" DefaultValue="{Context:DateTimeInUtc}" />
        <InputClaim ClaimTypeReferenceId="tenantId" PartnerClaimType="{property:TenantId}" DefaultValue="{Policy:TrustFrameworkTenantId}" />
        <InputClaim ClaimTypeReferenceId="PolicyId" PartnerClaimType="{property:Policy}" DefaultValue="{Policy:PolicyId}" />
        <InputClaim ClaimTypeReferenceId="CorrelationId" PartnerClaimType="{property:CorrelationId}" DefaultValue="{Context:CorrelationId}" />
        <InputClaim ClaimTypeReferenceId="Culture" PartnerClaimType="{property:Culture}" DefaultValue="{Culture:RFC5646}" />
    </InputClaims>
</TechnicalProfile>
```

Technical Profile for SignInComplete event

```
<TechnicalProfile Id="AppInsights-SignInComplete">
    <InputClaims>
        <InputClaim ClaimTypeReferenceId="EventType" PartnerClaimType="eventName" DefaultValue="SignInComplete" />
        <InputClaim ClaimTypeReferenceId="federatedUser" PartnerClaimType="{property:FederatedUser}" DefaultValue="false" />
        <InputClaim ClaimTypeReferenceId="parsedDomain" PartnerClaimType="{property:FederationPartner}" DefaultValue="Not Applicable" />
        <InputClaim ClaimTypeReferenceId="identityProvider" PartnerClaimType="{property:IDP}" DefaultValue="Local" />
    </InputClaims>
    <IncludeTechnicalProfile ReferenceId="AppInsights-Common" />
</TechnicalProfile>
```

Technical Profile for ChangePassword event

```
<TechnicalProfile Id="AppInsights-ChangePassword">
    <InputClaims>
    <!-- An input claim with a PartnerClaimType="eventName" is required. This is used by the AzureApplicationInsightsProvider to create an event with the specified value. -->
        <InputClaim ClaimTypeReferenceId="EventType" PartnerClaimType="eventName" DefaultValue="ChangePassword" />
    </InputClaims>
    <IncludeTechnicalProfile ReferenceId="AppInsights-Common" />
</TechnicalProfile>
```

Query Application insights for custom events

SignInComplete

```
let signInCompletes = customEvents
| where timestamp >= datetime('2023-08-01T00:00:00+01:00')
| where name == 'SignInComplete';

signInCompletes
| summarize signInCompleteCount=sum(itemCount) by bin(timestamp, 1h)
| project timestamp, signInCompleteCount
| render columnchart;
```

ChangePassword

```
let changePasswords = customEvents
| where timestamp >= datetime('2023-08-01T00:00:00+01:00')
| where name == 'ChangePassword';

changePasswords
| summarize changePasswordsCount=sum(itemCount) by bin(timestamp, 1h)
| project timestamp, changePasswordsCount
| render columnchart;
```