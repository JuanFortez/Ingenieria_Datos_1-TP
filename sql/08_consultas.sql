/* ====== QUERYS ====== */
USE Sistema_de_Gestion_Salud_Clinica_Samuel;
GO

/* --------------------------------------------------------------------------
   Consultas de ejemplo organizadas por tema. Algunas incluyen su expresion en
   algebra relacional:
     σ seleccion (filtra filas)      π proyeccion (elige columnas)
     ⋈ junta natural / theta         ∪ union   ∩ interseccion   − diferencia
     γ agrupamiento con funciones de totales
   -------------------------------------------------------------------------- */


/* ==========================================================================
   1. JOINS
   ========================================================================== */

-- 1.1 INNER JOIN de varias tablas: agenda de consultas con paciente, profesional,
--     especialidad y consultorio.
--     π fecha, hora, paciente, profesional, especialidad (TURNOS ⋈ PACIENTES ⋈ PROFESIONALES ⋈ ESPECIALIDADES)
SELECT
    T.TUR_FECHA,
    T.TUR_HORA,
    CONCAT(P.PAC_NOMBRE, ' ', P.PAC_APELLIDO) AS PACIENTE,
    CONCAT(PR.PRO_NOMBRE, ' ', PR.PRO_APELLIDO) AS PROFESIONAL,
    E.ESP_NOMBRE AS ESPECIALIDAD,
    T.TUR_CONSULTORIO AS CONSULTORIO,
    T.TUR_ESTADO
FROM TURNOS T
INNER JOIN PACIENTES P ON P.PAC_CODIGO = T.TUR_PACIENTE
INNER JOIN PROFESIONALES PR ON PR.PRO_CODIGO = T.TUR_PROFESIONAL
INNER JOIN ESPECIALIDADES E ON E.ESP_CODIGO = PR.PRO_ESPECIALIDAD
WHERE T.TUR_TIPO_TURNO = 'CONSULTA'
ORDER BY T.TUR_FECHA, T.TUR_HORA;

-- 1.2 LEFT JOIN: TODAS las especialidades con su cantidad de profesionales,
--     incluidas las que no tienen ninguno (un INNER JOIN las dejaria afuera).
SELECT
    E.ESP_NOMBRE,
    COUNT(P.PRO_CODIGO) AS CANTIDAD_PROFESIONALES   -- COUNT(columna) no cuenta los NULL
FROM ESPECIALIDADES E
LEFT JOIN PROFESIONALES P ON P.PRO_ESPECIALIDAD = E.ESP_CODIGO
GROUP BY E.ESP_CODIGO, E.ESP_NOMBRE
ORDER BY CANTIDAD_PROFESIONALES DESC, E.ESP_NOMBRE;

-- 1.3 Cadena de JOINs: detalle de cada factura con el paciente y el estudio cobrado.
SELECT
    F.FACT_CODIGO,
    F.FACT_FECHA,
    CONCAT(P.PAC_NOMBRE, ' ', P.PAC_APELLIDO) AS PACIENTE,
    ES.EST_NOMBRE AS ESTUDIO,
    DF.DF_MONTO_TOTAL,
    F.FACT_ESTADO_PAGO
FROM FACTURACIONES F
INNER JOIN DETALLES_FACTURAS DF ON DF.DF_FACTURA = F.FACT_CODIGO
INNER JOIN ESTUDIOS_SOLICITADOS ESO ON ESO.ESO_CODIGO = DF.DF_ESTUDIO_SOLICITADO
INNER JOIN ESTUDIOS ES ON ES.EST_CODIGO = ESO.ESO_ESTUDIO
INNER JOIN ATENCIONES_MEDICAS AM ON AM.AM_CODIGO = F.FACT_ATENCION
INNER JOIN TURNOS T ON T.TUR_CODIGO = AM.AM_TURNO
INNER JOIN PACIENTES P ON P.PAC_CODIGO = T.TUR_PACIENTE
ORDER BY F.FACT_CODIGO;


/* ==========================================================================
   2. FUNCIONES DE TOTALES, GROUP BY Y HAVING
   WHERE filtra filas ANTES de agrupar; HAVING filtra grupos DESPUES de agrupar
   (por eso solo HAVING puede usar COUNT, SUM, etc.).
   ========================================================================== */

