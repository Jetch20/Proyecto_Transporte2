-- =====================================================
-- VISTAS
-- =====================================================

-- =====================================================
-- VISTA: Viajes disponibles con información completa
-- =====================================================
CREATE OR REPLACE VIEW v_viajes_disponibles AS
SELECT 
    v.id_viaje,
    v.fecha_salida,
    v.hora_salida,
    v.tiempo_estimado_minutos,
    v.precio_boleto,
    v.lugares_disponibles,
    v.estado,
    r.nombre_ruta,
    r.es_directo,
    r.distancia_km,
    d_origen.nombre AS departamento_origen,
    d_destino.nombre AS departamento_destino,
    tb.nombre AS tipo_bus,
    b.numero_bus,
    b.placa,
    b.capacidad_pasajeros,
    p.nombres || ' ' || p.apellidos AS nombre_piloto,
    fn_porcentaje_ocupacion(v.id_viaje) AS porcentaje_ocupacion
FROM viaje v
INNER JOIN ruta r ON v.id_ruta = r.id_ruta
INNER JOIN departamento d_origen ON r.id_departamento_origen = d_origen.id_departamento
INNER JOIN departamento d_destino ON r.id_departamento_destino = d_destino.id_departamento
INNER JOIN bus b ON v.id_bus = b.id_bus
INNER JOIN tipo_bus tb ON b.id_tipo_bus = tb.id_tipo_bus
INNER JOIN piloto p ON v.id_piloto = p.id_piloto
WHERE v.estado = 'PROGRAMADO'
AND v.fecha_salida >= TRUNC(SYSDATE);

-- =====================================================
-- VISTA: Reservaciones con información completa
-- =====================================================
CREATE OR REPLACE VIEW v_reservaciones_completas AS
SELECT 
    r.id_reservacion,
    r.codigo_reservacion,
    r.fecha_reservacion,
    r.cantidad_pasajeros,
    r.monto_total,
    r.estado AS estado_reservacion,
    r.fecha_expiracion,
    r.fecha_confirmacion,
    c.nombres || ' ' || c.apellidos AS nombre_cliente,
    c.email AS email_cliente,
    c.telefono AS telefono_cliente,
    v.fecha_salida,
    v.hora_salida,
    d_origen.nombre AS origen,
    d_destino.nombre AS destino,
    rt.nombre_ruta,
    fn_estado_pago_reservacion(r.id_reservacion) AS estado_pago
FROM reservacion r
INNER JOIN cliente c ON r.id_cliente = c.id_cliente
INNER JOIN viaje v ON r.id_viaje = v.id_viaje
INNER JOIN ruta rt ON v.id_ruta = rt.id_ruta
INNER JOIN departamento d_origen ON rt.id_departamento_origen = d_origen.id_departamento
INNER JOIN departamento d_destino ON rt.id_departamento_destino = d_destino.id_departamento;

-- =====================================================
-- VISTA: Boletos emitidos
-- =====================================================
CREATE OR REPLACE VIEW v_boletos_emitidos AS
SELECT 
    b.id_boleto,
    b.codigo_boleto,
    b.numero_asiento,
    b.nombre_pasajero,
    b.dpi_pasajero,
    b.fecha_emision,
    b.precio,
    b.estado AS estado_boleto,
    r.codigo_reservacion,
    c.nombres || ' ' || c.apellidos AS nombre_cliente,
    v.fecha_salida,
    v.hora_salida,
    d_origen.nombre AS origen,
    d_destino.nombre AS destino,
    rt.nombre_ruta,
    bus.numero_bus,
    bus.placa
FROM boleto b
INNER JOIN reservacion r ON b.id_reservacion = r.id_reservacion
INNER JOIN cliente c ON b.id_cliente = c.id_cliente
INNER JOIN viaje v ON b.id_viaje = v.id_viaje
INNER JOIN ruta rt ON v.id_ruta = rt.id_ruta
INNER JOIN departamento d_origen ON rt.id_departamento_origen = d_origen.id_departamento
INNER JOIN departamento d_destino ON rt.id_departamento_destino = d_destino.id_departamento
INNER JOIN bus ON v.id_bus = bus.id_bus;

-- =====================================================
-- VISTA: Encomiendas con información completa
-- =====================================================
CREATE OR REPLACE VIEW v_encomiendas_completas AS
SELECT 
    e.id_encomienda,
    e.codigo_encomienda,
    e.nombre_destinatario,
    e.telefono_destinatario,
    e.direccion_destinatario,
    e.descripcion_contenido,
    e.peso_libras,
    e.volumen_m3,
    e.tarifa,
    e.fecha_registro,
    e.fecha_entrega,
    e.estado AS estado_encomienda,
    c.nombres || ' ' || c.apellidos AS nombre_remitente,
    c.telefono AS telefono_remitente,
    v.fecha_salida,
    d_origen.nombre AS origen,
    d_destino.nombre AS destino,
    rt.nombre_ruta
