# Mountebank overwire test double

Aug 2023

> Spin up a fake api in seconds, design request and responses.

Mountebank is a handy little application that spins up a fake api 

One Mountebank instance for many apis 

Download image from Docker 

```
docker pull bbyars/mountebank:2.8.2
```

Run image
```
docker run --rm -p 2525:2525 -p 4545:4545 -p 5555:5555 bbyars/mountebank:2.8.2 start 
```

## Add Hello World Endpoint 

Create payload

For port 4545 

Response code of 200

Response Json ``` { "message": "helloworld" }```

```
$data = @"
{
    "port": "4545",
    "protocol": "http",
    "stubs": [
        {
            "predicates": [
                {
                    "and":[
                        {
                            "equals": {
                                "path": "/hello",
                                "method": "GET",
                                "headers": {
                                    "Content-Type": "application/json"
                                }
                            }
                        }
                    ]
                }
            ],
            "responses": [
                {
                    "is": {
                        "statusCode": 200,
                        "headers": {
                            "Content-Type": "application/json"
                        },
                        "body": {
                            "message": "helloworld"
                        }
                    }
                }
            ]
        }
    ]
}
"@
```

Call Api by Invoke-WebRequest Add 

```
$data = $data -replace "\n", ""

Invoke-WebRequest -UseBasicParsing -Uri "http://localhost:2525/imposters" -Method Post -Body "$data" -ContentType "application/json"
```

Call Api by Httpie

Bash 

```
http Post http://localhost:2525/imposters <<<'$data'
```

Powershell

```
echo $data | http Post http://localhost:2525/imposters
```

```
echo $data | http Post http://localhost:2525/imposters
```

### Store Json payload in file 

Call imposters endpoint using httpie 

```
http Post http://localhost:2525/imposters < data.json
```

### Call Hello World Endpoint

Call Api using Invoke-WebRequest

```
Invoke-WebRequest -UseBasicParsing -Method Get -Uri http://localhost:4545/hello
```

Call using Httpie

```
http Get http://localhost:4545/hello
```

Call using Curl

```
curl -i -X GET -H 'Content-Type: application/json' http://localhost:4545/hello
```

Remove Powershell curl to Invoke-WebRequest Alias 

```
Remove-Item alias:curl 
```

Response 

```
HTTP/1.1 200 OK
Connection: close
Content-Type: application/json
Transfer-Encoding: chunked

{
    "message": "helloworld"
}
```

Remove Imposter 

```
http DELETE http://localhost:2525/imposters/4545
```

## Or create minimal API

New terminal 

```
dotnet new web -o FakeApi
cd FakeApi
```

Program.cs
```
var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

app.MapGet("/hello", async () =>
    Results.Ok(new { message="Hello World" } ) );

app.Run();
```

```
dotnet run
```

```
> Now listening on: http://localhost:5181
```

```
http get http://localhost:5181/hello
```

Response
```
http get http://localhost:5181/hello
HTTP/1.1 200 OK
Content-Type: application/json; charset=utf-8
Server: Kestrel
Transfer-Encoding: chunked

{
    "message": "Hello World"
}

```

Preferred approach as c# developer background minimal apis one for me  

Dockerfile 

```
FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src
COPY ["FakeApi.csproj", "."]
RUN dotnet restore "./FakeApi.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "FakeApi.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "FakeApi.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "FakeApi.dll"]
```

### Docker
```
docker build -f "Dockerfile" --force-rm -t nameofapi:latest .

docker run -p 54801:80 -d --name=nameofapi nameofapi:latest

docker container rm -f nameofapi

docker container ls -a
```


http get http://localhost:54801/hello