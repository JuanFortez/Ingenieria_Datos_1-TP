
CREATE DATABASE Sistema_de_Gestion_Salud_Clinica_Samuel
;
USE Sistema_de_Gestion_Salud_Clinica_Samuel;
go
;
CREATE TABLE COBERTURAS
(
C_CODIGO INT IDENTITY(1,1) PRIMARY KEY,
C_NOMBRE NVARCHAR(25),
C_PLAN NVARCHAR(25),
C_PAGO_CONSULTA INT
);


INSERT INTO COBERTURAS
VALUES 
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
('Particular','Particular', 55)
;

SELECT *
FROM COBERTURAS
;

CREATE TABLE PACIENTES 
(
P_CODIGO INT IDENTITY(1,1) PRIMARY KEY,
P_CUIT CHAR(11) NOT NULL,
P_NOMBRE NVARCHAR(25),
P_APELLIDO NVARCHAR(25),
P_FECHA_NACIMIENTO DATE,
P_DIRECCION NVARCHAR(100),
P_TELEFONO NVARCHAR(20) NOT NULL, 
P_EMAIL VARCHAR(100),
C_COBERTURA INT, 
P_OBSERVACION  NVARCHAR(150),
-- SOLO PUEDE ATENDERSE PACIENTES A PARTIR DE 18 A�OS, NO ES UNA CLINICA PEDIATRICA, SOLO ADULTOS. 
CHECK (P_FECHA_NACIMIENTO <= DATEADD(YEAR, -18, GETDATE())),
CHECK (P_EMAIL LIKE '%@%'),
CONSTRAINT FK_COBERTURAS
FOREIGN KEY  (C_COBERTURA) 
REFERENCES COBERTURAS(C_CODIGO)
)
;
INSERT INTO PACIENTES
(
    P_CUIT,
    P_NOMBRE,
    P_APELLIDO,
    P_FECHA_NACIMIENTO,
    P_DIRECCION,
    P_TELEFONO,
    P_EMAIL,
    C_COBERTURA,
    P_OBSERVACION
)
VALUES
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
 'Creador del lenguaje Python')
 ;

 SELECT * 
 FROM PACIENTES
 ;

 CREATE TABLE ESPECIALIDADES 
 (
 E_CODIGO INT IDENTITY(1,1) PRIMARY KEY,
 E_NOMBRE NVARCHAR(50) NOT NULL, 
 E_OBSERVACIONES NVARCHAR(20)  NULL DEFAULT NULL
 );

 INSERT INTO ESPECIALIDADES (E_NOMBRE)
 VALUES
('Cardiologo'),
('Cirujano Plastico'),
('Clinico Funcional'),
('Clinico Nutricionista'),
('Dermatologo'),
('Medico Oftalmologo')
 ;

 SELECT *
 FROM ESPECIALIDADES
 ;

CREATE TABLE CONSULTORIOS
(
C_CODIGO INT IDENTITY(1,1) PRIMARY KEY,
C_OBSERVACIONES NVARCHAR(20) NULL DEFAULT NULL,
C_ESPECIALIDAD INT,
CONSTRAINT FK_C_ESPECIALIDAD
FOREIGN KEY (C_ESPECIALIDAD)
REFERENCES ESPECIALIDADES(E_CODIGO)
);

INSERT INTO CONSULTORIOS(C_ESPECIALIDAD)
VALUES
 (1),
 (1),
 (2),
 (2),
 (3),
 (3),
 (4),
 (4),
 (5),
 (6)
;
SELECT *
FROM CONSULTORIOS
;

CREATE TABLE PROFESIONALES
--  USAMOS PRO, Y NO LA P SOLA PORQUE LOS ATRIBUTOS EMPEZARIAS CON P, Y SE PUEDE CONFUNDIR CON PACIENTES...
(
PRO_CODIGO INT IDENTITY(1,1) PRIMARY KEY,
PRO_CUIT CHAR(11) NOT NULL,
PRO_NOMBRE NVARCHAR(25),
PRO_APELLIDO NVARCHAR(25) NOT NULL,
PRO_FECHA_NACIMIENTO DATE,
PRO_DIRECCION NVARCHAR(100),
PRO_TELEFONO VARCHAR(20) NOT NULL, 
PRO_EMAIL VARCHAR(100),
PRO_ESPECIALIDAD INT, 
PRO_OBSERVACION  NVARCHAR(150),
CHECK (PRO_EMAIL LIKE '%@%'),
CONSTRAINT FK_ESPECIALIDAD
FOREIGN KEY (PRO_ESPECIALIDAD)
REFERENCES  ESPECIALIDADES(E_CODIGO)
)
;

INSERT INTO PROFESIONALES
(
    PRO_CUIT,
    PRO_NOMBRE,
    PRO_APELLIDO,
    PRO_FECHA_NACIMIENTO,
    PRO_DIRECCION,
    PRO_TELEFONO,
    PRO_EMAIL,
    PRO_ESPECIALIDAD,
    PRO_OBSERVACION
)
VALUES

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