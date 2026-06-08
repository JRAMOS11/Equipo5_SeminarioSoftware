# Control de Acceso Basado en Roles (RBAC) - Guía de Integración

## Resumen de Cambios

Se ha implementado un sistema completo de control de acceso basado en roles en todo el sistema académico. Este sistema restringe el acceso a páginas y características según los roles de usuario (Director, Maestro, Estudiante).

## Archivos Creados

### 1. **src/utilities/RoleMiddleware.php** (NUEVO)
Middleware principal para control de acceso basado en roles.

**Características Principales:**
- Definición centralizada de permisos de página por rol
- Verificación automática de acceso en todas las solicitudes de página
- Métodos auxiliares para validación de roles

**Métodos Principales:**
```php
RoleMiddleware::checkAccess($page)          // Verificar y aplicar control de acceso
RoleMiddleware::hasAccess($page)            // Verificar si usuario actual puede acceder a página
RoleMiddleware::isLoggedIn()                // Verificar si usuario está autenticado
RoleMiddleware::getUserRole()               // Obtener rol del usuario actual
RoleMiddleware::getAccessiblePages()        // Obtener todas las páginas accesibles para usuario
```

### 2. **src/utilities/Security.php** (ACTUALIZADO)
Utilidad auxiliar para verificación de roles en controladores y vistas.

**Métodos Principales:**
```php
Security::isDirector()                      // Verificar si usuario es director
Security::isMaestro()                       // Verificar si usuario es maestro
Security::isEstudiante()                    // Verificar si usuario es estudiante
Security::hasRole($role)                    // Verificar rol específico
Security::hasAnyRole($roles)                // Verificar si usuario tiene alguno de los roles en array
Security::hasPageAccess($page)              // Verificar acceso a página
Security::getUsername()                     // Obtener nombre del usuario
Security::getUserEmail()                    // Obtener correo del usuario
```

### 3. **src/utilities/Site.php** (ACTUALIZADO)
Gestión de navegación y menú basada en roles de usuario.

**Métodos Principales:**
```php
Site::getMenuItems()                        // Obtener elementos de menú para usuario actual
Site::getNavigationHTML()                   // Obtener HTML completo de navegación
Site::isPageInMenu($page)                   // Verificar si página está en menú del usuario
Site::getRoleDisplayName($role)             // Obtener nombre mostrado para rol
Site::getAllRoles()                         // Obtener todos los roles disponibles
```

### 4. **src/views/components/sidebar.php** (NUEVO)
Componente de barra lateral reutilizable para navegación basada en roles.

**Uso en plantillas:**
```php
<?php 
$currentPage = 'estudiantes'; 
include __DIR__ . "/../../components/sidebar.php"; 
?>
```

### 5. **index.php** (ACTUALIZADO)
- Integración de RoleMiddleware para control de acceso
- Verificaciones automáticas de acceso en páginas protegidas
- Ruta de página de panel de control agregada
- Filtrado de páginas basado en roles integrado

### 6. **src/views/templates/home.view.tpl** (ACTUALIZADO)
- Menú de navegación dinámico basado en rol del usuario
- Tarjetas de panel de control específicas para cada rol
- Visualización de información de usuario (nombre de usuario y rol)
- Contenido diferente para Directores, Maestros y Estudiantes

### 7. **src/views/templates/dashboard/dashboard.view.tpl** (ACTUALIZADO)
- Panel de control mejorado con información de rol
- Enlaces de acceso rápido a páginas accesibles
- Información de perfil del usuario
- Visualización de distintivo de rol

### 8. **DOCUMENTACION_RBAC.md** (NUEVO)
Documentación completa del sistema RBAC.

## Configuración de Control de Acceso

### Páginas y Permisos

**Director (Acceso Total):**
```
home, dashboard, logout, estudiantes, maestros, 
materias, calificaciones, reportes, usuarios, matriculas
```

**Maestro (Profesor):**
```
home, dashboard, logout, materias, calificaciones, reportes
```

**Estudiante:**
```
home, dashboard, logout, materias, calificaciones
```

Ver [RoleMiddleware.php](src/utilities/RoleMiddleware.php) para la configuración completa en el array `$rolePermissions`.

## Cómo Funciona

### Flujo de Autenticación
1. El usuario inicia sesión con correo y contraseña
2. El sistema valida credenciales y almacena rol en sesión
3. `$_SESSION['rol']` contiene nombre de rol (director, maestro, o estudiante)

