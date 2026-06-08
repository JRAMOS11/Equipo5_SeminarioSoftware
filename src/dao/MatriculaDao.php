<?php

namespace Dao;

require_once __DIR__ . "/Dao.php";
require_once __DIR__ . "/Table.php";

class MatriculaDao extends Table
{
    public static function listarMatriculas()
    {
        $sqlstr = "SELECT
                        m.*,
                        u.nombre AS estudiante_nombre,
                        mat.nombre AS materia_nombre
                   FROM matriculas m
                   INNER JOIN estudiantes e
                        ON m.id_estudiante = e.id_estudiante
                   INNER JOIN usuarios u
                        ON e.id_usuario = u.id_usuario
                   INNER JOIN materias mat
                        ON m.id_materia = mat.id_materia
                   ORDER BY m.id_matricula DESC";

        return self::obtenerRegistros($sqlstr);
    }

    public static function obtenerMatricula($id)
    {
        $sqlstr = "SELECT *
                   FROM matriculas
                   WHERE id_matricula = :id";

        return self::obtenerUnRegistro(
            $sqlstr,
            ["id" => $id]
        );
    }

    public static function registrarMatricula(
        $id_estudiante,
        $id_materia,
        $periodo,
        $estado = "activa"
    ) {
        $sqlstr = "INSERT INTO matriculas
                    (
                        id_estudiante,
                        id_materia,
                        periodo,
                        estado
                    )
                    VALUES
                    (
                        :id_estudiante,
                        :id_materia,
                        :periodo,
                        :estado
                    )";

        return self::executeNonQuery(
            $sqlstr,
            [
                "id_estudiante" => $id_estudiante,
                "id_materia" => $id_materia,
                "periodo" => $periodo,
                "estado" => $estado
            ]
        );
    }

    public static function actualizarMatricula(
        $id,
        $id_estudiante,
        $id_materia,
        $periodo,
        $estado
    ) {
        $sqlstr = "UPDATE matriculas
                   SET
                        id_estudiante = :id_estudiante,
                        id_materia = :id_materia,
                        periodo = :periodo,
                        estado = :estado
                   WHERE id_matricula = :id";

        return self::executeNonQuery(
            $sqlstr,
            [
                "id" => $id,
                "id_estudiante" => $id_estudiante,
                "id_materia" => $id_materia,
                "periodo" => $periodo,
                "estado" => $estado
            ]
        );
    }

    public static function eliminarMatricula($id)
    {
        $sqlstr = "DELETE FROM matriculas
                   WHERE id_matricula = :id";

        return self::executeNonQuery(
            $sqlstr,
            ["id" => $id]
        );
    }

    public static function obtenerEstudiantes()
    {
        $sqlstr = "SELECT
                        e.id_estudiante,
                        u.nombre
                   FROM estudiantes e
                   INNER JOIN usuarios u
                        ON e.id_usuario = u.id_usuario
                   ORDER BY u.nombre";

        return self::obtenerRegistros($sqlstr);
    }

    public static function obtenerMaterias()
    {
        $sqlstr = "SELECT
                        id_materia,
                        nombre
                   FROM materias
                   ORDER BY nombre";

        return self::obtenerRegistros($sqlstr);
    }
}