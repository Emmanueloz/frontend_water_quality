# Etapa 1: Build de Flutter
FROM ghcr.io/cirruslabs/flutter:stable AS build

WORKDIR /app

# Copiar dependencias y descargar
COPY pubspec.yaml pubspec.lock ./
RUN flutter pub get

# Copiar código fuente y buildear
COPY . .
RUN flutter config --enable-web
RUN flutter build web --release

# Etapa 2: Servir con Nginx Alpine (muy ligero)
FROM nginx:alpine

# Copiar archivos estáticos de Flutter
COPY --from=build /app/build/web /usr/share/nginx/html

# Configurar Nginx para SPA
RUN echo 'server { \
    listen 80; \
    location / { \
        root /usr/share/nginx/html; \
        try_files $uri $uri/ /index.html; \
    } \
}' > /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]