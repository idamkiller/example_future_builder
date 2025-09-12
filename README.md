# FutureBuilder Examples - Ejemplos Prácticos

Esta aplicación Flutter contiene ejemplos completos para demostrar el uso correcto e incorrecto del widget `FutureBuilder`.

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
