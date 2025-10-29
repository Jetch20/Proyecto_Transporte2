-- =====================================================
-- FUNCIONES
-- =====================================================

-- =====================================================
-- FUNCIÓN: Calcular tarifa de encomienda
-- =====================================================
CREATE OR REPLACE FUNCTION fn_calcular_tarifa_encomienda(
    p_peso_libras IN NUMBER
) RETURN NUMBER
IS
    v_tarifa NUMBER;
BEGIN
    IF p_peso_libras <= 10 THEN
        SELECT TO_NUMBER(valor) INTO v_tarifa 
        FROM parametro WHERE nombre = 'TARIFA_ENCOMIENDA_10LB';
    ELSIF p_peso_libras <= 100 THEN
        SELECT TO_NUMBER(valor) INTO v_tarifa 
        FROM parametro WHERE nombre = 'TARIFA_ENCOMIENDA_100LB';
    ELSE
        SELECT TO_NUMBER(valor) INTO v_tarifa 
        FROM parametro WHERE nombre = 'TARIFA_ENCOMIENDA_MAS100LB';
    END IF;
    
    RETURN v_tarifa;
EXCEPTION
    WHEN OTHERS THEN
        RETURN 0;
END;
/

-- =====================================================
-- FUNCIÓN: Verificar disponibilidad de lugares en viaje
-- =====================================================
CREATE OR REPLACE FUNCTION fn_verificar_disponibilidad(
    p_id_viaje IN NUMBER,
    p_cantidad_pasajeros IN NUMBER
) RETURN VARCHAR2
IS
    v_lugares_disponibles NUMBER;
BEGIN
    SELECT lugares_disponibles INTO v_lugares_disponibles
    FROM viaje
    WHERE id_viaje = p_id_viaje;
    
    IF v_lugares_disponibles >= p_cantidad_pasajeros THEN
        RETURN 'DISPONIBLE';
    ELSE
        RETURN 'NO_DISPONIBLE';
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 'VIAJE_NO_EXISTE';
    WHEN OTHERS THEN
        RETURN 'ERROR';
END;
/

-- =====================================================
-- FUNCIÓN: Generar código único
-- =====================================================
CREATE OR REPLACE FUNCTION fn_generar_codigo(
    p_prefijo IN VARCHAR2,
    p_secuencia IN NUMBER
) RETURN VARCHAR2
IS
BEGIN
    RETURN p_prefijo || '-' || TO_CHAR(SYSDATE, 'YYYYMMDD') || '-' || LPAD(p_secuencia, 6, '0');
END;
/

-- =====================================================
-- FUNCIÓN: Validar credenciales de usuario
-- =====================================================
CREATE OR REPLACE FUNCTION fn_validar_credenciales(
    p_username IN VARCHAR2,
    p_password IN VARCHAR2
) RETURN NUMBER
IS
    v_id_usuario NUMBER;
    v_password_hash VARCHAR2(256);
    v_bloqueado CHAR(1);
    v_estado CHAR(1);
BEGIN
    -- Encriptar password ingresado
    v_password_hash := RAWTOHEX(DBMS_CRYPTO.HASH(
        UTL_RAW.CAST_TO_RAW(p_password), 
        DBMS_CRYPTO.HASH_SH512
    ));
    
    -- Buscar usuario
    SELECT id_usuario, bloqueado, estado
    INTO v_id_usuario, v_bloqueado, v_estado
    FROM usuario
    WHERE username = p_username
    AND password_hash = v_password_hash;
    
    -- Verificar si está bloqueado o inactivo
    IF v_bloqueado = 'S' THEN
        RETURN -1; -- Usuario bloqueado
    ELSIF v_estado = 'I' THEN
        RETURN -2; -- Usuario inactivo
    ELSE
        -- Actualizar último acceso y resetear intentos fallidos
        UPDATE usuario
        SET ultimo_acceso = SYSTIMESTAMP,
            intentos_fallidos = 0
        WHERE id_usuario = v_id_usuario;
        
        RETURN v_id_usuario; -- Login exitoso
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        -- Incrementar intentos fallidos si el usuario existe
        BEGIN
            UPDATE usuario
            SET intentos_fallidos = intentos_fallidos + 1
            WHERE username = p_username;
            COMMIT;
        EXCEPTION
            WHEN OTHERS THEN
                NULL;
        END;
        RETURN 0; -- Credenciales inválidas
    WHEN OTHERS THEN
        RETURN -99; -- Error del sistema
END;
/

-- =====================================================
-- FUNCIÓN: Obtener nombre completo de cliente
-- =====================================================
CREATE OR REPLACE FUNCTION fn_nombre_completo_cliente(
    p_id_cliente IN NUMBER
) RETURN VARCHAR2
IS
    v_nombre_completo VARCHAR2(200);
BEGIN
    SELECT nombres || ' ' || apellidos
    INTO v_nombre_completo
    FROM cliente
    WHERE id_cliente = p_id_cliente;
    
    RETURN v_nombre_completo;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 'Cliente no encontrado';
    WHEN OTHERS THEN
        RETURN 'Error';
END;
/

