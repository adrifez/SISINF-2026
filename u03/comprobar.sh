#!/bin/bash
# Comprueba los resultados de u03/EJERCICIOS.md.
# Dice si cada resultado encaja. No imprime la orden que falta.

export LC_ALL=C

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DATOS="$ROOT/u03/datos"
TRABAJO="$ROOT/u03/trabajo"
HOY="$(date +%F)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

ok_n=0
mal_n=0
pend_n=0

ok() { printf '  %-10s %s\n' "ok" "$1"; ok_n=$((ok_n + 1)); }
mal() { printf '  %-10s %s\n' "mal" "$1"; mal_n=$((mal_n + 1)); }
pend() { printf '  %-10s %s\n' "pendiente" "$1"; pend_n=$((pend_n + 1)); }
nota() { printf '  %-10s %s\n' "nota" "$1"; }

section() { printf '\n%s\n' "$1"; }

usage() {
  echo "Uso: bash u03/comprobar.sh [terminal|sistemas|buscar|copias|script|paquetes|discos]"
  echo "Sin argumento comprueba todos los bloques."
}

abspath() {
  if command -v realpath >/dev/null 2>&1; then
    realpath "$1"
  else
    python3 -c 'import os, sys; print(os.path.realpath(sys.argv[1]))' "$1"
  fi
}

same_path() {
  local a="$1" b="$2" ra rb
  [ "$a" = "$b" ] && return 0
  ra="$(abspath "$a" 2>/dev/null)" || return 1
  rb="$(abspath "$b" 2>/dev/null)" || return 1
  [ "$ra" = "$rb" ]
}

file_hash() {
  if command -v sha256sum >/dev/null 2>&1; then
    sha256sum "$1" | awk '{print $1}'
  else
    shasum -a 256 "$1" | awk '{print $1}'
  fi
}

one_line() {
  sed 's/\r$//' "$1" \
    | sed -E $'s/\033\\[[0-9;]*[[:alpha:]]//g' \
    | sed '/^[[:space:]]*$/d' \
    | sed 's/[[:space:]]*$//'
}

case_sensitive_fs() {
  local d="$TRABAJO/.sonda-mayusculas"
  rm -rf "$d"
  mkdir -p "$d"
  printf '1\n' > "$d/A"
  printf '2\n' > "$d/a"
  local got
  got="$(cat "$d/A")"
  rm -rf "$d"
  [ "$got" = "1" ]
}

need_trabajo() {
  if [ -d "$TRABAJO" ]; then
    return 0
  fi
  pend "no existe u03/trabajo. Copia los datos como indica EJERCICIOS.md."
  return 1
}

need_file() {
  local f="$1" msg="$2"
  if [ -f "$f" ]; then
    return 0
  fi
  pend "$msg"
  return 1
}

nota_texto() {
  local f="$1" etiqueta="$2"
  if [ -s "$f" ]; then
    nota "$etiqueta está escrito. Contrástalo con el dossier."
  else
    nota "$etiqueta está pendiente. El comprobador no corrige ese texto."
  fi
}

norm_paths() {
  local prefix="$1"
  local file="$2"
  sed 's/\r$//' "$file" \
    | sed -E $'s/\033\\[[0-9;]*[[:alpha:]]//g' \
    | sed -E "s#.*(${prefix}/[^[:space:]]*)#\\1#" \
    | sed -E 's#^\./##' \
    | sed '/^[[:space:]]*$/d' \
    | sort -u
}

listing_ok() {
  local label="$1"
  local student="$2"
  local prefix="$3"
  local oracle_cmd="$4"
  if ! need_file "$student" "falta $label"; then
    return
  fi
  norm_paths "$prefix" "$student" > "$TMP/student-list"
  bash -c "cd \"$DATOS\" && $oracle_cmd" \
    | sed -E 's#^\./##' \
    | sed '/^[[:space:]]*$/d' \
    | sort -u > "$TMP/oracle-list"
  if cmp -s "$TMP/student-list" "$TMP/oracle-list"; then
    ok "$label"
  else
    mal "$label no coincide con los datos de práctica"
  fi
}

