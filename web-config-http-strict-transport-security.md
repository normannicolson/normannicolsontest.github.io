# Web.Config Http Strict Transport Security

Sep 2017

> How to add HSTS Header via Web.onfig which forces suitable browsers to prevent communications from being sent over HTTP instead will send all communications over HTTPS

```
<?xml version="1.0"?>
<configuration xmlns:xdt="http://schemas.microsoft.com/XML-Document-Transform">
  <system.webServer>
    <rewrite>
      <outboundRules>
        <rule name="Add Strict-Transport-Security when HTTPS" enabled="true" xdt:Transform="Insert">
          <match serverVariable="RESPONSE_Strict_Transport_Security" pattern=".*" />
          <conditions>
            <add input="{HTTPS}" pattern="on" ignoreCase="true" />
          </conditions>
          <action type="Rewrite" value="max-age=31536000" />
        </rule>
      </outboundRules>
    </rewrite>
  </system.webServer>
</configuration>
```