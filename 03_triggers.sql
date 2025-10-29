-- =====================================================
-- TRIGGERS
-- =====================================================

-- =====================================================
-- TRIGGER: Auditoría de CLIENTE
-- =====================================================
CREATE OR REPLACE TRIGGER trg_audit_cliente
AFTER INSERT OR UPDATE OR DELETE ON cliente
FOR EACH ROW
DECLARE
    v_operacion VARCHAR2(10);
    v_valores_ant CLOB;
    v_valores_new CLOB;
BEGIN
    IF INSERTING THEN
        v_operacion := 'INSERT';
        v_valores_new := 'ID:' || :NEW.id_cliente || ', Nombre:' || :NEW.nombres || ' ' || :NEW.apellidos || ', DPI:' || :NEW.dpi;
    ELSIF UPDATING THEN
        v_operacion := 'UPDATE';
        v_valores_ant := 'ID:' || :OLD.id_cliente || ', Nombre:' || :OLD.nombres || ' ' || :OLD.apellidos || ', Estado:' || :OLD.estado;
        v_valores_new := 'ID:' || :NEW.id_cliente || ', Nombre:' || :NEW.nombres || ' ' || :NEW.apellidos || ', Estado:' || :NEW.estado;
    ELSIF DELETING THEN
        v_operacion := 'DELETE';
        v_valores_ant := 'ID:' || :OLD.id_cliente || ', Nombre:' || :OLD.nombres || ' ' || :OLD.apellidos;
    END IF;
    
    INSERT INTO bitacora (
        id_bitacora, tabla_afectada, operacion, registro_id, 
        valores_anteriores, valores_nuevos, descripcion
    ) VALUES (
        seq_bitacora.NEXTVAL, 'CLIENTE', v_operacion, 
        COALESCE(:NEW.id_cliente, :OLD.id_cliente),
        v_valores_ant, v_valores_new, 
        'Operación ' || v_operacion || ' en tabla CLIENTE'
    );
END;
/

-- =====================================================
-- TRIGGER: Auditoría de RESERVACION
-- =====================================================
CREATE OR REPLACE TRIGGER trg_audit_reservacion
AFTER INSERT OR UPDATE OR DELETE ON reservacion
FOR EACH ROW
DECLARE
    v_operacion VARCHAR2(10);
    v_valores_ant CLOB;
    v_valores_new CLOB;
BEGIN
    IF INSERTING THEN
        v_operacion := 'INSERT';
        v_valores_new := 'Código:' || :NEW.codigo_reservacion || ', Viaje:' || :NEW.id_viaje || ', Estado:' || :NEW.estado;
    ELSIF UPDATING THEN
        v_operacion := 'UPDATE';
        v_valores_ant := 'Código:' || :OLD.codigo_reservacion || ', Estado:' || :OLD.estado;
        v_valores_new := 'Código:' || :NEW.codigo_reservacion || ', Estado:' || :NEW.estado;
    ELSIF DELETING THEN
        v_operacion := 'DELETE';
        v_valores_ant := 'Código:' || :OLD.codigo_reservacion || ', Estado:' || :OLD.estado;
    END IF;
    
    INSERT INTO bitacora (
        id_bitacora, tabla_afectada, operacion, registro_id,
        valores_anteriores, valores_nuevos, descripcion
    ) VALUES (
        seq_bitacora.NEXTVAL, 'RESERVACION', v_operacion,
        COALESCE(:NEW.id_reservacion, :OLD.id_reservacion),
        v_valores_ant, v_valores_new,
        'Operación ' || v_operacion || ' en tabla RESERVACION'
    );
END;
/

-- =====================================================
-- TRIGGER: Auditoría de PAGO
-- =====================================================
CREATE OR REPLACE TRIGGER trg_audit_pago
AFTER INSERT OR UPDATE OR DELETE ON pago
FOR EACH ROW
DECLARE
    v_operacion VARCHAR2(10);
    v_valores_ant CLOB;
    v_valores_new CLOB;
