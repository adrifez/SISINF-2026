# Tarea 4 — Script y cron

Hazla en la máquina Ubuntu de la unidad, con la cuenta `admin`, dentro de `u03/trabajo`. Lee antes, en el dossier, «Programación de tareas, variables y scripts». Conviene tener hecha la tarea 3: el script empaqueta el mismo `taller`. Este enunciado no trae el script resuelto.

La fecha de entrega y la calificación están en Moodle.

Si todavía no tienes la copia de trabajo, desde la raíz del repositorio:

```bash
cp -a u03/datos u03/trabajo
mkdir -p u03/trabajo/salidas u03/trabajo/respuestas
```

Crea la carpeta del script:

```bash
mkdir -p u03/trabajo/bin
cd u03/trabajo
```

# El script

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

# La línea de cron

La tarea definitiva es todos los domingos a las 23:30. Los cinco campos son los del dossier. El domingo es 0. Cron usa un `PATH` corto: la orden es la ruta absoluta del script. Guarda una sola línea en `salidas/crontab.txt`.

En una frase, dentro de `respuestas/cron.md`: qué decisión queda dentro del script para que el domingo siguiente no pise al anterior, y cómo sabes que el archivo se lee.

# Entregable

Desde la raíz del repositorio:

```bash
bash u03/comprobar.sh tarea-04 | tee u03/trabajo/salidas/comprobar-tarea-04.txt
```

Comprime la carpeta `u03/trabajo` en un `.zip` y súbelo a esta tarea. Un solo archivo. El zip puede arrastrar las tareas anteriores: el trabajo es acumulativo.

Dentro tienen que estar:

- `salidas/comprobar-tarea-04.txt`
- `bin/copia-taller.sh`
- `salidas/crontab.txt`
- `respuestas/cron.md`
- `copias/taller-AAAA-MM-DD.tar.gz` y `copias/taller-AAAA-MM-DD.lista`, dejados por el script
