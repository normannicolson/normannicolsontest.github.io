# Moq ControllerContext

Dec 2021

> How to mock controllercontext using moq.

```
var mockRequestContext = new Mock<RequestContext>();
var mockHttpContext = new Mock<HttpContextBase>();
var mockHttpRequestBase = new Mock<HttpRequestBase>();
var mockHttpResponseBase = new Mock<HttpResponseBase>();
var mockOwinContext = new Mock<IOwinContext>();
var controllerBase = new Mock<ControllerBase>();

mockRequestContext
    .Setup(i => i.HttpContext)
    .Returns(mockHttpContext.Object);

mockHttpContext
    .Setup(i => i.Request)
    .Returns(mockHttpRequestBase.Object);

mockHttpContext
    .Setup(i => i.Response)
    .Returns(mockHttpResponseBase.Object);

this.controller.ControllerContext = new ControllerContext(mockRequestContext.Object, controllerBase.Object);
```
