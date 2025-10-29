-- =====================================================
-- DATOS INICIALES - CATÁLOGOS
-- =====================================================

-- =====================================================
-- DEPARTAMENTOS DE GUATEMALA
-- =====================================================
INSERT INTO departamento VALUES (seq_departamento.NEXTVAL, 'Guatemala', 'GT', 'A');
INSERT INTO departamento VALUES (seq_departamento.NEXTVAL, 'Alta Verapaz', 'AV', 'A');
INSERT INTO departamento VALUES (seq_departamento.NEXTVAL, 'Baja Verapaz', 'BV', 'A');
INSERT INTO departamento VALUES (seq_departamento.NEXTVAL, 'Chimaltenango', 'CM', 'A');
INSERT INTO departamento VALUES (seq_departamento.NEXTVAL, 'Chiquimula', 'CQ', 'A');
INSERT INTO departamento VALUES (seq_departamento.NEXTVAL, 'El Progreso', 'PR', 'A');
INSERT INTO departamento VALUES (seq_departamento.NEXTVAL, 'Escuintla', 'ES', 'A');
INSERT INTO departamento VALUES (seq_departamento.NEXTVAL, 'Huehuetenango', 'HU', 'A');
INSERT INTO departamento VALUES (seq_departamento.NEXTVAL, 'Izabal', 'IZ', 'A');
INSERT INTO departamento VALUES (seq_departamento.NEXTVAL, 'Jalapa', 'JA', 'A');
INSERT INTO departamento VALUES (seq_departamento.NEXTVAL, 'Jutiapa', 'JU', 'A');
INSERT INTO departamento VALUES (seq_departamento.NEXTVAL, 'Petén', 'PE', 'A');
INSERT INTO departamento VALUES (seq_departamento.NEXTVAL, 'Quetzaltenango', 'QZ', 'A');
INSERT INTO departamento VALUES (seq_departamento.NEXTVAL, 'Quiché', 'QC', 'A');
INSERT INTO departamento VALUES (seq_departamento.NEXTVAL, 'Retalhuleu', 'RE', 'A');
INSERT INTO departamento VALUES (seq_departamento.NEXTVAL, 'Sacatepéquez', 'SA', 'A');
INSERT INTO departamento VALUES (seq_departamento.NEXTVAL, 'San Marcos', 'SM', 'A');
INSERT INTO departamento VALUES (seq_departamento.NEXTVAL, 'Santa Rosa', 'SR', 'A');
INSERT INTO departamento VALUES (seq_departamento.NEXTVAL, 'Sololá', 'SO', 'A');
INSERT INTO departamento VALUES (seq_departamento.NEXTVAL, 'Suchitepéquez', 'SU', 'A');
INSERT INTO departamento VALUES (seq_departamento.NEXTVAL, 'Totonicapán', 'TO', 'A');
INSERT INTO departamento VALUES (seq_departamento.NEXTVAL, 'Zacapa', 'ZA', 'A');

