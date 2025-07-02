# Etapa de construcción de Flutter
FROM cirruslabs/flutter:latest AS build-env

# Habilitar soporte web (ya hecho, pero útil tenerlo aquí)
RUN flutter config --enable-web

# Crear un directorio para tu aplicación en el contenedor
RUN mkdir /app/
COPY . /app/
WORKDIR /app/

# Obtener dependencias de Flutter
RUN flutter pub get

# Construir la aplicación web en modo release
RUN flutter build web --release

# Etapa de ejecución con Nginx
FROM nginx:1.26-alpine3.19-slim

# Copiar los archivos construidos de Flutter a la ubicación de Nginx
COPY --from=build-env /app/build/web /usr/share/nginx/html

# Exponer el puerto 80 para el servidor web
EXPOSE 80

# Comando para iniciar Nginx
CMD ["nginx", "-g", "daemon off;"]