BEGIN
    IF INSERTING THEN
        v_operacion := 'INSERT';
        v_valores_new := 'Monto:' || :NEW.monto || ', Estado:' || :NEW.estado || ', Tipo:' || :NEW.id_tipo_pago;
    ELSIF UPDATING THEN
        v_operacion := 'UPDATE';
        v_valores_ant := 'Estado:' || :OLD.estado || ', Verificado:' || :OLD.verificado_por;
        v_valores_new := 'Estado:' || :NEW.estado || ', Verificado:' || :NEW.verificado_por;
    ELSIF DELETING THEN
        v_operacion := 'DELETE';
        v_valores_ant := 'Monto:' || :OLD.monto || ', Estado:' || :OLD.estado;
    END IF;
    
    INSERT INTO bitacora (
        id_bitacora, tabla_afectada, operacion, registro_id,
        valores_anteriores, valores_nuevos, descripcion
    ) VALUES (
        seq_bitacora.NEXTVAL, 'PAGO', v_operacion,
        COALESCE(:NEW.id_pago, :OLD.id_pago),
        v_valores_ant, v_valores_new,
        'Operación ' || v_operacion || ' en tabla PAGO'
    );
END;
/

-- =====================================================
-- TRIGGER: Auditoría de VIAJE
-- =====================================================
CREATE OR REPLACE TRIGGER trg_audit_viaje
AFTER INSERT OR UPDATE OR DELETE ON viaje
FOR EACH ROW
DECLARE
    v_operacion VARCHAR2(10);
    v_valores_ant CLOB;
    v_valores_new CLOB;
BEGIN
    IF INSERTING THEN
        v_operacion := 'INSERT';
        v_valores_new := 'Ruta:' || :NEW.id_ruta || ', Bus:' || :NEW.id_bus || ', Fecha:' || :NEW.fecha_salida;
    ELSIF UPDATING THEN
        v_operacion := 'UPDATE';
        v_valores_ant := 'Estado:' || :OLD.estado || ', Lugares:' || :OLD.lugares_disponibles;
        v_valores_new := 'Estado:' || :NEW.estado || ', Lugares:' || :NEW.lugares_disponibles;
    ELSIF DELETING THEN
        v_operacion := 'DELETE';
        v_valores_ant := 'Ruta:' || :OLD.id_ruta || ', Estado:' || :OLD.estado;
    END IF;
    
    INSERT INTO bitacora (
        id_bitacora, tabla_afectada, operacion, registro_id,
        valores_anteriores, valores_nuevos, descripcion
    ) VALUES (
        seq_bitacora.NEXTVAL, 'VIAJE', v_operacion,
        COALESCE(:NEW.id_viaje, :OLD.id_viaje),
        v_valores_ant, v_valores_new,
        'Operación ' || v_operacion || ' en tabla VIAJE'
    );
END;
/

-- =====================================================
-- TRIGGER: Actualizar lugares disponibles en viaje
-- =====================================================
CREATE OR REPLACE TRIGGER trg_actualizar_lugares_viaje
AFTER INSERT OR DELETE ON boleto
FOR EACH ROW
DECLARE
    v_id_viaje NUMBER;
BEGIN
    IF INSERTING THEN
        v_id_viaje := :NEW.id_viaje;
        UPDATE viaje 
        SET lugares_disponibles = lugares_disponibles - 1
        WHERE id_viaje = v_id_viaje;
    ELSIF DELETING THEN
        v_id_viaje := :OLD.id_viaje;
        UPDATE viaje 
        SET lugares_disponibles = lugares_disponibles + 1
        WHERE id_viaje = v_id_viaje;
    END IF;
END;
/

-- =====================================================
-- TRIGGER: Validar capacidad del bus antes de insertar viaje
-- =====================================================
CREATE OR REPLACE TRIGGER trg_validar_capacidad_viaje
BEFORE INSERT ON viaje
FOR EACH ROW
DECLARE
    v_capacidad NUMBER;
BEGIN
    SELECT b.capacidad_pasajeros INTO v_capacidad
    FROM bus b
    WHERE b.id_bus = :NEW.id_bus;
    
    :NEW.lugares_disponibles := v_capacidad;
END;
/