check_terminal() {
  section "Terminal y rutas"
  need_trabajo || return
  local pwd_esperado
  pwd_esperado="$(cd "$TRABAJO" && pwd)"

  if need_file "$TRABAJO/salidas/pwd.txt" "falta salidas/pwd.txt"; then
    local linea n
    linea="$(one_line "$TRABAJO/salidas/pwd.txt")"
    n="$(printf '%s\n' "$linea" | grep -c . || true)"
    if [ "$n" -eq 1 ] && same_path "$linea" "$pwd_esperado"; then
      ok "pwd.txt es la ruta de u03/trabajo"
    else
      mal "pwd.txt no es la ruta absoluta de u03/trabajo"
    fi
  fi

  if need_file "$TRABAJO/salidas/pwd-vuelta.txt" "falta salidas/pwd-vuelta.txt"; then
    local linea n
    linea="$(one_line "$TRABAJO/salidas/pwd-vuelta.txt")"
    n="$(printf '%s\n' "$linea" | grep -c . || true)"
    if [ "$n" -eq 1 ] && same_path "$linea" "$pwd_esperado"; then
      ok "pwd-vuelta.txt vuelve a u03/trabajo"
    else
      mal "pwd-vuelta.txt no vuelve a u03/trabajo"
    fi
  fi

  if need_file "$TRABAJO/salidas/ruta-relativa.txt" "falta salidas/ruta-relativa.txt"; then
    local linea
    linea="$(one_line "$TRABAJO/salidas/ruta-relativa.txt")"
    if [ "$linea" = "taller/web/index.html" ]; then
      ok "ruta-relativa.txt nombra index.html desde trabajo"
    else
      mal "ruta-relativa.txt no es la ruta relativa de index.html"
    fi
  fi

  if need_file "$TRABAJO/salidas/ruta-absoluta.txt" "falta salidas/ruta-absoluta.txt"; then
    local linea n
    linea="$(one_line "$TRABAJO/salidas/ruta-absoluta.txt")"
    n="$(printf '%s\n' "$linea" | grep -c . || true)"
    if [ "$n" -eq 1 ] && same_path "$linea" "$TRABAJO/taller/web/index.html"; then
      ok "ruta-absoluta.txt es la ruta absoluta de index.html"
    else
      mal "ruta-absoluta.txt no es la ruta absoluta de index.html"
    fi
  fi

  if need_file "$TRABAJO/salidas/prestamo.txt" "falta salidas/prestamo.txt"; then
    if cmp -s "$TRABAJO/salidas/prestamo.txt" "$DATOS/taller/prestamos 2026.txt"; then
      ok "prestamo.txt es el fichero cuyo nombre lleva un espacio"
    else
      mal "prestamo.txt no es el contenido de «prestamos 2026.txt»"
    fi
  fi

  if need_file "$TRABAJO/salidas/eco.txt" "falta salidas/eco.txt"; then
    local linea
    linea="$(one_line "$TRABAJO/salidas/eco.txt")"
    if [ "$linea" = "eco" ]; then
      ok "eco.txt es la salida de ./muestra/eco.sh"
    else
      mal "eco.txt no es la salida de ./muestra/eco.sh"
    fi
  fi

  nota_texto "$TRABAJO/respuestas/rutas.md" "respuestas/rutas.md"
}

check_pair() {
  if ! case_sensitive_fs; then
    nota "este disco no distingue mayúsculas. Extrae el par en la Ubuntu de la unidad."
    return
  fi
  local member dest tmp
  for member in Informe.txt informe.txt; do
    dest="$TRABAJO/taller/$member"
    tmp="$TMP/member-$member"
    if [ ! -f "$dest" ]; then
      pend "falta taller/$member. Extrae muestra/par-mayusculas.tar en taller."
      continue
    fi
    tar -xOf "$DATOS/muestra/par-mayusculas.tar" "$member" > "$tmp"
    if cmp -s "$tmp" "$dest"; then
      ok "taller/$member conserva el texto del par"
    else
      mal "taller/$member no tiene el texto del par de mayúsculas"
    fi
  done
}

check_lugar() {
  local nombre="$1" destino="$2" papel="$3"
  local src="$TRABAJO/suelto/$nombre"
  local dest="$TRABAJO/arbol/$destino"
  local original="$DATOS/suelto/$nombre"
  if [ -f "$dest" ] && cmp -s "$dest" "$original"; then
    if [ -e "$src" ]; then
      mal "$nombre sigue en suelto; había que moverlo al directorio de $papel"
    else
      ok "$nombre está en el directorio de $papel"
    fi
  elif [ -e "$src" ] && [ ! -e "$dest" ]; then
    pend "$nombre sigue en suelto (directorio de $papel)"
  else
    mal "$nombre no está en el directorio de $papel, o el contenido ha cambiado"
  fi
}

