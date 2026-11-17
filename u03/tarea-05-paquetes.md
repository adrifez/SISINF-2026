# Tarea 5 — Paquetes y utilidades

Hazla en la máquina Ubuntu de la unidad, con la cuenta `admin`, dentro de `u03/trabajo`. Lee antes, en el dossier, «Paquetes y utilidades de gestión de la información». Este enunciado no trae las soluciones.

La fecha de entrega y la calificación están en Moodle.

Si todavía no tienes la copia de trabajo, desde la raíz del repositorio:

```bash
cp -a u03/datos u03/trabajo
mkdir -p u03/trabajo/salidas u03/trabajo/respuestas
cd u03/trabajo
```

Si ya la tienes, entra en ella:

```bash
cd u03/trabajo
```

# La ficha, antes de instalar

`apt update` renueva el índice. `apt show` enseña la ficha y no instala. En la Ubuntu, guarda la ficha de `rsync`:

```bash
apt show rsync > salidas/apt-rsync.txt
```

Instala el paquete solo si la tarea 3 no encontró la orden (`sudo apt update` y `sudo apt install rsync`). `apt remove` no hace falta.

# Qué herramienta responde

En `respuestas/utilidades.md`, qué herramienta responde a cada situación y cuál no:

1. Comprimir solo `taller/Informe.txt`. Qué le pasa al original si usas `gzip`.
2. Conservar el árbol de hoy y el de ayer. Un único destino de `rsync` se reescribe: qué herramienta, con la fecha en el nombre, guarda las dos versiones.
3. Quieres la línea que contiene `listen`, no el fichero elegido por su tamaño.

# Entregable

Desde la raíz del repositorio:

```bash
bash u03/comprobar.sh tarea-05 | tee u03/trabajo/salidas/comprobar-tarea-05.txt
```

Comprime la carpeta `u03/trabajo` en un `.zip` y súbelo a esta tarea. Un solo archivo. El zip puede arrastrar las tareas anteriores: el trabajo es acumulativo.

Dentro tienen que estar `salidas/comprobar-tarea-05.txt`, `salidas/apt-rsync.txt` (en la Ubuntu) y `respuestas/utilidades.md`. El comprobador mira la ficha. Las tres situaciones se contrastan con el dossier.