-- =====================================================
-- MUNICIPIOS (Cabeceras departamentales principales)
-- =====================================================
INSERT INTO municipio VALUES (seq_municipio.NEXTVAL, 1, 'Guatemala', 'GT-01', 'A');
INSERT INTO municipio VALUES (seq_municipio.NEXTVAL, 2, 'Cobán', 'AV-01', 'A');
INSERT INTO municipio VALUES (seq_municipio.NEXTVAL, 3, 'Salamá', 'BV-01', 'A');
INSERT INTO municipio VALUES (seq_municipio.NEXTVAL, 4, 'Chimaltenango', 'CM-01', 'A');
INSERT INTO municipio VALUES (seq_municipio.NEXTVAL, 5, 'Chiquimula', 'CQ-01', 'A');
INSERT INTO municipio VALUES (seq_municipio.NEXTVAL, 6, 'Guastatoya', 'PR-01', 'A');
INSERT INTO municipio VALUES (seq_municipio.NEXTVAL, 7, 'Escuintla', 'ES-01', 'A');
INSERT INTO municipio VALUES (seq_municipio.NEXTVAL, 8, 'Huehuetenango', 'HU-01', 'A');
INSERT INTO municipio VALUES (seq_municipio.NEXTVAL, 9, 'Puerto Barrios', 'IZ-01', 'A');
INSERT INTO municipio VALUES (seq_municipio.NEXTVAL, 10, 'Jalapa', 'JA-01', 'A');
INSERT INTO municipio VALUES (seq_municipio.NEXTVAL, 11, 'Jutiapa', 'JU-01', 'A');
INSERT INTO municipio VALUES (seq_municipio.NEXTVAL, 12, 'Flores', 'PE-01', 'A');
INSERT INTO municipio VALUES (seq_municipio.NEXTVAL, 13, 'Quetzaltenango', 'QZ-01', 'A');
INSERT INTO municipio VALUES (seq_municipio.NEXTVAL, 14, 'Santa Cruz del Quiché', 'QC-01', 'A');
INSERT INTO municipio VALUES (seq_municipio.NEXTVAL, 15, 'Retalhuleu', 'RE-01', 'A');
INSERT INTO municipio VALUES (seq_municipio.NEXTVAL, 16, 'Antigua Guatemala', 'SA-01', 'A');
INSERT INTO municipio VALUES (seq_municipio.NEXTVAL, 17, 'San Marcos', 'SM-01', 'A');
INSERT INTO municipio VALUES (seq_municipio.NEXTVAL, 18, 'Cuilapa', 'SR-01', 'A');
INSERT INTO municipio VALUES (seq_municipio.NEXTVAL, 19, 'Sololá', 'SO-01', 'A');
INSERT INTO municipio VALUES (seq_municipio.NEXTVAL, 20, 'Mazatenango', 'SU-01', 'A');
INSERT INTO municipio VALUES (seq_municipio.NEXTVAL, 21, 'Totonicapán', 'TO-01', 'A');
INSERT INTO municipio VALUES (seq_municipio.NEXTVAL, 22, 'Zacapa', 'ZA-01', 'A');

-- =====================================================
-- TIPOS DE BUS
-- =====================================================
INSERT INTO tipo_bus VALUES (seq_tipo_bus.NEXTVAL, 'Económico', 'Bus estándar con asientos básicos', 'A');
INSERT INTO tipo_bus VALUES (seq_tipo_bus.NEXTVAL, 'Ejecutivo', 'Bus con asientos reclinables y aire acondicionado', 'A');
INSERT INTO tipo_bus VALUES (seq_tipo_bus.NEXTVAL, 'VIP', 'Bus de lujo con asientos premium, WiFi y entretenimiento', 'A');
INSERT INTO tipo_bus VALUES (seq_tipo_bus.NEXTVAL, 'Semi-Cama', 'Bus con asientos semi-reclinables para viajes largos', 'A');

-- =====================================================
-- TIPOS DE PAGO
-- =====================================================
INSERT INTO tipo_pago VALUES (seq_tipo_pago.NEXTVAL, 'Tarjeta de Crédito', 'Pago con tarjeta de crédito en línea', 'N', 'A');
INSERT INTO tipo_pago VALUES (seq_tipo_pago.NEXTVAL, 'Tarjeta de Débito', 'Pago con tarjeta de débito en línea', 'N', 'A');
INSERT INTO tipo_pago VALUES (seq_tipo_pago.NEXTVAL, 'Depósito Bancario', 'Depósito en cuenta bancaria (requiere verificación)', 'S', 'A');
INSERT INTO tipo_pago VALUES (seq_tipo_pago.NEXTVAL, 'Efectivo', 'Pago en efectivo en taquilla', 'N', 'A');

-- =====================================================
-- ROLES
-- =====================================================
INSERT INTO rol VALUES (seq_rol.NEXTVAL, 'Administrador', 'Acceso total al sistema', 'A');
INSERT INTO rol VALUES (seq_rol.NEXTVAL, 'Operador', 'Gestión de reservaciones y ventas', 'A');
INSERT INTO rol VALUES (seq_rol.NEXTVAL, 'Cliente', 'Usuario cliente con acceso limitado', 'A');
INSERT INTO rol VALUES (seq_rol.NEXTVAL, 'Piloto', 'Acceso a información de viajes asignados', 'A');
INSERT INTO rol VALUES (seq_rol.NEXTVAL, 'Contador', 'Acceso a reportes y estadísticas', 'A');

