# Send Message to Azure Service Bus using REST endpoint with Curl

Mar 2020

> Send message to azure service bus using curl

Curl is a command line tool useful for making REST api calls in Bash or other command line tools, scripting various api interactions.

Send messages to Azure Service Bus using REST, first we need a SAS (Shared Access Signature) token to authenticate and authorise the request.

```
POST https://[namespace].servicebus.windows.net/[topic]/messages
Content-Type application/atom+xml;type=entry;charset=utf-8
Authorization SharedAccessSignature sr=https%3A%2F%2F[namespace].servicebus.windows.net%2F[topic]&sig=[Signature]&se=[Expiry]&skn=[SignatureKeyName]
```

Shared Access Signature is a uri query string containing four parameters sr, sig, se and skn.

- sr is the secured resource 
- sig is the signature 
- se is signature expiry 
- skn is shared access policy name 

## Create Access Token using C#

SAS token signature contains information about protected resource and expiry information hashed with shared access policy key.

```
private static string createToken(string resourceUri, string keyName, string key)
{
    TimeSpan sinceEpoch = DateTime.UtcNow - new DateTime(1970, 1, 1);

    var week = 60 * 60 * 24 * 7;

    var expiry = Convert.ToString((int)sinceEpoch.TotalSeconds + week);

    string stringToSign = HttpUtility.UrlEncode(resourceUri) + "\n" + expiry;
    HMACSHA256 hmac = new HMACSHA256(Encoding.UTF8.GetBytes(key));

    var signature = Convert.ToBase64String(hmac.ComputeHash(Encoding.UTF8.GetBytes(stringToSign)));
    var sasToken = String.Format(CultureInfo.InvariantCulture, "SharedAccessSignature sr={0}&sig={1}&se={2}&skn={3}", HttpUtility.UrlEncode(resourceUri), HttpUtility.UrlEncode(signature), expiry, keyName);

    return sasToken;
}
```

## String to Sign
Resource uri for service bus SAS token is topic or queue address https://[namespace].servicebus.windows.net/[topic]

Expiry Seconds after Epoch time(1970).

Url Encode resource uri with new line and expiry (seconds since 1970)

```
string stringToSign = HttpUtility.UrlEncode(resourceUri) + "\n" + expiry;
```

## Hash string using SHA256 with Shared Access Policy Key

Sign url encoded resource uri, new line and expiry using SHA256 and 

Shared Access Policy key.

```
HMACSHA256 hmac = new HMACSHA256(Encoding.UTF8.GetBytes(key));
var signature = Convert.ToBase64String(hmac.ComputeHash(Encoding.UTF8.GetBytes(stringToSign)));
Compose Token
Finally format Shared Access Signature with Url Encoded values "SharedAccessSignature sr={0}&sig={1}&se={2}&skn={3}"

var sasToken = String.Format(CultureInfo.InvariantCulture, "SharedAccessSignature sr={0}&sig={1}&se={2}&skn={3}", HttpUtility.UrlEncode(resourceUri), HttpUtility.UrlEncode(signature), expiry, keyName);
```

## Create Access Token Using Bash

Bash script depends on OpenSsl and jq dependancies use brew to simply installation. 

https://formulae.brew.sh/formula/openssl@1.1

https://formulae.brew.sh/formula/jq  

SAS token signature contains information about protected resource and expiry information hashed with shared access policy key.

```
get_sas_token() {
    local EVENTHUB_URI=$1
    local SHARED_ACCESS_KEY_NAME=$2
    local SHARED_ACCESS_KEY=$3
    local EXPIRY=${EXPIRY:=$((60 * 60 * 24))} # Default token expiry is 1 day

    local ENCODED_URI=$(echo -n $EVENTHUB_URI | jq -s -R -r @uri)
    local TTL=$(($(date +%s) + $EXPIRY))
    local UTF8_SIGNATURE=$(printf "%s\n%s" $ENCODED_URI $TTL | iconv -t utf8)

    local HASH=$(echo -n "$UTF8_SIGNATURE" | openssl sha256 -hmac $SHARED_ACCESS_KEY -binary | base64)
    local ENCODED_HASH=$(echo -n $HASH | jq -s -R -r @uri)

    echo -n "SharedAccessSignature sr=$ENCODED_URI&sig=$ENCODED_HASH&se=$TTL&skn=$SHARED_ACCESS_KEY_NAME"
}
```

```
source create-token.sh; create
```

https://docs.microsoft.com/en-us/rest/api/eventhub/generate-sas-token