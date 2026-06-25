#!/bin/sh
# idle.sh - Mantiene el contenedor vivo y permite ejecutar comandos

echo "=========================================="
echo "CONTENEDOR INICIADO EN MODO IDLE"
echo "EL server AUN no se inicia"
echo "Para crear/iniciar el server, dirijirse a la consola"
echo "y"
echo "ejecutar ./inicio.sh "
echo "una vez iniciado, podras ejecutar comandos de servidores de minecraft normal"
echo "=========================================="

# Mantener el contenedor vivo
# Esto hace que el contenedor nunca se detenga
tail -f /dev/null