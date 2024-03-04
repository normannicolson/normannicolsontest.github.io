
https://learn.microsoft.com/en-us/azure/container-registry/container-registry-get-started-docker-cli?tabs=azure-cli


az config set core.allow_broker=true
az account clear
az login


az acr login --name myregistry


az acr login --name normannicolson



docker ps

CONTAINER ID   IMAGE                                     COMMAND                  CREATED          STATUS          PORTS                                           NAMES
8e205f40a9a4   dockercompose6627046938699081999-db       "/opt/mssql/bin/perm…"   22 minutes ago   Up 22 minutes   0.0.0.0:1433->1433/tcp                          appealsdb  

Commit docker container 
docker commit appealsdb

PS C:\Repositories\GitHub\notes> docker commit appealsdb
sha256:d9a30be3def60ad096deafd2381326206d5c26c9f793e302d4091384b9d5d159

docker images -a
PS C:\Repositories\GitHub\notes> docker images -a
REPOSITORY                                TAG               IMAGE ID       CREATED              SIZE  
<none>                                    <none>            d9a30be3def6   About a minute ago   1.76GB
dockercompose6627046938699081999-db       latest            6637c63cbb23   34 minutes ago       1.6GB 



docker tag d9a30be3def6 normannicolson.azurecr.io/appeals-db


docker push normannicolson.azurecr.io/appeals-db















parameters:
  vstsFeed: ''
  buildConfiguration: ''
  versionSuffix: ''
  publishOutput: ''

steps:

  - script: 'docker --version'
    displayName: 'docker version'

    #  mv ./docker/ssl/localhost.crt ./src/localhost.crt
    #  mv ./docker/ssl/localhost.pfx ./src/localhost.pfx

  - script: |
      echo "Create certs into root"

      openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout localhost.key -out localhost.crt -config ./docker/ssl/localhost.conf -subj /CN=localhost
      openssl pkcs12 -export -out localhost.pfx -inkey localhost.key -in localhost.crt -passout pass:localhost

      echo "Move .crt into src"
      mv ./localhost.crt ./src

      echo "Move .pfx into $HOME/.aspnet/https/"
      mkdir -p $HOME/.aspnet/https/
      mv ./localhost.pfx $HOME/.aspnet/https/localhost.pfx
    displayName: 'make cert'

  - script: |
      cd ./docker/Docker
      docker compose up --detach
    displayName: 'docker compose'

  - script: |
      docker images 
    displayName: 'docker images'

  - script: |
      docker ps
    displayName: 'docker ps'

  - script: |
      docker logs subjectapi
    displayName: 'docker logs subjectapi'

  - script: |
      docker exec subjectapi ls
    displayName: 'docker exec subjectapi ls'

  - script: |
      sleep 30s
      docker ps
    displayName: 'docker ps 30s'

  # - script: |
  #     echo ""
  #     curl http://localhost:5002/      
  #     echo ""
  #     curl https://localhost:55302/ --insecure
  #     echo ""
  #     curl https://localhost:55303/ --insecure
  #     echo ""
  #     curl https://localhost:55302/subjects --insecure
  #     echo ""
  #     curl https://localhost:55303/centres --insecure
  #     echo ""
  #     curl https://localhost:55300/ --insecure
  #   displayName: 'curl'

  # - script: |
  #     docker exec database ls
  #     docker exec tests ls

  #   displayName: 'docker exec ls'

  - script: |
      docker exec tests npx prisma generate
      docker exec tests npm run test

    displayName: 'docker exec tests'

  # - script: |
  #     cd ./src
  #     docker build --file Example.Protected.SubjectApi.Web/Dockerfile --tag subjectapi:2 .
  #     cd .././docker
  #     docker build --file Docker.Database/Dockerfile --tag database:2  .
  #     cd ./src
  #     docker build --file Example.Protected.CentreApi.Web/Dockerfile --tag centreapi:2  .
  #     cd ./src
  #     docker build --file Example.Protected.Ui.BlazorWasm.Server/Dockerfile --tag ui:2  .
  #     cd .././e2e
  #     docker build --file Dockerfile --tag tests:2 .
  #   displayName: 'alternative docker build'

  # - script: |
  #     docker run -e "ASPNETCORE_ENVIRONMENT=Development" -e "ASPNETCORE_URLS=https://+:443;http://+:80" -p "5002:80" -p "55302:443" -v "${APPDATA}/Microsoft/UserSecrets:/root/.microsoft/usersecrets:ro" -v "${APPDATA}/ASP.NET/Https:/root/.aspnet/https:ro" -t -d --name subjectapi subjectapi:2
  #     docker ps
  #     docker run -e DATABASE_URL=sqlserver://localhost:1433;database=Example;user=sa;password=Password@123;trustServerCertificate=true tests 
  #     docker ps
  #   displayName: 'alternative docker run'

  # - script: |
  #     docker exec subjectapi ls
  #   displayName: 'docker exec'

  # - script: |
  #     echo ""
  #     curl http://localhost:5002/      
  #     echo ""
  #     curl https://localhost:55302/ --insecure
  #     echo ""
  #     curl https://localhost:55303/ --insecure
  #     echo ""
  #     curl https://localhost:55302/subjects --insecure
  #     echo ""
  #     curl https://localhost:55303/centres --insecure
  #     echo ""
  #     curl https://localhost:55300/ --insecure
  #   displayName: 'curl'

  # - script: |
  #     cd ./e2e
  #     npm install
  #     npx playwright install
  #   displayName: 'npm install'

  # - script: |
  #     cd ./e2e
  #     npx prisma generate
  #     npm run test 
  #   displayName: 'bdd tests against container'

  # - script: |
  #     cd ./docker/Docker
  #     docker compose stop
  #   displayName: 'docker compose stop'

  # - script: |
  #     docker run -d database
  #     sleep 30s
  #     docker ps
  #     docker ps
  #   displayName: 'docker scripts'