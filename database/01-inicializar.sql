-- Solo para desarrollo local. Se ejecuta automáticamente al crear el volumen de MySQL.
-- No incluye DROP ni borrados. No volver a ejecutar sobre una base ya inicializada.
CREATE DATABASE IF NOT EXISTS anomalias CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE anomalias;
SET NAMES utf8mb4;
SET time_zone = '+00:00';

CREATE TABLE viviendas (
    id BIGINT NOT NULL AUTO_INCREMENT,
    direccion VARCHAR(200) NOT NULL,
    residente VARCHAR(100) NOT NULL,
    email_contacto VARCHAR(150) NOT NULL,
    instrucciones_acceso VARCHAR(500),
    PRIMARY KEY (id)
) ENGINE=InnoDB;

CREATE TABLE especialistas (
    id BIGINT NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    disciplina VARCHAR(20) NOT NULL,
    nivel_autorizacion INT NOT NULL,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    PRIMARY KEY (id),
    CONSTRAINT chk_especialista_disciplina CHECK (disciplina IN ('TEMPORAL', 'ESPACIAL', 'REFLEJOS', 'SONORA')),
    CONSTRAINT chk_especialista_nivel CHECK (nivel_autorizacion BETWEEN 1 AND 5)
) ENGINE=InnoDB;

CREATE TABLE anomalias (
    id BIGINT NOT NULL AUTO_INCREMENT,
    vivienda_id BIGINT NOT NULL,
    titulo VARCHAR(150) NOT NULL,
    descripcion TEXT NOT NULL,
    disciplina VARCHAR(20) NOT NULL,
    peligrosidad INT NOT NULL,
    estado VARCHAR(20) NOT NULL DEFAULT 'REPORTADA',
    fecha_reporte DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    CONSTRAINT fk_anomalia_vivienda FOREIGN KEY (vivienda_id) REFERENCES viviendas (id),
    CONSTRAINT chk_anomalia_disciplina CHECK (disciplina IN ('TEMPORAL', 'ESPACIAL', 'REFLEJOS', 'SONORA')),
    CONSTRAINT chk_anomalia_peligrosidad CHECK (peligrosidad BETWEEN 1 AND 5),
    CONSTRAINT chk_anomalia_estado CHECK (estado IN ('REPORTADA', 'EN_ESTUDIO', 'CONTENIDA', 'DESBORDADA')),
    INDEX idx_anomalias_estado (estado),
    INDEX idx_anomalias_disciplina (disciplina)
) ENGINE=InnoDB;

CREATE TABLE intervenciones (
    id BIGINT NOT NULL AUTO_INCREMENT,
    anomalia_id BIGINT NOT NULL,
    especialista_id BIGINT NOT NULL,
    fecha_inicio DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_fin DATETIME,
    resultado VARCHAR(20),
    informe VARCHAR(1500),
    PRIMARY KEY (id),
    CONSTRAINT fk_intervencion_anomalia FOREIGN KEY (anomalia_id) REFERENCES anomalias (id),
    CONSTRAINT fk_intervencion_especialista FOREIGN KEY (especialista_id) REFERENCES especialistas (id),
    CONSTRAINT chk_intervencion_resultado CHECK (resultado IN ('CONTENIDA', 'SIN_CAMBIOS', 'EMPEORADA')),
    CONSTRAINT chk_intervencion_cierre CHECK (
        (fecha_fin IS NULL AND resultado IS NULL AND informe IS NULL)
        OR (fecha_fin IS NOT NULL AND resultado IS NOT NULL AND informe IS NOT NULL AND CHAR_LENGTH(TRIM(informe)) > 0)
    ),
    CONSTRAINT chk_intervencion_fechas CHECK (fecha_fin IS NULL OR fecha_fin >= fecha_inicio),
    INDEX idx_intervenciones_anomalia_fecha (anomalia_id, fecha_inicio),
    INDEX idx_intervenciones_especialista_fin (especialista_id, fecha_fin)
) ENGINE=InnoDB;

