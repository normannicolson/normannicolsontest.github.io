# Dotnet Core Localisation

Oct 2018

> Localisation capabilities using dotnet core.

As with other versions, .net localisation capabilities are centred round the use of resx files, language strings contained embedded resource in key value pairs.

Localisation has improved with dotnet with ILocation provider.

ILocalisation provides a central service to interact with language phrases within controllers, classes and views, implement own custom ILocalisation provider for example interacting with a SAAS providing translation.

Default localisation uses convention, all Resx files are all contained in Resources folder, Resources folder mirrors application folder structure.

Home Controller Index view in ~/Views/Home/Index.cshtml will use resource file ~/Resources/Views/Home/Index.en-GB.resx 

## Localised view using IViewLocalizer

```
@using Microsoft.AspNetCore.Mvc.Localization

@inject IViewLocalizer Localizer

<h1>@Localizer["Example Title"]</h1>
<p>@Localizer["Example summary"]</p>
```

Controller.

```
namespace Nlist.Web.Controllers
{
    using Nlist.Telemetry.Loggers;
    using Microsoft.AspNetCore.Cors;
    using Microsoft.AspNetCore.Mvc;

    public class ExampleController : Controller
    {
        public IActionResult Error(string id)
        {
            return this.View();
        }
    }
}
```

Mirror folders in Resources directory.

```
<?xml version="1.0" encoding="utf-8"?>
<root>
  <xsd:schema id="root" xmlns="" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:msdata="urn:schemas-microsoft-com:xml-msdata">
    <xsd:import namespace="http://www.w3.org/XML/1998/namespace" />
    <xsd:element name="root" msdata:IsDataSet="true">
      <xsd:complexType>
        <xsd:choice maxOccurs="unbounded">
          <xsd:element name="metadata">
            <xsd:complexType>
              <xsd:sequence>
                <xsd:element name="value" type="xsd:string" minOccurs="0" />
              </xsd:sequence>
              <xsd:attribute name="name" use="required" type="xsd:string" />
              <xsd:attribute name="type" type="xsd:string" />
              <xsd:attribute name="mimetype" type="xsd:string" />
              <xsd:attribute ref="xml:space" />
            </xsd:complexType>
          </xsd:element>
          <xsd:element name="assembly">
            <xsd:complexType>
              <xsd:attribute name="alias" type="xsd:string" />
              <xsd:attribute name="name" type="xsd:string" />
            </xsd:complexType>
          </xsd:element>
          <xsd:element name="data">
            <xsd:complexType>
              <xsd:sequence>
                <xsd:element name="value" type="xsd:string" minOccurs="0" msdata:Ordinal="1" />
                <xsd:element name="comment" type="xsd:string" minOccurs="0" msdata:Ordinal="2" />
              </xsd:sequence>
              <xsd:attribute name="name" type="xsd:string" use="required" msdata:Ordinal="1" />
              <xsd:attribute name="type" type="xsd:string" msdata:Ordinal="3" />
              <xsd:attribute name="mimetype" type="xsd:string" msdata:Ordinal="4" />
              <xsd:attribute ref="xml:space" />
            </xsd:complexType>
          </xsd:element>
          <xsd:element name="resheader">
            <xsd:complexType>
              <xsd:sequence>
                <xsd:element name="value" type="xsd:string" minOccurs="0" msdata:Ordinal="1" />
              </xsd:sequence>
              <xsd:attribute name="name" type="xsd:string" use="required" />
            </xsd:complexType>
          </xsd:element>
        </xsd:choice>
      </xsd:complexType>
    </xsd:element>
  </xsd:schema>
  <resheader name="resmimetype">
    <value>text/microsoft-resx</value>
  </resheader>
  <resheader name="version">
    <value>2.0</value>
  </resheader>
  <resheader name="reader">
    <value>System.Resources.ResXResourceReader, System.Windows.Forms, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089</value>
  </resheader>
  <resheader name="writer">
    <value>System.Resources.ResXResourceWriter, System.Windows.Forms, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089</value>
  </resheader>
  <data name="Example Title" xml:space="preserve">
    <value>错误</value>
  </data>
</root>
```