check_sistemas() {
  section "Sistemas de archivos y directorios"
  need_trabajo || return
  check_pair
  check_lugar fstab etc/fstab "configuración"
  check_lugar syslog var/log/syslog "registros"
  check_lugar apuntes.txt home/admin/apuntes.txt "la cuenta admin"
  check_lugar editor usr/bin/editor "programas"
  check_lugar cache.tmp tmp/cache.tmp "temporales"
  nota_texto "$TRABAJO/respuestas/sistemas.md" "respuestas/sistemas.md"
}

check_buscar() {
  section "Localizar con find y grep"
  need_trabajo || return
  listing_ok "salidas/find-logs.txt" \
    "$TRABAJO/salidas/find-logs.txt" \
    "registros" \
    "find registros -type f -name '*.log' -print"
  if need_file "$TRABAJO/salidas/grep-error.txt" "falta salidas/grep-error.txt"; then
    (cd "$DATOS" && grep -n -i --color=never error registros/app.log > "$TMP/oracle-grep" || true)
    sed 's/\r$//' "$TRABAJO/salidas/grep-error.txt" \
      | sed -E $'s/\033\\[[0-9;]*[[:alpha:]]//g' > "$TMP/student-grep"
    if cmp -s "$TMP/student-grep" "$TMP/oracle-grep"; then
      ok "salidas/grep-error.txt"
    else
      mal "salidas/grep-error.txt no coincide con las líneas de error"
    fi
  fi
  listing_ok "salidas/find-grandes.txt" \
    "$TRABAJO/salidas/find-grandes.txt" \
    "registros" \
    "find registros -type f -name '*.log' -size +1k -print"
  listing_ok "salidas/grep-listen.txt" \
    "$TRABAJO/salidas/grep-listen.txt" \
    "etc-muestra" \
    "grep -r -l --color=never listen etc-muestra"
}

miembro_relativo() {
  local arch="$1"
  tar -tzf "$arch" > "$TMP/tar-list"
  local code=$?
  [ "$code" -eq 0 ] || return 1
  if grep -q '^/' "$TMP/tar-list"; then
    return 2
  fi
  sed 's#^\./##' "$TMP/tar-list" | grep -qx 'taller/catalogo.txt'
}

check_copias() {
  section "Copias"
  need_trabajo || return
  local arch="$TRABAJO/copias/taller-$HOY.tar.gz"
  local lista="$TRABAJO/salidas/taller-$HOY.lista"
  local rest="$TRABAJO/restauracion/taller/catalogo.txt"
  local hash

  if [ ! -f "$arch" ]; then
    pend "falta copias/taller-$HOY.tar.gz"
  else
    hash="$(file_hash "$DATOS/taller/catalogo.txt")"
    miembro_relativo "$arch"
    local estado=$?
    if [ "$estado" -eq 0 ]; then
      ok "el archivo de hoy se lee y lleva taller/catalogo.txt con ruta relativa"
    elif [ "$estado" -eq 2 ]; then
      mal "el archivo de hoy contiene una ruta absoluta"
    else
      mal "el archivo de hoy no se lee, o no lleva taller/catalogo.txt"
    fi
    mkdir -p "$TMP/ext"
    if tar -xzf "$arch" -C "$TMP/ext" && cmp -s "$TMP/ext/taller/catalogo.txt" "$DATOS/taller/catalogo.txt"; then
      ok "al extraer el archivo, catalogo.txt coincide con el original"
    else
      mal "al extraer el archivo, catalogo.txt no coincide con el original"
    fi
  fi

  if need_file "$lista" "falta salidas/taller-$HOY.lista"; then
    if grep -q 'taller/catalogo.txt' "$lista"; then
      ok "la lista del archivo menciona taller/catalogo.txt"
    else
      mal "la lista del archivo no menciona taller/catalogo.txt"
    fi
  fi

  if need_file "$rest" "falta restauracion/taller/catalogo.txt"; then
    if cmp -s "$rest" "$DATOS/taller/catalogo.txt"; then
      ok "la restauración de catalogo.txt coincide con el original"
    else
      mal "la restauración de catalogo.txt no coincide con el original"
    fi
  fi

  if need_file "$TRABAJO/salidas/sha256-catalogo.txt" "falta salidas/sha256-catalogo.txt"; then
    hash="$(file_hash "$DATOS/taller/catalogo.txt")"
    local veces
    veces="$(grep -c -F "$hash" "$TRABAJO/salidas/sha256-catalogo.txt" || true)"
    if [ "$veces" -ge 2 ]; then
      ok "el resumen de catalogo.txt coincide en el original y en la restauración"
    else
      mal "el resumen de catalogo.txt no coincide en el original y en la restauración"
    fi
  fi

  if need_file "$TRABAJO/espejo/catalogo.txt" "falta espejo/catalogo.txt"; then
    if cmp -s "$TRABAJO/espejo/catalogo.txt" "$DATOS/taller/catalogo.txt"; then
      ok "espejo/catalogo.txt es la copia sincronizada"
    else
      mal "espejo/catalogo.txt no coincide con el original"
    fi
  fi

  if need_file "$TRABAJO/taller/novedad.txt" "falta taller/novedad.txt"; then
    if need_file "$TRABAJO/espejo/novedad.txt" "falta espejo/novedad.txt tras la segunda sincronización"; then
      if cmp -s "$TRABAJO/espejo/novedad.txt" "$TRABAJO/taller/novedad.txt"; then
        ok "espejo/novedad.txt llegó en la segunda sincronización"
      else
        mal "espejo/novedad.txt no coincide con taller/novedad.txt"
      fi
    fi
  fi
}

