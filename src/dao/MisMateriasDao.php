<?php

namespace Dao;

require_once __DIR__ . "/Dao.php";
require_once __DIR__ . "/Table.php";

class MisMateriasDao extends Table
{
    public static function obtenerEstudiantePorCorreo($correo)
    {
        $sqlstr = "SELECT e.id_estudiante, u.nombre, u.correo
                   FROM estudiantes e
                   INNER JOIN usuarios u ON e.id_usuario = u.id_usuario
                   WHERE u.correo = :correo";

        return self::obtenerUnRegistro($sqlstr, ["correo" => $correo]);
    }

    public static function obtenerMateriasInscritas($idEstudiante)
    {
        $sqlstr = "SELECT 
                    mt.id_matricula,
                    m.id_materia,
                    m.codigo,
                    m.nombre,
                    m.descripcion,
                    mt.periodo,
                    mt.estado
                   FROM matriculas mt
                   INNER JOIN materias m ON mt.id_materia = m.id_materia
                   WHERE mt.id_estudiante = :id_estudiante
                   ORDER BY mt.id_matricula DESC";

        return self::obtenerRegistros($sqlstr, ["id_estudiante" => $idEstudiante]);
    }

    public static function obtenerMateriasDisponibles($idEstudiante)
    {
        $sqlstr = "SELECT id_materia, codigo, nombre, descripcion, estado
                   FROM materias
                   WHERE estado = 'activa'
                   AND id_materia NOT IN (
                       SELECT id_materia
                       FROM matriculas
                       WHERE id_estudiante = :id_estudiante
                       AND estado = 'activa'
                   )
                   ORDER BY nombre";

        return self::obtenerRegistros($sqlstr, ["id_estudiante" => $idEstudiante]);
    }

    public static function inscribirMateria($idEstudiante, $idMateria)
    {
        $sqlstr = "INSERT INTO matriculas (id_estudiante, id_materia, periodo, estado)
                   VALUES (:id_estudiante, :id_materia, '2026-II', 'activa')";

        return self::executeNonQuery($sqlstr, [
            "id_estudiante" => $idEstudiante,
            "id_materia" => $idMateria
        ]);
    }

    public static function eliminarMateria($idMatricula, $idEstudiante)
    {
        $sqlstr = "DELETE FROM matriculas
                   WHERE id_matricula = :id_matricula
                   AND id_estudiante = :id_estudiante";

        return self::executeNonQuery($sqlstr, [
            "id_matricula" => $idMatricula,
            "id_estudiante" => $idEstudiante
        ]);
    }
}
?>