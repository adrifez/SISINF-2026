# Tarea 1 — Terminal, directorios y búsqueda

Hazla en el terminal de la máquina Ubuntu de la unidad, con la cuenta `admin`. Lee antes, en el dossier, «Uso de Linux: interfaz gráfica y terminal», «Sistemas de archivos y estructura de directorios» y «Trabajar con archivos y directorios». Este enunciado no trae las soluciones: el comprobador mira resultados y el texto se contrasta con el dossier.

La fecha de entrega y la calificación están en Moodle. Particionar el disco es la tarea 2. Aquí no uses `parted`, `mkfs` ni `lvcreate`.

Prepara la copia de trabajo una sola vez, desde la raíz del repositorio:

```bash
cp -a u03/datos u03/trabajo
cd u03/trabajo
mkdir -p salidas respuestas
```

A partir de aquí las órdenes se lanzan dentro de `u03/trabajo`, salvo cuando un paso diga otra cosa. Esa carpeta es tuya. Los datos de `u03/datos` se quedan como estaban. Las tareas siguientes reutilizan esta copia.

# 1. Terminal y rutas

Apartado del dossier: «Uso de Linux: interfaz gráfica y terminal».

El indicador acaba en `$` con la cuenta `admin`. `#` sería la cuenta root. Los atajos de Tab, flecha arriba, Ctrl+C y Ctrl+D están en el dossier: úsalos en esta sesión.

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
| `apuntes.txt` | Datos de la cuenta `admin` |
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

# Entregable

Desde la raíz del repositorio:

```bash
bash u03/comprobar.sh tarea-01 | tee u03/trabajo/salidas/comprobar-tarea-01.txt
```

Comprime la carpeta `u03/trabajo` en un `.zip` y súbelo a esta tarea. Un solo archivo. Puede incluir solo lo de esta tarea.

Dentro tienen que estar:

- `salidas/comprobar-tarea-01.txt` y el resto de listados de `salidas/`
- `respuestas/rutas.md` y `respuestas/sistemas.md`
- `taller/Informe.txt` y `taller/informe.txt`
- los cinco ficheros de `suelto/` ya colocados en `arbol/`

El comprobador mira las órdenes. Los dos textos se contrastan con el dossier.
