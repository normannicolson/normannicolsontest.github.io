# Create Client Certificate with Makecert

Nov 2017

> Walkthrough create a self-signed certificate using makecert.

https://docs.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-certificates-point-to-site-makecert

```
makecert -n "CN=RootCaClientTest" -r -sv RootCaClientTest.pvk RootCaClientTest.cer

makecert -crl -n "CN=RootCaClientTest" -r -sv RootCaClientTest.pvk RootCaClientTest.crl
```

Then install certificates 

```
makecert -sk MyKeyName -iv RootCaClientTest.pvk -n "CN=tempClientcert" -ic RootCaClientTest.cer -sr currentuser -ss my -sky signature -pe
```