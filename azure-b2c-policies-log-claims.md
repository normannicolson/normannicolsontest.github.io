# Debug B2c by logging version claims

Nov 2023

>  Debug B2c by logging version claims

Add Claims to ClaimsSchema

 ```
<ClaimType Id="version">
    <DisplayName>Version</DisplayName>
    <DataType>string</DataType>
</ClaimType>
```

Add SetVersion TechnicalProfile that sets version claim each edit increment DefaultValue, version will be logged. 

```
<TechnicalProfile Id="SetVersion">
    <DisplayName>Set Version</DisplayName>
    <Protocol Name="Proprietary" Handler="Web.TPEngine.Providers.ClaimsTransformationProtocolProvider,Web.TPEngine, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null" />
    <OutputClaims>
        <OutputClaim ClaimTypeReferenceId="version" DefaultValue="1" AlwaysUseDefaultValue="true" />
    </OutputClaims>
    <UseTechnicalProfileForSessionManagement ReferenceId="SM-Noop" />
</TechnicalProfile>
```

Add paste bin type endpoint 
```
<TechnicalProfile Id="RestfulProvider-ClaimsLog-Base">
    <DisplayName>For debugging</DisplayName>
    <Protocol Name="Proprietary" Handler="Web.TPEngine.Providers.RestfulProvider, Web.TPEngine, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null" />
    <Metadata>
        <Item Key="ServiceUrl">https://example.com</Item>
        <Item Key="AuthenticationType">None</Item>
        <Item Key="SendClaimsIn">Body</Item>
    </Metadata>
    <InputClaims>
        <InputClaim ClaimTypeReferenceId="version" />
        <InputClaim ClaimTypeReferenceId="objectId" />
    </InputClaims>
</TechnicalProfile>
```   

Add paste bin type endpoint 
```
<TechnicalProfile Id="RestfulProvider-ClaimsLog-Step1">
    <DisplayName>Claims log to url endpoint</DisplayName>
    <Metadata>
        <Item Key="ServiceUrl">https://example.com/step1</Item>
    </Metadata>
    <IncludeTechnicalProfile ReferenceId="RestfulProvider-ClaimsLog-Base" />
</TechnicalProfile>
```

User log step in Journey OrchestrationSteps

```
<OrchestrationStep Order="1" Type="ClaimsExchange">
    <ClaimsExchanges>
        <ClaimsExchange Id="SetVersion" TechnicalProfileReferenceId="SetVersion" />
    </ClaimsExchanges>
</OrchestrationStep>

<OrchestrationStep Order="2" Type="ClaimsExchange">
    <ClaimsExchanges>
        <ClaimsExchange Id="Step1" TechnicalProfileReferenceId="RestfulProvider-DebugBin-Step1" />
    </ClaimsExchanges>
</OrchestrationStep>
```