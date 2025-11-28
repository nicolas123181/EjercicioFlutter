# Documentación - Mini Smart Notepad

**Asignatura:** Desarrollo de Interfaces  
**Proyecto:** Aplicación de Notas con IA en Flutter  
**Equipo:** [Nombres de los miembros del equipo]

---

## 1. Plan de Trabajo Inicial

### Planificación de Desarrollo

1. **Fase 1 - Configuración Base:** Estructura del proyecto, dependencias y configuración inicial
2. **Fase 2 - Base de Datos:** Implementación de SQLite con modelo de datos Note
3. **Fase 3 - UI/UX:** Desarrollo de pantallas de listado y edición de notas
4. **Fase 4 - Estado:** Implementación de Riverpod para gestión de estado reactivo
5. **Fase 5 - IA:** Integración de Google Gemini para funcionalidad de resumen y mejora de texto
6. **Fase 6 - Testing:** Pruebas y corrección de errores

---

## 2. Uso de la IA (Google Gemini)

### Dónde se ha usado

La IA de Google Gemini se utiliza en dos funcionalidades principales:

1. **Resumen de texto:** Genera un resumen conciso del contenido de la nota
2. **Mejora de texto:** Optimiza la redacción para mayor claridad y profesionalismo

### Ejemplos de Prompts Utilizados

**Prompt para Resumen:**
```
Eres un especialista en síntesis de información. Tu tarea es extraer la idea principal 
del siguiente texto y condensarla en un resumen breve, conciso y profesional.

REQUISITOS DEL OUTPUT:
1. Tu respuesta debe contener **solamente** el texto del resumen final.
2. **Está estrictamente prohibido** presentar alternativas, opciones numeradas, listas, 
   o cualquier tipo de preámbulo o justificación.
3. Genera una **única versión final** del resumen.

TEXTO DE ENTRADA:
[texto de la nota]
```

**Prompt para Mejora:**
```
Eres un editor de contenido profesional y debes optimizar la claridad, el tono y la 
gramática del texto de entrada.

INSTRUCCIONES CLAVE:
1. Tu respuesta debe contener **solamente** el texto revisado y mejorado.
2. **Prohibido** listar múltiples opciones, presentar el texto original, añadir 
   introducciones o justificaciones.
3. Selecciona y genera **una única versión final** que cumpla con los estándares de 
   claridad y profesionalismo requeridos.

TEXTO A MEJORAR:
[texto de la nota]
```

### Problemas Resueltos por la IA

- **Compatibilidad de modelos:** Inicialmente usamos `gemini-pro` que estaba obsoleto. La IA nos ayudó a identificar que debíamos usar `gemini-2.0-flash` para la API v1beta
- **Depuración de errores:** Implementamos logs detallados para rastrear errores en las llamadas a la API
- **Optimización de prompts:** Refinamos los prompts para obtener respuestas más precisas y evitar formato no deseado

---

## 3. Arquitectura Básica

### SQLite

**Implementación:** Usamos el paquete `sqflite` con `sqflite_common_ffi` para compatibilidad multiplataforma (incluido macOS/desktop).

**Estructura de la base de datos:**
```sql
CREATE TABLE notes (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  title TEXT NOT NULL,
  content TEXT NOT NULL
)
```

**Patrón Singleton:** La clase `AppDatabase` implementa el patrón Singleton para garantizar una única instancia de la base de datos:
```dart
class AppDatabase {
  static final AppDatabase instance = AppDatabase._init();
  static Database? _database;
  
  AppDatabase._init();
  
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('notes.db');
    return _database!;
  }
}
```

**Ubicación:** La base de datos se almacena localmente en:
- macOS: `/Users/[user]/Library/Containers/com.example.ejerciciodificil/Data/.dart_tool/sqflite_common_ffi/databases/notes.db`

### Riverpod

**¿Por qué Riverpod?**

Riverpod es un framework de gestión de estado moderno que ofrece:
- **Seguridad en compile-time:** Detecta errores en tiempo de compilación
- **Provider autodescubribles:** No requiere BuildContext
- **Testing simplificado:** Facilita las pruebas unitarias
- **Reactividad:** Actualización automática de la UI cuando cambia el estado

**Providers Creados:**

