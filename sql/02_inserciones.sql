/* ====== INSERCIONES ====== */
USE Sistema_de_Gestion_Salud_Clinica_Samuel;
GO

-- COBERTURAS --
INSERT INTO COBERTURAS (COB_NOMBRE) VALUES 
('OSDE'),
('Galeno'),
('Swiss Medical'),
('PARTICULAR/OTROS');   -- nombre segun CHK_COB_NOMBRE

-- PLANES --
INSERT INTO PLANES (PLAN_COBERTURA, PLAN_NOMBRE, PLAN_PAGO_CONSULTA) VALUES 
(1, '210', 20000 ),
(1, '310', 30000 ),
(1, '410', 40000 ),
(1, '510', 50000 ),
(2, '220', 22000),
(2, '330', 33000),
(2, '440', 44000),
(3,'SMG20', 20000 ),
(3,'SMG40', 40000 ),
(3,'SMG60', 60000 ),
(3,'BLACK', 120000 ),
(4,'Particular', 55000); 

-- PACIENTES --
INSERT INTO PACIENTES (
    PAC_CUIT,
    PAC_NOMBRE,
    PAC_APELLIDO,
    PAC_FECHA_NACIMIENTO,
    PAC_DIRECCION,
    PAC_TELEFONO,
    PAC_EMAIL,
    COD_PLAN,
    PAC_OBSERVACION
) VALUES
('99000000001', 'Ada', 'Lovelace', '1815-12-10',
 'Av Monroe 4175', '1100000001', 'ada@hotmail.com', 4,
 'Pionera de la programacion'),

('99000000002', 'Charles', 'Babbage', '1791-12-26',
 'Av Melian 789', '1100000002', 'charles@gmail.com', 7,
 'Pionero de la computacion'),

('99000000003', 'Alan', 'Turing', '1912-06-23',
 'Av. Libertador 1432', '1100000003', 'alan@gmail.com', 11,
 'Pionero de la computacion teorica'),

('99000000004', 'Grace', 'Hopper', '1906-12-09',
 'Direccion ficticia 4', '1100000004', 'grace@example.com', 4,
 'Pionera de los compiladores'),

('99000000005', 'John', 'von Neumann', '1903-12-28',
 'Direccion ficticia 5', '1100000005', 'john@example.com', 7,
 'Aportes a la arquitectura de computadoras'),

('99000000006', 'Claude', 'Shannon', '1916-04-30',
 'Direccion ficticia 6', '1100000006', 'claude@example.com', 11,
 'Fundador de la teoria de la informacion'),

('99000000007', 'Donald', 'Knuth', '1938-01-10',
 'Direccion ficticia 7', '1100000007', 'donald@example.com', 4,
 'Referente de los algoritmos'),

('99000000008', 'Dennis', 'Ritchie', '1941-09-09',
 'Direccion ficticia 8', '1100000008', 'dennis@example.com', 7,
 'Creador del lenguaje C'),

('99000000009', 'Margaret', 'Hamilton', '1936-08-17',
 'Direccion ficticia 9', '1100000009', 'margaret@example.com', 11,
 'Pionera de la ingenieria de software'),

('99000000010', 'Tim', 'Berners-Lee', '1955-06-08',
 'Direccion ficticia 10', '1100000010', 'tim@gmail.com', 12,
 'Inventor de la World Wide Web'),

('99000000011', 'Linus', 'Torvalds', '1969-12-28',
 'Direccion ficticia 11', '1100000011', 'linus@hotmail.com', 4,
 'Creador del kernel Linux y Git'),

('99000000012', 'Guido', 'van Rossum', '1956-01-31',
 'Direccion ficticia 12', '1100000012', 'guido@hotmail.com', 4,
 'Creador del lenguaje Python');

-- ESPECIALIDADES --
INSERT INTO ESPECIALIDADES (ESP_NOMBRE) VALUES
('Cardiologo'),
('Cirujano Plastico'),
('Clinico Funcional'),
('Clinico Nutricionista'),
('Dermatologo'),
('Medico Oftalmologo'),
('Medico Deportologo')
;

