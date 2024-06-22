# Create self signed certificate

Jun 24

> Use openssl to create self signed certificate

Create Local Certificate Authority private key

```
openssl genrsa -out nlist-ca.key 4096
```

Create public key 

```
openssl rsa -in nlist-ca.key -pubout -out nlist-ca-public.key
```

Create Certificate Signing Request 

```
openssl req -new -key nlist-ca.key -out nlist-ca.csr -subj "/C=UK/ST=Scotland/L=Isle of Skye/O=Nlist Limited./OU=IT/CN=nlist-ca"
```

View Certificate Signing Request Infomation

```
openssl req -text -in nlist-ca.csr -noout -verify
```

## Create self signed certificate authority from Certificate Signing Request

Create self signed certificate authority 

```
openssl x509 -signkey nlist-ca.key -in nlist-ca.csr -req -days 365 -out nlist-ca.crt
```

Viewing Certificate Information

```
openssl x509 -text -in nlist-ca.crt -noout
```

Verifying Your Keys Match

```
openssl pkey -pubout -in nlist-ca.key | openssl sha256

openssl req -pubkey -in nlist-ca.csr -noout | openssl sha256

openssl x509 -pubkey -in nlist-ca.crt -noout | openssl sha256
```

## Create self signed certificate 

Create domain CSR

```
openssl req -new -key nlist-ca.key -out nlist-domain.csr -subj "/C=UK/ST=Scotland/L=Isle of Skye/O=Nlist Limited./OU=IT/CN=nlist.co.uk"
```

View CSR Infomation

```
openssl req -text -in nlist-domain.csr -noout -verify
```

```
openssl x509 -req -days 180 -CA nlist-ca.crt -CAkey nlist-ca.key -CAcreateserial -in nlist-domain.csr -out nlist-domain.crt
```

or use certificate authority private key for self signed ```-signkey nlist-ca.key ```

```
openssl x509 -req -days 180 -in nlist-domain.csr -signkey nlist-ca.key -out nlist-domain.crt
```

Viewing Certificate Information

```
openssl x509 -text -in nlist-domain.crt -noout
```

Verifying Your Keys Match

```
openssl req -pubkey -in nlist-domain.csr -noout | openssl sha256

openssl x509 -pubkey -in nlist-domain.crt -noout | openssl sha256
```

Verify certificate chain

```
openssl verify -CAfile nlist-ca.crt nlist-domain.crt
```

openssl verify nlist-domain.crt