-- =====================================================
-- FUNCIÓN: Calcular total de ingresos por viaje
-- =====================================================
CREATE OR REPLACE FUNCTION fn_total_ingresos_viaje(
    p_id_viaje IN NUMBER
) RETURN NUMBER
IS
    v_total_boletos NUMBER := 0;
    v_total_encomiendas NUMBER := 0;
    v_total NUMBER := 0;
BEGIN
    -- Sumar ingresos de boletos
    SELECT NVL(SUM(precio), 0) INTO v_total_boletos
    FROM boleto
    WHERE id_viaje = p_id_viaje
    AND estado = 'ACTIVO';
    
    -- Sumar ingresos de encomiendas
    SELECT NVL(SUM(tarifa), 0) INTO v_total_encomiendas
    FROM encomienda
    WHERE id_viaje = p_id_viaje
    AND estado IN ('REGISTRADA', 'EN_TRANSITO', 'ENTREGADA');
    
    v_total := v_total_boletos + v_total_encomiendas;
    
    RETURN v_total;
EXCEPTION
    WHEN OTHERS THEN
        RETURN 0;
END;
/

-- =====================================================
-- FUNCIÓN: Verificar si usuario tiene permiso
-- =====================================================
CREATE OR REPLACE FUNCTION fn_verificar_permiso(
    p_id_usuario IN NUMBER,
    p_nombre_permiso IN VARCHAR2
) RETURN VARCHAR2
IS
    v_tiene_permiso NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_tiene_permiso
    FROM usuario u
    INNER JOIN rol r ON u.id_rol = r.id_rol
    INNER JOIN rol_permiso rp ON r.id_rol = rp.id_rol
    INNER JOIN permiso p ON rp.id_permiso = p.id_permiso
    WHERE u.id_usuario = p_id_usuario
    AND p.nombre = p_nombre_permiso;
    
    IF v_tiene_permiso > 0 THEN
        RETURN 'S';
    ELSE
        RETURN 'N';
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        RETURN 'N';
END;
/

-- =====================================================
-- FUNCIÓN: Calcular porcentaje de ocupación de viaje
-- =====================================================
CREATE OR REPLACE FUNCTION fn_porcentaje_ocupacion(
    p_id_viaje IN NUMBER
) RETURN NUMBER
IS
    v_capacidad NUMBER;
    v_lugares_disponibles NUMBER;
    v_porcentaje NUMBER;
BEGIN
    SELECT b.capacidad_pasajeros, v.lugares_disponibles
    INTO v_capacidad, v_lugares_disponibles
    FROM viaje v
    INNER JOIN bus b ON v.id_bus = b.id_bus
    WHERE v.id_viaje = p_id_viaje;
    
    v_porcentaje := ((v_capacidad - v_lugares_disponibles) / v_capacidad) * 100;
    
    RETURN ROUND(v_porcentaje, 2);
EXCEPTION
    WHEN OTHERS THEN
        RETURN 0;
END;
/

-- =====================================================
-- FUNCIÓN: Obtener descripción de ruta
-- =====================================================
CREATE OR REPLACE FUNCTION fn_descripcion_ruta(
    p_id_ruta IN NUMBER
) RETURN VARCHAR2
IS
    v_descripcion VARCHAR2(300);
    v_origen VARCHAR2(100);
    v_destino VARCHAR2(100);
    v_es_directo CHAR(1);
BEGIN
    SELECT d1.nombre, d2.nombre, r.es_directo
    INTO v_origen, v_destino, v_es_directo
    FROM ruta r
    INNER JOIN departamento d1 ON r.id_departamento_origen = d1.id_departamento
    INNER JOIN departamento d2 ON r.id_departamento_destino = d2.id_departamento
    WHERE r.id_ruta = p_id_ruta;
    
    IF v_es_directo = 'S' THEN
        v_descripcion := v_origen || ' - ' || v_destino || ' (Directo)';
    ELSE
        v_descripcion := v_origen || ' - ' || v_destino || ' (Con escalas)';
    END IF;
    
    RETURN v_descripcion;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 'Ruta no encontrada';
    WHEN OTHERS THEN
        RETURN 'Error';
END;
/

-- =====================================================
-- FUNCIÓN: Contar reservaciones pendientes de expirar
-- =====================================================
CREATE OR REPLACE FUNCTION fn_contar_reservas_por_expirar
RETURN NUMBER
IS
    v_cantidad NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_cantidad
    FROM reservacion
    WHERE estado = 'PENDIENTE'
    AND fecha_expiracion BETWEEN SYSTIMESTAMP AND SYSTIMESTAMP + INTERVAL '2' HOUR;
    
    RETURN v_cantidad;
EXCEPTION
    WHEN OTHERS THEN
        RETURN 0;
END;
/

-- =====================================================
-- FUNCIÓN: Obtener estado de pago de reservación
-- =====================================================
CREATE OR REPLACE FUNCTION fn_estado_pago_reservacion(
    p_id_reservacion IN NUMBER
) RETURN VARCHAR2
IS
    v_estado_pago VARCHAR2(20);
BEGIN
    SELECT estado
    INTO v_estado_pago
    FROM pago
    WHERE id_reservacion = p_id_reservacion
    AND ROWNUM = 1
    ORDER BY fecha_pago DESC;
    
    RETURN v_estado_pago;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 'SIN_PAGO';
    WHEN OTHERS THEN
        RETURN 'ERROR';
END;
/

COMMIT;

