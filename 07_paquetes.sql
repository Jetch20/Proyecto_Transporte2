-- =====================================================
-- PAQUETES PL/SQL
-- =====================================================

-- =====================================================
-- PAQUETE: Gestión de Reservaciones
-- =====================================================
CREATE OR REPLACE PACKAGE pkg_reservaciones AS
    -- Procedimientos públicos
    PROCEDURE crear_reservacion(
        p_id_viaje IN NUMBER,
        p_id_cliente IN NUMBER,
        p_cantidad_pasajeros IN NUMBER,
        p_id_reservacion OUT NUMBER,
        p_codigo_reservacion OUT VARCHAR2,
        p_mensaje OUT VARCHAR2
    );
    
    PROCEDURE confirmar_reservacion(
        p_id_reservacion IN NUMBER,
        p_mensaje OUT VARCHAR2
    );
    
    PROCEDURE cancelar_reservacion(
        p_id_reservacion IN NUMBER,
        p_mensaje OUT VARCHAR2
    );
    
    PROCEDURE expirar_reservaciones_pendientes;
    
    -- Funciones públicas
    FUNCTION obtener_estado_reservacion(
        p_id_reservacion IN NUMBER
    ) RETURN VARCHAR2;
    
    FUNCTION contar_reservaciones_cliente(
        p_id_cliente IN NUMBER
    ) RETURN NUMBER;
END pkg_reservaciones;
/

CREATE OR REPLACE PACKAGE BODY pkg_reservaciones AS
    
    PROCEDURE crear_reservacion(
        p_id_viaje IN NUMBER,
        p_id_cliente IN NUMBER,
        p_cantidad_pasajeros IN NUMBER,
        p_id_reservacion OUT NUMBER,
        p_codigo_reservacion OUT VARCHAR2,
        p_mensaje OUT VARCHAR2
    ) IS
        v_lugares_disponibles NUMBER;
        v_precio_boleto NUMBER;
        v_monto_total NUMBER;
    BEGIN
        SELECT lugares_disponibles, precio_boleto
        INTO v_lugares_disponibles, v_precio_boleto
        FROM viaje
        WHERE id_viaje = p_id_viaje;
        
        IF v_lugares_disponibles < p_cantidad_pasajeros THEN
            p_mensaje := 'No hay suficientes lugares disponibles';
            RETURN;
        END IF;
        
        v_monto_total := v_precio_boleto * p_cantidad_pasajeros;
        p_id_reservacion := seq_reservacion.NEXTVAL;
        
        INSERT INTO reservacion (
            id_reservacion, id_viaje, id_cliente, cantidad_pasajeros, monto_total
        ) VALUES (
            p_id_reservacion, p_id_viaje, p_id_cliente, p_cantidad_pasajeros, v_monto_total
        );
        
        SELECT codigo_reservacion INTO p_codigo_reservacion
        FROM reservacion WHERE id_reservacion = p_id_reservacion;
        
        COMMIT;
        p_mensaje := 'Reservación creada exitosamente';
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            p_mensaje := 'Error: ' || SQLERRM;
    END crear_reservacion;
    
    PROCEDURE confirmar_reservacion(
        p_id_reservacion IN NUMBER,
        p_mensaje OUT VARCHAR2
    ) IS
    BEGIN
        UPDATE reservacion
        SET estado = 'CONFIRMADA',
            fecha_confirmacion = SYSTIMESTAMP
        WHERE id_reservacion = p_id_reservacion;
        
        COMMIT;
        p_mensaje := 'Reservación confirmada';
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            p_mensaje := 'Error: ' || SQLERRM;
    END confirmar_reservacion;
    
    PROCEDURE cancelar_reservacion(
        p_id_reservacion IN NUMBER,
        p_mensaje OUT VARCHAR2
    ) IS
    BEGIN
        UPDATE reservacion SET estado = 'CANCELADA'
        WHERE id_reservacion = p_id_reservacion;
        
        UPDATE boleto SET estado = 'CANCELADO'
        WHERE id_reservacion = p_id_reservacion;
        
        COMMIT;
        p_mensaje := 'Reservación cancelada';
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            p_mensaje := 'Error: ' || SQLERRM;
    END cancelar_reservacion;
    
    PROCEDURE expirar_reservaciones_pendientes IS
        v_cantidad NUMBER := 0;
    BEGIN
        UPDATE reservacion
        SET estado = 'EXPIRADA'
        WHERE estado = 'PENDIENTE'
        AND fecha_expiracion < SYSTIMESTAMP;
        
        v_cantidad := SQL%ROWCOUNT;
        COMMIT;
        
        DBMS_OUTPUT.PUT_LINE('Reservaciones expiradas: ' || v_cantidad);
    END expirar_reservaciones_pendientes;
    
    FUNCTION obtener_estado_reservacion(
        p_id_reservacion IN NUMBER
    ) RETURN VARCHAR2 IS
        v_estado VARCHAR2(20);
    BEGIN
        SELECT estado INTO v_estado
        FROM reservacion
        WHERE id_reservacion = p_id_reservacion;
        
        RETURN v_estado;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN 'NO_EXISTE';
    END obtener_estado_reservacion;
    
    FUNCTION contar_reservaciones_cliente(
        p_id_cliente IN NUMBER
    ) RETURN NUMBER IS
        v_cantidad NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_cantidad
        FROM reservacion
        WHERE id_cliente = p_id_cliente;
        
        RETURN v_cantidad;
    END contar_reservaciones_cliente;
    
