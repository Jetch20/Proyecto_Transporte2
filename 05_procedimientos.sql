-- =====================================================
-- PROCEDIMIENTOS ALMACENADOS
-- =====================================================

-- =====================================================
-- PROCEDIMIENTO: Crear reservación
-- =====================================================
CREATE OR REPLACE PROCEDURE sp_crear_reservacion(
    p_id_viaje IN NUMBER,
    p_id_cliente IN NUMBER,
    p_cantidad_pasajeros IN NUMBER,
    p_id_reservacion OUT NUMBER,
    p_codigo_reservacion OUT VARCHAR2,
    p_mensaje OUT VARCHAR2
)
IS
    v_lugares_disponibles NUMBER;
    v_precio_boleto NUMBER;
    v_monto_total NUMBER;
BEGIN
    -- Verificar disponibilidad
    SELECT lugares_disponibles, precio_boleto
    INTO v_lugares_disponibles, v_precio_boleto
    FROM viaje
    WHERE id_viaje = p_id_viaje;
    
    IF v_lugares_disponibles < p_cantidad_pasajeros THEN
        p_mensaje := 'No hay suficientes lugares disponibles';
        RETURN;
    END IF;
    
    -- Calcular monto total
    v_monto_total := v_precio_boleto * p_cantidad_pasajeros;
    
    -- Crear reservación
    p_id_reservacion := seq_reservacion.NEXTVAL;
    
    INSERT INTO reservacion (
        id_reservacion, id_viaje, id_cliente, cantidad_pasajeros, monto_total
    ) VALUES (
        p_id_reservacion, p_id_viaje, p_id_cliente, p_cantidad_pasajeros, v_monto_total
    );
    
    -- Obtener código generado por trigger
    SELECT codigo_reservacion INTO p_codigo_reservacion
    FROM reservacion
    WHERE id_reservacion = p_id_reservacion;
    
    COMMIT;
    p_mensaje := 'Reservación creada exitosamente';
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        ROLLBACK;
        p_mensaje := 'Viaje no encontrado';
    WHEN OTHERS THEN
        ROLLBACK;
        p_mensaje := 'Error al crear reservación: ' || SQLERRM;
END;
/

-- =====================================================
-- PROCEDIMIENTO: Registrar pago
-- =====================================================
CREATE OR REPLACE PROCEDURE sp_registrar_pago(
    p_id_tipo_pago IN NUMBER,
    p_id_reservacion IN NUMBER,
    p_id_encomienda IN NUMBER,
    p_monto IN NUMBER,
    p_numero_transaccion IN VARCHAR2,
    p_imagen_comprobante IN VARCHAR2,
    p_id_pago OUT NUMBER,
    p_mensaje OUT VARCHAR2
)
IS
    v_requiere_verificacion CHAR(1);
    v_estado_pago VARCHAR2(20);
BEGIN
    -- Verificar si el tipo de pago requiere verificación
    SELECT requiere_verificacion INTO v_requiere_verificacion
    FROM tipo_pago
    WHERE id_tipo_pago = p_id_tipo_pago;
    
    IF v_requiere_verificacion = 'S' THEN
        v_estado_pago := 'PENDIENTE';
    ELSE
        v_estado_pago := 'VERIFICADO';
    END IF;
    
    -- Registrar pago
    p_id_pago := seq_pago.NEXTVAL;
    
    INSERT INTO pago (
        id_pago, id_tipo_pago, id_reservacion, id_encomienda,
        monto, numero_transaccion, imagen_comprobante, estado
    ) VALUES (
        p_id_pago, p_id_tipo_pago, p_id_reservacion, p_id_encomienda,
        p_monto, p_numero_transaccion, p_imagen_comprobante, v_estado_pago
    );
    
    -- Si no requiere verificación, confirmar reservación inmediatamente
    IF v_requiere_verificacion = 'N' AND p_id_reservacion IS NOT NULL THEN
        UPDATE reservacion
        SET estado = 'CONFIRMADA',
            fecha_confirmacion = SYSTIMESTAMP
        WHERE id_reservacion = p_id_reservacion;
    END IF;
    
    COMMIT;
    
    IF v_estado_pago = 'VERIFICADO' THEN
        p_mensaje := 'Pago registrado y verificado exitosamente';
    ELSE
        p_mensaje := 'Pago registrado. Pendiente de verificación';
    END IF;
    
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        p_mensaje := 'Error al registrar pago: ' || SQLERRM;
END;
/