-- 2.1 Facturacion aprobada por mes: cantidad, total, promedio, minimo y maximo.
--     γ mes; COUNT, SUM, AVG, MIN, MAX (σ estado = 'APROBADO' (FACTURACIONES))
SELECT
    YEAR(FACT_FECHA) AS ANIO,
    MONTH(FACT_FECHA) AS MES,
    COUNT(*) AS CANTIDAD_FACTURAS,
    SUM(FACT_MONTO_TOTAL) AS TOTAL_FACTURADO,
    AVG(FACT_MONTO_TOTAL) AS PROMEDIO,
    MIN(FACT_MONTO_TOTAL) AS MINIMO,
    MAX(FACT_MONTO_TOTAL) AS MAXIMO
FROM FACTURACIONES
WHERE FACT_ESTADO_PAGO = 'APROBADO'
GROUP BY YEAR(FACT_FECHA), MONTH(FACT_FECHA)
ORDER BY ANIO, MES;

-- 2.2 HAVING: pacientes con 3 turnos o mas (de cualquier tipo y estado).
SELECT
    P.PAC_CODIGO,
    CONCAT(P.PAC_NOMBRE, ' ', P.PAC_APELLIDO) AS PACIENTE,
    COUNT(*) AS CANTIDAD_TURNOS
FROM PACIENTES P
INNER JOIN TURNOS T ON T.TUR_PACIENTE = P.PAC_CODIGO
GROUP BY P.PAC_CODIGO, P.PAC_NOMBRE, P.PAC_APELLIDO
HAVING COUNT(*) >= 3
ORDER BY CANTIDAD_TURNOS DESC;

-- 2.3 WHERE + GROUP BY + HAVING juntos: medios de pago con mas de $50.000
--     cobrados (solo facturas aprobadas).
SELECT
    FACT_MEDIO_PAGO,
    COUNT(*) AS CANTIDAD,
    SUM(FACT_MONTO_TOTAL) AS TOTAL
FROM FACTURACIONES
WHERE FACT_ESTADO_PAGO = 'APROBADO'
GROUP BY FACT_MEDIO_PAGO
HAVING SUM(FACT_MONTO_TOTAL) > 50000
ORDER BY TOTAL DESC;

-- 2.4 Conteo condicional: estado de los turnos de cada profesional en una sola fila.
SELECT
    CONCAT(PR.PRO_NOMBRE, ' ', PR.PRO_APELLIDO) AS PROFESIONAL,
    COUNT(T.TUR_CODIGO) AS TOTAL_TURNOS,
    SUM(CASE WHEN T.TUR_ESTADO = 'FINALIZADO' THEN 1 ELSE 0 END) AS FINALIZADOS,
    SUM(CASE WHEN T.TUR_ESTADO = 'AUSENTE' THEN 1 ELSE 0 END) AS AUSENTES,
    SUM(CASE WHEN T.TUR_ESTADO = 'CANCELADO' THEN 1 ELSE 0 END) AS CANCELADOS
FROM PROFESIONALES PR
LEFT JOIN TURNOS T ON T.TUR_PROFESIONAL = PR.PRO_CODIGO
GROUP BY PR.PRO_CODIGO, PR.PRO_NOMBRE, PR.PRO_APELLIDO
ORDER BY TOTAL_TURNOS DESC;


/* ==========================================================================
   3. SUBCONSULTAS
   ========================================================================== */

-- 3.1 Subconsulta con IN: pacientes que se hicieron algun estudio de cardiologia.
SELECT PAC_CODIGO, PAC_NOMBRE, PAC_APELLIDO
FROM PACIENTES
WHERE PAC_CODIGO IN (
    SELECT T.TUR_PACIENTE
    FROM TURNOS T
    INNER JOIN ATENCIONES_MEDICAS AM ON AM.AM_TURNO = T.TUR_CODIGO
    INNER JOIN ESTUDIOS_SOLICITADOS ESO ON ESO.ESO_ATENCION = AM.AM_CODIGO
    WHERE ESO.ESO_DEPARTAMENTO = (SELECT DEPTO_CODIGO FROM DEPARTAMENTOS WHERE DEPTO_NOMBRE = 'Cardiologia')
);

