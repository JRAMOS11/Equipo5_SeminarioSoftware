# Control de Acceso Basado en Roles (RBAC) - Documentación Completa

## Descripción General
Este sistema implementa control de acceso basado en roles en todo el sistema de gestión académica. Se definen tres roles: Director, Maestro y Estudiante.

## Roles y Permisos

### Director (Acceso Total) 🔓
**Puede acceder a:**
- Inicio
- Panel de Control
- Estudiantes (Gestión de Estudiantes)
- Maestros (Gestión de Maestros)
- Materias (Gestión de Materias)
- Calificaciones (Gestión de Calificaciones)
- Reportes (Informes)
- Usuarios (Gestión de Usuarios)

### Maestro/Profesor (Acceso Limitado) 📚
**Puede acceder a:**
- Inicio
- Panel de Control
- Materias (Ver/Gestionar Materias)
- Calificaciones (Ver/Registrar Calificaciones)
- Reportes (Ver Reportes)

**No puede acceder a:**
- Usuarios (Gestión de Usuarios)
- Maestros (Gestión de Maestros)
- Estudiantes (Gestión de Estudiantes)

### Estudiante (Acceso Mínimo) 👨‍🎓
**Puede acceder a:**
- Inicio
- Panel de Control
- Materias (Ver Materias)
- Calificaciones (Ver Calificaciones)

**No puede acceder a:**
- Usuarios (Gestión de Usuarios)
- Maestros (Gestión de Maestros)
- Estudiantes (Gestión de Estudiantes)
- Reportes (Informes)

## Detalles de Implementación

### Archivos Modificados/Creados

1. **src/utilities/RoleMiddleware.php** (NUEVO)
   - Define permisos de rol para todas las páginas
   - Verifica autorización del usuario antes de acceder a páginas
   - Proporciona métodos auxiliares para verificación de roles

2. **src/utilities/Security.php** (ACTUALIZADO)
   - Métodos auxiliares para verificar roles de usuario y autenticación
   - Métodos: `isDirector()`, `isMaestro()`, `isEstudiante()`
   - Métodos de control de acceso: `hasRole()`, `hasAnyRole()`, `hasPageAccess()`

3. **src/utilities/Site.php** (ACTUALIZADO)
   - Gestión de menú de navegación basada en roles
   - Visualización de elementos de menú basada en permisos
   - Métodos auxiliares para nombres de rol mostrados

4. **index.php** (ACTUALIZADO)
   - Integración de RoleMiddleware para control de acceso
   - Verificaciones de acceso en todas las páginas protegidas
   - Adición de ruta de página de panel de control

## Ejemplos de Uso

### En Controladores
```php
<?php
namespace Controllers;

require_once __DIR__ . "/../utilities/Security.php";

class MiControlador
{
    public function miAccion()
    {
        // Verificar si el usuario está autenticado
        \Utilities\Security::requireLogin();
        
        // Verificar si el usuario es un Director
        if (!\Utilities\Security::isDirector()) {
            echo "<script>alert('Solo directores pueden acceder'); window.location='index.php?page=home';</script>";
            exit();
        }
        
        // ... resto del código de la acción
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

<!-- Mostrar contenido solo para Directores -->
<?php if (\Utilities\Security::isDirector()): ?>
    <div>Contenido solo para directores</div>
<?php endif; ?>

<!-- Mostrar contenido diferente para diferentes roles -->
<?php if (\Utilities\Security::isMaestro()): ?>
    <div>Contenido específico para maestros</div>
<?php elseif (\Utilities\Security::isEstudiante()): ?>
    <div>Contenido específico para estudiantes</div>
<?php endif; ?>

<!-- Mostrar menú -->
<?php echo \Utilities\Site::getNavigationHTML(); ?>
```

### En Otros Archivos PHP
```php
<?php
require_once __DIR__ . "/src/utilities/Security.php";

// Verificar acceso a una página específica
if (!\Utilities\Security::hasPageAccess('usuarios')) {
    // Redirigir o denegar acceso
}

// Obtener información del usuario actual
$nombre = \Utilities\Security::getUsername();
$correo = \Utilities\Security::getUserEmail();
$rol = \Utilities\Security::getUserRole();
```

## Cómo Funciona

### Flujo de Control de Acceso
1. El usuario solicita una página (ej: `index.php?page=usuarios`)
2. `index.php` llama a `RoleMiddleware::checkAccess($page)` para todas las páginas no de autenticación
3. El middleware verifica si el rol del usuario está en los roles permitidos para esa página
4. Si está autorizado → la página se carga normalmente
5. Si no está autorizado → el usuario es redirigido a inicio o login

### Datos de Sesión
```php
$_SESSION['usuario']  // Nombre completo del usuario
$_SESSION['correo']   // Correo electrónico del usuario
$_SESSION['rol']      // Rol del usuario (director, maestro, o estudiante)
```

## Métodos Disponibles

### RoleMiddleware
- `isLoggedIn()` - Verificar si el usuario está autenticado
- `getUserRole()` - Obtener el rol del usuario actual
- `hasAccess($page)` - Verificar si el usuario puede acceder a una página
- `checkAccess($page)` - Redirigir si el acceso es denegado
- `getAccessiblePages()` - Obtener todas las páginas accesibles para el usuario

