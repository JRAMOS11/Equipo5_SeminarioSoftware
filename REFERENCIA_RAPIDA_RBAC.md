# Referencia Rápida RBAC

## Descripción General de Archivos Clave

| Archivo | Propósito | Métodos Clave |
|---------|-----------|--------------|
| `src/utilities/RoleMiddleware.php` | Motor de control de acceso | `checkAccess()`, `hasAccess()`, `isLoggedIn()` |
| `src/utilities/Security.php` | Auxiliares de verificación de roles | `isDirector()`, `isMaestro()`, `isEstudiante()`, `hasRole()` |
| `src/utilities/Site.php` | Gestión de navegación | `getMenuItems()`, `getNavigationHTML()`, `getRoleDisplayName()` |
| `src/views/components/sidebar.php` | Componente reutilizable de barra lateral | Incluir en plantillas |
| `index.php` | Manejo de rutas | Control de acceso integrado |
| `src/views/templates/home.view.tpl` | Página de inicio | Navegación y contenido consciente de roles |
| `src/views/templates/dashboard/dashboard.view.tpl` | Panel de control | Información del usuario y enlaces rápidos |

## Matriz de Permisos por Rol

| Página | Director | Maestro | Estudiante |
|--------|----------|---------|-----------|
| home | ✅ | ✅ | ✅ |
| dashboard | ✅ | ✅ | ✅ |
| estudiantes | ✅ | ❌ | ❌ |
| maestros | ✅ | ❌ | ❌ |
| materias | ✅ | ✅ | ✅ |
| calificaciones | ✅ | ✅ | ✅ |
| reportes | ✅ | ✅ | ❌ |
| usuarios | ✅ | ❌ | ❌ |
| matriculas | ✅ | ❌ | ❌ |

## Fragmentos de Código Comunes

### Verificar Rol de Usuario en Vista
```php
<?php require_once __DIR__ . "/../../utilities/Security.php"; ?>
<?php if (\Utilities\Security::isDirector()): ?>
    <!-- Contenido solo para director -->
<?php endif; ?>
```

### Verificar Acceso a Página
```php
require_once __DIR__ . "/src/utilities/Security.php";
if (!\Utilities\Security::hasPageAccess('usuarios')) {
    header("Location: index.php?page=home");
    exit();
}
```

### Obtener Información del Usuario Actual
```php
require_once __DIR__ . "/src/utilities/Security.php";
$nombre = \Utilities\Security::getUsername();
$correo = \Utilities\Security::getUserEmail();
$rol = \Utilities\Security::getUserRole();
```

### Incluir Barra Lateral en Plantilla
```php
<?php 
$currentPage = 'estudiantes'; 
include __DIR__ . "/../../components/sidebar.php"; 
?>
```

## Lista de Verificación de Prueba

- [ ] Inicia sesión como director - verifica acceso completo
- [ ] Inicia sesión como maestro - verifica acceso limitado
- [ ] Inicia sesión como estudiante - verifica acceso mínimo
- [ ] Intenta acceder a página restringida directamente - verifica redirección
- [ ] Verifica que los elementos del menú se muestren correctamente por rol
- [ ] Verifica que el panel de control muestre enlaces rápidos apropiados para el rol
- [ ] Prueba cerrar sesión desde todas las páginas
- [ ] Prueba página de inicio muestra tarjetas específicas del rol

## Lista de Verificación de Solución de Problemas

- [ ] Usuario no autenticado - verifica variables de sesión en index.php
- [ ] Rol incorrecto - verifica valor de id_rol del usuario en base de datos
- [ ] No puede acceder a página permitida - verifica permisos de RoleMiddleware.php
- [ ] Faltan elementos de menú - verifica configuración de Site.php
- [ ] Barra lateral no carga - verifica ruta de inclusión y que los archivos existan

## Comandos de Base de Datos

### Ver Roles Actuales
```sql
SELECT * FROM roles;
```

### Ver Roles de Usuarios
```sql
SELECT id_usuario, nombre, correo, r.nombre_rol 
FROM usuarios u 
JOIN roles r ON u.id_rol = r.id_rol;
```

### Actualizar Rol de Usuario
```sql
UPDATE usuarios SET id_rol = 1 WHERE id_usuario = 5; -- Establecer como director
UPDATE usuarios SET id_rol = 2 WHERE id_usuario = 5; -- Establecer como maestro
UPDATE usuarios SET id_rol = 3 WHERE id_usuario = 5; -- Establecer como estudiante
```

## Notas Importantes

1. **El control de acceso se aplica al nivel de index.php** - Todas las solicitudes de página se verifican antes de que se carguen las plantillas
2. **Las sesiones deben estar activas** - El usuario debe tener $_SESSION['rol'] establecido (hecho por login)
3. **Los roles distinguen mayúsculas y minúsculas** - Usa minúsculas: 'director', 'maestro', 'estudiante'
4. **La configuración de menú debe coincidir con los permisos** - Actualiza tanto RoleMiddleware como Site si agregas nuevas páginas
5. **Las plantillas existentes pueden usar utilidades** - No es necesario reescribir todo, solo agrega verificaciones de rol donde sea necesario

## Navegación Rápida

- 📖 [Documentación Completa](DOCUMENTACION_RBAC.md)
- 🔧 [Guía de Integración](GUIA_INTEGRACION_RBAC.md)
- 🎯 [Código Fuente RoleMiddleware](src/utilities/RoleMiddleware.php)
- 🛡️ [Utilidades de Seguridad](src/utilities/Security.php)
- 🎨 [Navegación del Sitio](src/utilities/Site.php)
- 📦 [Componente Barra Lateral](src/views/components/sidebar.php)

## Usuarios de Prueba

```
Director:
  Correo: joseguillermorosa200519@gmail.com
  
Maestro:
  Correo: juanperez@gmail.com
  
Estudiante:
  Correo: davidjasiel11@icloud.com
```

## Métodos de Rol Frecuentes

```php
\Utilities\Security::isDirector()      // Es director?
\Utilities\Security::isMaestro()       // Es maestro?
\Utilities\Security::isEstudiante()    // Es estudiante?
\Utilities\Security::hasRole('director') // Tiene rol específico?
\Utilities\Security::getUsername()     // Obtener nombre
\Utilities\Security::getUserEmail()    // Obtener correo
\Utilities\Security::getUserRole()     // Obtener rol
```

## Variables de Sesión Clave

```php
$_SESSION['usuario']   // Nombre del usuario
$_SESSION['correo']    // Correo del usuario
$_SESSION['rol']       // Rol (director, maestro, estudiante)
```

## Cambios Rápidos

### Agregar Nueva Página Protegida
1. Agregar caso en `index.php`
2. Agregar permisos en `RoleMiddleware.php`
3. (Opcional) Agregar al menú en `Site.php`

### Cambiar Permisos de Página
1. Abre `RoleMiddleware.php`
2. Encuentra página en `$rolePermissions`
3. Agrega/elimina nombres de rol

### Crear Nueva Plantilla
1. Crear archivo en `src/views/templates/`
2. Incluir utilidades de seguridad
3. Usar componente sidebar: `<?php $currentPage = 'x'; include '../../components/sidebar.php'; ?>`