-- CONSULTORIOS --
INSERT INTO CONSULTORIOS(COD_ESPECIALIDAD) VALUES
 (1),
 (1),
 (2),
 (2),
 (3),
 (3),
 (4),
 (4),
 (5),
 (6);

-- PROFESIONALES --
 INSERT INTO PROFESIONALES (
    PRO_CUIT,
    PRO_NOMBRE,
    PRO_APELLIDO,
    PRO_FECHA_NACIMIENTO,
    PRO_DIRECCION,
    PRO_TELEFONO,
    PRO_EMAIL,
    PRO_ESPECIALIDAD,
    PRO_OBSERVACION
) VALUES
(
    '20000000001',
    'Rene',
    'Favaloro',
    '19230712',
    'Direccion ficticia 1',
    '11-0000-0001',
    'prueba.favaloro01@gmail.com',
    1,
    'Cardiologo argentino. Desarrollo y popularizo la tecnica del bypass coronario.'
),

(
    '20000000002',
    'Daniel',
    'Lopez Rosetti',
    '19510214',
    'Direccion ficticia 2',
    '11-0000-0002',
    'prueba.lopezrosetti02@hotmail.com',
    1,
    'Medico argentino reconocido por su trabajo en cardiologia, estres y medicina del bienestar.'
),

(
    '20000000003',
    'Ivo',
    'Pitanguy',
    '19260705',
    'Direccion ficticia 3',
    '11-0000-0003',
    'prueba.pitanguy03@gmail.com',
    2,
    'Cirujano plastico brasilenio reconocido internacionalmente por su trayectoria en cirugia plastica.'
),

(
    '20000000004',
    'Alberto',
    'Cormillot',
    '19380831',
    'Direccion ficticia 4',
    '11-0000-0004',
    'prueba.cormillot04@hotmail.com',
    4,
    'Médico argentino especializado en nutricion y tratamiento de la obesidad.'
),

(
    '20000000005',
    'Frederick',
    'Mohs',
    '19100401',
    'Direccion ficticia 5',
    '11-0000-0005',
    'prueba.mohs05@gmail.com',
    5,
    'Dermatologo estadounidense creador de la tecnica quirurgica micrografica de Mohs.'
),

(
    '20000000006',
    'Albert',
    'Kligman',
    '19160317',
    'Direccion ficticia 6',
    '11-0000-0006',
    'prueba.kligman06@hotmail.com',
    5,
    'Dermatologo estadounidense conocido por sus investigaciones sobre la piel y el acne.'
),

(
    '20000000007',
    'Jose Ignacio',
    'Barraquer',
    '19160124',
    'Direccion ficticia 7',
    '11-0000-0007',
    'prueba.barraquer07@gmail.com',
    6,
    'Oftalmologo espaniol reconocido por sus aportes a la cirugia refractiva corneal.'
),

(
    '20000000008',
    'Ramon',
    'Castroviejo',
    '19040824',
    'Direccion ficticia 8',
    '11-0000-0008',
    'prueba.castroviejo08@hotmail.com',
    6,
    'Oftalmologo espaniol reconocido por sus contribuciones a la cirugia de cornea y los trasplantes corneales.'
),

(
    '20000000009',
    'Harold',
    'Ridley',
    '19060710',
    'Direccion ficticia 9',
    '11-0000-0009',
    'prueba.ridley09@gmail.com',
    6,
    'Oftalmologo britanico que introdujo el uso de lentes intraoculares en cirugia de cataratas.'
),

(
    '20000000010',
    'Charles',
    'Kelman',
    '19300523',
    'Direccion ficticia 10',
    '11-0000-0010',
    'prueba.kelman10@hotmail.com',
    6,
    'Oftalmologo estadounidense que desarrollo la tecnica de facoemulsificacion para cirugia de cataratas.'
);

