# Create Azure Active Directory Application using Azure Cli

Jun 2018

> Azure cli script to create active directory application identity.

Login with --allow-no-subscriptions flag enabling to access tenants without subscriptions, typically active directory tenants are without subscription.

```
az login --allow-no-subscriptions
```

List all tenants.

```
az account list
```

Outputs:

```
{
    "cloudName": "AzureCloud",
    "id": "*****",
    "isDefault": false,
    "name": "N/A(tenant level account)",
    "state": "Enabled",
    "tenantId": "*****",
    "user": {
      "name": "*****",
      "type": "user"
    }
  },
  {
    "cloudName": "AzureCloud",
    "id": "*****",
    "isDefault": true,
    "name": "N/A(tenant level account)",
    "state": "Enabled",
    "tenantId": "*****",
    "user": {
      "name": "*****",
      "type": "user"
    }
  },
```

Set default tenant.

```
az account set --subscription "{tenantId}"
```

Add application registration to default tenant.

```
az ad app create --display-name "{name}" --identifier-uris https://name.onmicrosoft.com/5efb7f9e-fb04-4eb9-94db-f67aef68e7a2 --reply-urls https://localhost:44300 https://localhost:44301 --required-resource-accesses @manifest.json
```

Manifest.json contains permissions.

```
[{
  "resourceAppId": "00000002-0000-0000-c000-000000000000",
  "resourceAccess": [
    {
      "id": "a42657d6-7f20-40e3-b6f0-cee03008a62a",
      "type": "Scope"
    }
  ]
}]
```

Outputs.

```
{
  "acceptMappedClaims": null,
  "addIns": [],
  "appId": "*****",
  "appPermissions": null,
  "appRoles": [],
  "availableToOtherTenants": false,
  "deletionTimestamp": null,
  "displayName": "name",
  "errorUrl": null,
  "groupMembershipClaims": null,
  "homepage": null,
  "identifierUris": [
    "https://name.onmicrosoft.com/*****"
  ],
  "informationalUrls": {
    "marketing": null,
    "privacy": null,
    "support": null,
    "termsOfService": null
  },
  "isDeviceOnlyAuthSupported": null,
  "keyCredentials": [],
  "knownClientApplications": [],
  "logo@odata.mediaContentType": "application/json;odata=minimalmetadata; charset=utf-8",
  "logoUrl": null,
  "logoutUrl": null,
  "oauth2AllowIdTokenImplicitFlow": true,
  "oauth2AllowImplicitFlow": false,
  "oauth2AllowUrlPathMatching": false,
  "oauth2Permissions": [
    {
      "adminConsentDescription": "Allow the application to access {name} on behalf of the signed-in user.",
      "adminConsentDisplayName": "Access name",
      "id": "*****",
      "isEnabled": true,
      "type": "User",
      "userConsentDescription": "Allow the application to access name on your behalf.",
      "userConsentDisplayName": "Access name",
      "value": "user_impersonation"
    }
  ],
  "oauth2RequirePostResponse": false,
  "objectId": "6ac12d97-6ce8-486c-abc1-dd82a3d7dd7a",
  "objectType": "Application",
  "odata.metadata": "https://graph.windows.net/992f121e-779d-406b-bc79-025b8fae18ac/$metadata#directoryObjects/Microsoft.DirectoryServices.Application/@Element",
  "odata.type": "Microsoft.DirectoryServices.Application",
  "optionalClaims": null,
  "orgRestrictions": [],
  "parentalControlSettings": {
    "countriesBlockedForMinors": [],
    "legalAgeGroupRule": "Allow"
  },
  "passwordCredentials": [],
  "publicClient": null,
  "publisherDomain": "name.onmicrosoft.com",
  "recordConsentConditions": null,
  "replyUrls": [
    "https://localhost:44300",
    "https://localhost:44301"
  ],
  "requiredResourceAccess": [
    {
      "resourceAccess": [
        {
          "id": "a42657d6-7f20-40e3-b6f0-cee03008a62a",
          "type": "Scope"
        }
      ],
      "resourceAppId": "00000002-0000-0000-c000-000000000000"
    }
  ],
  "samlMetadataUrl": null,
  "signInAudience": "AzureADMyOrg",
  "tokenEncryptionKeyId": null
}
```

Create with password.

```
az ad app create --display-name "{name}" --identifier-uris https://name.onmicrosoft.com/{name} --reply-urls https://localhost:44300 --password 1234AbCd!"£$ --end-data '2019-07-17' --required-resource-accesses @manifest.json
```

More info at https://docs.microsoft.com/en-us/cli/azure/ad?view=azure-cli-latest 