check_script() {
  section "Script y cron"
  need_trabajo || return
  local script="$TRABAJO/bin/copia-taller.sh"
  if [ ! -f "$script" ]; then
    pend "falta bin/copia-taller.sh"
  else
    local shebang
    shebang="$(head -n 1 "$script" | tr -d '\r')"
    if [ "$shebang" = "#!/bin/bash" ]; then
      ok "el script empieza por #!/bin/bash"
    else
      mal "la primera línea del script tiene que ser #!/bin/bash"
    fi
    if [ -x "$script" ]; then
      ok "el script es ejecutable"
    else
      mal "el script no es ejecutable"
    fi
    if grep -Eq '^[[:space:]]*(export[[:space:]]+)?[A-Za-z_][A-Za-z0-9_]*=' "$script"; then
      ok "el script asigna una variable"
    else
      mal "el destino y la fecha van en variables, sin espacios alrededor del igual"
    fi
    if grep -Fq 'date' "$script" && grep -Fq '%F' "$script"; then
      ok "el script obtiene la fecha con date y %F"
    else
      mal "el nombre del archivo tiene que salir de date +%F"
    fi
    if grep -Fq 'tar' "$script"; then
      ok "el script usa tar"
    else
      mal "el script tiene que empaquetar con tar"
    fi

    local arch="$TRABAJO/copias/taller-$HOY.tar.gz"
    local lista="$TRABAJO/copias/taller-$HOY.lista"
    if [ -x "$script" ]; then
      # Aparta el archivo del bloque 4: el que vale aquí es el que escriba el script.
      [ -f "$arch" ] && cp -p "$arch" "$TMP/archivo-previo.tar.gz"
      [ -f "$lista" ] && cp -p "$lista" "$TMP/lista-previa"
      rm -f "$arch" "$lista"
      local code
      (
        cd /tmp || exit 99
        if command -v timeout >/dev/null 2>&1; then
          timeout 20 "$script"
        else
          "$script"
        fi
      ) > "$TMP/script-out" 2> "$TMP/script-err"
      code=$?
      if [ "$code" -eq 0 ]; then
        ok "el script termina con código 0 lanzado desde otro directorio"
      else
        mal "el script, lanzado desde otro directorio, terminó con código $code"
        if [ -s "$TMP/script-err" ]; then
          sed 's/^/             /' "$TMP/script-err" | head -n 5
        fi
      fi
      if [ ! -f "$arch" ]; then
        pend "el script no ha dejado copias/taller-$HOY.tar.gz"
        [ -f "$TMP/archivo-previo.tar.gz" ] && cp -p "$TMP/archivo-previo.tar.gz" "$arch"
      else
        miembro_relativo "$arch"
        local estado=$?
        if [ "$estado" -eq 0 ]; then
          ok "el archivo del script se lee y lleva rutas relativas"
        elif [ "$estado" -eq 2 ]; then
          mal "el archivo del script contiene una ruta absoluta"
        else
          mal "el archivo del script no se lee, o no lleva taller/catalogo.txt"
        fi
      fi
      if [ ! -f "$lista" ]; then
        pend "falta copias/taller-$HOY.lista"
        [ -f "$TMP/lista-previa" ] && cp -p "$TMP/lista-previa" "$lista"
      elif grep -q 'taller/catalogo.txt' "$lista"; then
        ok "la lista del script menciona taller/catalogo.txt"
      else
        mal "la lista del script no menciona taller/catalogo.txt"
      fi
    fi
  fi

  if need_file "$TRABAJO/salidas/crontab.txt" "falta salidas/crontab.txt"; then
    local linea n ruta
    linea="$(one_line "$TRABAJO/salidas/crontab.txt")"
    n="$(printf '%s\n' "$linea" | grep -c . || true)"
    if [ "$n" -eq 1 ] && [[ "$linea" =~ ^30[[:space:]]+23[[:space:]]+\*[[:space:]]+\*[[:space:]]+0[[:space:]]+(.+)$ ]]; then
      ruta="${BASH_REMATCH[1]}"
      ruta="${ruta#\"}"
      ruta="${ruta%\"}"
      ruta="${ruta#\'}"
      ruta="${ruta%\'}"
      if [ -f "$script" ] && same_path "$ruta" "$script"; then
        ok "crontab.txt es el domingo a las 23:30 con la ruta absoluta del script"
      else
        mal "la orden de crontab.txt no es la ruta absoluta de bin/copia-taller.sh"
      fi
    else
      mal "crontab.txt no es una sola línea del domingo a las 23:30 seguida del script"
    fi
  fi

  nota_texto "$TRABAJO/respuestas/cron.md" "respuestas/cron.md"
}

