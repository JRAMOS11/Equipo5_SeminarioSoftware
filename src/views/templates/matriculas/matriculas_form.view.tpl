<?php

require_once __DIR__ . "/../../../controllers/MatriculasController.php";

use Controllers\MatriculasController;

$estudiantes = MatriculasController::obtenerEstudiantes();
$materias = MatriculasController::obtenerMaterias();

$matricula = null;

if(isset($_GET["id"]))
{
    $matricula = MatriculasController::obtener($_GET["id"]);
}

if($_SERVER["REQUEST_METHOD"] === "POST")
{
    if(empty($_POST["id_matricula"]))
    {
        MatriculasController::crear(
            $_POST["id_estudiante"],
            $_POST["id_materia"],
            $_POST["periodo"]
        );
    }
    else
    {
        MatriculasController::actualizar(
            $_POST["id_matricula"],
            $_POST["id_estudiante"],
            $_POST["id_materia"],
            $_POST["periodo"],
            $_POST["estado"]
        );
    }

    header("Location:index.php?page=matriculas");
    exit();
}
?>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registro de Matrícula</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="public/css/style.css">
</head>

<body>

<div class="container mt-4">

    <div class="card shadow">

        <div class="card-header bg-primary text-white">
            <h4>
                <i class="bi bi-journal-check"></i>
                Registro de Matrícula
            </h4>
        </div>

        <div class="card-body">

            <form method="POST">

                <input type="hidden"
                       name="id_matricula"
                       value="<?= $matricula["id_matricula"] ?? '' ?>">

                <div class="row">

                    <div class="col-md-6 mb-3">
                        <label class="form-label">Estudiante</label>

                        <select name="id_estudiante"
                                class="form-select"
                                required>

                            <?php foreach($estudiantes as $e): ?>

                                <option value="<?= $e["id_estudiante"] ?>">
                                    <?= htmlspecialchars($e["nombre"]) ?>
                                </option>

                            <?php endforeach; ?>

                        </select>
                    </div>

                    <div class="col-md-6 mb-3">
                        <label class="form-label">Materia</label>

                        <select name="id_materia"
                                class="form-select"
                                required>

                            <?php foreach($materias as $m): ?>

                                <option value="<?= $m["id_materia"] ?>">
                                    <?= htmlspecialchars($m["nombre"]) ?>
                                </option>

                            <?php endforeach; ?>

                        </select>
                    </div>

                    <div class="col-md-6 mb-3">
                        <label class="form-label">Periodo</label>

                        <input type="text"
                               name="periodo"
                               class="form-control"
                               value="<?= $matricula["periodo"] ?? '' ?>"
                               placeholder="2025-I"
                               required>
                    </div>

                    <div class="col-md-6 mb-3">
                        <label class="form-label">Estado</label>

                        <select name="estado"
                                class="form-select">

                            <option value="activa">Activa</option>
                            <option value="cancelada">Cancelada</option>

                        </select>
                    </div>

                </div>

                <div class="mt-4">

                    <button type="submit" class="btn btn-success">
                        <i class="bi bi-save"></i>
                        Guardar Matrícula
                    </button>

                    <a href="index.php?page=matriculas"
                       class="btn btn-secondary">
                        <i class="bi bi-arrow-left"></i>
                        Regresar
                    </a>

                </div>

            </form>

        </div>

    </div>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>