# Docker Https Website 

Oct 2022

> Docker local development add https certificate 

Use command "dotnet dev-certs https -ep C:\Users\username\.aspnet\https\aspnetapp.pfx -p <>" to add own certificate.

```
dotnet dev-certs https -ep C:\Users\username\.aspnet\https\aspnetapp.pfx -p <>
```

Typically a https certificate will already have be added.

"A valid HTTPS certificate is already present."

## Remove your existing dev certificate(s)

dotnet dev-certs https --clean

Cleaning HTTPS development certificates from the machine. A prompt might get displayed to confirm the removal of some of the certificates.
HTTPS development certificates successfully removed from the machine.

## Add new development certificate with known password 

dotnet dev-certs https -ep C:\Users\username\.aspnet\https\aspnetapp.pfx -p Password@123

The HTTPS developer certificate was generated successfully.

## Trust Cert 
dotnet dev-certs https --trust

Run the container image with ASP.NET Core configured for HTTPS in a command shell:

docker pull mcr.microsoft.com/dotnet/samples:aspnetapp

docker run --rm -it -p 8000:80 -p 8001:443 -e ASPNETCORE_URLS="https://+;http://+" -e ASPNETCORE_HTTPS_PORT=8001 -e ASPNETCORE_Kestrel__Certificates__Default__Password="Password@123" -e ASPNETCORE_Kestrel__Certificates__Default__Path=/https/aspnetapp.pfx -v C:\Users\username\.aspnet\https:/https/ mcr.microsoft.com/dotnet/samples:aspnetapp