Register on Startup

```
namespace Nlist.Web
{
    using System;
    using System.Collections.Generic;
    using System.Globalization;
    using Microsoft.AspNetCore.Builder;
    using Microsoft.AspNetCore.Hosting;
    using Microsoft.AspNetCore.Localization;
    using Microsoft.Extensions.Configuration;
    using Microsoft.Extensions.DependencyInjection;
    using Microsoft.IdentityModel.Tokens;

    public class Startup
    {
        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        public static IConfiguration Configuration { get; set; }

        public void ConfigureServices(IServiceCollection services)
        {
            services.AddLocalization(options => options.ResourcesPath = "Resources");
        }

        public void Configure(IApplicationBuilder app, IHostingEnvironment env)
        {
            var supportedCultures = new[]
            {
                new CultureInfo(Cultures.EnGB),
                new CultureInfo(Cultures.FrFR),
                new CultureInfo(Cultures.Fr),
                new CultureInfo(Cultures.ZhHK)
            };

            app.UseRequestLocalization(new RequestLocalizationOptions
            {
                DefaultRequestCulture = new RequestCulture(Cultures.EnGB),
                SupportedCultures = supportedCultures,
                SupportedUICultures = supportedCultures
            });
        }
    }
}
```

Override browser culture using culture parameters.

Culture parameter determines date, time, number, and currency formatting and sets request culture.

Ui-culture parameter controls determines resx strings are displayed.

```
/?culture=nl-BE&ui-culture=nl-BE
```

Localisation within Classes using IStringLocalizer

```
namespace Nlist.Web.Services
{
    using System.Collections.Generic;
    using Nlist.Core.Services;
    using Microsoft.Extensions.Localization;

    public class EmailTemplateService : IEmailTemplateService
    {
        private readonly IStringLocalizer<EmailTemplateService> localizer;

        public EmailTemplateService(IStringLocalizer<EmailTemplateService> localizer)
        {
            this.localizer = localizer;
        }

        public string Parse(string name, dynamic data)
        {
            var template = this.localizer[name].Value;

            var requestDictionary = ConvertToDictionary(data);

            foreach (var keyValue in requestDictionary)
            {
                var placeholder = "{" + keyValue.Key + "}";
                template = template.Replace(placeholder, keyValue.Value);
            }

            return template;
        }

        private static Dictionary<string, object> ConvertToDictionary(dynamic data)
        {
            var dictionary = new Dictionary<string, object>();

            foreach (var propertyDescriptor in System.ComponentModel.TypeDescriptor.GetProperties(data))
            {
                var value = propertyDescriptor.GetValue(data).ToString();
                dictionary.Add(propertyDescriptor.Name, value);
            }

            return dictionary;
        }
    }
}
```

```
namespace Nlist.Web.Controllers
{
    using System;
    using System.Collections.Generic;
    using System.Dynamic;
    using System.Threading.Tasks;
    using Nlist.Core.Services;
    using Nlist.Web.Models;
    using Microsoft.AspNetCore.Authorization;
    using Microsoft.AspNetCore.Mvc;

    [Authorize(Policy = Constants.AuthorizePolicies.Jwt)]
    [Route(Constants.Routes.ApiControllerPattern)]
    public class EmailTemplateController : Controller
    {
        private readonly IEmailTemplateService emailTemplateService;

        public EmailTemplateController(IEmailTemplateService emailTemplateService)
        {
            this.emailTemplateService = emailTemplateService;
        }

        [HttpPost(Constants.Routes.ActionPattern)]
        public IActionResult Parse(string id, [FromBody]dynamic data)
        {
            var contentResult = new ContentResult
            {
                Content = this.emailTemplateService.Parse(id, data)
            };

            return contentResult;
        }
    }
}
```