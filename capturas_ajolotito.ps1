# ============================================================================
#  Ajolotito Hambriento - capturas del ciclo TDD en ORDEN (ROJO -> VERDE)
#
#  Uso (desde la carpeta del proyecto, en PowerShell o CMD):
#     powershell -ExecutionPolicy Bypass -File .\capturas_ajolotito.ps1
#  Opcional (solo rojos "de compilación", sin los de aserción):
#     powershell -ExecutionPolicy Bypass -File .\capturas_ajolotito.ps1 -SinAserciones
#
#  En cada pantalla el script se detiene: toma tu captura (Win + Shift + S)
#  y presiona Enter. Todo se guarda también en la carpeta capturas\ (.txt).
#  Si el script se corta, vuelve a ejecutarlo: primero restaura lo que ocultó.
# ============================================================================
param([switch]$SinAserciones)

$ErrorActionPreference = 'Continue'
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$raiz = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $raiz
$logs = Join-Path $raiz 'capturas'
New-Item -ItemType Directory -Force -Path $logs | Out-Null
$utf8 = New-Object System.Text.UTF8Encoding($false)
$script:contador = 0

# --- Si una corrida anterior se cortó, deja todo como estaba -----------------
Get-ChildItem -Path $raiz -Recurse -Force -Include '*.bak', '*.orig' -ErrorAction SilentlyContinue |
    Where-Object { $_.FullName -notmatch '\\(\.dart_tool|build)\\' } |
    ForEach-Object {
        $destino = $_.FullName -replace '\.(bak|orig)$', ''
        if ($_.Extension -eq '.orig') {
            Move-Item -Force $_.FullName $destino
        } elseif (-not (Test-Path $destino)) {
            Move-Item $_.FullName $destino
        }
    }

function Encabezado($texto, $color) {
    Clear-Host
    Write-Host ('=' * 72) -ForegroundColor $color
    Write-Host ("  " + $texto) -ForegroundColor $color
    Write-Host ('=' * 72) -ForegroundColor $color
    Write-Host ''
}

function Pausa($mensaje) {
    Write-Host ''
    Read-Host ">> $mensaje  (Enter para continuar)" | Out-Null
}

function Ocultar($rutas) {
    foreach ($r in $rutas) {
        $p = Join-Path $raiz $r
        if (Test-Path $p) { Rename-Item -Path $p -NewName ((Split-Path $p -Leaf) + '.bak') }
    }
}

function Restaurar($rutas) {
    foreach ($r in $rutas) {
        $p = Join-Path $raiz $r
        if (Test-Path ($p + '.bak')) { Rename-Item -Path ($p + '.bak') -NewName (Split-Path $p -Leaf) }
    }
}

# Cambia un texto del archivo para que una regla "se rompa" (guarda copia .orig)
function Romper($ruta, $buscar, $reemplazo) {
    $p = Join-Path $raiz $ruta
    Copy-Item $p ($p + '.orig') -Force
    $txt = [System.IO.File]::ReadAllText($p, $utf8)
    if (-not $txt.Contains($buscar)) {
        Write-Host "No encontré el texto a romper en $ruta (¿cambiaste el archivo?)." -ForegroundColor Yellow
        return $false
    }
    [System.IO.File]::WriteAllText($p, $txt.Replace($buscar, $reemplazo), $utf8)
    return $true
}

function Desromper($ruta) {
    $p = Join-Path $raiz $ruta
    if (Test-Path ($p + '.orig')) { Move-Item -Force ($p + '.orig') $p }
}

function Probar($prueba, $nombreLog) {
    $script:contador++
    $archivo = Join-Path $logs ('{0:D2}_{1}.txt' -f $script:contador, $nombreLog)
    Write-Host "PS> flutter test --reporter expanded $prueba" -ForegroundColor DarkGray
    flutter test --reporter expanded $prueba 2>&1 | Tee-Object -FilePath $archivo
}

# --- Un ciclo ROJO (falta el código) -> VERDE (se restaura) -------------------
function Ronda($titulo, $prueba, $ocultar, $nombreLog) {
    Encabezado "$titulo  |  ROJO: la prueba existe, el código todavía no" 'Red'
    Ocultar $ocultar
    Probar $prueba "${nombreLog}_rojo"
    Pausa 'Toma la captura del ROJO'
    Restaurar $ocultar
    Encabezado "$titulo  |  VERDE: se escribió el código" 'Green'
    Probar $prueba "${nombreLog}_verde"
    Pausa 'Toma la captura del VERDE'
}

# --- Un ciclo ROJO (una regla rota, falla una aserción) -> VERDE --------------
function RondaRota($titulo, $prueba, $ruta, $buscar, $reemplazo, $nombreLog) {
    if ($SinAserciones) { return }
    Encabezado "$titulo  |  ROJO: una regla se rompe y la prueba lo detecta" 'Red'
    if (Romper $ruta $buscar $reemplazo) {
        Probar $prueba "${nombreLog}_rojo"
        Pausa 'Toma la captura del ROJO (aserción fallida)'
        Desromper $ruta
        Encabezado "$titulo  |  VERDE: regla restaurada" 'Green'
        Probar $prueba "${nombreLog}_verde"
        Pausa 'Toma la captura del VERDE'
    } else {
        Desromper $ruta
        Pausa 'Se omite este paso'
    }
}

