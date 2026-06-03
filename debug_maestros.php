<?php
// Conectar a la base de datos
$envPath = __DIR__ . "/parameters.env";
$env = parse_ini_file($envPath);

try {
    $pdo = new PDO(
        "mysql:host={$env['DB_SERVER']};dbname={$env['DB_DATABASE']};port={$env['DB_PORT']};charset=utf8",
        $env['DB_USER'],
        $env['DB_PSWD'],
        [
            PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_EMULATE_PREPARES => true,
            PDO::ATTR_PERSISTENT => false
        ]
    );

    echo "<h2>Usuarios con rol maestro:</h2>";
    $stmt = $pdo->query("
        SELECT u.id_usuario, u.nombre, u.estado, r.nombre_rol 
        FROM usuarios u 
        INNER JOIN roles r ON u.id_rol = r.id_rol 
        WHERE r.nombre_rol = 'maestro'
    ");
    $usuarios = $stmt->fetchAll(PDO::FETCH_ASSOC);
    echo "<pre>";
    print_r($usuarios);
    echo "</pre>";

    echo "<h2>Maestros en la tabla maestros:</h2>";
    $stmt2 = $pdo->query("
        SELECT ma.id_maestro, ma.id_usuario, ma.codigo, ma.especialidad, 
               u.nombre, u.estado
        FROM maestros ma 
        LEFT JOIN usuarios u ON ma.id_usuario = u.id_usuario
    ");
    $maestros = $stmt2->fetchAll(PDO::FETCH_ASSOC);
    echo "<pre>";
    print_r($maestros);
    echo "</pre>";

    echo "<h2>Maestros disponibles (query del selector):</h2>";
    $stmt3 = $pdo->query("
        SELECT ma.id_maestro, u.nombre FROM maestros ma 
        INNER JOIN usuarios u ON ma.id_usuario = u.id_usuario 
        WHERE u.estado = 'activo' ORDER BY u.nombre ASC
    ");
    $disponibles = $stmt3->fetchAll(PDO::FETCH_ASSOC);
    echo "<pre>";
    print_r($disponibles);
    echo "</pre>";

} catch (Exception $ex) {
    echo "❌ Error: " . $ex->getMessage();
}
?>