-- =====================================================
-- PERMISOS
-- =====================================================
-- Módulo: Catálogos
INSERT INTO permiso VALUES (seq_permiso.NEXTVAL, 'VER_CATALOGOS', 'Ver catálogos del sistema', 'CATALOGOS', 'READ');
INSERT INTO permiso VALUES (seq_permiso.NEXTVAL, 'CREAR_CATALOGOS', 'Crear registros en catálogos', 'CATALOGOS', 'CREATE');
INSERT INTO permiso VALUES (seq_permiso.NEXTVAL, 'EDITAR_CATALOGOS', 'Editar registros en catálogos', 'CATALOGOS', 'UPDATE');
INSERT INTO permiso VALUES (seq_permiso.NEXTVAL, 'ELIMINAR_CATALOGOS', 'Eliminar registros en catálogos', 'CATALOGOS', 'DELETE');

-- Módulo: Buses
INSERT INTO permiso VALUES (seq_permiso.NEXTVAL, 'VER_BUSES', 'Ver información de buses', 'BUSES', 'READ');
INSERT INTO permiso VALUES (seq_permiso.NEXTVAL, 'CREAR_BUSES', 'Registrar nuevos buses', 'BUSES', 'CREATE');
INSERT INTO permiso VALUES (seq_permiso.NEXTVAL, 'EDITAR_BUSES', 'Editar información de buses', 'BUSES', 'UPDATE');
INSERT INTO permiso VALUES (seq_permiso.NEXTVAL, 'ELIMINAR_BUSES', 'Eliminar buses', 'BUSES', 'DELETE');

-- Módulo: Pilotos
INSERT INTO permiso VALUES (seq_permiso.NEXTVAL, 'VER_PILOTOS', 'Ver información de pilotos', 'PILOTOS', 'READ');
INSERT INTO permiso VALUES (seq_permiso.NEXTVAL, 'CREAR_PILOTOS', 'Registrar nuevos pilotos', 'PILOTOS', 'CREATE');
INSERT INTO permiso VALUES (seq_permiso.NEXTVAL, 'EDITAR_PILOTOS', 'Editar información de pilotos', 'PILOTOS', 'UPDATE');
INSERT INTO permiso VALUES (seq_permiso.NEXTVAL, 'ELIMINAR_PILOTOS', 'Eliminar pilotos', 'PILOTOS', 'DELETE');

-- Módulo: Rutas
INSERT INTO permiso VALUES (seq_permiso.NEXTVAL, 'VER_RUTAS', 'Ver rutas disponibles', 'RUTAS', 'READ');
INSERT INTO permiso VALUES (seq_permiso.NEXTVAL, 'CREAR_RUTAS', 'Crear nuevas rutas', 'RUTAS', 'CREATE');
INSERT INTO permiso VALUES (seq_permiso.NEXTVAL, 'EDITAR_RUTAS', 'Editar rutas', 'RUTAS', 'UPDATE');
INSERT INTO permiso VALUES (seq_permiso.NEXTVAL, 'ELIMINAR_RUTAS', 'Eliminar rutas', 'RUTAS', 'DELETE');

-- Módulo: Viajes
INSERT INTO permiso VALUES (seq_permiso.NEXTVAL, 'VER_VIAJES', 'Ver viajes programados', 'VIAJES', 'READ');
INSERT INTO permiso VALUES (seq_permiso.NEXTVAL, 'CREAR_VIAJES', 'Programar nuevos viajes', 'VIAJES', 'CREATE');
INSERT INTO permiso VALUES (seq_permiso.NEXTVAL, 'EDITAR_VIAJES', 'Editar viajes', 'VIAJES', 'UPDATE');
INSERT INTO permiso VALUES (seq_permiso.NEXTVAL, 'CANCELAR_VIAJES', 'Cancelar viajes', 'VIAJES', 'DELETE');

-- Módulo: Reservaciones
INSERT INTO permiso VALUES (seq_permiso.NEXTVAL, 'VER_RESERVACIONES', 'Ver reservaciones', 'RESERVACIONES', 'READ');
INSERT INTO permiso VALUES (seq_permiso.NEXTVAL, 'CREAR_RESERVACIONES', 'Crear reservaciones', 'RESERVACIONES', 'CREATE');
INSERT INTO permiso VALUES (seq_permiso.NEXTVAL, 'CONFIRMAR_RESERVACIONES', 'Confirmar reservaciones', 'RESERVACIONES', 'UPDATE');
INSERT INTO permiso VALUES (seq_permiso.NEXTVAL, 'CANCELAR_RESERVACIONES', 'Cancelar reservaciones', 'RESERVACIONES', 'DELETE');