# ============================= INICIO ======================================
Encabezado 'Ajolotito: preparación (no necesita captura)' 'Cyan'
flutter pub get
Pausa 'Listo. A partir de aquí cada pantalla es una captura'

# --- Ronda 2: el reloj y el ajolote ------------------------------------------
Ronda 'RONDA 2 - Mascota (saciedad, humor, predicción)' 'test\mascota_test.dart' `
    @('lib\dominio\mascota.dart') 'r2_mascota'
RondaRota 'RONDA 2 - El umbral de hambre sube de 40 a 50' 'test\mascota_test.dart' `
    'lib\dominio\mascota.dart' 'static const double umbralHambre = 40;' 'static const double umbralHambre = 50;' `
    'r2_mascota_aserc'

# --- Rondas 4 y 5: política de silencio y payload (mismo archivo de prueba) --
Ronda 'RONDAS 4 y 5 - Política de silencio y payload' 'test\politica_payload_test.dart' `
    @('lib\dominio\politica.dart', 'lib\dominio\payload.dart') 'r4_r5_politica_payload'
RondaRota 'RONDA 4 - El silencio cruzando la medianoche se rompe (O -> Y)' 'test\politica_payload_test.dart' `
    'lib\dominio\politica.dart' '(h >= silencioDesde || h < silencioHasta)' '(h >= silencioDesde && h < silencioHasta)' `
    'r4_silencio_aserc'
RondaRota 'RONDA 5 - El payload cambia de v1 a v2' 'test\politica_payload_test.dart' `
    'lib\dominio\payload.dart' "'v1:`${destino.name}'" "'v2:`${destino.name}'" 'r5_payload_aserc'

# --- Ronda 6: el planificador -------------------------------------------------
Ronda 'RONDA 6 - Planificador (de estado a agenda de avisos)' 'test\planificador_test.dart' `
    @('lib\dominio\planificador.dart') 'r6_planificador'
RondaRota 'RONDA 6 - La sorpresa pasa de las 18:00 a las 19:00' 'test\planificador_test.dart' `
    'lib\dominio\planificador.dart' 'static const int horaSorpresa = 18;' 'static const int horaSorpresa = 19;' `
    'r6_planificador_aserc'

# --- Ronda 8: gestor de permisos (usa el puerto falso de la Ronda 7) ---------
Ronda 'RONDAS 7 y 8 - Puerto falso y gestor de permisos' 'test\permiso_test.dart' `
    @('lib\dominio\gestor_permiso.dart', 'lib\dominio\almacen.dart') 'r8_permiso'
RondaRota 'RONDA 8 - Se vuelve a insistir con el permiso aunque dijo que no' 'test\permiso_test.dart' `
    'lib\dominio\gestor_permiso.dart' 'pregunto ? EstadoPermiso.denegado : EstadoPermiso.sinPreguntar' 'EstadoPermiso.sinPreguntar' `
    'r8_permiso_aserc'

# --- Ronda 9: el servicio -----------------------------------------------------
Ronda 'RONDA 9 - Servicio (sincronizar, primer plano, modo clase)' 'test\servicio_test.dart' `
    @('lib\dominio\servicio.dart') 'r9_servicio'
RondaRota 'RONDA 9 - El modo clase deja de ser 600 puntos por hora' 'test\servicio_test.dart' `
    'lib\dominio\servicio.dart' 'static const double ritmoClase = 600;' 'static const double ritmoClase = 60;' `
    'r9_servicio_aserc'

# --- Ronda 11: ViewModel y pantalla ------------------------------------------
Ronda 'RONDA 11 - ViewModel' 'test\vm_test.dart' `
    @('lib\presentacion\ajolote_vm.dart') 'r11_vm'
RondaRota 'RONDA 11 - El mensaje de panza llena cambia' 'test\vm_test.dart' `
    'lib\presentacion\ajolote_vm.dart' 'está llenísimo; ni un acocil más.' 'está llenito; ni un acocil más.' `
    'r11_vm_aserc'
Ronda 'RONDA 11 - Pantalla (widget test)' 'test\pantalla_test.dart' `
    @('lib\presentacion\pantalla_ajolote.dart') 'r11_pantalla'
RondaRota 'RONDA 11 - Cambia el texto del ajolote feliz' 'test\pantalla_test.dart' `
    'lib\presentacion\pantalla_ajolote.dart' "Humor.feliz => 'Feliz y con la pancita llena'" "Humor.feliz => 'Feliz y contento'" `
    'r11_pantalla_aserc'

# --- Final: todo junto --------------------------------------------------------
Encabezado 'FINAL - Todas las pruebas en verde (7 archivos)' 'Green'
$script:contador++
flutter test --reporter expanded 2>&1 | Tee-Object -FilePath (Join-Path $logs ('{0:D2}_final.txt' -f $script:contador))
Pausa 'Toma la captura final'

Encabezado 'Terminaste. Tus textos de respaldo están en la carpeta capturas\' 'Cyan'