-- ESTUDIOS --
INSERT INTO ESTUDIOS (EST_NOMBRE, EST_DESCRIPCION, EST_PRECIO_BASE) VALUES
('Electrocardiograma', 'Registro de la actividad electrica del corazon', 22000),
('Ecocardiograma', 'Ecografia del corazon', 45000),
('Analisis de sangre', 'Hemograma y perfil bioquimico completo', 28000),
('Campo visual', 'Evaluacion del campo visual', 18000),
('Biopsia cutánea', 'Extracción de una pequeña muestra de tejido de la piel para su análisis en laboratorio ante sospechas de patologías complejas.', 55000),
('Agudeza visual y refracción', 'Evalúa la capacidad para ver letras o símbolos a distancia.', 20000),
('Tonometría', 'Mide la presión intraocular.', 15000),
('Fondo de ojo', 'Evalúa la parte posterior del ojo (retina, disco óptico y vasos sanguíneos)', 25000),
('Prueba de esfuerzo (Ergometría)', 'Registra el comportamiento del corazón y la presión arterial mientras el paciente camina o corre en una cinta.', 48000),
('Perfil hormonal completo', 'Evalúa el funcionamiento de la tiroides (TSH, T4 libre), cortisol y hormonas sexuales.', 65000),
('Marcadores inflamatorios', 'Análisis como la Proteína C Reactiva (PCR) y la Eritrosedimentación (VSG) para detectar inflamación sistémica.', 32000),
('Antropometría', 'Medición detallada de pliegues cutáneos, diámetros y circunferencias corporales para determinar el somatotipo.', 18000),
('Bioimpedancia eléctrica (BIA)', 'Mide la composición corporal (porcentaje de masa grasa, masa muscular y agua) mediante una corriente eléctrica de baja intensidad.', 25000),
('Dermatoscopía', 'Examen de los lunares y lesiones de la piel con un lente de aumento iluminado para detectar signos tempranos de cáncer de piel.', 30000),
('Luz de Wood', 'Uso de luz ultravioleta para evaluar infecciones por hongos, bacterias o trastornos de la pigmentación como el vitíligo.', 16000),
('Fotografía clínica estandarizada', 'Registro fotográfico preciso desde múltiples ángulos para planificar la cirugía y evaluar los resultados del "antes y después".', 12000),
('Marcación y mapeo quirúrgico', 'Dibujo técnico sobre el cuerpo del paciente en bipedestación para guiar las incisiones y simular las simetrías.', 20000);


-- DEPARTAMENTOS --
INSERT INTO DEPARTAMENTOS (DEPTO_ESPECIALIDAD, DEPTO_NOMBRE, DEPTO_UBICACION_PISO) VALUES
(1, 'Cardiologia', 1),
(2, 'Cirugia Plastica', 2),
(3, 'Clinica Funcional', 3),
(4, 'Nutricion', 3),
(5, 'Dermatologia', 4),
(6, 'Oftalmologia', 5);

-- TURNOS --
INSERT INTO TURNOS (TUR_PACIENTE, TUR_PROFESIONAL, TUR_CONSULTORIO, TUR_FECHA, TUR_HORA, TUR_ESTADO, TUR_TIPO_TURNO) VALUES
(1, 1, 1, '2026-10-26', '09:00', 'CONFIRMADO', 'CONSULTA'),
(2, 2, 2, '2026-10-26', '10:00', 'FINALIZADO', 'CONSULTA'),
(2, NULL, 1, '2026-10-27', '11:00', 'CONFIRMADO', 'ESTUDIO'),
(4, 7, 10, '2026-10-27', '15:00', 'FINALIZADO', 'CONSULTA');

-- ATENCIONES_MEDICAS --
INSERT INTO ATENCIONES_MEDICAS (AM_TURNO, AM_MOTIVO_CONSULTA, AM_DIAGNOSTICO, AM_OBSERVACIONES) VALUES
(2, 'Palpitaciones', 'Taquicardia sinusal leve', 'Se solicitan estudios'),
(4, 'Control de vision', 'Miopia leve', 'Se solicita campo visual');