-- Módulo: Pagos
INSERT INTO permiso VALUES (seq_permiso.NEXTVAL, 'VER_PAGOS', 'Ver pagos', 'PAGOS', 'READ');
INSERT INTO permiso VALUES (seq_permiso.NEXTVAL, 'VERIFICAR_PAGOS', 'Verificar pagos por depósito', 'PAGOS', 'UPDATE');

-- Módulo: Encomiendas
INSERT INTO permiso VALUES (seq_permiso.NEXTVAL, 'VER_ENCOMIENDAS', 'Ver encomiendas', 'ENCOMIENDAS', 'READ');
INSERT INTO permiso VALUES (seq_permiso.NEXTVAL, 'CREAR_ENCOMIENDAS', 'Registrar encomiendas', 'ENCOMIENDAS', 'CREATE');
INSERT INTO permiso VALUES (seq_permiso.NEXTVAL, 'ACTUALIZAR_ENCOMIENDAS', 'Actualizar estado de encomiendas', 'ENCOMIENDAS', 'UPDATE');

-- Módulo: Reportes
INSERT INTO permiso VALUES (seq_permiso.NEXTVAL, 'VER_REPORTES', 'Ver reportes gerenciales', 'REPORTES', 'READ');
INSERT INTO permiso VALUES (seq_permiso.NEXTVAL, 'EXPORTAR_REPORTES', 'Exportar reportes', 'REPORTES', 'EXPORT');

-- Módulo: Usuarios
INSERT INTO permiso VALUES (seq_permiso.NEXTVAL, 'VER_USUARIOS', 'Ver usuarios', 'USUARIOS', 'READ');
INSERT INTO permiso VALUES (seq_permiso.NEXTVAL, 'CREAR_USUARIOS', 'Crear usuarios', 'USUARIOS', 'CREATE');
INSERT INTO permiso VALUES (seq_permiso.NEXTVAL, 'EDITAR_USUARIOS', 'Editar usuarios', 'USUARIOS', 'UPDATE');
INSERT INTO permiso VALUES (seq_permiso.NEXTVAL, 'ELIMINAR_USUARIOS', 'Eliminar usuarios', 'USUARIOS', 'DELETE');

-- Módulo: Bitácora
INSERT INTO permiso VALUES (seq_permiso.NEXTVAL, 'VER_BITACORA', 'Ver bitácora de auditoría', 'BITACORA', 'READ');

-- =====================================================
-- ASIGNACIÓN DE PERMISOS A ROLES
-- =====================================================

-- Administrador: TODOS los permisos
DECLARE
    v_id_rol_admin NUMBER;
BEGIN
    SELECT id_rol INTO v_id_rol_admin FROM rol WHERE nombre = 'Administrador';
    
    FOR perm IN (SELECT id_permiso FROM permiso) LOOP
        INSERT INTO rol_permiso VALUES (seq_rol_permiso.NEXTVAL, v_id_rol_admin, perm.id_permiso);
    END LOOP;
END;
/

-- Operador: Permisos operativos
DECLARE
    v_id_rol_operador NUMBER;
BEGIN
    SELECT id_rol INTO v_id_rol_operador FROM rol WHERE nombre = 'Operador';
    
    FOR perm IN (
        SELECT id_permiso FROM permiso 
        WHERE nombre IN (
            'VER_CATALOGOS', 'VER_BUSES', 'VER_PILOTOS', 'VER_RUTAS', 'VER_VIAJES',
            'VER_RESERVACIONES', 'CREAR_RESERVACIONES', 'CONFIRMAR_RESERVACIONES', 'CANCELAR_RESERVACIONES',
            'VER_PAGOS', 'VERIFICAR_PAGOS',
            'VER_ENCOMIENDAS', 'CREAR_ENCOMIENDAS', 'ACTUALIZAR_ENCOMIENDAS',
            'VER_REPORTES', 'EXPORTAR_REPORTES'
        )
    ) LOOP
        INSERT INTO rol_permiso VALUES (seq_rol_permiso.NEXTVAL, v_id_rol_operador, perm.id_permiso);
    END LOOP;
END;
/

-- Cliente: Permisos limitados
DECLARE
    v_id_rol_cliente NUMBER;