-- 3.2 Subconsulta correlacionada con NOT EXISTS: profesionales que nunca
--     atendieron una consulta (la subconsulta se evalua para cada profesional).
SELECT PR.PRO_CODIGO, PR.PRO_NOMBRE, PR.PRO_APELLIDO
FROM PROFESIONALES PR
WHERE NOT EXISTS (
    SELECT 1
    FROM TURNOS T
    INNER JOIN ATENCIONES_MEDICAS AM ON AM.AM_TURNO = T.TUR_CODIGO
    WHERE T.TUR_PROFESIONAL = PR.PRO_CODIGO
);

-- 3.3 Subconsulta en el SELECT: cada estudio con la cantidad de veces que fue
--     solicitado (incluye los nunca pedidos, con 0).
SELECT
    E.EST_NOMBRE,
    E.EST_PRECIO_BASE,
    (SELECT COUNT(*) FROM ESTUDIOS_SOLICITADOS ESO WHERE ESO.ESO_ESTUDIO = E.EST_CODIGO) AS VECES_SOLICITADO
FROM ESTUDIOS E
ORDER BY VECES_SOLICITADO DESC, E.EST_NOMBRE;

-- 3.4 Operador de comparacion con ALL: el o los estudios mas caros.
SELECT EST_NOMBRE, EST_PRECIO_BASE
FROM ESTUDIOS
WHERE EST_PRECIO_BASE >= ALL (SELECT EST_PRECIO_BASE FROM ESTUDIOS);

-- 3.5 Operador de comparacion con ANY: estudios mas caros que ALGUNO de los
--     estudios de oftalmologia (es decir, mas caros que el mas barato de ellos).
SELECT EST_NOMBRE, EST_PRECIO_BASE
FROM ESTUDIOS
WHERE EST_PRECIO_BASE > ANY (
    SELECT E.EST_PRECIO_BASE
    FROM ESTUDIOS E
    INNER JOIN ESTUDIOS_SOLICITADOS ESO ON ESO.ESO_ESTUDIO = E.EST_CODIGO
    WHERE ESO.ESO_DEPARTAMENTO = 6   -- Oftalmologia
)
ORDER BY EST_PRECIO_BASE DESC;

-- 3.6 Subconsulta en el FROM (tabla derivada): facturacion promedio por
--     cobertura, calculada sobre el total facturado a cada paciente.
SELECT
    X.COB_NOMBRE,
    COUNT(*) AS PACIENTES_FACTURADOS,
    AVG(X.TOTAL_PACIENTE) AS PROMEDIO_POR_PACIENTE
FROM (
    SELECT P.PAC_CODIGO, C.COB_NOMBRE, SUM(F.FACT_MONTO_TOTAL) AS TOTAL_PACIENTE
    FROM FACTURACIONES F
    INNER JOIN ATENCIONES_MEDICAS AM ON AM.AM_CODIGO = F.FACT_ATENCION
    INNER JOIN TURNOS T ON T.TUR_CODIGO = AM.AM_TURNO
    INNER JOIN PACIENTES P ON P.PAC_CODIGO = T.TUR_PACIENTE
    INNER JOIN COBERTURAS C ON C.COB_CODIGO = P.COD_COBERTURA
    GROUP BY P.PAC_CODIGO, C.COB_NOMBRE
) AS X
GROUP BY X.COB_NOMBRE
ORDER BY PROMEDIO_POR_PACIENTE DESC;

-- 3.7 Subconsulta correlacionada en el WHERE: facturas por encima del promedio
--     de su mismo medio de pago.
SELECT F1.FACT_CODIGO, F1.FACT_MEDIO_PAGO, F1.FACT_MONTO_TOTAL
FROM FACTURACIONES F1
WHERE F1.FACT_MONTO_TOTAL > (
    SELECT AVG(F2.FACT_MONTO_TOTAL)
    FROM FACTURACIONES F2
    WHERE F2.FACT_MEDIO_PAGO = F1.FACT_MEDIO_PAGO
)
ORDER BY F1.FACT_MEDIO_PAGO, F1.FACT_MONTO_TOTAL DESC;


/* ==========================================================================
   4. OPERADORES DE CONJUNTOS
   Las consultas combinadas deben devolver la misma cantidad de columnas, con
   tipos compatibles. UNION elimina duplicados; UNION ALL los conserva.
   ========================================================================== */

