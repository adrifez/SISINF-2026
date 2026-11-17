# Práctica — Gestión de la información en Linux

Haz los ejercicios en el terminal de la máquina Ubuntu de la unidad, con la cuenta `alumno`. Lee antes el apartado del dossier que indica cada bloque. Este cuaderno no trae las soluciones: el comprobador mira resultados y el texto se contrasta con el dossier.

Prepara la copia de trabajo una sola vez, desde la raíz del repositorio:

```bash
cp -a u03/datos u03/trabajo
cd u03/trabajo
mkdir -p salidas respuestas copias restauracion espejo bin
```

A partir de aquí las órdenes se lanzan dentro de `u03/trabajo`, salvo cuando un paso diga otra cosa. Esa carpeta es tuya. Los datos de `u03/datos` se quedan como estaban.

Al terminar un bloque, o al final:

```bash
bash u03/comprobar.sh
```

Un bloque suelto: `bash u03/comprobar.sh terminal`, y lo mismo con `sistemas`, `buscar`, `copias`, `script`, `paquetes` o `discos`. Lo que aún no está hecho sale como pendiente.

> Particionar, formatear y crear volúmenes no forma parte de esta práctica. `parted`, `mkfs` y `lvcreate` se usan en la práctica del segundo disco, sobre ese disco vacío.

# 1. Terminal y rutas

Apartado del dossier: «Uso de Linux: interfaz gráfica y terminal».

El indicador acaba en `$` con la cuenta `alumno`. `#` sería la cuenta root. Los atajos de Tab, flecha arriba, Ctrl+C y Ctrl+D están en el dossier: úsalos en esta sesión.

Desde `u03/trabajo`:

```bash
pwd > salidas/pwd.txt
ls taller/web/index.html > salidas/ruta-relativa.txt
ls "$PWD/taller/web/index.html" > salidas/ruta-absoluta.txt
cat "taller/prestamos 2026.txt" > salidas/prestamo.txt
cd taller/web
cd ../..
pwd > salidas/pwd-vuelta.txt
```

`pwd.txt` es una ruta absoluta. `ruta-relativa.txt` nombra el mismo `index.html` desde `trabajo`. Las comillas del `cat` hacen falta porque el nombre lleva un espacio: el shell parte la línea por espacios antes de lanzar el programa.

El directorio actual no está en `PATH`. Prueba `muestra/eco.sh` escrito así, sin punto y barra: el shell no lo encuentra. Márcalo ejecutable y lánzalo con `./`:

```bash
chmod +x muestra/eco.sh
./muestra/eco.sh > salidas/eco.txt
```

En `respuestas/rutas.md`, dos frases: qué indica `$` en el indicador, y por qué hace falta `./` delante de `eco.sh`.

`rm` borra el nombre. No hay papelera. Crea un fichero para tirarlo y bórralo solo a él:

```bash
printf '%s\n' basura > borrar-esto.txt
rm borrar-esto.txt
```

# 2. Sistemas de archivos y directorios

Apartado del dossier: «Sistemas de archivos y estructura de directorios».

En `taller` hay `Informe.txt`. El otro nombre, que solo cambia en las mayúsculas, viaja dentro de `muestra/par-mayusculas.tar`: en un disco que no distingue mayúsculas el segundo pisa al primero, y el repositorio se puede clonar en uno de esos discos. En el ext4 de la Ubuntu son dos ficheros. Extrae el par dentro de `taller`:

```bash
tar -xf muestra/par-mayusculas.tar -C taller
ls taller/Informe.txt taller/informe.txt
```

`ls` tiene que mostrar los dos caminos. Si el segundo ha sustituido al primero, no estás en el ext4 de la máquina de la unidad.

`arbol/` es un árbol en miniatura con los nombres del FHS. `suelto/` tiene cinco ficheros fuera de sitio. Lee cada uno y muévelo, conservando el nombre, al directorio de `arbol/` cuya función le corresponde:

| Fichero | Qué es |
| --- | --- |
| `fstab` | Configuración de montajes, en texto |
| `syslog` | Un registro |
| `apuntes.txt` | Datos de la cuenta `alumno` |
| `editor` | Un programa |
| `cache.tmp` | Un temporal |

Al terminar, `suelto/` ya no tiene esos cinco nombres.

En `respuestas/sistemas.md`:

1. Qué anota el diario de un ext4, y qué no recupera.
2. Qué pasa con `Informe.txt` e `informe.txt` al copiarlos a un FAT32 que Windows trata sin distinguir mayúsculas.
3. Para qué sirven `/etc` y `/var`, y por qué una copia de seguridad deja fuera `/proc` y `/sys`.

# 3. Localizar con find y grep

Apartado del dossier: «Trabajar con archivos y directorios».

`find` elige ficheros por nombre, tamaño o fecha. `grep` elige líneas de texto. En Archivos, abre `taller` y busca `informe`: es la búsqueda por nombre de la carpeta que tienes abierta.

Estas dos órdenes ya están escritas. Guarda la salida.

```bash
find registros -type f -name "*.log" > salidas/find-logs.txt
grep -n -i error registros/app.log > salidas/grep-error.txt
```

Las dos siguientes las escribes tú. La salida va a esos ficheros, y nada más que la salida.

- Los ficheros normales bajo `registros` cuyo nombre acaba en `.log` y ocupan más de 1 KiB. En el dossier, `+10M` es más de 10 mebibytes; la unidad de 1024 bytes en `find` es `k`. Guarda el listado en `salidas/find-grandes.txt`.
- Los ficheros bajo `etc-muestra` que contienen la palabra `listen`. Solo el nombre de cada fichero, como en el dossier cuando basta saber en qué fichero apareció. Guarda el listado en `salidas/grep-listen.txt`.

