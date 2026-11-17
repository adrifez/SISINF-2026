# Tarea 5 — Paquetes y utilidades

Hazla en la máquina Ubuntu de la unidad, con la cuenta `admin`. Lee antes, en el dossier, «Paquetes y utilidades de gestión de la información».

Este enunciado dice qué hay que dejar por escrito. El cómo consultar el gestor de paquetes está en el dossier y, si la usas, en una conversación con un modelo de lenguaje. La fecha de entrega y la calificación están en Moodle.

Usa la copia `u03/trabajo` de la tarea 1. Si no existe, créala como allí se indica.

# La ficha

Guarda en `salidas/apt-rsync.txt` la ficha de `rsync`: versión y descripción, sin instalarlo por el hecho de leerla. Instala el paquete solo si en la tarea 3 la orden no estaba. No hace falta quitarlo después.

# Qué herramienta responde

En `respuestas/utilidades.md`, qué herramienta responde a cada situación y cuál no:

1. Comprimir solo `taller/Informe.txt`. Qué le pasa al original si usas `gzip`.
2. Conservar el árbol de hoy y el de ayer. Un único destino que se reescribe no guarda el día anterior: qué herramienta, con la fecha en el nombre, guarda las dos versiones.
3. Quieres la línea que contiene `listen`, no el fichero elegido por su tamaño.

# Entregable

Desde la raíz del repositorio:

```bash
bash u03/comprobar.sh tarea-05 | tee u03/trabajo/salidas/comprobar-tarea-05.txt
```

Comprime la carpeta `u03/trabajo` en un `.zip` y súbelo a esta tarea. Un solo archivo. El zip puede arrastrar las tareas anteriores.

Dentro tienen que estar `salidas/comprobar-tarea-05.txt`, `salidas/apt-rsync.txt` (en la Ubuntu) y `respuestas/utilidades.md`. El comprobador mira la ficha. Las tres situaciones se contrastan con el dossier.
