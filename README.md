# Play.Inventory

Play Economy Inventory microservice

```powershell
$version="1.0.2"
$owner="dotnet-microservices-build"
$gh_pat="[PAT here]"

dotnet pack src/Play.Inventory.Contracts --configuration Release -p:PackageVersion=$version -p:RepositoryUrl=https://github.com/$owner/play.inventory -o: ../packages

dotnet nuget push ../packages/Play.Inventory.Contracts.$version.nupkg --api-key $gh_pat --source "github"
```

## Build the docker image

```powershell
$env:GH_OWNER="dotnet-microservices-build"
$env:GH_PAT="[PAT here]"

docker build --secret id=GH_OWNER --secret id=GH_PAT -t play.inventory:$version .

```

## Run the docker image

```powershell
docker run -it --rm -p 5004:5004 --name inventory -e MongoDbSettings__Host=mongo -e RabbitMQSettings__Host=rabbitmq --network playinfra_default play.inventory:$version

```

### with azure service bus

```powershell
$adminPass="[PASSWORD HERE]"
$cosmosDbConnString="[CONNECTION STRING HERE]"
$serviceBusConnString="[CONNECTION STRING HERE]"

docker run -it --rm -p 5004:5004 --name inventory -e MongoDbSettings__ConnectionString=$cosmosDbConnString -e ServiceBusSettings__ConnectionString=$serviceBusConnString -e ServiceSettings__MessageBroker="servicebus" play.inventory:$version

```

-it: creates an interactive shell so you won't be able to return to the command line terminal until you cancel the execution of the docker run command (until the docker container is stopped running)

--rm: destroys the docker container that was created as soon as the docker run execution is canceled. i.e destroys the container as soon as it is stopped running, just to keep things clean in your local machine

-p: port_on_host_machine:port_on_docker_container

-name: it is good to specify so your container does not get a random name

-e: enviroment variables to override the configs in out appsettings.json file for the microservice. In this case we override the localhost values with the container names of rabbitmq and mongo which we define in play.infra

-network: is used to specify he newtork used by the other docker containers we want to connect to. In this case the rabbitmq and mongodb containers. We can use the command to get the networks of other containers `docker network ls`