-- =====================================================
-- TRIGGER: Generar código de reservación automáticamente
-- =====================================================
CREATE OR REPLACE TRIGGER trg_generar_codigo_reserva
BEFORE INSERT ON reservacion
FOR EACH ROW
BEGIN
    IF :NEW.codigo_reservacion IS NULL THEN
        :NEW.codigo_reservacion := 'RES-' || TO_CHAR(SYSDATE, 'YYYYMMDD') || '-' || LPAD(:NEW.id_reservacion, 6, '0');
    END IF;
    
    -- Establecer fecha de expiración (24 horas)
    IF :NEW.fecha_expiracion IS NULL THEN
        :NEW.fecha_expiracion := SYSTIMESTAMP + INTERVAL '24' HOUR;
    END IF;
END;
/

-- =====================================================
-- TRIGGER: Generar código de boleto automáticamente
-- =====================================================
CREATE OR REPLACE TRIGGER trg_generar_codigo_boleto
BEFORE INSERT ON boleto
FOR EACH ROW
BEGIN
    IF :NEW.codigo_boleto IS NULL THEN
        :NEW.codigo_boleto := 'BOL-' || TO_CHAR(SYSDATE, 'YYYYMMDD') || '-' || LPAD(:NEW.id_boleto, 6, '0');
    END IF;
END;
/

-- =====================================================
-- TRIGGER: Generar código de encomienda automáticamente
-- =====================================================
CREATE OR REPLACE TRIGGER trg_generar_codigo_encom
BEFORE INSERT ON encomienda
FOR EACH ROW
BEGIN
    IF :NEW.codigo_encomienda IS NULL THEN
        :NEW.codigo_encomienda := 'ENC-' || TO_CHAR(SYSDATE, 'YYYYMMDD') || '-' || LPAD(:NEW.id_encomienda, 6, '0');
    END IF;
END;
/

-- =====================================================
-- TRIGGER: Calcular tarifa de encomienda automáticamente
-- =====================================================
CREATE OR REPLACE TRIGGER trg_calcular_tarifa_encom
BEFORE INSERT OR UPDATE ON encomienda
FOR EACH ROW
DECLARE
    v_tarifa_10lb NUMBER;
    v_tarifa_100lb NUMBER;
    v_tarifa_mas100lb NUMBER;
BEGIN
    -- Obtener tarifas de parámetros
    SELECT TO_NUMBER(valor) INTO v_tarifa_10lb 
    FROM parametro WHERE nombre = 'TARIFA_ENCOMIENDA_10LB';
    
    SELECT TO_NUMBER(valor) INTO v_tarifa_100lb 
    FROM parametro WHERE nombre = 'TARIFA_ENCOMIENDA_100LB';
    
    SELECT TO_NUMBER(valor) INTO v_tarifa_mas100lb 
    FROM parametro WHERE nombre = 'TARIFA_ENCOMIENDA_MAS100LB';
    
    -- Calcular tarifa según peso
    IF :NEW.peso_libras <= 10 THEN
        :NEW.tarifa := v_tarifa_10lb;
    ELSIF :NEW.peso_libras <= 100 THEN
        :NEW.tarifa := v_tarifa_100lb;
    ELSE
        :NEW.tarifa := v_tarifa_mas100lb;
    END IF;
END;
/

-- =====================================================
-- TRIGGER: Confirmar reservación al verificar pago
-- =====================================================
CREATE OR REPLACE TRIGGER trg_confirmar_reserva_pago
AFTER UPDATE OF estado ON pago
FOR EACH ROW
WHEN (NEW.estado = 'VERIFICADO' AND OLD.estado = 'PENDIENTE')
BEGIN
    IF :NEW.id_reservacion IS NOT NULL THEN
        UPDATE reservacion
        SET estado = 'CONFIRMADA',
            fecha_confirmacion = SYSTIMESTAMP
        WHERE id_reservacion = :NEW.id_reservacion;
    END IF;
END;
/

