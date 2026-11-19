# Ajolotito Hambriento (notificaciones locales + TDD)

Código del manual "Ajolotito Hambriento" (UTNG).

```powershell
flutter create .      # genera android/ios/windows (no pisa lib/ ni pubspec.yaml)
flutter pub get
flutter test          # 7 archivos de pruebas
```

`flutter test` NO necesita teléfono ni la configuración de Android/iOS: todo el
comportamiento está detrás de un puerto falso. Para correr la app en un teléfono
sigue las Rondas 1 y 12 del manual (AndroidManifest, desugaring, AppDelegate).

Capturas en orden ROJO -> VERDE:

```powershell
powershell -ExecutionPolicy Bypass -File .\capturas_ajolotito.ps1
```
