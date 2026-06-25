# Minecraft Forge Server

Servidor Forge con configuración vía JSON, modo IDLE para administración y despliegue en Docker.

---

## ¿Qué hace?

Levanta un servidor de Minecraft con Forge usando un solo `config.json` para controlar:

- Versiones (Minecraft + Forge)
- Configuración del mundo (dificultad, gamemode, etc.)
- RAM asignada

**Modo IDLE**: El contenedor arranca en espera. El servidor NO se inicia automáticamente. Debes ejecutar `./inicio.sh` manualmente dentro del contenedor en la consola.

---

## Estructura del Proyecto

```
├── Dockerfile # Construye la imagen
├── inicio.sh # Script principal (instala y arranca el servidor)
├── idle.sh # Mantiene el contenedor vivo (entrypoint)
├── config.json # Configuración del servidor
├── mods/ # Poner aquí los .jar de mods
└── SERVER/ # Generado al ejecutar (datos persistentes)
    ├── run.sh # Script de Forge
    ├── server.properties
    ├── eula.txt
    ├── forge-*.jar
    ├── libraries/
    ├── mods/ # Mods instalados (copiados desde mods/)
    ├── world/
    └── logs/
```

---

## Iniciamos

`config.json` es el archivo de confuguración.

La seccion de "version" maneja las versiones del juego y de forge.
es importante que la combinacion de juego + forge exista, asegurate de ello en el link oficial de __[forge](https://files.minecraftforge.net/net/minecraftforge/forge/)__.

La sección de "world" establece los valores indicados en el archivo `server.properties`.Si no se establece un parametro al principio, el instalador establecerá el valor por defecto, tambien es posible editar el archivo a posteriori con `nano` (algo incomodo, no recomiendo).

La sección de "sistema" establece los limites superior e inferior de memoria RAM a utilizar.Se puede establecer en Mb ([X]M -> X Mb) o en Gb ([X]G -> X Gb), si no se establece aquí, se asignarán los valores por defecto, concidera que un pack grande de mods puede requerir mayor cantidad de RAM.


Aquí el ejemplo de cómo debería quedar:
```json
{
  "versions": {
    "minecraft": "1.20.1",
    "forge": "47.4.20"
  },
  "world": {
    "difficulty": "hard",
    "gamemode": "survival",
    "max-players": 20,
    "view-distance": 10,
    "online-mode": false
  },
  "sistema": {
    "min_ram": "2500M",
    "max_ram": "3500M"
  }
}
```
---

## Instalación y Uso

Después de personalizar `config.json` y armar tu modpack (recuerda probarlo localmente primero), es momento de poner tu servidor en marcha.

### 1. Mods

Copia tus mods en la carpeta `mods/`. Incluí  unos mods de prueba que generan biomas y estructuras únicas, pero siéntete libre de reemplazarlos por los tuyos. Recuerda que entre más mods quieras instalar, mayores recursos computacionales requerirás.


### 2. Construir la imagen

```bash
docker build -t server-minecraft .
```

### 3. Ejecutar el contenedor (modo IDLE)

```bash
docker run -d  -p 25565:25565 --name maincra server-minecraft
```

### 4. Iniciar el servidor (dentro del contenedor)

El contenedor arranca en **modo IDLE**. Para iniciar el servidor:

```bash
# Entrar al contenedor
docker exec -it maincra /bin/sh
```
También puedes entrar directamente con __[Docker Desktop](https://docs.docker.com/desktop/)__. o tu gestor de Dockers favorito.


```
# Una vez dentro
ls #revisar si están todos los archivos
./inicio.sh
```


### 4. Aceptar la EULA


Ya casi estamos! Esto solo es necesario hacerlo una vez, en un momento, el script preguntará si se aceptan los terminos y condiciones de _MOJAN_.

Una vez hecho eso el servidor estará **completamente listo**, la generación del mundo empezará, cuando termine de cargar tendrás acceso a la consola del servidor, algunos  `comandos útiles`:

| Comando | Utilidad |
|---------|---------|
| `help` | muestra todos los posibles comandos |
| `list` | muestra la lista actual de jugadores comentados |
| `say <mensaje>` | mandas un mensaje a travez del chat |
| `kick <jugador>` | expulsas temporalmente a `<jugador>` |
| `ban <jugador>` | vetas indefinidamente a `<jugador>` |
| `op <jugador>` | otorgas a `<jugador>` la capacidad de ejecutar comandos |
| `deop <jugador>` | retiras a `<jugador>` la capacidad de ejecutar comandos|
| `difficulty <dificultad>` | cambias la dificultad del mundo |
| `stop` | detienes de manera "segura" el servidor, util para mantenimientos sin perder datos. |

---

## Notas importantes

- `SERVER/` es persistente. Todo lo que se genera queda ahí (mundo, configuraciones, etc.).
- Los mods se copian de `mods/` a `SERVER/mods/` al ejecutar `inicio.sh`.
- Forge se descarga e instala automáticamente si no está presente.
- El contenedor arranca en **modo IDLE**; el servidor NO se inicia automáticamente.
- Si cambias `config.json`, tienes que reconstruir la imagen o montarlo como volumen.
- Para cambios en mods: solo reiniciar el contenedor y ejecutar `./inicio.sh` nuevamente. Es posible que algo se rompa si usas mods nuevos en un mundo que se creó sin ellos, no recomiendo.

---

## Resetear todo

```bash
# Eliminar contenedor e imagen
docker stop maincra
docker rm maincra
docker rmi server-minecraft

# Eliminar datos generados (opcional - borra mundo y configuración)
rm -rf SERVER/
```

---

## Créditos

Este proyecto se apoya en el trabajo de:

### Juego Base
- **[Mojang Studios](https://www.minecraft.net/)** - Creadores de Minecraft.

### Framework de Mods
- **[Forge](https://files.minecraftforge.net/)** - La plataforma que hace posible el modding en Minecraft.

### Mods Incluidos (Ejemplo)
- **[Alex's Caves](https://www.curseforge.com/minecraft/mc-mods/alexs-caves)** por [sbom_xela](https://www.curseforge.com/members/sbom_xela/projects)
- **[Citadel](https://www.curseforge.com/minecraft/mc-mods/citadel)** por [sbom_xela](https://www.curseforge.com/members/sbom_xela/projects)
- **[Terrallith](https://www.curseforge.com/minecraft/mc-mods/terralith)** por [Starmute](https://www.curseforge.com/members/starmute/projects)

### Tecnologías
- **[Docker](https://www.docker.com/)** - Contenerización y despliegue.
- **[OpenJDK](https://openjdk.org/)** - Entorno de ejecución Java.

**Minecraft® es una marca registrada de Mojang Studios.**

---