-- =====================================================
-- TRIGGER: Validar que no se exceda capacidad del bus
-- =====================================================
CREATE OR REPLACE TRIGGER trg_validar_capacidad_boleto
BEFORE INSERT ON boleto
FOR EACH ROW
DECLARE
    v_lugares_disponibles NUMBER;
BEGIN
    SELECT lugares_disponibles INTO v_lugares_disponibles
    FROM viaje
    WHERE id_viaje = :NEW.id_viaje;
    
    IF v_lugares_disponibles <= 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'No hay lugares disponibles en este viaje');
    END IF;
END;
/

-- =====================================================
-- TRIGGER: Encriptar contraseña de usuario
-- =====================================================
CREATE OR REPLACE TRIGGER trg_encriptar_password
BEFORE INSERT OR UPDATE OF password_hash ON usuario
FOR EACH ROW
BEGIN
    -- Si la contraseña no está encriptada (longitud diferente a SHA-512)
    IF LENGTH(:NEW.password_hash) != 128 THEN
        :NEW.password_hash := DBMS_CRYPTO.HASH(
            UTL_RAW.CAST_TO_RAW(:NEW.password_hash), 
            DBMS_CRYPTO.HASH_SH512
        );
        :NEW.password_hash := RAWTOHEX(:NEW.password_hash);
    END IF;
END;
/

-- =====================================================
-- TRIGGER: Bloquear usuario después de 3 intentos fallidos
-- =====================================================
CREATE OR REPLACE TRIGGER trg_bloquear_usuario
BEFORE UPDATE OF intentos_fallidos ON usuario
FOR EACH ROW
DECLARE
    v_max_intentos NUMBER;
BEGIN
    SELECT TO_NUMBER(valor) INTO v_max_intentos
    FROM parametro WHERE nombre = 'MAX_INTENTOS_LOGIN';
    
    IF :NEW.intentos_fallidos >= v_max_intentos THEN
        :NEW.bloqueado := 'S';
        :NEW.estado := 'I';
    END IF;
END;
/

-- =====================================================
-- TRIGGER: Registrar login en bitácora
-- =====================================================
CREATE OR REPLACE TRIGGER trg_registrar_login
AFTER UPDATE OF ultimo_acceso ON usuario
FOR EACH ROW
BEGIN
    INSERT INTO bitacora (
        id_bitacora, id_usuario, tabla_afectada, operacion,
        registro_id, descripcion
    ) VALUES (
        seq_bitacora.NEXTVAL, :NEW.id_usuario, 'USUARIO', 'LOGIN',
        :NEW.id_usuario, 'Usuario ' || :NEW.username || ' inició sesión'
    );
END;
/

-- =====================================================
-- TRIGGER: Validar fechas de viaje
-- =====================================================
CREATE OR REPLACE TRIGGER trg_validar_fechas_viaje
BEFORE INSERT OR UPDATE ON viaje
FOR EACH ROW
BEGIN
    IF :NEW.fecha_salida < TRUNC(SYSDATE) THEN
        RAISE_APPLICATION_ERROR(-20002, 'La fecha de salida no puede ser anterior a hoy');
    END IF;
    
    IF :NEW.fecha_llegada_estimada < :NEW.fecha_salida THEN
        RAISE_APPLICATION_ERROR(-20003, 'La fecha de llegada no puede ser anterior a la fecha de salida');
    END IF;
END;
/

-- =====================================================
-- TRIGGER: Validar volumen de encomienda
-- =====================================================
CREATE OR REPLACE TRIGGER trg_validar_volumen_encom
BEFORE INSERT OR UPDATE ON encomienda
FOR EACH ROW
BEGIN
    IF :NEW.volumen_m3 >= 1 THEN
        RAISE_APPLICATION_ERROR(-20004, 'El volumen de la encomienda debe ser menor a 1 metro cúbico');
    END IF;
END;
/

-- =====================================================
-- TRIGGER: Actualizar fecha de modificación de parámetros
-- =====================================================
CREATE OR REPLACE TRIGGER trg_actualizar_fecha_param
BEFORE UPDATE ON parametro
FOR EACH ROW
BEGIN
    :NEW.fecha_modificacion := SYSTIMESTAMP;
END;
/

COMMIT;

