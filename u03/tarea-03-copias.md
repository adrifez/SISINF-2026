# Tarea 3 — Copias de seguridad

Hazla en la máquina Ubuntu de la unidad, con la cuenta `admin`. Lee antes, en el dossier, «Copias de seguridad».

Este enunciado dice qué copia hace falta. El cómo está en el dossier, en la documentación de las órdenes y, si la usas, en una conversación con un modelo de lenguaje. El comprobador mira el archivo, la restauración y el espejo. La fecha de entrega y la calificación están en Moodle.

Usa la copia `u03/trabajo` de la tarea 1. Si no existe, créala como allí se indica. Los destinos de esta tarea son `copias`, `restauracion` y `espejo`, dentro de `trabajo`. Si la orden de sincronizar no está instalada, instala solo ese paquete. La valoración de la herramienta es la tarea 5.

# Copia fechada y restauración

Deja un archivo del árbol `taller` con la fecha de hoy en el nombre, en la forma `copias/taller-AAAA-MM-DD.tar.gz`. Dentro, las rutas son relativas y empiezan por `taller/`. Una lista de ese archivo, sin extraerlo, va a `salidas/taller-AAAA-MM-DD.lista`.

Extrae el archivo en `restauracion`, que está vacío. `restauracion/taller/catalogo.txt` tiene que coincidir con el original. Guarda el resumen SHA-256 de los dos `catalogo.txt` en `salidas/sha256-catalogo.txt`: las dos sumas son la misma.

> La prueba es extraer en `restauracion` y abrir un fichero. Dejar el archivo encima de `taller`, o encima de `/`, pisa lo que ya existe.

# Sincronizar

Deja en `espejo/` el contenido de `taller/`, no una carpeta `taller` dentro de `espejo`. Hazlo dos veces. Entre las dos pasadas, añade un fichero nuevo en el origen. Tras la segunda, ese fichero está en `espejo` y se llama `novedad.txt`. La segunda pasada no vuelve a enviar lo que ya coincidía.

> La opción que borra en el destino lo que ya no está en el origen no entra en esta tarea.

# Entregable

Desde la raíz del repositorio:

```bash
bash u03/comprobar.sh tarea-03 | tee u03/trabajo/salidas/comprobar-tarea-03.txt
```

Comprime la carpeta `u03/trabajo` en un `.zip` y súbelo a esta tarea. Un solo archivo. El zip puede arrastrar las tareas anteriores.

Dentro tienen que estar:

- `salidas/comprobar-tarea-03.txt`
- `copias/taller-AAAA-MM-DD.tar.gz` con la fecha de hoy
- `salidas/taller-AAAA-MM-DD.lista`
- `restauracion/taller/catalogo.txt`
- `salidas/sha256-catalogo.txt`
- `espejo/novedad.txt` y `taller/novedad.txt`, con el mismo contenido
