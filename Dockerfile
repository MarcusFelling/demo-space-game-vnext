FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src

COPY ["web-app/web-app.csproj", "web-app/"]
RUN dotnet restore "web-app/web-app.csproj"
COPY . .
WORKDIR "/src/web-app"
RUN dotnet build "web-app.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "web-app.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "web-app.dll"]