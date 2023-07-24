# Create Azure B2c Identity Experience Framework App Registration

Nov 2021

> Create Azure B2c Identity Experience Framework App Registration Bash script using Azure Cli

B2c directorates are not compatible with Azure Resource Manager(ARM) Templates, directories are manually configured, key setup steps are creating Identity Experience Framework application registration and Proxy Identity Experience Framework Application registration they provide ability to use advanced custom policies and connectivity between B2c and AD allowing users to sign in and enrich claims. 

Switch Azure Cli to newly created B2c Directory 

## Script

```
#!/bin/bash -x

graphApplicationAppId="00000003-0000-0000-c000-000000000000"
graphOpenIdPermissionId="37f7f235-527c-4136-accd-4a02d197296e"
graphOfflineAccessPermissionId="7427e0e9-2fba-42fe-b0c0-848c9e6a8182"
tenant=$1
applicationName="IdentityExperienceFramework"
userImpersonationPermissionId="00000000-0000-0000-0000-000000000001"

#Check if application exists 
read applicationId <<< $(az rest --method GET --uri "https://graph.microsoft.com/v1.0/applications" --headers "Content-Type=application/json" --query "value[?displayName == '$applicationName'][id]" --output tsv)

if [ -z "$applicationId" ]
then
	echo "Creating Application"
	read applicationId applicationAppId <<< $(az rest --method POST --uri "https://graph.microsoft.com/v1.0/applications" --headers "Content-Type=application/json" --body "{\"displayName\":\"$applicationName\",\"identifierUris\": [\"https://$tenant.onmicrosoft.com/$applicationName\"],\"api\": {\"acceptMappedClaims\": null,\"knownClientApplications\": [],\"oauth2PermissionScopes\":[{\"adminConsentDescription\": \"Allows application to access IdentityExperienceFramework on behalf of user.\",\"adminConsentDisplayName\": \"Access IdentityExperienceFramework\",\"id\": \"$userImpersonationPermissionId\",\"isEnabled\":true,\"type\":\"Admin\",\"userConsentDescription\": null,\"userConsentDisplayName\": null,\"value\": \"user_impersonation\"}],\"preAuthorizedApplications\": [],\"requestedAccessTokenVersion\": null},\"signInAudience\": \"AzureADMyOrg\",\"requiredResourceAccess\":[{\"resourceAppId\": \"$graphApplicationAppId\",\"resourceAccess\":[{\"id\": \"$graphOpenIdPermissionId\",\"type\": \"Scope\"},{\"id\": \"$graphOfflineAccessPermissionId\",\"type\": \"Scope\"}]}],\"web\": {\"homePageUrl\": null,\"implicitGrantSettings\": {\"enableAccessTokenIssuance\": false,\"enableIdTokenIssuance\": false},\"logoutUrl\": null,\"redirectUris\": [\"https://$tenant.b2clogin.com/$tenant.onmicrosoft.com\"]}}" --query "{id:id, appId:appId}" --output tsv) 
	sleep 10s

	echo "Granting Admin Consent"
	az ad app permission admin-consent --id "$applicationId"
	sleep 10s
fi

#read -p "Press enter to continue"
```

## Use
```
.\create-identity-experience-framework-app.sh tenant
```