END pkg_reservaciones;
/

-- =====================================================
-- PAQUETE: Gestión de Pagos
-- =====================================================
CREATE OR REPLACE PACKAGE pkg_pagos AS
    PROCEDURE registrar_pago(
        p_id_tipo_pago IN NUMBER,
        p_id_reservacion IN NUMBER,
        p_id_encomienda IN NUMBER,
        p_monto IN NUMBER,
        p_numero_transaccion IN VARCHAR2,
        p_imagen_comprobante IN VARCHAR2,
        p_id_pago OUT NUMBER,
        p_mensaje OUT VARCHAR2
    );
    
    PROCEDURE verificar_pago(
        p_id_pago IN NUMBER,
        p_id_usuario_verificador IN NUMBER,
        p_aprobado IN CHAR,
        p_observaciones IN VARCHAR2,
        p_mensaje OUT VARCHAR2
    );
    
    FUNCTION obtener_total_pagado(
        p_id_reservacion IN NUMBER
    ) RETURN NUMBER;
END pkg_pagos;
/

CREATE OR REPLACE PACKAGE BODY pkg_pagos AS
    
    PROCEDURE registrar_pago(
        p_id_tipo_pago IN NUMBER,
        p_id_reservacion IN NUMBER,
        p_id_encomienda IN NUMBER,
        p_monto IN NUMBER,
        p_numero_transaccion IN VARCHAR2,
        p_imagen_comprobante IN VARCHAR2,
        p_id_pago OUT NUMBER,
        p_mensaje OUT VARCHAR2
    ) IS
        v_requiere_verificacion CHAR(1);
        v_estado_pago VARCHAR2(20);
    BEGIN
        SELECT requiere_verificacion INTO v_requiere_verificacion
        FROM tipo_pago WHERE id_tipo_pago = p_id_tipo_pago;
        
        v_estado_pago := CASE WHEN v_requiere_verificacion = 'S' THEN 'PENDIENTE' ELSE 'VERIFICADO' END;
        
        p_id_pago := seq_pago.NEXTVAL;
        
        INSERT INTO pago (
            id_pago, id_tipo_pago, id_reservacion, id_encomienda,
            monto, numero_transaccion, imagen_comprobante, estado
        ) VALUES (
            p_id_pago, p_id_tipo_pago, p_id_reservacion, p_id_encomienda,
            p_monto, p_numero_transaccion, p_imagen_comprobante, v_estado_pago
        );
        
        IF v_requiere_verificacion = 'N' AND p_id_reservacion IS NOT NULL THEN
            UPDATE reservacion
            SET estado = 'CONFIRMADA', fecha_confirmacion = SYSTIMESTAMP
            WHERE id_reservacion = p_id_reservacion;
        END IF;
        
        COMMIT;
        p_mensaje := 'Pago registrado exitosamente';
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            p_mensaje := 'Error: ' || SQLERRM;
    END registrar_pago;
    
    PROCEDURE verificar_pago(
        p_id_pago IN NUMBER,
        p_id_usuario_verificador IN NUMBER,
        p_aprobado IN CHAR,
        p_observaciones IN VARCHAR2,
        p_mensaje OUT VARCHAR2
    ) IS
        v_id_reservacion NUMBER;
    BEGIN
        SELECT id_reservacion INTO v_id_reservacion
        FROM pago WHERE id_pago = p_id_pago;
        
        IF p_aprobado = 'S' THEN
            UPDATE pago
            SET estado = 'VERIFICADO',
                fecha_verificacion = SYSTIMESTAMP,
                verificado_por = p_id_usuario_verificador,
                observaciones = p_observaciones
            WHERE id_pago = p_id_pago;
            
            IF v_id_reservacion IS NOT NULL THEN
                UPDATE reservacion
                SET estado = 'CONFIRMADA', fecha_confirmacion = SYSTIMESTAMP
                WHERE id_reservacion = v_id_reservacion;
            END IF;
            
            p_mensaje := 'Pago verificado y aprobado';
        ELSE
            UPDATE pago
            SET estado = 'RECHAZADO',
                fecha_verificacion = SYSTIMESTAMP,
                verificado_por = p_id_usuario_verificador,
                observaciones = p_observaciones
            WHERE id_pago = p_id_pago;
            
            p_mensaje := 'Pago rechazado';
        END IF;
        
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            p_mensaje := 'Error: ' || SQLERRM;
    END verificar_pago;
    
    FUNCTION obtener_total_pagado(
        p_id_reservacion IN NUMBER
    ) RETURN NUMBER IS
        v_total NUMBER;
    BEGIN
        SELECT NVL(SUM(monto), 0) INTO v_total
        FROM pago
        WHERE id_reservacion = p_id_reservacion
        AND estado = 'VERIFICADO';
        
        RETURN v_total;
    END obtener_total_pagado;
    