### Security
- `isLoggedIn()` - Verificar autenticación
- `getUserRole()` - Obtener rol del usuario
- `getUsername()` - Obtener nombre del usuario
- `getUserEmail()` - Obtener correo del usuario
- `hasRole($role)` - Verificar rol específico
- `hasAnyRole($roles)` - Verificar si el usuario tiene alguno de los roles en el array
- `hasPageAccess($page)` - Verificar acceso a página
- `requireLogin()` - Redirigir si no está autenticado
- `requireRole($role)` - Redirigir si no tiene el rol
- `isDirector()` - Verificar si el usuario es director
- `isMaestro()` - Verificar si el usuario es maestro
- `isEstudiante()` - Verificar si el usuario es estudiante

### Site
- `getMenuItems()` - Obtener menú para usuario actual
- `isPageInMenu($page)` - Verificar si página está en menú
- `getMenuLabel($page)` - Obtener etiqueta de menú para página
- `getNavigationHTML()` - Obtener HTML de navegación
- `getRoleDisplayName($role)` - Obtener nombre mostrado para rol
- `getAllRoles()` - Obtener todos los roles disponibles

## Requisitos de Base de Datos

El sistema espera la siguiente estructura de base de datos:

### Tabla usuarios
```sql
CREATE TABLE usuarios (
  id_usuario INT PRIMARY KEY AUTO_INCREMENT,
  nombre VARCHAR(100),
  correo VARCHAR(100),
  password VARCHAR(255),
  id_rol INT,
  estado VARCHAR(20),
  fecha_creacion TIMESTAMP,
  FOREIGN KEY (id_rol) REFERENCES roles(id_rol)
);
```

### Tabla roles
```sql
CREATE TABLE roles (
  id_rol INT PRIMARY KEY AUTO_INCREMENT,
  nombre_rol VARCHAR(50)
);

-- Roles:
INSERT INTO roles (nombre_rol) VALUES ('director');
INSERT INTO roles (nombre_rol) VALUES ('maestro');
INSERT INTO roles (nombre_rol) VALUES ('estudiante');
```

## Prueba de Implementación

### Usuarios de Prueba (desde base de datos)
1. **Director**: `joseguillermorosa200519@gmail.com` (id_rol = 1)
2. **Maestro**: `juanperez@gmail.com` (id_rol = 2)
3. **Estudiante**: `davidjasiel11@icloud.com` (id_rol = 3)

### Pasos de Prueba
1. Inicia sesión como diferentes roles
2. Intenta acceder a páginas restringidas
3. Verifica que el acceso sea denegado apropiadamente
4. Comprueba que los elementos del menú aparezcan/desaparezcan según el rol
5. Verifica que los datos de sesión sean correctos

## Agregar Nuevas Páginas

Para agregar una nueva página con control de acceso basado en roles:

1. Añade el caso en `index.php`:
```php
case "minuevapagina":
    require_once __DIR__ . "/src/views/templates/minuevapagina.view.tpl";
    break;
```

2. Añade permiso en `RoleMiddleware.php`:
```php
'minuevapagina' => ['director', 'maestro'], // Solo directores y maestros pueden acceder
```

3. (Opcional) Añade al menú en `Site.php` si es necesario

4. El middleware verificará automáticamente el acceso en cada solicitud

## Modificar Permisos

Para cambiar qué roles pueden acceder a una página:
1. Edita el array `$rolePermissions` en `RoleMiddleware.php`
2. Añade o elimina nombres de roles del array de la página
3. Los cambios toman efecto inmediatamente en la siguiente solicitud

## Consideraciones de Seguridad

1. **Validación de Sesión**: Siempre verifica que la sesión exista antes de acceder a datos sensibles
2. **Doble Verificación**: Para operaciones sensibles, realiza verificaciones de autorización en controladores también
3. **Almacenamiento de Contraseña**: Usa `password_hash()` con algoritmo PASSWORD_DEFAULT
4. **Logout**: Destruye completamente la sesión al cerrar sesión
5. **Prevención de XSS**: Recuerda escapar la salida en plantillas
6. **Protección CSRF**: Considera agregar tokens CSRF para operaciones que modifican estado

## Solución de Problemas

### El usuario no puede acceder a página permitida
1. Verifica que la sesión esté activa: `var_dump($_SESSION);`
2. Verifica que el rol sea correcto: `echo $_SESSION['rol'];`
3. Verifica permiso de página en `RoleMiddleware.php`
4. Limpia el caché del navegador e intenta de nuevo

### La página redirige a login
1. Verifica que el usuario esté autenticado: `var_dump(session_status());`
2. Verifica que las variables de sesión existan
3. Verifica que el proceso de login almacene el rol correctamente

### Elementos de menú incorrectos
1. Verifica la configuración del menú en `Site.php`
2. Verifica el rol del usuario en la base de datos
3. Verifica que `getUserRole()` retorne el valor correcto
