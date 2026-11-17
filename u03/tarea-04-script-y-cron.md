# Tarea 4 — Script y cron

Hazla en la máquina Ubuntu de la unidad, con la cuenta `admin`. Lee antes, en los apuntes, «Programación de tareas, variables y scripts». Conviene tener hecha la tarea 3: el script empaqueta el mismo `taller`.

Este enunciado dice qué tiene que cumplir el script y la línea de cron. El cómo está en los apuntes y, si la usas, en una conversación con un modelo de lenguaje. La fecha de entrega y la calificación están en Moodle.

Usa la copia `u03/trabajo` de la tarea 1. El script vive en `u03/trabajo/bin`.

# El script

`bin/copia-taller.sh`, lanzado con su ruta absoluta desde cualquier directorio, tiene que cumplir todo esto:

- Lo interpreta Bash: la primera línea es `#!/bin/bash` y el fichero es ejecutable.
- El destino y la fecha son variables. La fecha no está escrita a fuego: el script la obtiene con `date` y el formato `%F`.
- Crea `copias` si falta.
- Deja `copias/taller-AAAA-MM-DD.tar.gz` con `taller/catalogo.txt` dentro y con rutas relativas.
- Deja al lado `copias/taller-AAAA-MM-DD.lista`, el listado de ese archivo sin extraerlo.
- Termina con código 0.

Pruébalo desde un directorio que no sea `trabajo`. El comprobador hace esa misma prueba.

# La línea de cron

La ejecución definitiva es todos los domingos a las 23:30. En el día de la semana, el domingo es 0. La orden es la ruta absoluta del script, porque cron no busca en el directorio actual. Guarda una sola línea en `salidas/crontab.txt`.

En `respuestas/cron.md`, qué decisión queda dentro del script para que el domingo siguiente no pise al anterior, y cómo sabes que el archivo se lee.

# Entregable

Desde la raíz del repositorio:

```bash
bash u03/comprobar.sh tarea-04 | tee u03/trabajo/salidas/comprobar-tarea-04.txt
```

Sube a Moodle estos dos ficheros:

- `u03/trabajo/salidas/comprobar-tarea-04.txt`
- `u03/trabajo/respuestas/cron.md`

El comprobador lanza el script y mira la línea de cron. El texto se contrasta con los apuntes.
