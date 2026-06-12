<?php

namespace Utilities;

class RoleMiddleware
{
    public static function checkAccess($page)
    {
        if (session_status() === PHP_SESSION_NONE) {
            session_start();
        }

        $paginasPublicas = array("login", "register", "logout");

        if (in_array($page, $paginasPublicas)) {
            return true;
        }

        if (!isset($_SESSION["usuario"])) {
            header("Location: index.php?page=login");
            exit();
        }

        $rol = $_SESSION["rol"] ?? "";

        $permisos = array(
            "director" => array(
    "home",
    "dashboard",

    "estudiantes",
    "estudiante_nuevo",
    "estudiante_guardar",
    "estudiante_editar",
    "estudiante_eliminar",

    "maestros",
    "maestro_nuevo",
    "maestro_guardar",
    "maestro_editar",
    "maestro_eliminar",

    "materias",
    "materia_nueva",
    "materia_guardar",
    "materia_editar",
    "materia_eliminar",

    "matriculas",
    "matricula_nueva",
    "matricula_guardar",
    "matricula_editar",
    "matricula_eliminar",

    "calificaciones",
    "calificacion_nueva",
    "calificacion_guardar",
    "calificacion_editar",
    "calificacion_eliminar",

    "reportes",

    "usuarios",
    "usuario_nuevo",
    "usuario_guardar",
    "usuario_editar",
    "usuario_eliminar",

    "mis_materias",
    "logout"
),
            "maestro" => array(
    "home",
    "dashboard",

    "materias",
    "materia_ver",

    "matriculas",

    "calificaciones",
    "calificacion_nueva",
    "calificacion_editar",

    "reportes",

    "logout"
),
            "estudiante" => array(
    "home",
    "dashboard",

    "materias",
    "mis_materias",

    "matriculas_nueva",
    

    "calificaciones",

    "logout"
),
        );

        if (!isset($permisos[$rol])) {
            header("Location: index.php?page=login");
            exit();
        }

        if (!in_array($page, $permisos[$rol])) {
            echo "<script>
                    alert('No tiene permiso para acceder a esta sección');
                    window.location='index.php?page=home';
                  </script>";
            exit();
        }

        return true;
    }
}
?>