FROM encomienda e
INNER JOIN cliente c ON e.id_cliente_remitente = c.id_cliente
INNER JOIN viaje v ON e.id_viaje = v.id_viaje
INNER JOIN ruta rt ON v.id_ruta = rt.id_ruta
INNER JOIN departamento d_origen ON rt.id_departamento_origen = d_origen.id_departamento
INNER JOIN departamento d_destino ON rt.id_departamento_destino = d_destino.id_departamento;

-- =====================================================
-- VISTA: Pagos pendientes de verificación
-- =====================================================
CREATE OR REPLACE VIEW v_pagos_pendientes AS
SELECT 
    p.id_pago,
    p.monto,
    p.fecha_pago,
    p.numero_transaccion,
    p.imagen_comprobante,
    p.observaciones,
    tp.nombre AS tipo_pago,
    r.codigo_reservacion,
    r.monto_total AS monto_reservacion,
    c.nombres || ' ' || c.apellidos AS nombre_cliente,
    c.email AS email_cliente,
    c.telefono AS telefono_cliente
FROM pago p
INNER JOIN tipo_pago tp ON p.id_tipo_pago = tp.id_tipo_pago
LEFT JOIN reservacion r ON p.id_reservacion = r.id_reservacion
LEFT JOIN cliente c ON r.id_cliente = c.id_cliente
WHERE p.estado = 'PENDIENTE';

-- =====================================================
-- VISTA: Ingresos por viaje
-- =====================================================
CREATE OR REPLACE VIEW v_ingresos_por_viaje AS
SELECT 
    v.id_viaje,
    v.fecha_salida,
    d_origen.nombre AS origen,
    d_destino.nombre AS destino,
    rt.nombre_ruta,
    v.estado,
    COUNT(DISTINCT b.id_boleto) AS total_boletos_vendidos,
    COUNT(DISTINCT e.id_encomienda) AS total_encomiendas,
    NVL(SUM(b.precio), 0) AS ingresos_boletos,
    NVL(SUM(e.tarifa), 0) AS ingresos_encomiendas,
    NVL(SUM(b.precio), 0) + NVL(SUM(e.tarifa), 0) AS ingresos_totales,
    bus.capacidad_pasajeros,
    v.lugares_disponibles,
    fn_porcentaje_ocupacion(v.id_viaje) AS porcentaje_ocupacion
FROM viaje v
INNER JOIN ruta rt ON v.id_ruta = rt.id_ruta
INNER JOIN departamento d_origen ON rt.id_departamento_origen = d_origen.id_departamento
INNER JOIN departamento d_destino ON rt.id_departamento_destino = d_destino.id_departamento
INNER JOIN bus ON v.id_bus = bus.id_bus
LEFT JOIN boleto b ON v.id_viaje = b.id_viaje AND b.estado = 'ACTIVO'
LEFT JOIN encomienda e ON v.id_viaje = e.id_viaje AND e.estado IN ('REGISTRADA', 'EN_TRANSITO', 'ENTREGADA')
GROUP BY 
    v.id_viaje, v.fecha_salida, d_origen.nombre, d_destino.nombre,
    rt.nombre_ruta, v.estado, bus.capacidad_pasajeros, v.lugares_disponibles;

-- =====================================================
-- VISTA: Rutas más utilizadas
-- =====================================================
CREATE OR REPLACE VIEW v_rutas_mas_utilizadas AS
SELECT 
    r.id_ruta,
    r.nombre_ruta,
    d_origen.nombre AS origen,
    d_destino.nombre AS destino,
    r.distancia_km,
    r.es_directo,
    COUNT(v.id_viaje) AS total_viajes,
    COUNT(DISTINCT b.id_boleto) AS total_boletos_vendidos,
    NVL(SUM(b.precio), 0) AS ingresos_totales
FROM ruta r
INNER JOIN departamento d_origen ON r.id_departamento_origen = d_origen.id_departamento
INNER JOIN departamento d_destino ON r.id_departamento_destino = d_destino.id_departamento
LEFT JOIN viaje v ON r.id_ruta = v.id_ruta
LEFT JOIN boleto b ON v.id_viaje = b.id_viaje AND b.estado = 'ACTIVO'
WHERE r.estado = 'A'
GROUP BY 
    r.id_ruta, r.nombre_ruta, d_origen.nombre, d_destino.nombre,
    r.distancia_km, r.es_directo
