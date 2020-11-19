FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build-env
WORKDIR /app
# Copia csproj
COPY *.csproj ./
# restaura las dependencias y las herramientas de un proyecto
RUN dotnet restore
# Copia todo y  everything else and build
COPY . ./
# compila la aplicación, lee sus dependencias especificadas en el archivo de proyecto y publica el conjunto resultante de archivos en un directorio
RUN dotnet publish -c Release -o out
# Build runtime image
FROM mcr.microsoft.com/dotnet/core/aspnet:3.1
ENV MONGO_URI=mongodb://mymongo:27017
WORKDIR /app
EXPOSE 80
COPY --from=build-env /app/out .
ENTRYPOINT ["dotnet", "backend.dll"]