-- INSERTAR DATOS DE PRUEBA
-- Ejecutar este script completo con F5

-- DEPARTAMENTOS
INSERT INTO departamento VALUES (1, 'Guatemala', 'GT', 'A');
INSERT INTO departamento VALUES (2, 'Quetzaltenango', 'QZ', 'A');
INSERT INTO departamento VALUES (3, 'Escuintla', 'ES', 'A');
INSERT INTO departamento VALUES (4, 'Petén', 'PT', 'A');

-- TIPO BUS
INSERT INTO tipo_bus VALUES (1, 'Ejecutivo', 'Bus con aire acondicionado', 'A');
INSERT INTO tipo_bus VALUES (2, 'Económico', 'Bus estándar', 'A');

-- BUSES
INSERT INTO bus VALUES (1, 1, 'BUS-001', 'P-123ABC', 'Mercedes', 'Sprinter', 2020, 45, 'ACTIVO', SYSDATE);
INSERT INTO bus VALUES (2, 1, 'BUS-002', 'P-456DEF', 'Volvo', 'B12', 2019, 50, 'ACTIVO', SYSDATE);
INSERT INTO bus VALUES (3, 2, 'BUS-003', 'P-789GHI', 'Hino', 'AK', 2018, 40, 'ACTIVO', SYSDATE);

-- PILOTOS
INSERT INTO piloto VALUES (1, 'Juan Carlos', 'Pérez López', '1234567890101', 'LIC-001', 'C', SYSDATE+365, '12345678', 'juan@email.com', 'Zona 1', SYSDATE, 'A');
INSERT INTO piloto VALUES (2, 'María Elena', 'García Ruiz', '9876543210101', 'LIC-002', 'C', SYSDATE+365, '87654321', 'maria@email.com', 'Zona 10', SYSDATE, 'A');
INSERT INTO piloto VALUES (3, 'Pedro Antonio', 'Martínez Soto', '5555555550101', 'LIC-003', 'C', SYSDATE+365, '55555555', 'pedro@email.com', 'Zona 5', SYSDATE, 'A');

-- RUTAS
INSERT INTO ruta VALUES (1, 1, 2, 'Guatemala - Quetzaltenango', 205, 'S', 'Ruta directa', 'A');
INSERT INTO ruta VALUES (2, 1, 3, 'Guatemala - Escuintla', 60, 'S', 'Ruta directa', 'A');
INSERT INTO ruta VALUES (3, 1, 4, 'Guatemala - Petén', 480, 'N', 'Ruta con escalas', 'A');

-- CLIENTES
INSERT INTO cliente VALUES (1, 'Ana María', 'López Hernández', '1111111110101', '111111-1', '11111111', 'ana@email.com', 'Zona 1', TO_DATE('1990-01-01','YYYY-MM-DD'), SYSDATE, 'A');
INSERT INTO cliente VALUES (2, 'Carlos Alberto', 'Ramírez Cruz', '2222222220101', '222222-2', '22222222', 'carlos@email.com', 'Zona 2', TO_DATE('1985-05-15','YYYY-MM-DD'), SYSDATE, 'A');
INSERT INTO cliente VALUES (3, 'Lucía Fernanda', 'Torres Gómez', '3333333330101', '333333-3', '33333333', 'lucia@email.com', 'Zona 3', TO_DATE('1992-08-20','YYYY-MM-DD'), SYSDATE, 'A');

-- VIAJES
INSERT INTO viaje VALUES (1, 1, 1, 1, SYSDATE+1, SYSTIMESTAMP+1, 240, SYSDATE+1, SYSTIMESTAMP+1+240/1440, 45, 150.00, 'PROGRAMADO', SYSTIMESTAMP);
INSERT INTO viaje VALUES (2, 2, 2, 2, SYSDATE+2, SYSTIMESTAMP+2, 90, SYSDATE+2, SYSTIMESTAMP+2+90/1440, 50, 75.00, 'PROGRAMADO', SYSTIMESTAMP);
INSERT INTO viaje VALUES (3, 3, 3, 3, SYSDATE+3, SYSTIMESTAMP+3, 600, SYSDATE+4, SYSTIMESTAMP+3+600/1440, 40, 350.00, 'PROGRAMADO', SYSTIMESTAMP);

-- TIPO PAGO
INSERT INTO tipo_pago VALUES (1, 'Efectivo', 'Pago en efectivo', 'N', 'A');
INSERT INTO tipo_pago VALUES (2, 'Tarjeta', 'Pago con tarjeta', 'S', 'A');

-- RESERVACIONES
INSERT INTO reservacion VALUES (1, 1, 1, 'RES-001', SYSTIMESTAMP, 2, '1,2', 300.00, 'CONFIRMADA', SYSTIMESTAMP+1, SYSTIMESTAMP);
INSERT INTO reservacion VALUES (2, 2, 2, 'RES-002', SYSTIMESTAMP, 1, '5', 75.00, 'CONFIRMADA', SYSTIMESTAMP+2, SYSTIMESTAMP);
INSERT INTO reservacion VALUES (3, 3, 3, 'RES-003', SYSTIMESTAMP, 3, '10,11,12', 1050.00, 'PENDIENTE', SYSTIMESTAMP+3, NULL);

-- ENCOMIENDAS
INSERT INTO encomienda VALUES (1, 1, 1, 'ENC-001', 'Ana López', 'Carlos Pérez', '12345678', 'Guatemala', 'Quetzaltenango', 'Paquete de documentos', 5.5, SYSDATE+1, 50.00, 'PENDIENTE', SYSTIMESTAMP);
INSERT INTO encomienda VALUES (2, 2, 2, 'ENC-002', 'María García', 'Luis Martínez', '87654321', 'Guatemala', 'Escuintla', 'Caja de ropa', 15.0, SYSDATE+2, 100.00, 'EN_TRANSITO', SYSTIMESTAMP);
INSERT INTO encomienda VALUES (3, 3, 3, 'ENC-003', 'Pedro Torres', 'Sofía Ramírez', '55555555', 'Guatemala', 'Petén', 'Electrodoméstico', 25.0, SYSDATE+3, 200.00, 'PENDIENTE', SYSTIMESTAMP);

-- GUARDAR CAMBIOS
COMMIT;

-- VERIFICAR
SELECT 'DEPARTAMENTOS: ' || COUNT(*) FROM departamento;
SELECT 'BUSES: ' || COUNT(*) FROM bus;
SELECT 'PILOTOS: ' || COUNT(*) FROM piloto;
SELECT 'RUTAS: ' || COUNT(*) FROM ruta;
SELECT 'CLIENTES: ' || COUNT(*) FROM cliente;
SELECT 'VIAJES: ' || COUNT(*) FROM viaje;
SELECT 'RESERVACIONES: ' || COUNT(*) FROM reservacion;
SELECT 'ENCOMIENDAS: ' || COUNT(*) FROM encomienda;