1. **`notesRepositoryProvider`** - Proporciona la instancia del repositorio:
```dart
final notesRepositoryProvider = Provider<NotesRepository>((ref) {
  return NotesRepository();
});
```

2. **`notesProvider`** - Gestiona el estado de la lista de notas:
```dart
final notesProvider = AsyncNotifierProvider<NotesNotifier, List<Note>>(() {
  return NotesNotifier();
});
```

**NotesNotifier:** Implementa la lógica de negocio con métodos para:
- `build()` - Inicialización y carga de notas
- `addNote()` - Agregar nueva nota
- `updateNote()` - Actualizar nota existente
- `deleteNote()` - Eliminar nota

---

## 4. Problemas Encontrados

### 1. Compatibilidad de SDK
**Problema:** El proyecto requería Dart SDK ^3.8.1 pero teníamos 3.8.0 instalado.  
**Solución:** Modificamos `pubspec.yaml` para aceptar `sdk: ^3.0.0`

### 2. Permisos de Red en macOS
**Problema:** Error `Operation not permitted` al intentar conectar con la API de Gemini.  
**Solución:** Agregamos los permisos de red a los archivos de entitlements de macOS:
```xml
<key>com.apple.security.network.client</key>
<true/>
```

### 3. Modelo de IA Obsoleto
**Problema:** El modelo `gemini-pro` ya no estaba disponible en la API v1beta.  
**Solución:** Actualizamos a `gemini-2.0-flash` que es compatible con la versión actual de la API.

### 4. Dependencias Faltantes
**Problema:** Errores de compilación por falta de `flutter_riverpod` y otros paquetes.  
**Solución:** Agregamos todas las dependencias necesarias en `pubspec.yaml`:
- `flutter_riverpod: ^3.0.3`
- `sqflite: ^2.4.2`
- `google_generative_ai: ^0.4.7`
- `sqflite_common_ffi: ^2.3.6`

### 5. Cross-platform SQLite
**Problema:** SQLite no funcionaba correctamente en macOS desktop.  
**Solución:** Implementamos `sqflite_common_ffi` e inicializamos en `main.dart`:
```dart
sqfliteFfiInit();
databaseFactory = databaseFactoryFfi;
```

---

## 5. Capturas de Pantalla

### Lista de Notas
![Lista de Notas](./screenshots/lista_notas.png)
*Pantalla principal mostrando todas las notas guardadas con título y vista previa del contenido*

### Creación/Edición de Nota
![Editar Nota](./screenshots/editar_nota.png)
*Interfaz para crear o modificar una nota con campos de título y contenido*

### Funcionalidad de IA
![Resultado IA](./screenshots/resultado_ia.png)
*Demostración de la función de mejora y resumen de texto usando Google Gemini*

---

## 6. Estructura del Proyecto

```
lib/
├── app/
│   ├── app.dart                    # Configuración principal de la app
│   └── router.dart                 # Gestión de rutas
├── config/
│   └── theme.dart                  # Tema personalizado
├── core/
│   ├── database/
│   │   └── app_database.dart       # Configuración SQLite
│   ├── models/
│   │   └── note.dart               # Modelo de datos Note
│   └── services/
│       └── ai_service.dart         # Servicio de integración con Gemini
├── features/
│   └── notes/
│       ├── data/
│       │   └── notes_repository.dart    # Repositorio CRUD
│       ├── presentation/
│       │   ├── pages/
│       │   │   ├── notes_list_page.dart # Página principal
│       │   │   └── note_edit_page.dart  # Página de edición
│       │   └── widgets/
│       │       └── note_form.dart       # Formulario de nota
│       └── providers/
│           └── notes_provider.dart      # Provider Riverpod
└── main.dart                       # Punto de entrada
```

---

## 7. Conclusiones

El proyecto "Mini Smart Notepad" demuestra la integración exitosa de:
- **SQLite** para persistencia de datos local
- **Riverpod** para gestión de estado reactivo y escalable  
- **Google Gemini AI** para funcionalidades inteligentes de procesamiento de texto
- **Arquitectura limpia** con separación de capas (datos, lógica, presentación)

La aplicación funciona correctamente en **macOS desktop** y está lista para ser expandida a otras plataformas (iOS, Android, Web) con mínimos ajustes.
