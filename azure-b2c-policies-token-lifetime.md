# B2c Token lifetime

Nov 2023

> B2c Policy Token lifetime

Base Policy 
```
<TechnicalProfile Id="JwtIssuer">
  <DisplayName>JWT Issuer</DisplayName>
  <Protocol Name="OpenIdConnect" />
  <OutputTokenFormat>JWT</OutputTokenFormat>
  <Metadata>
    <Item Key="client_id">{service:te}</Item>
    <Item Key="issuer_refresh_token_user_identity_claim_type">objectId</Item>
    <Item Key="SendTokenResponseBodyWithJsonNumbers">true</Item>
  </Metadata>
```

Add token_lifetime_secs or id_token_lifetime_secs
```
<Metadata>
  <Item Key="token_lifetime_secs">900</Item>
  <Item Key="id_token_lifetime_secs">900</Item>

```