-- =====================================================
-- PROCEDIMIENTO: Verificar pago por depósito
-- =====================================================
CREATE OR REPLACE PROCEDURE sp_verificar_pago(
    p_id_pago IN NUMBER,
    p_id_usuario_verificador IN NUMBER,
    p_aprobado IN CHAR,
    p_observaciones IN VARCHAR2,
    p_mensaje OUT VARCHAR2
)
IS
    v_id_reservacion NUMBER;
BEGIN
    -- Obtener ID de reservación
    SELECT id_reservacion INTO v_id_reservacion
    FROM pago
    WHERE id_pago = p_id_pago;
    
    IF p_aprobado = 'S' THEN
        -- Aprobar pago
        UPDATE pago
        SET estado = 'VERIFICADO',
            fecha_verificacion = SYSTIMESTAMP,
            verificado_por = p_id_usuario_verificador,
            observaciones = p_observaciones
        WHERE id_pago = p_id_pago;
        
        -- Confirmar reservación
        IF v_id_reservacion IS NOT NULL THEN
            UPDATE reservacion
            SET estado = 'CONFIRMADA',
                fecha_confirmacion = SYSTIMESTAMP
            WHERE id_reservacion = v_id_reservacion;
        END IF;
        
        p_mensaje := 'Pago verificado y aprobado';
    ELSE
        -- Rechazar pago
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
        p_mensaje := 'Error al verificar pago: ' || SQLERRM;
END;
/

-- =====================================================
-- PROCEDIMIENTO: Emitir boleto
-- =====================================================
CREATE OR REPLACE PROCEDURE sp_emitir_boleto(
    p_id_reservacion IN NUMBER,
    p_nombre_pasajero IN VARCHAR2,
    p_dpi_pasajero IN VARCHAR2,
    p_numero_asiento IN VARCHAR2,
    p_id_boleto OUT NUMBER,
    p_codigo_boleto OUT VARCHAR2,
    p_mensaje OUT VARCHAR2
)
IS
    v_id_viaje NUMBER;
    v_id_cliente NUMBER;
    v_precio NUMBER;
    v_estado_reserva VARCHAR2(20);
BEGIN
    -- Verificar que la reservación esté confirmada
    SELECT id_viaje, id_cliente, estado, monto_total
    INTO v_id_viaje, v_id_cliente, v_estado_reserva, v_precio
    FROM reservacion
    WHERE id_reservacion = p_id_reservacion;
    
    IF v_estado_reserva != 'CONFIRMADA' THEN
        p_mensaje := 'La reservación no está confirmada';
        RETURN;
    END IF;
    
    -- Emitir boleto
    p_id_boleto := seq_boleto.NEXTVAL;
    
    INSERT INTO boleto (
        id_boleto, id_reservacion, id_viaje, id_cliente,
        numero_asiento, nombre_pasajero, dpi_pasajero, precio
    ) VALUES (
        p_id_boleto, p_id_reservacion, v_id_viaje, v_id_cliente,
        p_numero_asiento, p_nombre_pasajero, p_dpi_pasajero, v_precio
    );
    
    -- Obtener código generado
    SELECT codigo_boleto INTO p_codigo_boleto
    FROM boleto
    WHERE id_boleto = p_id_boleto;
    
    COMMIT;
    p_mensaje := 'Boleto emitido exitosamente';
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        ROLLBACK;
        p_mensaje := 'Reservación no encontrada';
    WHEN OTHERS THEN
        ROLLBACK;
        p_mensaje := 'Error al emitir boleto: ' || SQLERRM;
END;
/

