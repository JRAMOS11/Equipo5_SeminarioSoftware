-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 12-06-2026 a las 09:41:46
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `seguimiento_academico`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `calificaciones`
--

CREATE TABLE `calificaciones` (
  `id_calificacion` int(11) NOT NULL,
  `id_matricula` int(11) NOT NULL,
  `nota` decimal(5,2) NOT NULL,
  `observacion` varchar(255) DEFAULT NULL,
  `fecha_registro` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `calificaciones`
--

INSERT INTO `calificaciones` (`id_calificacion`, `id_matricula`, `nota`, `observacion`, `fecha_registro`) VALUES
(1, 1, 98.00, 'EXCELENTE', '2026-06-08 06:18:38');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `estudiantes`
--

CREATE TABLE `estudiantes` (
  `id_estudiante` int(11) NOT NULL,
  `id_usuario` int(11) NOT NULL,
  `cuenta` varchar(30) NOT NULL,
  `carrera` varchar(100) NOT NULL,
  `telefono` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `estudiantes`
--

INSERT INTO `estudiantes` (`id_estudiante`, `id_usuario`, `cuenta`, `carrera`, `telefono`) VALUES
(1, 10, '0102200202340', 'sistemas', '54678989'),
(2, 16, 'EST-016', 'Ingeniería en Sistemas', '99999999'),
(3, 17, '1111111111111', 'sistemas', '74568790');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `maestros`
--

CREATE TABLE `maestros` (
  `id_maestro` int(11) NOT NULL,
  `id_usuario` int(11) NOT NULL,
  `codigo` varchar(30) NOT NULL,
  `especialidad` varchar(100) DEFAULT NULL,
  `telefono` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `maestros`
--

INSERT INTO `maestros` (`id_maestro`, `id_usuario`, `codigo`, `especialidad`, `telefono`) VALUES
(1, 4, 'MAE-001', 'Matemáticas', '99999999'),
(4, 11, 'ECU-001', 'Ecuaciones', '87445655'),
(5, 18, 'CAL-0001', 'calculo', '76065423');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `materias`
--

CREATE TABLE `materias` (
  `id_materia` int(11) NOT NULL,
  `codigo` varchar(30) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `id_maestro` int(11) NOT NULL,
  `estado` varchar(20) DEFAULT 'activa'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `materias`
--

INSERT INTO `materias` (`id_materia`, `codigo`, `nombre`, `descripcion`, `id_maestro`, `estado`) VALUES
(2, '1', 'Matematicas', 'Ecuaciones y Operaciones combinadas ', 1, 'activa'),
(3, '2', 'Ecuaciones', 'maestro calificado', 4, 'activa'),
(84, 'INF-111', 'Programación Web', 'Materia de Ingeniería en Sistemas', 4, 'activa'),
(85, 'INF-112', 'Programación Móvil', 'Materia de Ingeniería en Sistemas', 4, 'activa'),
(86, 'INF-113', 'Base de Datos Avanzada', 'Materia de Ingeniería en Sistemas', 4, 'activa'),
(87, 'INF-114', 'Arquitectura de Computadoras', 'Materia de Ingeniería en Sistemas', 4, 'activa'),
(88, 'INF-115', 'Desarrollo de Software', 'Materia de Ingeniería en Sistemas', 4, 'activa'),
(89, 'CAL-0001', 'Calculo', 'calculo', 5, 'activa');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `matriculas`
--

CREATE TABLE `matriculas` (
  `id_matricula` int(11) NOT NULL,
  `id_estudiante` int(11) NOT NULL,
  `id_materia` int(11) NOT NULL,
  `periodo` varchar(30) NOT NULL,
  `estado` varchar(20) DEFAULT 'activa'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `matriculas`
--

INSERT INTO `matriculas` (`id_matricula`, `id_estudiante`, `id_materia`, `periodo`, `estado`) VALUES
(1, 1, 2, '2026-II', 'activa'),
(2, 1, 3, '2026-II', 'activa'),
(3, 2, 3, '2026-II', 'activa'),
(5, 2, 2, '2026-II', 'activa');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `roles`
--

CREATE TABLE `roles` (
  `id_rol` int(11) NOT NULL,
  `nombre_rol` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `roles`
--

INSERT INTO `roles` (`id_rol`, `nombre_rol`) VALUES
(1, 'director'),
(3, 'estudiante'),
(2, 'maestro');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `id_usuario` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `correo` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `id_rol` int(11) NOT NULL,
  `estado` varchar(20) DEFAULT 'activo',
  `fecha_creacion` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`id_usuario`, `nombre`, `correo`, `password`, `id_rol`, `estado`, `fecha_creacion`) VALUES
(2, 'Jasiel David Ramos', 'davidjasiel11@icloud.com', '$2y$10$XXn/J7QWsQP88j1gJHafKOEMs6xThlF1r/fW/2Qxey8mZR6XmLZ2S', 3, 'activo', '2026-06-02 18:22:18'),
(4, 'Juan Perez', 'juanperez@gmail.com', '$2y$10$83O5Ba8u7h7oVtI2oyuFl.EVih2kJulEYbgCAQN0wNiuYLlnu/ZKa', 2, 'activo', '2026-06-03 14:47:38'),
(5, 'Prof. Juan García', 'juan.garcia@escuela.com', '$2y$10$XXn/J7QWsQP88j1gJHafKOEMs6xThlF1r/fW/2Qxey8mZR6XmLZ2S', 2, 'activo', '2026-06-03 14:50:31'),
(10, 'Roberto rosales', 'roberto@gmail.com', '$2y$10$LUt.8s3.5bQioDyG/fkYPe0JvuDBEaj.SRdP26TZ3SI03PRjLFsAu', 3, 'activo', '2026-06-08 06:14:07'),
(11, 'Josue Ramos', 'joosue@gmail.com', '$2y$10$XWn4UQWHvwwlbOVr9pZYJuVmLTQuEe3gahNvH8c84A2b3nU6i3K/q', 2, 'activo', '2026-06-08 06:39:29'),
(13, 'Juan Delarca', 'delarca@gmail.com', '$2y$10$L5Mv7moO/4mBSHxacDKJP.e.TUmIhLMJmNB6eUcIn5d6pW5M64Uyu', 2, 'activo', '2026-06-09 00:23:40'),
(15, 'David Ramos', 'ramos11@gmail.com', '$2y$10$5piqcifQa3.reH5LrRSvDuTSKH/yofFh8BwViSfvuCXfXTwut6i3i', 1, 'activo', '2026-06-12 05:47:26'),
(16, 'alejandra trochez', 'alejandra11@gmail.com', '$2y$10$rI7GsL6J0as4we4BLFQC6OVRGz6Ol12dTDwff2Fc1GzKvfiiLb5ZW', 3, 'activo', '2026-06-12 06:03:59'),
(17, 'elmer carranza', 'elmer11@gmail.com', '$2y$10$6ri5qM/Sw31xr1Ib1KOjr.59uGCxImlCBuQjcsqdJ6tuup70kbz7q', 3, 'activo', '2026-06-12 07:36:42'),
(18, 'alberto perez', 'alberto11@gmail.com', '$2y$10$/.x.NqCSZEhqvN3FVLe7SugUcj7.p4XvCa3XeGQUdBMRJrg9PlYwW', 2, 'activo', '2026-06-12 07:38:40');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `calificaciones`
--
ALTER TABLE `calificaciones`
  ADD PRIMARY KEY (`id_calificacion`),
  ADD KEY `id_matricula` (`id_matricula`);

--
-- Indices de la tabla `estudiantes`
--
ALTER TABLE `estudiantes`
  ADD PRIMARY KEY (`id_estudiante`),
  ADD UNIQUE KEY `cuenta` (`cuenta`),
  ADD KEY `id_usuario` (`id_usuario`);

--
-- Indices de la tabla `maestros`
--
ALTER TABLE `maestros`
  ADD PRIMARY KEY (`id_maestro`),
  ADD UNIQUE KEY `codigo` (`codigo`),
  ADD KEY `id_usuario` (`id_usuario`);

--
-- Indices de la tabla `materias`
--
ALTER TABLE `materias`
  ADD PRIMARY KEY (`id_materia`),
  ADD UNIQUE KEY `codigo` (`codigo`),
  ADD KEY `id_maestro` (`id_maestro`);

--
-- Indices de la tabla `matriculas`
--
ALTER TABLE `matriculas`
  ADD PRIMARY KEY (`id_matricula`),
  ADD KEY `id_estudiante` (`id_estudiante`),
  ADD KEY `id_materia` (`id_materia`);

--
-- Indices de la tabla `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id_rol`),
  ADD UNIQUE KEY `nombre_rol` (`nombre_rol`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id_usuario`),
  ADD UNIQUE KEY `correo` (`correo`),
  ADD KEY `id_rol` (`id_rol`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `calificaciones`
--
ALTER TABLE `calificaciones`
  MODIFY `id_calificacion` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `estudiantes`
--
ALTER TABLE `estudiantes`
  MODIFY `id_estudiante` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `maestros`
--
ALTER TABLE `maestros`
  MODIFY `id_maestro` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `materias`
--
ALTER TABLE `materias`
  MODIFY `id_materia` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=90;

--
-- AUTO_INCREMENT de la tabla `matriculas`
--
ALTER TABLE `matriculas`
  MODIFY `id_matricula` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `roles`
--
ALTER TABLE `roles`
  MODIFY `id_rol` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id_usuario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `calificaciones`
--
ALTER TABLE `calificaciones`
  ADD CONSTRAINT `calificaciones_ibfk_1` FOREIGN KEY (`id_matricula`) REFERENCES `matriculas` (`id_matricula`);

--
-- Filtros para la tabla `estudiantes`
--
ALTER TABLE `estudiantes`
  ADD CONSTRAINT `estudiantes_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`);

--
-- Filtros para la tabla `maestros`
--
ALTER TABLE `maestros`
  ADD CONSTRAINT `maestros_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`);

--
-- Filtros para la tabla `materias`
--
ALTER TABLE `materias`
  ADD CONSTRAINT `materias_ibfk_1` FOREIGN KEY (`id_maestro`) REFERENCES `maestros` (`id_maestro`);

--
-- Filtros para la tabla `matriculas`
--
ALTER TABLE `matriculas`
  ADD CONSTRAINT `matriculas_ibfk_1` FOREIGN KEY (`id_estudiante`) REFERENCES `estudiantes` (`id_estudiante`),
  ADD CONSTRAINT `matriculas_ibfk_2` FOREIGN KEY (`id_materia`) REFERENCES `materias` (`id_materia`);

--
-- Filtros para la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD CONSTRAINT `usuarios_ibfk_1` FOREIGN KEY (`id_rol`) REFERENCES `roles` (`id_rol`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
