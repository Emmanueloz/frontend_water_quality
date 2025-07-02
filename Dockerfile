# Build de la aplicación Flutter
FROM ghcr.io/cirruslabs/flutter:stable

# Establecer directorio de trabajo
WORKDIR /app

# Copiar archivos de configuración
COPY pubspec.yaml pubspec.lock ./

# Instalar dependencias
RUN flutter pub get

# Copiar el código fuente
COPY . .

# Habilitar Flutter web
RUN flutter config --enable-web

# Build de la aplicación para web
RUN flutter build web --release