END pkg_pagos;
/

-- =====================================================
-- PAQUETE: Reportes y Estadísticas
-- =====================================================
CREATE OR REPLACE PACKAGE pkg_reportes AS
    TYPE t_cursor IS REF CURSOR;
    
    PROCEDURE reporte_ingresos_por_periodo(
        p_fecha_inicio IN DATE,
        p_fecha_fin IN DATE,
        p_cursor OUT t_cursor
    );
    
    PROCEDURE reporte_top_clientes(
        p_limite IN NUMBER,
        p_cursor OUT t_cursor
    );
    
    PROCEDURE reporte_rutas_populares(
        p_cursor OUT t_cursor
    );
    
    FUNCTION calcular_ingresos_totales(
        p_fecha_inicio IN DATE,
        p_fecha_fin IN DATE
    ) RETURN NUMBER;
END pkg_reportes;
/

CREATE OR REPLACE PACKAGE BODY pkg_reportes AS
    
    PROCEDURE reporte_ingresos_por_periodo(
        p_fecha_inicio IN DATE,
        p_fecha_fin IN DATE,
        p_cursor OUT t_cursor
    ) IS
    BEGIN
        OPEN p_cursor FOR
        SELECT 
            v.fecha_salida,
            d_origen.nombre AS origen,
            d_destino.nombre AS destino,
            COUNT(DISTINCT b.id_boleto) AS total_boletos,
            COUNT(DISTINCT e.id_encomienda) AS total_encomiendas,
            NVL(SUM(b.precio), 0) AS ingresos_boletos,
            NVL(SUM(e.tarifa), 0) AS ingresos_encomiendas,
            NVL(SUM(b.precio), 0) + NVL(SUM(e.tarifa), 0) AS ingresos_totales
        FROM viaje v
        INNER JOIN ruta r ON v.id_ruta = r.id_ruta
        INNER JOIN departamento d_origen ON r.id_departamento_origen = d_origen.id_departamento
        INNER JOIN departamento d_destino ON r.id_departamento_destino = d_destino.id_departamento
        LEFT JOIN boleto b ON v.id_viaje = b.id_viaje AND b.estado = 'ACTIVO'
        LEFT JOIN encomienda e ON v.id_viaje = e.id_viaje
        WHERE v.fecha_salida BETWEEN p_fecha_inicio AND p_fecha_fin
        GROUP BY v.fecha_salida, d_origen.nombre, d_destino.nombre
        ORDER BY v.fecha_salida DESC;
    END reporte_ingresos_por_periodo;
    
    PROCEDURE reporte_top_clientes(
        p_limite IN NUMBER,
        p_cursor OUT t_cursor
    ) IS
    BEGIN
        OPEN p_cursor FOR
        SELECT * FROM (
            SELECT 
                c.id_cliente,
                c.nombres || ' ' || c.apellidos AS nombre_completo,
                c.email,
                COUNT(DISTINCT r.id_reservacion) AS total_reservaciones,
                NVL(SUM(b.precio), 0) + NVL(SUM(e.tarifa), 0) AS gasto_total
            FROM cliente c
            LEFT JOIN reservacion r ON c.id_cliente = r.id_cliente
            LEFT JOIN boleto b ON c.id_cliente = b.id_cliente
            LEFT JOIN encomienda e ON c.id_cliente = e.id_cliente_remitente
            GROUP BY c.id_cliente, c.nombres, c.apellidos, c.email
            ORDER BY gasto_total DESC
        )
        WHERE ROWNUM <= p_limite;
    END reporte_top_clientes;
    
    PROCEDURE reporte_rutas_populares(
        p_cursor OUT t_cursor
    ) IS
    BEGIN
        OPEN p_cursor FOR
        SELECT 
            r.nombre_ruta,
            d_origen.nombre AS origen,
            d_destino.nombre AS destino,
            COUNT(v.id_viaje) AS total_viajes,
            COUNT(DISTINCT b.id_boleto) AS total_boletos,
            NVL(SUM(b.precio), 0) AS ingresos_totales
        FROM ruta r
        INNER JOIN departamento d_origen ON r.id_departamento_origen = d_origen.id_departamento
        INNER JOIN departamento d_destino ON r.id_departamento_destino = d_destino.id_departamento
        LEFT JOIN viaje v ON r.id_ruta = v.id_ruta
        LEFT JOIN boleto b ON v.id_viaje = b.id_viaje AND b.estado = 'ACTIVO'
        GROUP BY r.nombre_ruta, d_origen.nombre, d_destino.nombre
        ORDER BY total_boletos DESC;
    END reporte_rutas_populares;
    
    FUNCTION calcular_ingresos_totales(
        p_fecha_inicio IN DATE,
        p_fecha_fin IN DATE
    ) RETURN NUMBER IS
        v_total NUMBER;
    BEGIN
        SELECT 
            NVL(SUM(b.precio), 0) + NVL(SUM(e.tarifa), 0)
        INTO v_total
        FROM viaje v
        LEFT JOIN boleto b ON v.id_viaje = b.id_viaje AND b.estado = 'ACTIVO'
        LEFT JOIN encomienda e ON v.id_viaje = e.id_viaje
        WHERE v.fecha_salida BETWEEN p_fecha_inicio AND p_fecha_fin;
        
        RETURN v_total;
    END calcular_ingresos_totales;
    
END pkg_reportes;
/

COMMIT;

