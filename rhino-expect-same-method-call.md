# Rhino Expect Same Method Call

Sep 2017

> Using rhino mocks mocking to validate if same method called with different parameters.

```
[Test]
public async Task WhenAuditRestClientIsCalledAndFirstAttemptFails_ThenAuditCreatedAndAuditRetuned()
{
    var audit = new Audit();

    var request = MockRepository.GenerateStrictMock<IRestRequest>();

    request
        .Expect(i => i.AddJsonBody(audit))
        .Return(request);

    this.requestFactory
        .Expect(i => i.Create(Method.POST))
        .Return(request);

    var failResponse = new RestResponse<Audit>
    {
        StatusCode = System.Net.HttpStatusCode.NotFound,
        Data = new Audit()
    };

    this.client
        .Expect(i => i.ExecuteTaskAsync<Audit>(request))
        .Return(Task.FromResult<IRestResponse<Audit>>(failResponse))
        .Repeat.Once();

    var successResponse = new RestResponse<Audit>
    {
        StatusCode = System.Net.HttpStatusCode.OK,
        Data = new Audit()
    };

    this.client
        .Expect(i => i.ExecuteTaskAsync<Audit>(request))
        .Return(Task.FromResult<IRestResponse<Audit>>(successResponse))
        .Repeat.Once();

    var auditRestClient = new AuditRestClient(this.client, this.requestFactory);

    var actual = await auditRestClient.PostAsync(audit);

    Assert.AreEqual(successResponse.Data, actual);

    this.requestFactory.VerifyAllExpectations();
    this.client.VerifyAllExpectations();
}
```