BEGIN
    SELECT id_rol INTO v_id_rol_cliente FROM rol WHERE nombre = 'Cliente';
    
    FOR perm IN (
        SELECT id_permiso FROM permiso 
        WHERE nombre IN (
            'VER_RUTAS', 'VER_VIAJES',
            'VER_RESERVACIONES', 'CREAR_RESERVACIONES', 'CANCELAR_RESERVACIONES',
            'VER_ENCOMIENDAS', 'CREAR_ENCOMIENDAS'
        )
    ) LOOP
        INSERT INTO rol_permiso VALUES (seq_rol_permiso.NEXTVAL, v_id_rol_cliente, perm.id_permiso);
    END LOOP;
END;
/

-- Piloto: Permisos de consulta
DECLARE
    v_id_rol_piloto NUMBER;
BEGIN
    SELECT id_rol INTO v_id_rol_piloto FROM rol WHERE nombre = 'Piloto';
    
    FOR perm IN (
        SELECT id_permiso FROM permiso 
        WHERE nombre IN ('VER_VIAJES', 'VER_RUTAS', 'VER_ENCOMIENDAS')
    ) LOOP
        INSERT INTO rol_permiso VALUES (seq_rol_permiso.NEXTVAL, v_id_rol_piloto, perm.id_permiso);
    END LOOP;
END;
/

-- Contador: Permisos de reportes
DECLARE
    v_id_rol_contador NUMBER;
BEGIN
    SELECT id_rol INTO v_id_rol_contador FROM rol WHERE nombre = 'Contador';
    
    FOR perm IN (
        SELECT id_permiso FROM permiso 
        WHERE nombre IN (
            'VER_REPORTES', 'EXPORTAR_REPORTES', 'VER_PAGOS', 'VER_BITACORA',
            'VER_VIAJES', 'VER_RESERVACIONES', 'VER_ENCOMIENDAS'
        )
    ) LOOP
        INSERT INTO rol_permiso VALUES (seq_rol_permiso.NEXTVAL, v_id_rol_contador, perm.id_permiso);
    END LOOP;
END;
/

-- =====================================================
-- PARÁMETROS DEL SISTEMA
-- =====================================================
INSERT INTO parametro VALUES (seq_parametro.NEXTVAL, 'HORAS_EXPIRACION_RESERVA', '24', 'Horas para expirar reservación sin pago', 'NUMBER', SYSTIMESTAMP);
INSERT INTO parametro VALUES (seq_parametro.NEXTVAL, 'TARIFA_ENCOMIENDA_10LB', '20.00', 'Tarifa para encomiendas hasta 10 libras', 'NUMBER', SYSTIMESTAMP);
INSERT INTO parametro VALUES (seq_parametro.NEXTVAL, 'TARIFA_ENCOMIENDA_100LB', '50.00', 'Tarifa para encomiendas hasta 100 libras', 'NUMBER', SYSTIMESTAMP);
INSERT INTO parametro VALUES (seq_parametro.NEXTVAL, 'TARIFA_ENCOMIENDA_MAS100LB', '100.00', 'Tarifa para encomiendas más de 100 libras', 'NUMBER', SYSTIMESTAMP);
INSERT INTO parametro VALUES (seq_parametro.NEXTVAL, 'MAX_INTENTOS_LOGIN', '3', 'Máximo de intentos fallidos de login', 'NUMBER', SYSTIMESTAMP);
INSERT INTO parametro VALUES (seq_parametro.NEXTVAL, 'NOMBRE_EMPRESA', 'Transportes Guatemala Express', 'Nombre de la empresa', 'STRING', SYSTIMESTAMP);
INSERT INTO parametro VALUES (seq_parametro.NEXTVAL, 'EMAIL_SOPORTE', 'soporte@transportesgt.com', 'Email de soporte técnico', 'STRING', SYSTIMESTAMP);

-- =====================================================
-- USUARIO ADMINISTRADOR INICIAL
-- =====================================================
DECLARE
    v_id_rol_admin NUMBER;
BEGIN
    SELECT id_rol INTO v_id_rol_admin FROM rol WHERE nombre = 'Administrador';
    
    INSERT INTO usuario (
        id_usuario, id_rol, username, password_hash, email, estado
    ) VALUES (
        seq_usuario.NEXTVAL,
        v_id_rol_admin,
        'admin',
        'C7AD44CBAD762A5DA0A452F9E854FDC1E0E7A52A38015F23F3EAB1D80B931DD472634DFAC71CD34EBC35D16AB7FB8A90C81F975113D6C7538DC69DD8DE9077EC', -- SHA-512 de 'admin123'
        'admin@transportesgt.com',
        'A'
    );
END;
/

COMMIT;
COMMIT;