### Flujo de Control de Acceso
1. El usuario solicita una página (ej: `index.php?page=usuarios`)
2. `index.php` llama a `RoleMiddleware::checkAccess($page)` para todas las páginas no de autenticación
3. El middleware verifica si el rol del usuario está en los roles permitidos para esa página
4. Si está autorizado → la página se carga normalmente
5. Si no está autorizado → el usuario es redirigido a inicio o login

## Datos de Sesión
```php
$_SESSION['usuario']  // Nombre completo del usuario
$_SESSION['correo']   // Correo electrónico del usuario
$_SESSION['rol']      // Rol del usuario (director, maestro, o estudiante)
```

## Ejemplos de Uso

### En Controladores

```php
<?php
namespace Controllers;

require_once __DIR__ . "/../utilities/Security.php";

class UsuariosController
{
    public static function listar()
    {
        // Requerir inicio de sesión
        \Utilities\Security::requireLogin();
        
        // Solo directores pueden gestionar usuarios
        if (!\Utilities\Security::isDirector()) {
            echo "<script>alert('Solo directores pueden acceder'); 
                  window.location='index.php?page=home';</script>";
            exit();
        }
        
        // Lógica del controlador aquí
    }
}
?>
```

### En Vistas/Plantillas

```php
<?php
require_once __DIR__ . "/../../utilities/Security.php";
require_once __DIR__ . "/../../utilities/Site.php";
?>

<!-- Mostrar contenido solo a directores -->
<?php if (\Utilities\Security::isDirector()): ?>
    <div class="admin-section">
        <!-- Contenido solo para director -->
    </div>
<?php endif; ?>

<!-- Contenido diferente para cada rol -->
<?php switch(\Utilities\Security::getUserRole()): 
    case 'director': ?>
        <!-- Contenido director -->
    <?php break;
    case 'maestro': ?>
        <!-- Contenido maestro -->
    <?php break;
    case 'estudiante': ?>
        <!-- Contenido estudiante -->
    <?php break;
endswitch; ?>

<!-- Incluir barra lateral consciente de roles -->
<?php 
$currentPage = 'miPagina'; 
include __DIR__ . "/../../components/sidebar.php"; 
?>
```

### Verificar Acceso a Página Específica

```php
<?php
require_once __DIR__ . "/src/utilities/Security.php";

// Redirigir si el usuario no puede acceder a la página
if (!\Utilities\Security::hasPageAccess('usuarios')) {
    header("Location: index.php?page=home");
    exit();
}
?>
```

## Integración con Plantillas Existentes

### Opción 1: Usar Componente de Barra Lateral Precompilado (Recomendado)
Reemplaza barra lateral codificada con:
```php
<?php 
$currentPage = 'estudiantes'; // Establecer a página actual
include __DIR__ . "/../../components/sidebar.php"; 
?>
```

### Opción 2: Migración Gradual
Usa los métodos de utilidad proporcionados en plantillas existentes sin reemplazar barra lateral:
```php
<?php if (\Utilities\Security::isDirector()): ?>
    <a href="index.php?page=usuarios">Gestión de Usuarios</a>
<?php endif; ?>
```

### Opción 3: Usar Generador de HTML de Navegación
Para plantillas más simples:
```php
<?php
require_once __DIR__ . "/../../utilities/Site.php";
echo \Utilities\Site::getNavigationHTML();
?>
```

## Gestión de Sesiones

### Variables de Sesión
```php
$_SESSION['usuario']   // Nombre completo del usuario
$_SESSION['correo']    // Correo electrónico del usuario
$_SESSION['rol']       // Rol del usuario (director, maestro, estudiante)
```

### Verificación de Sesión
```php
<?php
require_once __DIR__ . "/src/utilities/Security.php";

// Verificar si está iniciado sesión
if (!\Utilities\Security::isLoggedIn()) {
    header("Location: index.php?page=login");
    exit();
}

// Obtener datos de sesión
$usuario = \Utilities\Security::getUsername();
$correo = \Utilities\Security::getUserEmail();
$rol = \Utilities\Security::getUserRole();
?>
```

## Agregar Nuevas Páginas con Protección de Rol

### Paso 1: Agregar Ruta en index.php
```php
case "minuevapagina":
    require_once __DIR__ . "/src/views/templates/minuevapagina.view.tpl";
    break;
```

### Paso 2: Definir Permisos en RoleMiddleware.php
```php
private static $rolePermissions = [
    // ... entradas existentes ...
    'minuevapagina' => ['director', 'maestro'], // Solo directores y maestros
];
```

