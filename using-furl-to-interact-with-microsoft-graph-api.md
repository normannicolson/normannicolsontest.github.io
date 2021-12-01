# Using Furl to Interact with Microsoft Graph Api

Oct 2018

> Furl is an easy to use fluent http client with many extension methods taking a string and making an api call to de/serializing.

## Use Furl to gain Bearer Token

```
namespace Nlist.Data.ActiveDirectory.Clients
{
    using System;
    using System.Threading.Tasks;
    using Nlist.Core.Clients;
    using Nlist.Core.Models;
    using Nlist.Data.ActiveDirectory.Models;
    using Flurl.Http;

    public class TokenClient : ITokenClient
    {
        private const string GrantType = "client_credentials";
        private readonly TokenClientSettings tokenClientSettings;

        public TokenClient(TokenClientSettings tokenClientSettings)
        {
            this.tokenClientSettings = tokenClientSettings;
        }

        public async Task<Token> GetTokenAsync()
        {
            var tokenUri = this.tokenClientSettings.TokenEndpoint;

            var tokenResponse = await tokenUri
                .PostUrlEncodedAsync(
                    new
                    {
                        grant_type = GrantType,
                        client_id = this.tokenClientSettings.TokenClientId,
                        client_secret = this.tokenClientSettings.TokenClientSecret
                    })
                .ReceiveJson<TokenResponse>();

            var token = new Token
            {
                TokenType = tokenResponse.TokenType,
                ExpiresIn = tokenResponse.ExpiresIn,
                ExtExpiresIn = tokenResponse.ExtExpiresIn,
                ExpiresOn = tokenResponse.ExpiresOn,
                NotBefore = tokenResponse.NotBefore,
                Resource = tokenResponse.Resource,
                AccessToken = tokenResponse.AccessToken
            };

            return token;
        }
    }
}
```

## Call Microsoft Graph Api

Retrieve user using Rest Api

```
namespace Nlist.Data.ActiveDirectory.Clients
{
    using System;
    using System.Collections.Generic;
    using System.Globalization;
    using System.Linq;
    using System.Net;
    using System.Threading.Tasks;
    using Nlist.Core.Clients;
    using Nlist.Core.Models;
    using Nlist.Data.ActiveDirectory.Helper;
    using Nlist.Data.ActiveDirectory.Models;
    using Flurl.Http;

    public class UserClient : IUserClient
    {
        private const string GrantType = "client_credentials";
        private const string EmailAddress = "emailAddress";
        private const string ContentTypeHeaderName = "Content-Type";
        private const string ContentTypeHeaderApplicationJson = "application/json; charset=utf-8";
        private readonly UserClientSettings userClientSettings;

        public UserClient(UserClientSettings userClientSettings)
        {
            this.userClientSettings = userClientSettings;
        }

        public async Task<User> GetUserAsync(Guid id)
        {
            var userUri = string.Format(CultureInfo.InvariantCulture, this.userClientSettings.GraphApiUserEndpointPattern, id);

            var tokenResponse = await this.GetToken();

            try
            {
                var userResponse = await userUri
                    .WithOAuthBearerToken(tokenResponse.AccessToken)
                    .ReceiveJson<UserResponse>();

                var user = new User
                {
                    ObjectId = userResponse.ObjectId,
                    Email = userResponse.SignInNames.First(i => i.Type.Equals(EmailAddress, StringComparison.InvariantCulture)).Value,
                    GivenName = userResponse.GivenName,
                    Surname = userResponse.Surname,
                    SecurityQuestionAnswers = new List<SecurityQuestionAnswer>
                    {
                        new SecurityQuestionAnswer(userResponse.FirstSecurityQuestion),
                        new SecurityQuestionAnswer(userResponse.SecondSecurityQuestion),
                        new SecurityQuestionAnswer(userResponse.ThirdSecurityQuestion),
                    },
                };

                return user;
            }
            catch (FlurlHttpException ex)
            {
                if (ex.Call.HttpStatus == System.Net.HttpStatusCode.NotFound)
                {
                    return null;
                }

                throw ex;
            }
        }
    }
}
```

Retrive string.

```
var userResponse = await "userUri"
    .WithOAuthBearerToken(tokenResponse.AccessToken)
    .GetStringAsync();
```

Retrive Json object.

```
var userResponse = await "userUri"
    .WithOAuthBearerToken(tokenResponse.AccessToken)
    .ReceiveJson<UserResponse>();
```

More information at https://flurl.io/ 