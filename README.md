# Capturas de las pruebas (TDD)

Cada captura va en orden: ronda, resultado (ROJO = falla, VERDE = pasa) y la imagen.

## 1. Ronda 2 · El reloj y el ajolote (`mascota_test.dart`)
**Resultado: ROJO ❌** — Falla: todavía no existe `mascota.dart`.

![Ronda 2 · El reloj y el ajolote (`mascota_test.dart`) - ROJO ❌](capturas/01_r2_mascota_rojo.png)

## 2. Ronda 2 · El reloj y el ajolote (`mascota_test.dart`)
**Resultado: VERDE ✅** — Pasan las 16 pruebas.

![Ronda 2 · El reloj y el ajolote (`mascota_test.dart`) - VERDE ✅](capturas/02_r2_mascota_verde.png)

## 3. Ronda 4 · Política de buena educación (`politica_payload_test.dart`)
**Resultado: ROJO ❌** — Falla: todavía no existen `politica.dart` ni `payload.dart`.

![Ronda 4 · Política de buena educación (`politica_payload_test.dart`) - ROJO ❌](capturas/03_r4_politica_rojo.png)

## 4. Ronda 4 · Política de buena educación (`politica_payload_test.dart`)
**Resultado: NO PASA ❌** — Con `politica.dart` creado sigue fallando: el mismo archivo de pruebas ya usa `payload.dart`, que el manual crea hasta la Ronda 5.

![Ronda 4 · Política de buena educación (`politica_payload_test.dart`) - NO PASA ❌](capturas/04_r4_politica_verde_sin_payload.png)

## 5. Ronda 5 · El payload (`politica_payload_test.dart`)
**Resultado: VERDE ✅** — Con `payload.dart` pasan las 12 pruebas (política + payload).

![Ronda 5 · El payload (`politica_payload_test.dart`) - VERDE ✅](capturas/05_r5_payload_verde.png)

## 6. Ronda 6 · El planificador (`planificador_test.dart`)
**Resultado: ROJO ❌** — Falla: todavía no existe `planificador.dart`.

![Ronda 6 · El planificador (`planificador_test.dart`) - ROJO ❌](capturas/06_r6_planificador_rojo.png)

## 7. Ronda 6 · El planificador (`planificador_test.dart`)
**Resultado: VERDE ✅** — Pasan las 13 pruebas.

![Ronda 6 · El planificador (`planificador_test.dart`) - VERDE ✅](capturas/07_r6_planificador_verde.png)

## 8. Ronda 8 · El permiso (`permiso_test.dart`)
**Resultado: ROJO ❌** — Falla: todavía no existen `almacen.dart` ni `gestor_permiso.dart`.

![Ronda 8 · El permiso (`permiso_test.dart`) - ROJO ❌](capturas/08_r8_permiso_rojo.png)

## 9. Ronda 8 · El permiso (`permiso_test.dart`)
**Resultado: VERDE ✅** — Pasan las 6 pruebas.

![Ronda 8 · El permiso (`permiso_test.dart`) - VERDE ✅](capturas/09_r8_permiso_verde.png)

## 10. Ronda 9 · El servicio (`servicio_test.dart`)
**Resultado: ROJO ❌** — Falla: todavía no existe `servicio.dart`.

![Ronda 9 · El servicio (`servicio_test.dart`) - ROJO ❌](capturas/10_r9_servicio_rojo.png)

## 11. Ronda 9 · El servicio (`servicio_test.dart`)
**Resultado: VERDE ✅** — Pasan las 14 pruebas.

![Ronda 9 · El servicio (`servicio_test.dart`) - VERDE ✅](capturas/11_r9_servicio_verde.png)

## 12. Ronda 11 · ViewModel (`vm_test.dart`)
**Resultado: ROJO ❌** — Falla: todavía no existe `ajolote_vm.dart`.

![Ronda 11 · ViewModel (`vm_test.dart`) - ROJO ❌](capturas/12_r11_vm_rojo.png)

## 13. Ronda 11 · ViewModel (`vm_test.dart`)
**Resultado: VERDE ✅** — Pasan las 10 pruebas.

![Ronda 11 · ViewModel (`vm_test.dart`) - VERDE ✅](capturas/13_r11_vm_verde.png)

## 14. Ronda 11 · Suite completa
**Resultado: VERDE ✅** — `flutter test`: 71 pruebas pasan.

![Ronda 11 · Suite completa - VERDE ✅](capturas/14_r11_suite_final.png)

