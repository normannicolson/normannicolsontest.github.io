# Rhino Mocks Arg Matches

Jan 2018

> How to expect arguments when object created within method and not mocked.

```
[Test]
public void Given_metric_When_TrackMetric_is_called_Then_metric_recorded()
{
    this.telemetryClientWrapper
        .Expect(i => i.TrackMetric(Arg<MetricTelemetry>.Matches(m => m.Name == "Name" && m.Sum == 1.1)));

    this.sut.TrackMetric("Name", 1.1);
}

public void TrackMetric(string name, double value)
{
    var telemetry = new MetricTelemetry(name, value);

    this.telemetryClient.TrackMetric(telemetry);
}
```