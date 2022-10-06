# Docker Sonarqube for local development

Oct 2022

> Install setup Sonarqube

Pull image 
```
docker pull sonarqube:9.6.1-community
```

Create container
```
docker create --name sonarqube sonarqube
```

Run container in detached terminal with mapped ports  
```
docker run -d -p 9000:9000 -p 9092:9092 sonarqube
```

Navigate to sonarqube http://localhost:9000/

Login using defaults with username *admin* password *admin*.

Create new password when prompted.

As its local setup manually enter project name and select local analyse your repository.

Continue with automatically generated token.

Select *Run analysis on your project* select *.Net* then follow Execute the Scanner instructions listed. 

Change terminal location to solution folder 

Ensure tools installed 
```
dotnet tool install --global dotnet-sonarscanner
```

Update projects in folder with sonarscanner SonarProject configs
```
dotnet sonarscanner begin /k:"Appeals" /d:sonar.host.url="http://localhost:9000"  /d:sonar.login="sqp_9de0eeab88e3e8954a173181fe21ad5ae31df75b"
```

Build solution

```
dotnet build
```

Send and complete scan
```
dotnet sonarscanner end /d:sonar.login="sqp_9de0eeab88e3e8954a173181fe21ad5ae31df75b"
```

Java dependency    

May get following error if Java not installed 

```
ERROR: JAVA_HOME not found in your environment, and no Java executable present in the PATH.
Please set the JAVA_HOME variable in your environment to match the
location of your Java installation, or add "java.exe" to the PATH
```

Resolve by downloading and installing Java https://www.oracle.com/java/technologies/downloads/ 

Stop container
```
docker stop sonarqube
```

Remove container
```
docker rm sonarqube
```