INSERT INTO viviendas (id, direccion, residente, email_contacto, instrucciones_acceso) VALUES
    (1, 'Calle del Minuto Extra, 13, 2º B', 'Vera Instante', 'vera@example.com', 'No usar el timbre: avisa al vecino de ayer.'),
    (2, 'Plaza de las Esquinas, 0', 'Bruno Pliegue', 'bruno@example.com', 'La tercera puerta conduce a la segunda. Entrar por la ventana.'),
    (3, 'Avenida del Reflejo, 8', 'Alma Azogue', 'alma@example.com', 'No saludar al reflejo si él saluda primero.'),
    (4, 'Pasaje del Silencio, 4', 'Teo Murmullo', 'teo@example.com', 'Traer zapatillas. El suelo recuerda los pasos.');

INSERT INTO especialistas (id, nombre, disciplina, nivel_autorizacion, activo) VALUES
    (1, 'Dra. Hora Vuelta', 'TEMPORAL', 4, TRUE),
    (2, 'Nicolás Entreparedes', 'ESPACIAL', 3, TRUE),
    (3, 'Inés del Otro Lado', 'REFLEJOS', 5, TRUE),
    (4, 'Olivia Susurro', 'SONORA', 2, TRUE),
    (5, 'Tomás Todavía', 'TEMPORAL', 1, TRUE),
    (6, 'Celia Sin Eco', 'SONORA', 5, FALSE);

INSERT INTO anomalias (id, vivienda_id, titulo, descripcion, disciplina, peligrosidad, estado, fecha_reporte) VALUES
    (1, 1, 'La nevera imprime recuerdos de mañana', 'Cada apertura deja un imán con una conversación que aún no ha ocurrido.', 'TEMPORAL', 3, 'REPORTADA', UTC_TIMESTAMP() - INTERVAL 3 DAY),
    (2, 2, 'El pasillo gana dos metros cada martes', 'La cocina ya queda a seis minutos andando del salón.', 'ESPACIAL', 2, 'EN_ESTUDIO', UTC_TIMESTAMP() - INTERVAL 5 DAY),
    (3, 3, 'El espejo devuelve el reflejo con retraso', 'El reflejo tarda siete segundos y a veces lleva otro jersey.', 'REFLEJOS', 4, 'REPORTADA', UTC_TIMESTAMP() - INTERVAL 1 DAY),
    (4, 4, 'El armario aplaude las malas decisiones', 'Solo aplaude después de compras impulsivas y mensajes al ex.', 'SONORA', 1, 'CONTENIDA', UTC_TIMESTAMP() - INTERVAL 10 DAY),
    (5, 2, 'La habitación de invitados ocupa todo el edificio', 'Desde fuera mide nueve metros cuadrados. Dentro hay una estación de tren.', 'ESPACIAL', 5, 'DESBORDADA', UTC_TIMESTAMP() - INTERVAL 2 DAY),
    (6, 4, 'Las tuberías retransmiten conversaciones de las nubes', 'Se escucha una discusión sobre dónde llover el fin de semana.', 'SONORA', 2, 'REPORTADA', UTC_TIMESTAMP() - INTERVAL 6 HOUR),
    (7, 1, 'La tostadora rebobina el desayuno', 'La tostada vuelve a ser pan al untarla. La mantequilla conserva la memoria.', 'TEMPORAL', 1, 'REPORTADA', UTC_TIMESTAMP() - INTERVAL 2 HOUR),
    (8, 3, 'La sombra del perchero se ha independizado', 'Ahora aparece en el espejo aunque el perchero esté en otra habitación.', 'REFLEJOS', 2, 'REPORTADA', UTC_TIMESTAMP() - INTERVAL 30 MINUTE);

INSERT INTO intervenciones (id, anomalia_id, especialista_id, fecha_inicio, fecha_fin, resultado, informe) VALUES
    (1, 2, 2, UTC_TIMESTAMP() - INTERVAL 1 DAY, NULL, NULL, NULL),
    (2, 4, 4, UTC_TIMESTAMP() - INTERVAL 9 DAY, UTC_TIMESTAMP() - INTERVAL 8 DAY, 'CONTENIDA', 'Se aisló el armario con corcho. Sigue juzgando, pero en silencio.'),
    (3, 5, 2, UTC_TIMESTAMP() - INTERVAL 2 DAY, UTC_TIMESTAMP() - INTERVAL 36 HOUR, 'EMPEORADA', 'La anomalía era de nivel 3. Tras intentar plegar el dormitorio aparecieron dos andenes y subió a nivel 5.');
