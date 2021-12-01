# Using Ngrok to tunnel from web to localhost

Nov 2018

> Using Ngrok to tunnel from web to localhost allowing cloud service call localhost.

After downloading move Ngrok ngrok.exe to desired location.

## Connect Account

```
ngrok authtoken ***************************************************
```

Outputs

```
Authtoken saved to configuration file: C:\Users\Norman.Nicolson/.ngrok2/ngrok.yml
```

## Expose a local webserver

```
ngrok http 80
```

More information at https://dashboard.ngrok.com/get-started