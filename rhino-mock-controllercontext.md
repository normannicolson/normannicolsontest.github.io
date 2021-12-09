# Rhino Mocks ControllerContext

Jul 2017

> How to mock controllercontext using rhino mocks.

```
var mockRequestContext = MockRepository.GenerateMock<RequestContext>();
var mockHttpContext = MockRepository.GenerateMock<HttpContextBase>();
var mockHttpRequestBase = MockRepository.GenerateMock<HttpRequestBase>();
var mockHttpResponseBase = MockRepository.GenerateMock<HttpResponseBase>();
var controllerBase = MockRepository.GenerateMock<ControllerBase>();

mockRequestContext
    .Stub(i => i.HttpContext)
    .Return(mockHttpContext);

mockHttpContext
    .Stub(i => i.Request)
    .Return(mockHttpRequestBase);

mockHttpContext
    .Stub(i => i.Response)
    .Return(mockHttpResponseBase);

this.controller.ControllerContext = new ControllerContext(mockRequestContext, controllerBase);
```
