# Implicit flow  

Oct 2021 

> Using Httpie to illustrate Azure B2c Sign in Implicit flow  

## Prerequisites  

Azure B2c implicit flow application setup

In Azure b2c ensure application registration is configured for implicit flow, in Authentication section:

* Add "Web" Platform Configuration with application redirect url

Enable Implicit grant and hybrid flows

* Access tokens (used for implicit flows) checked 
* ID tokens (used for implicit and hybrid flows) checked 

## Redirect Request 

Redirect url
```
https://{tenant}.b2clogin.com/{tenant}.onmicrosoft.com/{policy}/oauth2/v2.0/authorize
?client_id={client-id}
&response_type=code+id_token
&response_mode=fragment
&redirect_uri={redirect-uri}
&scope=openid offline_access https://{tenant}/{app-id-uri}/{scope}
```

Example
```
https://tenant.b2clogin.com/tenant.onmicrosoft.com/B2C_1A_SignIn/oauth2/v2.0/authorize?client_id=ac6d4172-4cf8-4d0c-a131-2c37053ead05&response_type=code+id_token&response_mode=fragment&redirect_uri=https://jwt.ms&scope=openid offline_access https://tenant.onmicrosoft.com/postsapi/Post.Create
```

Response 
```
https://jwt.ms/#code=#######&id_token=#######
```