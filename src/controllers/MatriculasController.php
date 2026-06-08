<?php

namespace Controllers;

require_once __DIR__ . '/../dao/MatriculaDao.php';

use Dao\MatriculaDao;

class MatriculasController
{
    public static function listar()
    {
        return MatriculaDao::listarMatriculas();
    }

    public static function obtener($id)
    {
        return MatriculaDao::obtenerMatricula($id);
    }

    public static function crear(
        $id_estudiante,
        $id_materia,
        $periodo
    ) {
        return MatriculaDao::registrarMatricula(
            $id_estudiante,
            $id_materia,
            $periodo
        );
    }

    public static function actualizar(
        $id,
        $id_estudiante,
        $id_materia,
        $periodo,
        $estado
    ) {
        return MatriculaDao::actualizarMatricula(
            $id,
            $id_estudiante,
            $id_materia,
            $periodo,
            $estado
        );
    }

    public static function eliminar($id)
    {
        return MatriculaDao::eliminarMatricula($id);
    }

    public static function obtenerEstudiantes()
    {
        return MatriculaDao::obtenerEstudiantes();
    }

    public static function obtenerMaterias()
    {
        return MatriculaDao::obtenerMaterias();
    }
}