-- =====================================================
-- PROCEDIMIENTO: Registrar encomienda
-- =====================================================
CREATE OR REPLACE PROCEDURE sp_registrar_encomienda(
    p_id_viaje IN NUMBER,
    p_id_cliente_remitente IN NUMBER,
    p_nombre_destinatario IN VARCHAR2,
    p_telefono_destinatario IN VARCHAR2,
    p_direccion_destinatario IN VARCHAR2,
    p_descripcion_contenido IN VARCHAR2,
    p_peso_libras IN NUMBER,
    p_volumen_m3 IN NUMBER,
    p_id_encomienda OUT NUMBER,
    p_codigo_encomienda OUT VARCHAR2,
    p_tarifa OUT NUMBER,
    p_mensaje OUT VARCHAR2
)
IS
BEGIN
    -- Validar volumen
    IF p_volumen_m3 >= 1 THEN
        p_mensaje := 'El volumen debe ser menor a 1 metro cúbico';
        RETURN;
    END IF;
    
    -- Calcular tarifa
    p_tarifa := fn_calcular_tarifa_encomienda(p_peso_libras);
    
    -- Registrar encomienda
    p_id_encomienda := seq_encomienda.NEXTVAL;
    
    INSERT INTO encomienda (
        id_encomienda, id_viaje, id_cliente_remitente,
        nombre_destinatario, telefono_destinatario, direccion_destinatario,
        descripcion_contenido, peso_libras, volumen_m3, tarifa
    ) VALUES (
        p_id_encomienda, p_id_viaje, p_id_cliente_remitente,
        p_nombre_destinatario, p_telefono_destinatario, p_direccion_destinatario,
        p_descripcion_contenido, p_peso_libras, p_volumen_m3, p_tarifa
    );
    
    -- Obtener código generado
    SELECT codigo_encomienda INTO p_codigo_encomienda
    FROM encomienda
    WHERE id_encomienda = p_id_encomienda;
    
    COMMIT;
    p_mensaje := 'Encomienda registrada exitosamente';
    
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        p_mensaje := 'Error al registrar encomienda: ' || SQLERRM;
END;
/

-- =====================================================
-- PROCEDIMIENTO: Cancelar reservación
-- =====================================================
CREATE OR REPLACE PROCEDURE sp_cancelar_reservacion(
    p_id_reservacion IN NUMBER,
    p_mensaje OUT VARCHAR2
)
IS
BEGIN
    -- Actualizar estado de reservación
    UPDATE reservacion
    SET estado = 'CANCELADA'
    WHERE id_reservacion = p_id_reservacion;
    
    -- Cancelar boletos asociados
    UPDATE boleto
    SET estado = 'CANCELADO'
    WHERE id_reservacion = p_id_reservacion;
    
    COMMIT;
    p_mensaje := 'Reservación cancelada exitosamente';
    
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        p_mensaje := 'Error al cancelar reservación: ' || SQLERRM;
END;
/

-- =====================================================
-- PROCEDIMIENTO: Expirar reservaciones pendientes
-- =====================================================
CREATE OR REPLACE PROCEDURE sp_expirar_reservaciones
IS
    v_cantidad NUMBER := 0;
BEGIN
    UPDATE reservacion
    SET estado = 'EXPIRADA'
    WHERE estado = 'PENDIENTE'
    AND fecha_expiracion < SYSTIMESTAMP;
    
    v_cantidad := SQL%ROWCOUNT;
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('Reservaciones expiradas: ' || v_cantidad);
    
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error al expirar reservaciones: ' || SQLERRM);
END;
/

-- =====================================================
-- PROCEDIMIENTO: Crear cliente
-- =====================================================
CREATE OR REPLACE PROCEDURE sp_crear_cliente(
    p_nombres IN VARCHAR2,
    p_apellidos IN VARCHAR2,
    p_dpi IN VARCHAR2,
    p_nit IN VARCHAR2,
    p_telefono IN VARCHAR2,
    p_email IN VARCHAR2,
    p_direccion IN VARCHAR2,
    p_fecha_nacimiento IN DATE,
    p_id_cliente OUT NUMBER,
    p_mensaje OUT VARCHAR2
)
IS
BEGIN
    p_id_cliente := seq_cliente.NEXTVAL;
    
    INSERT INTO cliente (
        id_cliente, nombres, apellidos, dpi, nit,
        telefono, email, direccion, fecha_nacimiento
    ) VALUES (
        p_id_cliente, p_nombres, p_apellidos, p_dpi, p_nit,
        p_telefono, p_email, p_direccion, p_fecha_nacimiento
    );
    
    COMMIT;
    p_mensaje := 'Cliente registrado exitosamente';
    
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        ROLLBACK;
        p_mensaje := 'El DPI o Email ya está registrado';
    WHEN OTHERS THEN
        ROLLBACK;
        p_mensaje := 'Error al crear cliente: ' || SQLERRM;
