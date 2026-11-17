# Tarea 1 — Terminal, directorios y búsqueda

Hazla en el terminal de la máquina Ubuntu de la unidad, con la cuenta `admin`. Lee antes, en el dossier, «Uso de Linux: interfaz gráfica y terminal», «Sistemas de archivos y estructura de directorios» y «Trabajar con archivos y directorios».

Este enunciado dice qué resultado hace falta. El cómo está en el dossier, en la documentación de las órdenes y, si la usas, en una conversación con un modelo de lenguaje. El comprobador mira el resultado y no enseña la orden que falta. La fecha de entrega y la calificación están en Moodle.

Particionar el disco es la tarea 2. Aquí no uses `parted`, `mkfs` ni `lvcreate`.

Abre un terminal (Ctrl+Alt+T). Si `git` no está instalado, instálalo con el gestor de paquetes. Clona el material en tu directorio personal. No hace falta una cuenta de GitHub.

```bash
cd
git clone https://github.com/adrifez/SISINF-2026.git
cd SISINF-2026
```

Los enunciados están en `u03/`. Si ya lo habías clonado, actualiza con `git pull` desde `~/SISINF-2026`.

Copia `u03/datos` a `u03/trabajo` y crea ahí `salidas` y `respuestas`. Trabaja solo dentro de `u03/trabajo`. `u03/datos` se queda como estaba. Las tareas siguientes reutilizan esta copia.

# 1. Terminal y rutas

Apartado del dossier: «Uso de Linux: interfaz gráfica y terminal».

El indicador acaba en `$` con la cuenta `admin`. `#` sería la cuenta root.

Desde `u03/trabajo`, deja estos resultados:

- `salidas/pwd.txt`: la ruta absoluta de `u03/trabajo`.
- `salidas/ruta-relativa.txt`: la ruta relativa de `taller/web/index.html` desde `trabajo`. El fichero contiene exactamente `taller/web/index.html`.
- `salidas/ruta-absoluta.txt`: la ruta absoluta de ese mismo `index.html`.
- `salidas/prestamo.txt`: el contenido del fichero de `taller` cuyo nombre lleva un espacio.
- `salidas/pwd-vuelta.txt`: entra en `taller/web` y vuelve a `u03/trabajo` subiendo al directorio padre. Guarda la ruta en la que acabas.

`muestra/eco.sh` no arranca si lo lanzas por su nombre solo. Hazlo ejecutable, lánzalo de forma que el shell lo encuentre en el directorio actual y guarda lo que imprime en `salidas/eco.txt`.

En `respuestas/rutas.md`, dos frases: qué indica `$` en el indicador, y por qué hace falta esa forma de lanzar `eco.sh`.

Crea un fichero de usar y tirar dentro de `trabajo` y bórralo. `rm` no tiene papelera: que sea solo ese fichero.

# 2. Sistemas de archivos y directorios

Apartado del dossier: «Sistemas de archivos y estructura de directorios».

En `taller` hay `Informe.txt`. El otro nombre, que solo cambia en las mayúsculas, está dentro de `muestra/par-mayusculas.tar`. En el ext4 de la Ubuntu tienen que quedar los dos ficheros, cada uno con su texto. Si el segundo sustituye al primero, no estás en el ext4 de la máquina de la unidad.

`arbol/` es un árbol en miniatura con los nombres del FHS. `suelto/` tiene cinco ficheros fuera de sitio. Coloca cada uno, conservando el nombre, en el directorio de `arbol/` cuya función le corresponde. Al terminar, `suelto/` ya no los tiene.

| Fichero | Qué es |
| --- | --- |
| `fstab` | Configuración de montajes, en texto |
| `syslog` | Un registro |
| `apuntes.txt` | Datos de la cuenta `admin` |
| `editor` | Un programa |
| `cache.tmp` | Un temporal |

En `respuestas/sistemas.md`:

1. Qué anota el diario de un ext4, y qué no recupera.
2. Qué pasa con `Informe.txt` e `informe.txt` al copiarlos a un FAT32 que Windows trata sin distinguir mayúsculas.
3. Para qué sirven `/etc` y `/var`, y por qué una copia de seguridad deja fuera `/proc` y `/sys`.

# 3. Localizar con find y grep

Apartado del dossier: «Trabajar con archivos y directorios».

En Archivos, abre `taller` y busca `informe`. Es la búsqueda por nombre de la carpeta que tienes abierta. En el terminal, el mismo problema se resuelve con otras órdenes: una elige ficheros y otra elige líneas. Guarda solo la salida, en estos ficheros:

- `salidas/find-logs.txt`: los ficheros normales de `registros` cuyo nombre acaba en `.log`.
- `salidas/grep-error.txt`: las líneas de `registros/app.log` que contienen `error`, sin distinguir mayúsculas, con el número de línea.
- `salidas/find-grandes.txt`: los ficheros normales de `registros` cuyo nombre acaba en `.log` y ocupan más de 1 KiB.
- `salidas/grep-listen.txt`: el nombre de cada fichero de `etc-muestra` que contiene la palabra `listen`. Solo el nombre.

# Entregable

Desde la raíz del repositorio:

```bash
bash u03/comprobar.sh tarea-01 | tee u03/trabajo/salidas/comprobar-tarea-01.txt
```

Comprime la carpeta `u03/trabajo` en un `.zip` y súbelo a esta tarea. Un solo archivo.

Dentro tienen que estar:

- `salidas/comprobar-tarea-01.txt` y el resto de listados de `salidas/`
- `respuestas/rutas.md` y `respuestas/sistemas.md`
- `taller/Informe.txt` y `taller/informe.txt`
- los cinco ficheros de `suelto/` ya colocados en `arbol/`

El comprobador mira las órdenes. Los dos textos se contrastan con el dossier.