-- ESTUDIOS_SOLICITADOS -- 
INSERT INTO ESTUDIOS_SOLICITADOS (ESO_ATENCION, ESO_ESTUDIO, ESO_ESTADO, ESO_TURNO) VALUES
(1, 1, 'PROGRAMADO', 3),
(1, 2, 'PENDIENTE',  NULL),
(2, 4, 'PENDIENTE',  NULL);

-- FACTURACIONES --
/*
    FACT_MONTO_TOTAL es un snapshot historico del total al momento de facturar.
    No se recalcula si luego cambia ESTUDIOS.EST_PRECIO_BASE.
*/
INSERT INTO FACTURACIONES (FACT_ATENCION, FACT_MONTO_TOTAL, FACT_MEDIO_PAGO, FACT_ESTADO_PAGO) VALUES
(1, 67000, 'CREDITO', 'APROBADO'),   -- 22000 + 45000
(2, 18000, 'EFECTIVO', 'PENDIENTE');

-- DETALLES_FACTURAS --
/*
    DF_MONTO_TOTAL es un snapshot historico del precio cobrado al momento de facturar.
    No se recalcula si luego cambia ESTUDIOS.EST_PRECIO_BASE.
*/
INSERT INTO DETALLES_FACTURAS (DF_FACTURA, DF_ESTUDIO_SOLICITADO, DF_MONTO_TOTAL) VALUES
(1, 1, 22000),   -- Electrocardiograma
(1, 2, 45000),   -- Ecocardiograma
(2, 3, 18000);   -- Campo visual

-- PACIENTES (13 a 16) con CUIT de formato real: 2 digitos + DNI (8) + verificador --
INSERT INTO PACIENTES (PAC_CUIT, PAC_NOMBRE, PAC_APELLIDO, PAC_FECHA_NACIMIENTO, PAC_DIRECCION, PAC_TELEFONO, PAC_EMAIL, COD_PLAN, PAC_OBSERVACION) VALUES
('27384561237', 'Barbara', 'Liskov',   '1939-11-07', 'Direccion ficticia 13', '1100000013', 'barbara@example.com', 1, 'DNI 38456123'),   -- 13
('20401239876', 'Edsger',  'Dijkstra', '1930-05-11', 'Direccion ficticia 14', '1100000014', 'edsger@example.com',  6, 'DNI 40123987'),   -- 14
('20295847612', 'Edgar',   'Codd',     '1923-08-19', 'Direccion ficticia 15', '1100000015', 'edgar@example.com',   9, 'DNI 29584761'),   -- 15
('27312456785', 'Frances', 'Allen',    '1932-08-04', 'Direccion ficticia 16', '1100000016', 'frances@example.com', 2, 'Paciente nuevo, todavia sin turnos');   -- 16