### Paso 3: (Opcional) Agregar al Menú en Site.php
```php
private static $menuByRole = [
    'director' => [
        // ... elementos existentes ...
        ['label' => 'Mi Página', 'page' => 'minuevapagina', 'icon' => 'star'],
    ],
    'maestro' => [
        // ... elementos existentes ...
        ['label' => 'Mi Página', 'page' => 'minuevapagina', 'icon' => 'star'],
    ],
];
```

¡El control de acceso funcionará automáticamente!

## Modificar Permisos

Para cambiar qué roles pueden acceder a una página:
1. Abre [src/utilities/RoleMiddleware.php](src/utilities/RoleMiddleware.php)
2. Busca la página en el array `$rolePermissions`
3. Agrega/elimina nombres de roles del array
4. Guarda - los cambios tienen efecto inmediatamente

Ejemplo:
```php
// Antes: solo directores
'reportes' => ['director'],

// Después: directores y maestros
'reportes' => ['director', 'maestro'],
```

## Requisitos de Base de Datos

El sistema espera estas tablas de base de datos:

### Tabla usuarios
- `id_usuario` - Clave primaria
- `nombre` - Nombre completo del usuario
- `correo` - Correo (único)
- `password` - Contraseña cifrada
- `id_rol` - Clave externa a tabla roles
- `estado` - Estado (activo/inactivo)
- `fecha_creacion` - Timestamp de creación

### Tabla roles
- `id_rol` - Clave primaria
- `nombre_rol` - Nombre de rol (director, maestro, estudiante)

Roles actuales en base de datos:
```sql
SELECT * FROM roles;
-- Resultados:
-- (1, 'director')
-- (2, 'maestro')
-- (3, 'estudiante')
```

## Prueba

### Credenciales de Prueba (desde base de datos)

1. **Cuenta Director**
   - Correo: joseguillermorosa200519@gmail.com
   - Rol: director
   - Puede acceder a: Todas las páginas y módulos

2. **Cuenta Maestro**
   - Correo: juanperez@gmail.com
   - Rol: maestro
   - Puede acceder a: Inicio, Panel de Control, Materias, Calificaciones, Reportes

3. **Cuenta Estudiante**
   - Correo: davidjasiel11@icloud.com
   - Rol: estudiante
   - Puede acceder a: Inicio, Panel de Control, Materias, Calificaciones

### Pasos de Prueba
1. Inicia sesión con cuenta director → verifica que aparezcan todos los elementos de menú
2. Inicia sesión con cuenta maestro → verifica que aparezcan elementos limitados
3. Inicia sesión con cuenta estudiante → verifica que aparezcan elementos mínimos
4. Intenta acceder a páginas restringidas directamente vía URL → verifica redirección
5. Verifica que la barra lateral muestre información correcta del usuario y rol

## Solución de Problemas

### Problema: El usuario puede acceder a página restringida
**Solución:** Verifica `RoleMiddleware.php` para permisos de página y verifica rol de usuario en base de datos.

### Problema: Elementos de menú no aparecen
**Solución:** Verifica configuración de `Site.php` e incluye combinación de rol y página.

### Problema: Redirección a login en página permitida
**Solución:** Verifica que `$_SESSION['rol']` esté siendo establecido correctamente en controlador de login.

### Problema: Componente de barra lateral no carga
**Solución:** Verifica ruta de inclusión y que Security.php y Site.php sean accesibles.

## Consideraciones de Seguridad

1. **Validación del Lado del Servidor**: El control de acceso se aplica del lado del servidor en `index.php`
2. **Validación de Sesión**: Siempre verifica que la sesión exista antes de acceder a datos
3. **Doble Verificación**: Los controladores pueden realizar verificaciones de rol adicionales
4. **Cifrado de Contraseña**: Usa `password_hash()` de PHP con PASSWORD_DEFAULT
5. **Sanitización de Entrada**: Usa `htmlspecialchars()` al mostrar datos del usuario
6. **Protección CSRF**: Considera agregar tokens CSRF para operaciones que modifican estado

## Consideraciones de Rendimiento

- Las verificaciones de control de acceso son mínimas (búsqueda de array) - sin consultas a base de datos
- Los permisos de rol se definen en código (rápido) no en base de datos (más lento)
- La generación de menú ocurre por solicitud pero es muy eficiente

## Mejoras Futuras

1. Control basado en permisos en lugar de basado en roles (más granular)
2. Panel de administración para gestionar roles y permisos
3. Registro de auditoría para intentos de acceso
4. Gestión de expiración/programación de roles
5. Seguimiento de actividad del usuario
6. Autenticación de dos factores (2FA)

## Soporte y Preguntas

Para documentación detallada de API, ver [DOCUMENTACION_RBAC.md](DOCUMENTACION_RBAC.md).
