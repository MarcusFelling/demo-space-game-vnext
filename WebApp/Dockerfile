FROM mcr.microsoft.com/dotnet/aspnet:5.0-buster-slim AS build-env
WORKDIR /app

# Copy the published web app
COPY *.csproj ./
RUN dotnet restore

# Copy everything else and build
COPY . ./
RUN dotnet publish -c Release -o out

# Run command
FROM mcr.microsoft.com/dotnet/aspnet:5.0-buster-slim
WORKDIR /app
COPY --from=build-env /app/out .
ENTRYPOINT ["dotnet", "aspnet-core-dotnet-core.dll"]