ORDER BY total_boletos_vendidos DESC;

-- =====================================================
-- VISTA: Top 10 clientes frecuentes
-- =====================================================
CREATE OR REPLACE VIEW v_top_clientes AS
SELECT 
    c.id_cliente,
    c.nombres || ' ' || c.apellidos AS nombre_completo,
    c.email,
    c.telefono,
    COUNT(DISTINCT r.id_reservacion) AS total_reservaciones,
    COUNT(DISTINCT b.id_boleto) AS total_boletos,
    COUNT(DISTINCT e.id_encomienda) AS total_encomiendas,
    NVL(SUM(b.precio), 0) + NVL(SUM(e.tarifa), 0) AS gasto_total
FROM cliente c
LEFT JOIN reservacion r ON c.id_cliente = r.id_cliente
LEFT JOIN boleto b ON c.id_cliente = b.id_cliente AND b.estado = 'ACTIVO'
LEFT JOIN encomienda e ON c.id_cliente = e.id_cliente_remitente
WHERE c.estado = 'A'
GROUP BY 
    c.id_cliente, c.nombres, c.apellidos, c.email, c.telefono
ORDER BY gasto_total DESC;

-- =====================================================
-- VISTA: Buses con mayor ocupación
-- =====================================================
CREATE OR REPLACE VIEW v_buses_ocupacion AS
SELECT 
    b.id_bus,
    b.numero_bus,
    b.placa,
    tb.nombre AS tipo_bus,
    b.capacidad_pasajeros,
    COUNT(v.id_viaje) AS total_viajes,
    NVL(AVG(fn_porcentaje_ocupacion(v.id_viaje)), 0) AS promedio_ocupacion,
    NVL(SUM(fn_total_ingresos_viaje(v.id_viaje)), 0) AS ingresos_totales
FROM bus b
INNER JOIN tipo_bus tb ON b.id_tipo_bus = tb.id_tipo_bus
LEFT JOIN viaje v ON b.id_bus = v.id_bus
WHERE b.estado = 'ACTIVO'
GROUP BY 
    b.id_bus, b.numero_bus, b.placa, tb.nombre, b.capacidad_pasajeros
ORDER BY promedio_ocupacion DESC;

-- =====================================================
-- VISTA: Estadísticas de encomiendas por destino
-- =====================================================
CREATE OR REPLACE VIEW v_estadisticas_encomiendas AS
SELECT 
    d.id_departamento,
    d.nombre AS departamento_destino,
    COUNT(e.id_encomienda) AS total_encomiendas,
    NVL(SUM(e.peso_libras), 0) AS peso_total_libras,
    NVL(SUM(e.tarifa), 0) AS ingresos_totales,
    NVL(AVG(e.peso_libras), 0) AS peso_promedio
FROM departamento d
LEFT JOIN ruta r ON d.id_departamento = r.id_departamento_destino
LEFT JOIN viaje v ON r.id_ruta = v.id_ruta
LEFT JOIN encomienda e ON v.id_viaje = e.id_viaje
WHERE d.estado = 'A'
GROUP BY d.id_departamento, d.nombre
ORDER BY total_encomiendas DESC;

-- =====================================================
-- VISTA: Usuarios con permisos
-- =====================================================
CREATE OR REPLACE VIEW v_usuarios_permisos AS
SELECT 
    u.id_usuario,
    u.username,
    u.email,
    u.estado,
    r.nombre AS rol,
    p.nombre AS permiso,
    p.modulo,
    p.accion
FROM usuario u
INNER JOIN rol r ON u.id_rol = r.id_rol
INNER JOIN rol_permiso rp ON r.id_rol = rp.id_rol
INNER JOIN permiso p ON rp.id_permiso = p.id_permiso
WHERE u.estado = 'A';

-- =====================================================
-- VISTA: Bitácora con información de usuario
-- =====================================================
CREATE OR REPLACE VIEW v_bitacora_auditoria AS
SELECT 
    b.id_bitacora,
    b.fecha_hora,
    u.username,
    u.email,
    r.nombre AS rol,
    b.tabla_afectada,
    b.operacion,
    b.registro_id,
    b.descripcion,
    b.ip_address
FROM bitacora b
LEFT JOIN usuario u ON b.id_usuario = u.id_usuario
LEFT JOIN rol r ON u.id_rol = r.id_rol
ORDER BY b.fecha_hora DESC;

COMMIT;

