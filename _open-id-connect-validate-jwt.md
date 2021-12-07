# Open Id Connect Validate JWT *

Jun 2017

> How to validate the authenticity of a json web token.

JWT or JSON Web Tokens are an industry standard for communicating claims securely between two parties. Claims are assertions about the individual like Name, Email Address, permissions etc.

They are typically issued from one party called the identity provider and consumed by other called the relying party. The relying party has a business relationship with the identity provider and vice versa.  

The relying party initiates the request for claims, when you use Facebook or Google to log into a website you are performing this exchange.

For example https://bitbucket.org uses Facebook, GitHub, Google & Twitter as identity providers. On Signup you are given the option of using one of the identity providers (Facebook, GitHub, Google & Twitter ) as your login, this sends a request to the selected IDP (identity provider Facebook, GitHub, Google or Twitter) and presents a login form, once logged in & terms accepted the claims are send back to https://bitbucket.org the claims will include Name, Email Address, permissions etc.

The claims data passed back is contained within a JWT (JSON Web Token) via a Http Post, Relying parties need to validate the authenticity and integrity of the JWT to ensure it has not been compromised. 

A recommended overview is found at https://jwt.io/ 

Sample JWT
The JWT is split into three sections Header, Payload & Signature each separated by a dot simply Header.Payload.Signature the Header, Payload & Signature are each Base64 Url encoded and then joined with the dot separator. 

How to create your own token 
Serialise objects to JSON   

json 

then base 64 url encode 

header contains information about what json is contained in payload and what algorithm is used for signing 

header is then combined with payload including dot separator 

combined header and payload is signed using signature algorithm producing a signature

signature is base 64 url encoded 

signature is joined header and payload separated by dot

the Header.Payload.Signature is send to the relying part