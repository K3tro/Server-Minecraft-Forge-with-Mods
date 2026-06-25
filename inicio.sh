#!/bin/sh
#script maestro para arrancar el server, wat chucha saleee!!!

set -e

EJECUTOR="SERVER/run.sh"
CONFIG_FILE="config.json"

########################################################################################################################
#      DESARGA DEL INSTALADOR: VERIFICARÁ SI EXISTE; SI ES EL CASO, NO HARÁ NADA, DE LO CONTRARIO LO DESCARGARÁ
########################################################################################################################

MMFF="$(jq -r '.versions.minecraft // "1.20.1"' "$CONFIG_FILE")-$(jq -r '.versions.forge // "47.4.20"' "$CONFIG_FILE")"

INSTALLER="INSTALLER.jar"

if [ -f "$INSTALLER" ];then
    echo "Instalador presente en $INSTALLER, No se requiere descarga"
else
    if curl -s -I "https://maven.minecraftforge.net/net/minecraftforge/forge/$MMFF/forge-$MMFF-installer.jar" | head -n1 | grep -q "HTTP/.* 200"; then

        echo "No se encontró el instalador en $INSTALLER, procediendo con la descarga..."
        curl -o $INSTALLER "https://maven.minecraftforge.net/net/minecraftforge/forge/$MMFF/forge-$MMFF-installer.jar"
        echo "Descarga Finalizada!"
    else
        echo "ERROR! la URL no existe"
        echo "Verifique si su versión de forge o del juego son correctos en:"
        echo "https://files.minecraftforge.net/net/minecraftforge/forge/"
        exit 1
    fi
fi

########################################################################################################################
#                       VERIFICA SI EL LANZADOR FINAL EXISTE, SI NO, EJECUTARÁ EL INSTALADOR
########################################################################################################################

if [ -f "$EJECUTOR" ];then
    echo "El ejecutor está listo!"

else
    echo "Ejecutando el instalador"
    echo "Version : $MMFF"
    java -jar $INSTALLER --installServer SERVER #instala
    
    #configura
    echo "" > SERVER/server.properties
    jq -r '.world | keys[]' "$CONFIG_FILE" | while read -r key; do
        value=$(jq -r ".world[\"$key\"]" "$CONFIG_FILE")
        echo "Clave: $key, Valor: $value"
        echo "$key=$value" >> SERVER/server.properties
    done
    #mueve los mods
    cp -rv mods SERVER/

fi

########################################################################################################################
#                       EJECUTA EL SERVIDOR PROPIAMENTE DICHO
########################################################################################################################
MINIM=$(jq -r '.sistema.min_ram // "2500M"' "$CONFIG_FILE")
MAXIM=$(jq -r '.sistema.max_ram // "3500M"' "$CONFIG_FILE")

cd SERVER/
EULA_FILE="eula.txt"

echo "" > user_jvm_args.txt


echo "-Xmx"$MINIM"" >> user_jvm_args.txt
echo "-Xmx"$MAXIM"" >> user_jvm_args.txt

#./run.sh
if [ ! -f "$EULA_FILE" ];then
    ./run.sh
fi

EULA_VALUE=$(grep "^eula=" "$EULA_FILE" | cut -d'=' -f2)

if [ "$EULA_VALUE" != "true" ]; then
    
    echo "Debes aceptar el EULA de Minecraft: https://aka.ms/MinecraftEULA"
    echo -n "¿Aceptas? (sí/no): "
    read -r respuesta
    if [ "$respuesta" = "sí" ] || [ "$respuesta" = "si" ] || [ "$respuesta" = "s" ] || [ "$respuesta" = "SI" ]; then
        sed -i 's/eula=false/eula=true/' "$EULA_FILE"
        echo "EULA aceptado, procediendo con el servidor"
        ./run.sh --nogui
    else
        echo "No se puede iniciar el servidor sin aceptar el EULA"
        exit 1
    fi
else
  ./run.sh --nogui
fi