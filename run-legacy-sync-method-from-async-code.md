# Run Legacy Sync Method From Async Code

Jun 2018

> Run legacy sync methods from async code useful when interface async.

Run sync code from async code.

```
return await Task.Run(() =>
{
    return model.Method();
});
```