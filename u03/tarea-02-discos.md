# Tarea 2 — Discos, particiones y volúmenes

Hazla en la máquina Ubuntu de la unidad, con la cuenta `admin`, dentro de `u03/trabajo` (la copia de la tarea 1). Lee antes, en el dossier, «Discos, particiones y volúmenes lógicos». Este enunciado no trae las soluciones.

La fecha de entrega y la calificación están en Moodle. Esta tarea se escribe. El disco de la máquina no se reparte aquí: no uses `parted`, `mkfs` ni `lvcreate`. Crear la tabla GPT, el montaje en `fstab` y el volumen que se amplía es la práctica del segundo disco.

Si todavía no tienes la copia de trabajo, desde la raíz del repositorio:

```bash
cp -a u03/datos u03/trabajo
mkdir -p u03/trabajo/salidas u03/trabajo/respuestas
```

# Discos, volúmenes y Windows

Responde en `u03/trabajo/respuestas/discos.md`:

1. Un disco vacío tiene que arrancar por UEFI y separar el sistema de los datos de los usuarios. Qué tabla eliges, qué partición lee el firmware y con qué formato, y por qué un MBR con una sola partición lógica no vale para todo.
2. En qué se distingue una partición lógica de MBR de un volumen lógico de LVM.
3. Ordena las capas desde el disco hasta el directorio donde se ven los ficheros.
4. Tras ampliar, `df` del ext4 montado no se ha movido porque `resize2fs` se ejecutó antes que `lvextend`. Qué capa sigue sin ver los bloques nuevos, y en qué orden se repiten las dos órdenes.
5. En Windows, qué herramienta usas para una letra en un solo disco, y cuál, con qué resistencia, para una letra que siga disponible si muere uno de tres discos.

# Entregable

Desde la raíz del repositorio:

```bash
bash u03/comprobar.sh tarea-02 | tee u03/trabajo/salidas/comprobar-tarea-02.txt
```

Comprime la carpeta `u03/trabajo` en un `.zip` y súbelo a esta tarea. Un solo archivo. El zip puede arrastrar lo de la tarea 1: el trabajo es acumulativo.

Dentro tiene que estar `respuestas/discos.md`, con las cinco respuestas, y `salidas/comprobar-tarea-02.txt`. El comprobador solo mira que el fichero esté escrito. El texto se contrasta con el dossier y con la práctica del segundo disco.
