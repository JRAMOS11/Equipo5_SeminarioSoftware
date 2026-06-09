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
    "maestros",
    "maestro_nuevo",
    "materias",
    "materia_nueva",
    "matriculas",
    "matricula_nueva",
    "matricula_editar",
    "calificaciones",
    "reportes",
    "usuarios",
    "usuario_nuevo",
    "usuario_editar",
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

    "matriculas",

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