END;
/

-- =====================================================
-- PROCEDIMIENTO: Crear usuario
-- =====================================================
CREATE OR REPLACE PROCEDURE sp_crear_usuario(
    p_id_rol IN NUMBER,
    p_username IN VARCHAR2,
    p_password IN VARCHAR2,
    p_email IN VARCHAR2,
    p_id_cliente IN NUMBER,
    p_id_piloto IN NUMBER,
    p_id_usuario OUT NUMBER,
    p_mensaje OUT VARCHAR2
)
IS
BEGIN
    p_id_usuario := seq_usuario.NEXTVAL;
    
    INSERT INTO usuario (
        id_usuario, id_rol, username, password_hash,
        email, id_cliente, id_piloto
    ) VALUES (
        p_id_usuario, p_id_rol, p_username, p_password,
        p_email, p_id_cliente, p_id_piloto
    );
    
    COMMIT;
    p_mensaje := 'Usuario creado exitosamente';
    
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        ROLLBACK;
        p_mensaje := 'El username o email ya está registrado';
    WHEN OTHERS THEN
        ROLLBACK;
        p_mensaje := 'Error al crear usuario: ' || SQLERRM;
END;
/

-- =====================================================
-- PROCEDIMIENTO: Actualizar estado de encomienda
-- =====================================================
CREATE OR REPLACE PROCEDURE sp_actualizar_estado_encomienda(
    p_id_encomienda IN NUMBER,
    p_nuevo_estado IN VARCHAR2,
    p_observaciones IN VARCHAR2,
    p_mensaje OUT VARCHAR2
)
IS
BEGIN
    UPDATE encomienda
    SET estado = p_nuevo_estado,
        observaciones = p_observaciones,
        fecha_entrega = CASE WHEN p_nuevo_estado = 'ENTREGADA' THEN SYSTIMESTAMP ELSE fecha_entrega END
    WHERE id_encomienda = p_id_encomienda;
    
    COMMIT;
    p_mensaje := 'Estado de encomienda actualizado';
    
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        p_mensaje := 'Error al actualizar encomienda: ' || SQLERRM;
END;
/

-- =====================================================
-- PROCEDIMIENTO: Programar viaje
-- =====================================================
CREATE OR REPLACE PROCEDURE sp_programar_viaje(
    p_id_ruta IN NUMBER,
    p_id_bus IN NUMBER,
    p_id_piloto IN NUMBER,
    p_fecha_salida IN DATE,
    p_hora_salida IN TIMESTAMP,
    p_tiempo_estimado_minutos IN NUMBER,
    p_precio_boleto IN NUMBER,
    p_id_viaje OUT NUMBER,
    p_mensaje OUT VARCHAR2
)
IS
    v_fecha_llegada DATE;
    v_hora_llegada TIMESTAMP;
BEGIN
    -- Calcular fecha y hora de llegada estimada
    v_fecha_llegada := p_fecha_salida;
    v_hora_llegada := p_hora_salida + NUMTODSINTERVAL(p_tiempo_estimado_minutos, 'MINUTE');
    
    p_id_viaje := seq_viaje.NEXTVAL;
    
    INSERT INTO viaje (
        id_viaje, id_ruta, id_bus, id_piloto,
        fecha_salida, hora_salida, tiempo_estimado_minutos,
        fecha_llegada_estimada, hora_llegada_estimada, precio_boleto
    ) VALUES (
        p_id_viaje, p_id_ruta, p_id_bus, p_id_piloto,
        p_fecha_salida, p_hora_salida, p_tiempo_estimado_minutos,
        v_fecha_llegada, v_hora_llegada, p_precio_boleto
    );
    
    COMMIT;
    p_mensaje := 'Viaje programado exitosamente';
    
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        p_mensaje := 'Error al programar viaje: ' || SQLERRM;
END;
/

COMMIT;

