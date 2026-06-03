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

    // Insertar usuario maestro
    $passwordHash = password_hash('password123', PASSWORD_DEFAULT);
    $stmtUser = $pdo->prepare("
        INSERT INTO usuarios (nombre, correo, password, id_rol, estado, fecha_creacion) 
        VALUES (:nombre, :correo, :password, :id_rol, 'activo', NOW())
    ");
    
    $stmtUser->execute([
        ':nombre' => 'Prof. Juan García',
        ':correo' => 'juan.garcia@escuela.com',
        ':password' => $passwordHash,
        ':id_rol' => 2  // maestro
    ]);
    
    $usuarioId = $pdo->lastInsertId();
    echo "✅ Usuario insertado con ID: " . $usuarioId . "\n";

    // Insertar maestro
    $stmtMaestro = $pdo->prepare("
        INSERT INTO maestros (id_usuario, codigo, especialidad, telefono) 
        VALUES (:id_usuario, :codigo, :especialidad, :telefono)
    ");
    
    $stmtMaestro->execute([
        ':id_usuario' => $usuarioId,
        ':codigo' => 'MAE-001',
        ':especialidad' => 'Matemáticas',
        ':telefono' => '99999999'
    ]);
    
    $maestroId = $pdo->lastInsertId();
    echo "✅ Maestro insertado con ID: " . $maestroId . "\n";
    echo "\n✅ Datos insertados exitosamente!\n";
    echo "Correo: juan.garcia@escuela.com\n";
    echo "Contraseña: password123\n";

} catch (Exception $ex) {
    echo "❌ Error: " . $ex->getMessage();
}
?>