-- 4.1 UNION: directorio de contactos de la clinica (pacientes y profesionales).
--     π nombre, email (PACIENTES) ∪ π nombre, email (PROFESIONALES)
SELECT CONCAT(PAC_NOMBRE, ' ', PAC_APELLIDO) AS NOMBRE, PAC_EMAIL AS EMAIL, 'PACIENTE' AS ROL
FROM PACIENTES
UNION
SELECT CONCAT(PRO_NOMBRE, ' ', PRO_APELLIDO), PRO_EMAIL, 'PROFESIONAL'
FROM PROFESIONALES
ORDER BY ROL, NOMBRE;

-- 4.2 INTERSECT: pacientes que tuvieron turnos de CONSULTA y tambien de ESTUDIO.
--     π paciente (σ tipo = CONSULTA (TURNOS)) ∩ π paciente (σ tipo = ESTUDIO (TURNOS))
SELECT TUR_PACIENTE FROM TURNOS WHERE TUR_TIPO_TURNO = 'CONSULTA'
INTERSECT
SELECT TUR_PACIENTE FROM TURNOS WHERE TUR_TIPO_TURNO = 'ESTUDIO';

-- 4.3 EXCEPT: atenciones que todavia no se facturaron.
--     π codigo (ATENCIONES_MEDICAS) − π atencion (FACTURACIONES)
SELECT AM_CODIGO FROM ATENCIONES_MEDICAS
EXCEPT
SELECT FACT_ATENCION FROM FACTURACIONES;

-- 4.4 EXCEPT: pacientes registrados que nunca tuvieron un turno.
SELECT PAC_CODIGO, PAC_NOMBRE, PAC_APELLIDO FROM PACIENTES
EXCEPT
SELECT P.PAC_CODIGO, P.PAC_NOMBRE, P.PAC_APELLIDO
FROM PACIENTES P
INNER JOIN TURNOS T ON T.TUR_PACIENTE = P.PAC_CODIGO;

-- 4.5 UNION ALL: movimientos de un paciente (consultas y estudios facturados)
--     en una sola lista ordenada por fecha.
SELECT T.TUR_FECHA AS FECHA, 'Consulta' AS MOVIMIENTO, E.ESP_NOMBRE AS DETALLE
FROM TURNOS T
INNER JOIN PROFESIONALES PR ON PR.PRO_CODIGO = T.TUR_PROFESIONAL
INNER JOIN ESPECIALIDADES E ON E.ESP_CODIGO = PR.PRO_ESPECIALIDAD
WHERE T.TUR_PACIENTE = 3 AND T.TUR_ESTADO = 'FINALIZADO'
UNION ALL
SELECT F.FACT_FECHA, 'Estudio facturado', ES.EST_NOMBRE
FROM FACTURACIONES F
INNER JOIN DETALLES_FACTURAS DF ON DF.DF_FACTURA = F.FACT_CODIGO
INNER JOIN ESTUDIOS_SOLICITADOS ESO ON ESO.ESO_CODIGO = DF.DF_ESTUDIO_SOLICITADO
INNER JOIN ESTUDIOS ES ON ES.EST_CODIGO = ESO.ESO_ESTUDIO
INNER JOIN ATENCIONES_MEDICAS AM ON AM.AM_CODIGO = F.FACT_ATENCION
INNER JOIN TURNOS T ON T.TUR_CODIGO = AM.AM_TURNO
WHERE T.TUR_PACIENTE = 3
ORDER BY FECHA;


/* ==========================================================================
   5. USO DE LAS FUNCIONES (07_functions.sql)
   ========================================================================== */

-- 5.1 Funcion escalar en el SELECT y en el WHERE: pacientes mayores de 80 anios.
SELECT
    PAC_NOMBRE,
    PAC_APELLIDO,
    dbo.Fn_DNIDesdeCUIT(PAC_CUIT) AS DNI,
    dbo.Fn_Edad(PAC_FECHA_NACIMIENTO) AS EDAD
FROM PACIENTES
WHERE dbo.Fn_Edad(PAC_FECHA_NACIMIENTO) > 80
ORDER BY EDAD DESC;

-- 5.2 Funcion de tabla en el FROM, como si fuera una tabla: ingresos por consultas de septiembre 2026.
SELECT COB_NOMBRE, SUM(INGRESO_TOTAL) AS INGRESO
FROM Fn_IngresosConsultasPorMes(2026, 9)
GROUP BY COB_NOMBRE
ORDER BY INGRESO DESC;