-- TURNOS (5 a 34) --
-- Consultorios por especialidad: 1-2 Cardiologia, 3-4 Cirugia Plastica, 5-6 Clinica Funcional,
-- 7-8 Nutricion, 9 Dermatologia, 10 Oftalmologia.
INSERT INTO TURNOS (TUR_PACIENTE, TUR_PROFESIONAL, TUR_CONSULTORIO, TUR_FECHA, TUR_HORA, TUR_ESTADO, TUR_TIPO_TURNO) VALUES
(5,  5,    9,  '2026-08-04', '10:00', 'FINALIZADO', 'CONSULTA'),   -- 5
(3,  1,    1,  '2026-08-05', '09:00', 'FINALIZADO', 'CONSULTA'),   -- 6
(5,  NULL, 9,  '2026-08-11', '10:00', 'FINALIZADO', 'ESTUDIO'),    -- 7
(3,  NULL, 2,  '2026-08-12', '09:00', 'FINALIZADO', 'ESTUDIO'),    -- 8
(3,  NULL, 2,  '2026-08-12', '09:30', 'FINALIZADO', 'ESTUDIO'),    -- 9
(7,  4,    7,  '2026-08-18', '16:00', 'FINALIZADO', 'CONSULTA'),   -- 10
(7,  NULL, 8,  '2026-08-25', '16:00', 'FINALIZADO', 'ESTUDIO'),    -- 11
(6,  8,    10, '2026-08-26', '12:00', 'CANCELADO',  'CONSULTA'),   -- 12
(8,  3,    3,  '2026-09-02', '14:00', 'FINALIZADO', 'CONSULTA'),   -- 13
(8,  NULL, 4,  '2026-09-09', '14:00', 'FINALIZADO', 'ESTUDIO'),    -- 14
(8,  NULL, 4,  '2026-09-09', '14:30', 'FINALIZADO', 'ESTUDIO'),    -- 15
(9,  6,    9,  '2026-09-10', '15:00', 'FINALIZADO', 'CONSULTA'),   -- 16
(9,  NULL, 9,  '2026-09-17', '15:00', 'FINALIZADO', 'ESTUDIO'),    -- 17
(11, 1,    1,  '2026-09-15', '09:30', 'AUSENTE',    'CONSULTA'),   -- 18
(12, 9,    10, '2026-09-22', '11:00', 'FINALIZADO', 'CONSULTA'),   -- 19
(12, NULL, 10, '2026-09-29', '11:00', 'FINALIZADO', 'ESTUDIO'),    -- 20
(10, 2,    2,  '2026-09-23', '10:00', 'FINALIZADO', 'CONSULTA'),   -- 21
(10, NULL, 2,  '2026-09-30', '10:00', 'FINALIZADO', 'ESTUDIO'),    -- 22
(1,  7,    10, '2026-10-06', '15:00', 'FINALIZADO', 'CONSULTA'),   -- 23
(13, 4,    7,  '2026-10-07', '16:00', 'FINALIZADO', 'CONSULTA'),   -- 24
(14, 5,    9,  '2026-10-13', '11:00', 'FINALIZADO', 'CONSULTA'),   -- 25
(14, NULL, 9,  '2026-10-20', '11:00', 'FINALIZADO', 'ESTUDIO'),    -- 26
(6,  1,    1,  '2026-10-14', '09:00', 'FINALIZADO', 'CONSULTA'),   -- 27
(6,  NULL, 1,  '2026-10-21', '08:00', 'FINALIZADO', 'ESTUDIO'),    -- 28
(9,  2,    2,  '2026-10-28', '10:00', 'AUSENTE',    'CONSULTA'),   -- 29
(2,  2,    2,  '2026-11-09', '10:00', 'CONFIRMADO', 'CONSULTA'),   -- 30
(13, 4,    7,  '2026-11-10', '16:00', 'PENDIENTE',  'CONSULTA'),   -- 31
(15, 7,    10, '2026-11-11', '15:00', 'PENDIENTE',  'CONSULTA'),   -- 32
(3,  1,    1,  '2026-11-12', '09:00', 'CONFIRMADO', 'CONSULTA'),   -- 33
(11, 6,    9,  '2026-11-13', '15:00', 'PENDIENTE',  'CONSULTA');   -- 34

-- ATENCIONES_MEDICAS (3 a 13) --
INSERT INTO ATENCIONES_MEDICAS (AM_TURNO, AM_MOTIVO_CONSULTA, AM_DIAGNOSTICO, AM_OBSERVACIONES) VALUES
(5,  'Lunar con cambios de color',  'Nevo atipico',                       'Se indica dermatoscopia'),          -- 3
(6,  'Dolor de pecho al esfuerzo',  'Angina estable a confirmar',         'Se solicitan ECG y ergometria'),    -- 4
(10, 'Descenso de peso',            'Sobrepeso grado I',                  'Plan alimentario personalizado'),   -- 5
(13, 'Consulta por rinoplastia',    'Desviacion de tabique',              'Paciente particular'),              -- 6
(16, 'Manchas blancas en la piel',  'Vitiligo',                           NULL),                               -- 7
(19, 'Vision borrosa de cerca',     'Cataratas incipientes',              NULL),                               -- 8
(21, 'Control post tratamiento',    'Taquicardia controlada',             NULL),                               -- 9
(23, 'Ojo seco',                    'Sindrome de ojo seco',               'Sin estudios'),                     -- 10
(24, 'Control nutricional',         'Habitos alimentarios saludables',    NULL),                               -- 11
(25, 'Lesion en la espalda',        'Lesion sospechosa',                  'Se indica biopsia'),                -- 12
(27, 'Control de rutina',           'Colesterol elevado a confirmar',     'Se solicita analisis de sangre');   -- 13

