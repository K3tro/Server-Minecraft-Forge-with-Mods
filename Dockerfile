# Usar OpenJDK Alpine (ligero)
FROM azul/zulu-openjdk-alpine:21-jre-latest

# Instalar herramientas necesarias (curl para descargas, jq para JSON)
RUN apk add --no-cache curl jq

# Configurar directorio de trabajo
WORKDIR /data

# Copiar scripts
COPY inicio.sh /data/inicio.sh
COPY idle.sh /data/idle.sh

# Dar permisos de ejecución
RUN chmod +x /data/inicio.sh /data/idle.sh

# Copiar archivo de configuración
COPY config.json /data/config.json

# Copiar mods al contenedor (solo lectura)
COPY mods/ /data/mods/

# Puerto del servidor (usado por minecraft por default)
EXPOSE 25565/tcp
EXPOSE 25565/udp

# Entrypoint: idle.sh (mantiene el contenedor vivo, y nada mas)
ENTRYPOINT ["/data/idle.sh"]