debian_con_apt() {
  [ -r /etc/debian_version ] && command -v apt >/dev/null 2>&1
}

check_paquetes() {
  section "Paquetes y utilidades"
  if ! debian_con_apt; then
    nota "en este sistema no hay apt. Omite la ficha y escribe las tres situaciones."
  else
    need_trabajo || return
    if need_file "$TRABAJO/salidas/apt-rsync.txt" "falta salidas/apt-rsync.txt"; then
      if grep -q '^Package: rsync$' "$TRABAJO/salidas/apt-rsync.txt"; then
        ok "apt-rsync.txt es la ficha de rsync"
      else
        mal "apt-rsync.txt no es la ficha de rsync"
      fi
    fi
  fi
  if [ -d "$TRABAJO" ]; then
    nota_texto "$TRABAJO/respuestas/utilidades.md" "respuestas/utilidades.md"
  fi
}

check_discos() {
  section "Discos, volúmenes y Windows"
  nota "respuestas/discos.md se contrasta con el dossier y con la práctica del segundo disco."
  if [ -s "$TRABAJO/respuestas/discos.md" ]; then
    nota "el fichero está escrito."
  else
    nota "el fichero todavía no está escrito."
  fi
}

part="${1:-todo}"
case "$part" in
  todo|terminal|sistemas|buscar|copias|script|paquetes|discos) ;;
  -h|--help|help)
    usage
    exit 0
    ;;
  *)
    usage
    exit 2
    ;;
esac

[ "$part" = todo ] || [ "$part" = terminal ] && check_terminal
[ "$part" = todo ] || [ "$part" = sistemas ] && check_sistemas
[ "$part" = todo ] || [ "$part" = buscar ] && check_buscar
[ "$part" = todo ] || [ "$part" = copias ] && check_copias
[ "$part" = todo ] || [ "$part" = script ] && check_script
[ "$part" = todo ] || [ "$part" = paquetes ] && check_paquetes
[ "$part" = todo ] || [ "$part" = discos ] && check_discos

printf '\nResumen: %s ok, %s pendientes, %s mal\n' "$ok_n" "$pend_n" "$mal_n"
if [ "$mal_n" -eq 0 ] && [ "$pend_n" -eq 0 ]; then
  exit 0
fi
exit 1
