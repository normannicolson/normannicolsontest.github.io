# Feature Toggle using Cookies

Jun 2017

> Release a feature to a cohort of users, useful for ab testing.

```
public class FeatureToggleHelper : IFeatureToggleHelper
{
    public bool IsFeatureOn(HttpCookieCollection cookies, FeatureToggle feature)
    {
        var name = string.Format("FeatureToggle.{0}", feature);

        return cookies[name] != null;
    }
}

public enum FeatureToggle
{
    Report
}

public void GivenNoCookieWhenIsFeatureOnIsCalledThenFalseRetuned()
{
    var featureToggleHelper = new FeatureToggleHelper();

    var cookies = new System.Web.HttpCookieCollection();

    var result = featureToggleHelper.IsFeatureOn(cookies, Enums.FeatureToggle.Report);

    Assert.IsFalse(result);
}

public void GivenCookieWhenIsFeatureOnIsCalledThenTrueRetuned()
{
    var featureToggleHelper = new FeatureToggleHelper();

    var cookies = new System.Web.HttpCookieCollection();
    cookies.Add(new System.Web.HttpCookie("FeatureToggle.Report", string.Empty));

    var result = featureToggleHelper.IsFeatureOn(cookies, Enums.FeatureToggle.Report);

    Assert.IsTrue(result);
}
```