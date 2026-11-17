# Tarea 3 — Copias de seguridad

Hazla en la máquina Ubuntu de la unidad, con la cuenta `admin`, dentro de `u03/trabajo` (la copia de la tarea 1). Lee antes, en el dossier, «Copias de seguridad». Este enunciado no trae las soluciones: el comprobador mira el archivo, la restauración y el espejo.

La fecha de entrega y la calificación están en Moodle.

Si todavía no tienes la copia de trabajo, desde la raíz del repositorio:

```bash
cp -a u03/datos u03/trabajo
mkdir -p u03/trabajo/salidas u03/trabajo/respuestas
```

Entra en la copia y crea los destinos de esta tarea:

```bash
cd u03/trabajo
mkdir -p copias restauracion espejo
```

Si `rsync` no está instalado, lee antes la ficha e instala solo ese paquete. La valoración de la herramienta es la tarea 5.

```bash
apt show rsync
sudo apt update
sudo apt install rsync
```

# Copia fechada y restauración

El archivo lleva la fecha en el nombre y, por dentro, rutas `taller/...`. `-C` cambia de directorio antes de empaquetar, así la ruta no queda absoluta. La lista demuestra que el archivo se lee. La extracción va a `restauracion`, que está vacío. El resumen de `catalogo.txt` tiene que coincidir en el original y en lo restaurado.

```bash
fecha=$(date +%F)
tar -czf "copias/taller-$fecha.tar.gz" -C "$PWD" taller
tar -tzf "copias/taller-$fecha.tar.gz" > "salidas/taller-$fecha.lista"
tar -xzf "copias/taller-$fecha.tar.gz" -C restauracion
sha256sum taller/catalogo.txt restauracion/taller/catalogo.txt > salidas/sha256-catalogo.txt
```

> Extrae en `restauracion`. Dejar el archivo encima de `taller`, o encima de `/`, pisa lo que ya existe. Eso no es la prueba de la copia.

# Sincronizar

`rsync -a` deja el destino como el origen y, la segunda vez, transmite lo que cambió. La barra final de `taller/` copia el contenido, no una carpeta `taller` dentro del destino. Entre las dos pasadas se añade un fichero.

```bash
rsync -a taller/ espejo/
printf '%s\n' 'alta de un libro' > taller/novedad.txt
rsync -a taller/ espejo/
```

> `--delete` no entra en este ejercicio. En un destino equivocado borra lo que el origen ya no tiene.

Mira la segunda pasada: no vuelve a enviar `catalogo.txt`. `espejo/novedad.txt` sí está, porque apareció entre medias.

# Entregable

Desde la raíz del repositorio:

```bash
bash u03/comprobar.sh tarea-03 | tee u03/trabajo/salidas/comprobar-tarea-03.txt
```

Comprime la carpeta `u03/trabajo` en un `.zip` y súbelo a esta tarea. Un solo archivo. El zip puede arrastrar las tareas anteriores: el trabajo es acumulativo.

Dentro tienen que estar:

- `salidas/comprobar-tarea-03.txt`
- `copias/taller-AAAA-MM-DD.tar.gz` con la fecha de hoy
- `salidas/taller-AAAA-MM-DD.lista`
- `restauracion/taller/catalogo.txt`
- `salidas/sha256-catalogo.txt`
- `espejo/novedad.txt`
