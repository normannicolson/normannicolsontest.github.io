# Https Checklist for Web Apps

Oct 2018

> Https checklist to ensure https for application has been configured correctly.

HTTPS aims to ensure:

- Authenticity
- Integrity
- Confidentiality

Without HTTPS a page source can be modified by a man in the middle, for example a hotel Wifi captive portal or malicious fake content.

SSL and TLS terms are used interchangeably, TLS is current implementation.

HTTPS aims to ensure authenticity, integrity and confidentiality of content.

## How a Browser gets a certificate

- TLS handshake is unencrypted
- Client sends highest version of TLS supported and Cypher suites
- Server returns public key
- Client validates public key against certificate authorities (possibly pre loaded on machine)
- Client key exchange is client encrypted by servers public key
- Server can return server finished response

## HTTP to HTTPS redirect

First request is unsecure and possible for compromise by man in the middle can be solved by HSTS headers.

Enter domain name in browser for first time, browser by default sends over to server.

The server will return 301 moved permanently redirect with https.

To solve this HSTS headers can be used, HSTS headers tell browser to load domain content using https.

## HSTS headers

Http header strict-transport-security is expressed in seconds.

After loading page with HSTS when navigating to unsecure request then results in 307 internal redirect never leaving machine and internally redirects to https.

Include subdomains directive inherits HSTS policy.

## Trust on first use issue

Very first request in still open to compromise.

Increasing strict-transport-security max age still leaves Trust on First Use.

HSTS Preload keyword solves TOFU with hstspreload.org 

Add website into preload list used by Chrome, Safari, Edge, Firefox & IE browsers 

https://hstspreload.org/?domain={}

Browsers build this list into browser software so browser will never speak http from this list will internal redirect to https.

## Content security Policy

Understand active or passive content

Browser will load passive content even is resource is referenced by https

Active content is scripts and will not load.

## PKP Public Key Pinning

Man in middle has compromised certificate Authority

HPKP

Defines what public keys are avialible

Defines the max age of the public keys
Define if applicable to subdomains

To do browser headers