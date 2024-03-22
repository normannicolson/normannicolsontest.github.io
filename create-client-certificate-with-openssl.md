# Create Client Certificate with Openssl *

Nov 2017

> Walkthrough create a self-signed certificate using openssl.

Create configuration file 

```
touch example.conf
```

Update example.conf file 

```
[req]
default_bits       = 2048
default_keyfile    = example.key
distinguished_name = req_distinguished_name
req_extensions     = req_ext
x509_extensions    = v3_ca

[req_distinguished_name]
commonName         = Example

[req_ext]
subjectAltName = @alt_names

[v3_ca]
subjectAltName = @alt_names
basicConstraints = critical, CA:false
keyUsage = keyCertSign, cRLSign, digitalSignature,keyEncipherment
extendedKeyUsage = 1.3.6.1.5.5.7.3.1
1.3.6.1.4.1.311.84.1.1 = DER:01

[alt_names]
DNS.1   = host.docker.internal
DNS.2   = 127.0.0.1
DNS.3   = api
DNS.4   = ui
DNS.5   = localhost
```

Generate certificate

```
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout example.key -out example.crt -config example.conf -subj /CN=example
```

Create pfx

```
openssl pkcs12 -export -out example.pfx -inkey example.key -in example.crt -passout pass:example
```