-- ESTUDIOS_SOLICITADOS (4 a 16) --
INSERT INTO ESTUDIOS_SOLICITADOS (ESO_ATENCION, ESO_ESTUDIO, ESO_ESTADO, ESO_TURNO) VALUES
(3,  14, 'REALIZADO', 7),       -- 4: Dermatoscopia
(4,  1,  'REALIZADO', 8),       -- 5: Electrocardiograma
(4,  9,  'REALIZADO', 9),       -- 6: Ergometria
(5,  13, 'REALIZADO', 11),      -- 7: Bioimpedancia
(6,  16, 'REALIZADO', 14),      -- 8: Fotografia clinica
(6,  17, 'REALIZADO', 15),      -- 9: Marcacion quirurgica
(7,  15, 'REALIZADO', 17),      -- 10: Luz de Wood
(8,  8,  'REALIZADO', 20),      -- 11: Fondo de ojo
(8,  7,  'CANCELADO', NULL),    -- 12: Tonometria (cancelado, no se factura)
(9,  2,  'REALIZADO', 22),      -- 13: Ecocardiograma
(11, 12, 'PENDIENTE', NULL),    -- 14: Antropometria
(12, 5,  'REALIZADO', 26),      -- 15: Biopsia cutanea
(13, 3,  'REALIZADO', 28);      -- 16: Analisis de sangre (realizado y todavia sin facturar)

-- FACTURACIONES (3 a 10) --
-- Las atenciones 10, 11 y 13 quedan sin facturar a proposito (para probar procedures y cursores).
INSERT INTO FACTURACIONES (FACT_ATENCION, FACT_FECHA, FACT_HORA, FACT_MONTO_TOTAL, FACT_MEDIO_PAGO, FACT_ESTADO_PAGO) VALUES
(3,  '2026-08-11', '10:30', 30000, 'DEBITO',        'APROBADO'),    -- 3
(4,  '2026-08-12', '10:00', 70000, 'CREDITO',       'APROBADO'),    -- 4: 22000 + 48000
(5,  '2026-08-25', '16:30', 25000, 'EFECTIVO',      'APROBADO'),    -- 5
(6,  '2026-09-09', '15:00', 32000, 'TRANSFERENCIA', 'APROBADO'),    -- 6: 12000 + 20000
(7,  '2026-09-17', '15:30', 16000, 'CREDITO',       'RECHAZADO'),   -- 7
(8,  '2026-09-29', '11:30', 25000, 'DEBITO',        'APROBADO'),    -- 8
(9,  '2026-09-30', '10:30', 45000, 'EFECTIVO',      'APROBADO'),    -- 9
(12, '2026-10-20', '11:30', 55000, 'TRANSFERENCIA', 'PENDIENTE');   -- 10

-- DETALLES_FACTURAS (4 a 13) --
INSERT INTO DETALLES_FACTURAS (DF_FACTURA, DF_ESTUDIO_SOLICITADO, DF_MONTO_TOTAL) VALUES
(3,  4,  30000),   -- Dermatoscopia
(4,  5,  22000),   -- Electrocardiograma
(4,  6,  48000),   -- Ergometria
(5,  7,  25000),   -- Bioimpedancia
(6,  8,  12000),   -- Fotografia clinica
(6,  9,  20000),   -- Marcacion quirurgica
(7,  10, 16000),   -- Luz de Wood
(8,  11, 25000),   -- Fondo de ojo
(9,  13, 45000),   -- Ecocardiograma
(10, 15, 55000);   -- Biopsia cutanea
