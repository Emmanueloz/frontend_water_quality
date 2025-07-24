# Etapa 1: Build de Flutter
FROM ghcr.io/cirruslabs/flutter:stable AS build

WORKDIR /app

# Copiar y descargar dependencias
COPY pubspec.* ./
RUN flutter pub get

# Copiar todo el código
COPY . .

# Asegurar que sólo web está habilitado
RUN flutter config --enable-web

# Build de la app
RUN flutter build web --release

# Etapa 2: Servir con Nginx Alpine
FROM nginx:alpine

# Copiar archivos web generados
COPY --from=build /app/build/web /usr/share/nginx/html

# Configurar Nginx para manejar rutas tipo SPA
RUN rm /etc/nginx/conf.d/default.conf && \
    echo 'server { \
        listen 80; \
        server_name localhost; \
        root /usr/share/nginx/html; \
        index index.html; \
        location / { \
            try_files $uri $uri/ /index.html; \
            add_header Cache-Control "no-store, no-cache, must-revalidate, proxy-revalidate, max-age=0"; \
        } \
    }' > /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
