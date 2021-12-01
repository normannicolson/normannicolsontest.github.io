# Selenium Page Model Abstraction

Dec 2017

> Abstract browser selenium interaction from test creating clean, maintainable human readable test scenarios.

```
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Nlist.Automation.Framework;
using Nlist.Automation.Site;

namespace Nlist.Automation.Test
{
    [TestClass]
    public class When_ReferralPage_is_called
    {
        [TestMethod]
        public void ValidSubmission()
        {
            foreach (var browser in new BrowserFactory().WebDrivers())
            {
                browser
                    .Navigate("url")
                    .ReferralSite().HomePage().Navigation().ReferralLink().Click()
                    .ReferralSite().ReferralPage().FirstName().Type("Norman2")
                    .ReferralSite().ReferralPage().LastName().Type("Auto2")
                    .ReferralSite().ReferralPage().EmailAddress().Type("emailaddress@mailinator.com")
                    .ReferralSite().ReferralPage().Submit().Click()

                    .ReferralSite().ReferralSuccessPage().Heading().Should().Be("Referral Sent")

                    .Navigate("")
                    .ProviderSite().HomePage().Navigation().RetrieveReferralLink().Click()
                    .ProviderSite().InvitePage().EmailAddress().Should().Be("emailaddress@mailinator.com")
                    .ProviderSite().InvitePage().Submit().Click()
                    .ProviderSite().InviteSuccessPage().Heading().Should().Be("Invite Success")

                    .Navigate("https://www.mailinator.com/v2/inbox.jsp")
                    .MailinatorSite().HomePage().InboxTextBox().Type("emailaddress")
                    .MailinatorSite().HomePage().InboxButton().Click()
                    .MailinatorSite().InboxPage().FirstEmailLink().Click()
                    .MailinatorSite().EmailPage().EmailMessage().CompleteInviteLink().Should().Be("Complete Invite")
                    .MailinatorSite().EmailPage().EmailMessage().CompleteInviteLink().Click()

                    .ServiceSite().RegistrationWelcomePage().ContinueButton().Should().Be("Click here to continue by logging in")
                    .ServiceSite().RegistrationWelcomePage().ContinueButton().Click()

                    .LoginSite().IdpSelectorPage().MicrosoftButton().Click()
                    .LoginSite().MicrosoftUsernamePage().Email().Type("emailaddress@mailinator.com")
                    .LoginSite().MicrosoftUsernamePage().Submit().Click()
                    .LoginSite().MicrosoftPasswordPage().Password().Type("***************")
                    .LoginSite().MicrosoftUsernamePage().Submit().Click();
            }
        }
    }
}
```

```
using Nlist.Automation.Framework;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Nlist.Automation.Site.Services
{
    public class ServiceSite
    {
        private Browser context;

        public ServiceSite(Browser context)
        {
            this.context = context;
        }

        public RegistrationWelcomePage RegistrationWelcomePage()
        {
            return new RegistrationWelcomePage(this.context);
        }
    }
}
```

```
using OpenQA.Selenium;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Nlist.Automation.Framework
{
    public class BrowserPage
    {
        public Browser context;

        public BrowserPage(Browser context)
        {
            context.Driver.SwitchTo().Window(context.Driver.WindowHandles.Last());
            context.Driver.SwitchTo().ParentFrame();
            
            context.Element = context.Driver.FindElement(By.TagName("html"));

            this.context = context;
        }
    }
}
```

```
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using OpenQA.Selenium;

namespace Nlist.Automation.Framework
{
    public class Control
    {
        private Browser context;

        public Control(Browser context)
        {
            this.context = context;
        }

        public Browser Click()
        {
            this.context.Element.Click();
            return this.context;
        }

        public Browser Clear()
        {
            this.context.Element.Clear();
            return this.context;
        }

        public Browser Type(string value)
        {
            this.context.Element.SendKeys(value);
            return this.context;
        }

        public Browser Select(string value)
        {
            OpenQA.Selenium.Support.UI.SelectElement selectElement = new OpenQA.Selenium.Support.UI.SelectElement(this.context.Element); 
            selectElement.SelectByText(value);

            return this.context;
        }

        public ControlAssert Should()
        {
            return new ControlAssert(this.context);
        }
    }
}
```

```
namespace Nlist.Automation.Framework
{
    public class ControlAssert
    {
        private Browser context;

        public ControlAssert(Browser context)
        {
            this.context = context;
        }

        public Browser Be(string value)
        {
            if (this.context.Element.TagName == "input"  && this.context.Element.GetAttribute("type") == "text")
            {
                var attribute = this.context.Element.GetAttribute("value");
                Assert.AreEqual(value, attribute);
            }
            else
            {
                Assert.AreEqual(value, this.element.Text);
            }

            return this.context;
        }

        public Browser HaveCssClass(string className)
        {
            return this.context;
        }
    }
}
```