FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app

# ensure /app is owned by the 'app' user so the runtime can write keys there
RUN mkdir -p /app && chown -R app:app /app

EXPOSE 5004

ENV ASPNETCORE_URLS=http://+:5004

USER app
FROM --platform=$BUILDPLATFORM mcr.microsoft.com/dotnet/sdk:8.0 AS build
ARG configuration=Release
WORKDIR /src
COPY ["src/Play.Inventory.Contracts/Play.Inventory.Contracts.csproj", "Play.Inventory.Contracts/"]
COPY ["src/Play.Inventory.Service/Play.Inventory.Service.csproj", "Play.Inventory.Service/"]

RUN --mount=type=secret,id=GH_OWNER,dst=/GH_OWNER --mount=type=secret,id=GH_PAT,dst=/GH_PAT \
    dotnet nuget add source --username USERNAME --password `cat /GH_PAT` --store-password-in-clear-text --name github "https://nuget.pkg.github.com/`cat /GH_OWNER`/index.json"
RUN dotnet restore "Play.Inventory.Service/Play.Inventory.Service.csproj"
COPY ./src .
WORKDIR "/src/Play.Inventory.Service"

RUN dotnet publish "Play.Inventory.Service.csproj" -c $configuration --no-restore -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "Play.Inventory.Service.dll"]
