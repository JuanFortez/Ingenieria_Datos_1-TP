/* ====== INSERCIONES ====== */

-- COBERTURAS --
INSERT INTO COBERTURAS VALUES 
('OSDE', '210', 20 ),
('OSDE', '310', 30 ),
('OSDE', '410', 40 ),
('OSDE', '510', 50 ),
('Galeno', '220', 22),
('Galeno', '330', 33),
('Galeno', '440', 44),
('Swiss Medica','SMG20', 20 ),
('Swiss Medica','SMG40', 40 ),
('Swiss Medica','SMG60', 60 ),
('Swiss Medica','BLACK', 120 ),
('Particular','Particular', 55);

-- PACIENTES --
INSERT INTO PACIENTES (
    PAC_CUIT,
    PAC_NOMBRE,
    PAC_APELLIDO,
    PAC_FECHA_NACIMIENTO,
    PAC_DIRECCION,
    PAC_TELEFONO,
    PAC_EMAIL,
    COD_COBERTURA,
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
('Medico Oftalmologo');

-- CONSULTORIOS --
INSERT INTO CONSULTORIOS(CONS_ESPECIALIDAD) VALUES
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
    'M�dico argentino especializado en nutricion y tratamiento de la obesidad.'
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
INSERT INTO ESTUDIOS_SOLICITADOS (ESO_ATENCION, ESO_ESTUDIO, ESO_ESTADO, ESO_TURNO, ESO_DEPARTAMENTO) VALUES
(1, 1, 'PROGRAMADO', 3,    1),
(1, 2, 'PENDIENTE',  NULL, 1),
(2, 4, 'PENDIENTE',  NULL, 6);

-- FACTURACIONES --
INSERT INTO FACTURACIONES (FACT_ATENCION, FACT_MONTO_TOTAL, FACT_MEDIO_PAGO, FACT_ESTADO_PAGO) VALUES
(1, 230, 'CREDITO', 'APROBADO'),
(2, 90, 'EFECTIVO', 'PENDIENTE');

-- DETALLES_FACTURAS --
INSERT INTO DETALLES_FACTURAS (DF_FACTURA, DF_ESTUDIO_SOLICITADO, DF_PRECIO_APLICADO, DF_MONTO_COBERTURA, DF_MONTO_PACIENTE) VALUES
(1, 1, 80, 60, 20),
(1, 2, 150, 110, 40),
(2, 3, 90, 30, 60);