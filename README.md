# FutureBuilder Examples - Ejemplos Prácticos

Esta aplicación Flutter contiene ejemplos completos para demostrar el uso correcto e incorrecto del widget `FutureBuilder`, ideal para charlas y presentaciones técnicas.

## 📱 Pantallas Incluidas

### 1. ✅ **Buenas Prácticas** (`GoodPracticesScreen`)
- **Future declarado fuera del `build()`**: En `initState()` o como variable de instancia
- **Beneficios**: No se ejecuta nuevamente en cada rebuild
- **Funcionalidades**:
  - Contador de rebuilds para demostrar que el Future no se re-ejecuta
  - Botón de refresh que actualiza el Future correctamente
  - Manejo adecuado de estados de carga, error y éxito

### 2. ❌ **Malas Prácticas** (`BadPracticesScreen`)
- **Future creado en el `build()`**: Demuestra el problema de re-ejecución
- **Problemas mostrados**:
  - Contador de llamadas API que incrementa en cada rebuild
  - Performance degradada por llamadas innecesarias
  - Experiencia de usuario pobre (carga constante)

### 3. 📊 **ConnectionState** (`ConnectionStateScreen`)
- **Manejo detallado de estados**: `none`, `waiting`, `active`, `done`
- **Funcionalidades**:
  - Comparación entre carga rápida (0.5s) y lenta (5s)
  - Visualización en tiempo real del estado actual
  - Explicaciones detalladas de cada estado
  - UI diferente para cada estado de conexión

### 4. 🔧 **StatelessWidget** (`StatelessExampleScreen`)
- **Future en widgets sin estado**: Muestra limitaciones y casos de uso
- **Ejemplos incluidos**:
  - Widget de perfil de usuario
  - Lista de usuarios
  - Demostración de que el Future se recrea en cada rebuild del padre

### 5. ⚙️ **StatefulWidget** (`StatefulExampleScreen`)
- **Future en widgets con estado**: Implementación correcta
- **Funcionalidades**:
  - Future estable entre rebuilds
  - Selector de usuario con carga dinámica
  - Widget anidado que demuestra `didUpdateWidget()`
  - Manejo correcto de cambios en parámetros

### 6. ⚠️ **Manejo de Errores** (`ErrorHandlingScreen`)
- **Gestión completa de errores**: Estados de error, retry, y recuperación
- **Funcionalidades**:
  - Switch para forzar errores (útil para demostrar)
  - Contador de intentos
  - UI rica para estados de error
  - Botones de reintentar con diferentes estrategias
  - Consejos de buenas prácticas

## 🎯 Puntos Clave para la Charla

### 🚫 Errores Comunes
1. **Future en build()**: Causa re-ejecuciones innecesarias
2. **No manejar ConnectionState**: UI pobre durante la carga
3. **Ignorar errores**: App se rompe sin manejo adecuado
4. **No actualizar Future**: Datos obsoletos en la UI

### ✅ Mejores Prácticas
1. **Declarar Future fuera de build()**: En `initState()` o variables de instancia
2. **Usar ConnectionState apropiadamente**: UI específica para cada estado
3. **Manejar todos los casos**: Loading, error, empty, success
4. **Implementar refresh correctamente**: Crear nuevo Future cuando sea necesario
5. **Considerar didUpdateWidget()**: Para widgets que reciben parámetros externos

## 🛠️ Servicios Incluidos

### `ApiService`
Simula llamadas a API con diferentes comportamientos:
- `getUsers()`: Lista de usuarios (puede fallar aleatoriamente)
- `getFastData()`: Carga rápida (0.5s)
- `getSlowData()`: Carga lenta (5s)
- `getUserProfile(id)`: Perfil específico de usuario

### `User` Model
Modelo simple para demostrar datos estructurados:
```dart
class User {
  final int id;
  final String name;
  final String email;
  final String phone;
}
```

## 🚀 Cómo Usar en tu Charla

1. **Introducción**: Mostrar la pantalla principal con todos los ejemplos
2. **Problema**: Comenzar con "Malas Prácticas" para mostrar los problemas
3. **Solución**: Contrastar con "Buenas Prácticas"
4. **Estados**: Demostrar ConnectionState con cargas rápidas/lentas
5. **Contexto**: Mostrar diferencias entre StatelessWidget y StatefulWidget
6. **Robustez**: Terminar con manejo de errores

## 📝 Notas para el Presentador

- Cada pantalla tiene indicadores visuales (contadores, colores) para evidenciar los conceptos
- Los botones de "Forzar Rebuild" ayudan a demostrar el comportamiento en tiempo real
- Los comentarios en el código están marcados con ✅ y ❌ para facilitar la explicación
- La app funciona sin conexión a internet (usa datos simulados)

## 🔧 Configuración

```bash
flutter pub get
flutter run
```

La aplicación está lista para ejecutarse sin dependencias externas.