# 4. Copias

Apartado del dossier: «Copias de seguridad».

Si `rsync` no está instalado, lee antes la ficha con `apt show rsync` y instala solo ese paquete (`sudo apt update` y `sudo apt install rsync`). La valoración de la herramienta está en el bloque 6.

El archivo lleva la fecha en el nombre y, por dentro, rutas `taller/...`. `-C` cambia de directorio antes de empaquetar, así la ruta no queda absoluta. La lista demuestra que el archivo se lee. La extracción va a `restauracion`, que está vacío. El resumen de `catalogo.txt` tiene que coincidir en el original y en lo restaurado.

```bash
fecha=$(date +%F)
tar -czf "copias/taller-$fecha.tar.gz" -C "$PWD" taller
tar -tzf "copias/taller-$fecha.tar.gz" > "salidas/taller-$fecha.lista"
tar -xzf "copias/taller-$fecha.tar.gz" -C restauracion
sha256sum taller/catalogo.txt restauracion/taller/catalogo.txt > salidas/sha256-catalogo.txt
```

> Extrae en `restauracion`. Dejar el archivo encima de `taller`, o encima de `/`, pisa lo que ya existe. Eso no es la prueba de la copia.

`rsync -a` deja el destino como el origen y, la segunda vez, transmite lo que cambió. La barra final de `taller/` copia el contenido, no una carpeta `taller` dentro del destino. Entre las dos pasadas se añade un fichero.

```bash
rsync -a taller/ espejo/
printf '%s\n' 'alta de un libro' > taller/novedad.txt
rsync -a taller/ espejo/
```

> `--delete` no entra en este ejercicio. En un destino equivocado borra lo que el origen ya no tiene.

Mira la segunda pasada: no vuelve a enviar `catalogo.txt`. `espejo/novedad.txt` sí está, porque apareció entre medias.

# 5. Script y cron

Apartado del dossier: «Programación de tareas, variables y scripts».

Escribe `bin/copia-taller.sh`. Al lanzarlo con su ruta absoluta, desde cualquier directorio, tiene que cumplir todo esto:

- La primera línea es `#!/bin/bash`.
- El destino y la fecha son variables, asignadas sin espacios alrededor del igual.
- La fecha sale de `date +%F`, en la forma `AAAA-MM-DD`.
- Crea `copias` si falta.
- Deja `copias/taller-AAAA-MM-DD.tar.gz` con `taller/catalogo.txt` dentro y con rutas relativas.
- Deja al lado `copias/taller-AAAA-MM-DD.lista`, la salida de `tar -tzf` de ese archivo.
- Termina con código 0.

Hazlo ejecutable. Pruébalo desde otro sitio, que es como lo va a lanzar cron:

```bash
chmod +x bin/copia-taller.sh
cd /tmp
"$OLDPWD/bin/copia-taller.sh"
cd -
```

`OLDPWD` aquí es `u03/trabajo`, si el `cd /tmp` acaba de salir de esa carpeta. Si no, escribe la ruta absoluta que te dio `pwd` antes de cambiar. `cd -` vuelve a `trabajo`.

La tarea definitiva es todos los domingos a las 23:30. Los cinco campos son los del dossier. El domingo es 0. Cron usa un `PATH` corto: la orden es la ruta absoluta del script. Guarda una sola línea en `salidas/crontab.txt`.

En una frase, dentro de `respuestas/cron.md`: qué decisión queda dentro del script para que el domingo siguiente no pise al anterior, y cómo sabes que el archivo se lee.

# 6. Paquetes y utilidades

Apartado del dossier: «Paquetes y utilidades de gestión de la información».

`apt update` renueva el índice. `apt show` enseña la ficha y no instala. En la Ubuntu, guarda la ficha de `rsync`:

```bash
apt show rsync > salidas/apt-rsync.txt
```

Instala el paquete solo si el bloque 4 no encontró la orden. `apt remove` no hace falta.

En `respuestas/utilidades.md`, qué herramienta responde a cada situación y cuál no:

1. Comprimir solo `taller/Informe.txt`. Qué le pasa al original si usas `gzip`.
2. Conservar el árbol de hoy y el de ayer. Un único destino de `rsync` se reescribe: qué herramienta, con la fecha en el nombre, guarda las dos versiones.
3. Quieres la línea que contiene `listen`, no el fichero elegido por su tamaño.

# 7. Discos, volúmenes y Windows

Apartado del dossier: «Discos, particiones y volúmenes lógicos».

Este bloque se escribe. El disco de la máquina no se reparte aquí. Responde en `respuestas/discos.md`:

1. Un disco vacío tiene que arrancar por UEFI y separar el sistema de los datos de los usuarios. Qué tabla eliges, qué partición lee el firmware y con qué formato, y por qué un MBR con una sola partición lógica no vale para todo.
2. En qué se distingue una partición lógica de MBR de un volumen lógico de LVM.
3. Ordena las capas desde el disco hasta el directorio donde se ven los ficheros.
4. Tras ampliar, `df` del ext4 montado no se ha movido porque `resize2fs` se ejecutó antes que `lvextend`. Qué capa sigue sin ver los bloques nuevos, y en qué orden se repiten las dos órdenes.
5. En Windows, qué herramienta usas para una letra en un solo disco, y cuál, con qué resistencia, para una letra que siga disponible si muere uno de tres discos.

El comprobador avisa de que este texto se contrasta con el dossier y con la práctica del segundo disco. Crear la tabla GPT, el montaje en `fstab` y el volumen que se amplía es esa práctica.
