# Web.Config Transform Redirect All Requests to Https

Sep 2017

> Transform Web.Config to include extra elements

```
<system.webServer>
  <rewrite xdt:Transform="Insert">
    <rules>
      <rule name="Force HTTPS">
        <match url=".*" />
        <conditions>
          <add input="{HTTPS}" pattern="off" ignoreCase="true" />
        </conditions>
        <action type="Redirect" url="https://{HTTP_HOST}/{R:0}" appendQueryString="true" redirectType="Permanent" />
      </rule>
    </rules>
  </rewrite>
</system.webServer>
```