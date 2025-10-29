-- =====================================================
-- SEGURIDAD Y ROLES DE BASE DE DATOS
-- =====================================================

-- =====================================================
-- CREAR ROLES DE BASE DE DATOS
-- =====================================================

-- Rol para Administradores
CREATE ROLE rol_db_admin;

-- Rol para Operadores
CREATE ROLE rol_db_operador;

-- Rol para Clientes (solo lectura limitada)
CREATE ROLE rol_db_cliente;

-- Rol para Pilotos (solo lectura de viajes)
CREATE ROLE rol_db_piloto;

-- Rol para Contadores (reportes)
CREATE ROLE rol_db_contador;

-- =====================================================
-- ASIGNAR PERMISOS A ROL ADMINISTRADOR
-- =====================================================

-- Permisos completos en todas las tablas
GRANT ALL ON departamento TO rol_db_admin;
GRANT ALL ON municipio TO rol_db_admin;
GRANT ALL ON tipo_bus TO rol_db_admin;
GRANT ALL ON bus TO rol_db_admin;
GRANT ALL ON piloto TO rol_db_admin;
GRANT ALL ON ruta TO rol_db_admin;
GRANT ALL ON escala TO rol_db_admin;
GRANT ALL ON viaje TO rol_db_admin;
GRANT ALL ON cliente TO rol_db_admin;
GRANT ALL ON tipo_pago TO rol_db_admin;
GRANT ALL ON reservacion TO rol_db_admin;
GRANT ALL ON pago TO rol_db_admin;
GRANT ALL ON boleto TO rol_db_admin;
GRANT ALL ON encomienda TO rol_db_admin;
GRANT ALL ON rol TO rol_db_admin;
GRANT ALL ON usuario TO rol_db_admin;
GRANT ALL ON permiso TO rol_db_admin;
GRANT ALL ON rol_permiso TO rol_db_admin;
GRANT ALL ON bitacora TO rol_db_admin;
GRANT ALL ON parametro TO rol_db_admin;

-- Permisos en secuencias
GRANT SELECT ON seq_departamento TO rol_db_admin;
GRANT SELECT ON seq_municipio TO rol_db_admin;
GRANT SELECT ON seq_tipo_bus TO rol_db_admin;
GRANT SELECT ON seq_bus TO rol_db_admin;
GRANT SELECT ON seq_piloto TO rol_db_admin;
GRANT SELECT ON seq_ruta TO rol_db_admin;
GRANT SELECT ON seq_escala TO rol_db_admin;
GRANT SELECT ON seq_viaje TO rol_db_admin;
GRANT SELECT ON seq_cliente TO rol_db_admin;
GRANT SELECT ON seq_tipo_pago TO rol_db_admin;
GRANT SELECT ON seq_reservacion TO rol_db_admin;
GRANT SELECT ON seq_pago TO rol_db_admin;
GRANT SELECT ON seq_boleto TO rol_db_admin;
GRANT SELECT ON seq_encomienda TO rol_db_admin;
GRANT SELECT ON seq_rol TO rol_db_admin;
GRANT SELECT ON seq_usuario TO rol_db_admin;
GRANT SELECT ON seq_permiso TO rol_db_admin;
GRANT SELECT ON seq_rol_permiso TO rol_db_admin;
GRANT SELECT ON seq_bitacora TO rol_db_admin;
GRANT SELECT ON seq_parametro TO rol_db_admin;

-- Permisos en vistas
GRANT SELECT ON v_viajes_disponibles TO rol_db_admin;
GRANT SELECT ON v_reservaciones_completas TO rol_db_admin;
GRANT SELECT ON v_boletos_emitidos TO rol_db_admin;
GRANT SELECT ON v_encomiendas_completas TO rol_db_admin;
GRANT SELECT ON v_pagos_pendientes TO rol_db_admin;
GRANT SELECT ON v_ingresos_por_viaje TO rol_db_admin;
GRANT SELECT ON v_rutas_mas_utilizadas TO rol_db_admin;
GRANT SELECT ON v_top_clientes TO rol_db_admin;
GRANT SELECT ON v_buses_ocupacion TO rol_db_admin;
GRANT SELECT ON v_estadisticas_encomiendas TO rol_db_admin;
GRANT SELECT ON v_usuarios_permisos TO rol_db_admin;
GRANT SELECT ON v_bitacora_auditoria TO rol_db_admin;

-- Permisos en procedimientos, funciones y paquetes
GRANT EXECUTE ON pkg_reservaciones TO rol_db_admin;
GRANT EXECUTE ON pkg_pagos TO rol_db_admin;
GRANT EXECUTE ON pkg_reportes TO rol_db_admin;

-- =====================================================
-- ASIGNAR PERMISOS A ROL OPERADOR
-- =====================================================

-- Lectura en catálogos
GRANT SELECT ON departamento TO rol_db_operador;
GRANT SELECT ON municipio TO rol_db_operador;
GRANT SELECT ON tipo_bus TO rol_db_operador;
GRANT SELECT ON tipo_pago TO rol_db_operador;

-- Lectura en buses y pilotos
GRANT SELECT ON bus TO rol_db_operador;
GRANT SELECT ON piloto TO rol_db_operador;
GRANT SELECT ON ruta TO rol_db_operador;
GRANT SELECT ON viaje TO rol_db_operador;

-- CRUD en clientes
GRANT SELECT, INSERT, UPDATE ON cliente TO rol_db_operador;

-- CRUD en reservaciones
GRANT SELECT, INSERT, UPDATE, DELETE ON reservacion TO rol_db_operador;
GRANT SELECT ON seq_reservacion TO rol_db_operador;

-- CRUD en boletos
GRANT SELECT, INSERT, UPDATE ON boleto TO rol_db_operador;
GRANT SELECT ON seq_boleto TO rol_db_operador;

-- CRUD en encomiendas
GRANT SELECT, INSERT, UPDATE ON encomienda TO rol_db_operador;
GRANT SELECT ON seq_encomienda TO rol_db_operador;

-- Gestión de pagos
GRANT SELECT, INSERT, UPDATE ON pago TO rol_db_operador;
GRANT SELECT ON seq_pago TO rol_db_operador;

-- Vistas operativas
GRANT SELECT ON v_viajes_disponibles TO rol_db_operador;
GRANT SELECT ON v_reservaciones_completas TO rol_db_operador;
GRANT SELECT ON v_boletos_emitidos TO rol_db_operador;
GRANT SELECT ON v_encomiendas_completas TO rol_db_operador;
GRANT SELECT ON v_pagos_pendientes TO rol_db_operador;

-- Paquetes operativos
GRANT EXECUTE ON pkg_reservaciones TO rol_db_operador;
GRANT EXECUTE ON pkg_pagos TO rol_db_operador;

-- =====================================================
-- ASIGNAR PERMISOS A ROL CLIENTE
-- =====================================================

-- Solo lectura en catálogos básicos
GRANT SELECT ON departamento TO rol_db_cliente;
GRANT SELECT ON tipo_bus TO rol_db_cliente;

-- Solo lectura en rutas y viajes
GRANT SELECT ON ruta TO rol_db_cliente;
GRANT SELECT ON v_viajes_disponibles TO rol_db_cliente;

-- Lectura limitada de sus propias reservaciones (se controla en aplicación)
GRANT SELECT ON reservacion TO rol_db_cliente;
GRANT SELECT ON boleto TO rol_db_cliente;
GRANT SELECT ON encomienda TO rol_db_cliente;

-- Vistas limitadas
GRANT SELECT ON v_reservaciones_completas TO rol_db_cliente;
GRANT SELECT ON v_boletos_emitidos TO rol_db_cliente;

-- =====================================================
-- ASIGNAR PERMISOS A ROL PILOTO
-- =====================================================

-- Solo lectura de viajes y rutas
GRANT SELECT ON viaje TO rol_db_piloto;
GRANT SELECT ON ruta TO rol_db_piloto;
GRANT SELECT ON departamento TO rol_db_piloto;
GRANT SELECT ON bus TO rol_db_piloto;
GRANT SELECT ON encomienda TO rol_db_piloto;

-- Vistas de consulta
GRANT SELECT ON v_viajes_disponibles TO rol_db_piloto;
GRANT SELECT ON v_encomiendas_completas TO rol_db_piloto;

-- =====================================================
-- ASIGNAR PERMISOS A ROL CONTADOR
-- =====================================================

-- Solo lectura en todas las tablas
GRANT SELECT ON departamento TO rol_db_contador;
GRANT SELECT ON municipio TO rol_db_contador;
GRANT SELECT ON tipo_bus TO rol_db_contador;
GRANT SELECT ON bus TO rol_db_contador;
GRANT SELECT ON piloto TO rol_db_contador;
GRANT SELECT ON ruta TO rol_db_contador;
GRANT SELECT ON viaje TO rol_db_contador;
GRANT SELECT ON cliente TO rol_db_contador;
GRANT SELECT ON reservacion TO rol_db_contador;
GRANT SELECT ON pago TO rol_db_contador;
GRANT SELECT ON boleto TO rol_db_contador;
GRANT SELECT ON encomienda TO rol_db_contador;
GRANT SELECT ON bitacora TO rol_db_contador;

-- Todas las vistas de reportes
GRANT SELECT ON v_viajes_disponibles TO rol_db_contador;
GRANT SELECT ON v_reservaciones_completas TO rol_db_contador;
GRANT SELECT ON v_boletos_emitidos TO rol_db_contador;
GRANT SELECT ON v_encomiendas_completas TO rol_db_contador;
GRANT SELECT ON v_pagos_pendientes TO rol_db_contador;
GRANT SELECT ON v_ingresos_por_viaje TO rol_db_contador;
GRANT SELECT ON v_rutas_mas_utilizadas TO rol_db_contador;
GRANT SELECT ON v_top_clientes TO rol_db_contador;
GRANT SELECT ON v_buses_ocupacion TO rol_db_contador;
GRANT SELECT ON v_estadisticas_encomiendas TO rol_db_contador;
GRANT SELECT ON v_bitacora_auditoria TO rol_db_contador;

-- Paquete de reportes
GRANT EXECUTE ON pkg_reportes TO rol_db_contador;

-- =====================================================
-- CREAR USUARIOS DE BASE DE DATOS (EJEMPLOS)
-- =====================================================

-- Usuario Administrador
CREATE USER admin_user IDENTIFIED BY "Admin2025!";
GRANT CONNECT, RESOURCE TO admin_user;
GRANT rol_db_admin TO admin_user;

-- Usuario Operador
CREATE USER operador_user IDENTIFIED BY "Oper2025!";
GRANT CONNECT TO operador_user;
GRANT rol_db_operador TO operador_user;

-- Usuario Cliente (ejemplo)
CREATE USER cliente_user IDENTIFIED BY "Cliente2025!";
GRANT CONNECT TO cliente_user;
GRANT rol_db_cliente TO cliente_user;

-- Usuario Piloto (ejemplo)
CREATE USER piloto_user IDENTIFIED BY "Piloto2025!";
GRANT CONNECT TO piloto_user;
GRANT rol_db_piloto TO piloto_user;

-- Usuario Contador
CREATE USER contador_user IDENTIFIED BY "Contador2025!";
GRANT CONNECT TO contador_user;
GRANT rol_db_contador TO contador_user;

-- =====================================================
-- POLÍTICAS DE SEGURIDAD ADICIONALES
-- =====================================================

-- Habilitar auditoría en tablas críticas
AUDIT INSERT, UPDATE, DELETE ON reservacion BY ACCESS;
AUDIT INSERT, UPDATE, DELETE ON pago BY ACCESS;
AUDIT INSERT, UPDATE, DELETE ON usuario BY ACCESS;
AUDIT INSERT, UPDATE, DELETE ON boleto BY ACCESS;

-- Política de contraseñas (se configura a nivel de base de datos)
-- ALTER PROFILE DEFAULT LIMIT
--   FAILED_LOGIN_ATTEMPTS 3
--   PASSWORD_LIFE_TIME 90
--   PASSWORD_REUSE_TIME 365
--   PASSWORD_REUSE_MAX 5
--   PASSWORD_VERIFY_FUNCTION verify_function
--   PASSWORD_LOCK_TIME 1;

COMMIT;

-- =====================================================
-- COMENTARIOS SOBRE SEGURIDAD
-- =====================================================

/*
NOTAS DE IMPLEMENTACIÓN:

1. Los roles de base de datos (rol_db_*) complementan los roles de aplicación
   definidos en la tabla ROL.

2. Los usuarios de base de datos son ejemplos. En producción:
   - Usar contraseñas más seguras
   - Crear usuarios específicos por operador/piloto
   - Implementar rotación de contraseñas

3. La seguridad a nivel de fila (Row Level Security) se implementa
   en la capa de aplicación mediante filtros en las consultas.

4. Las contraseñas de usuarios de aplicación se almacenan encriptadas
   con SHA-512 en la tabla USUARIO.

5. La bitácora registra todas las operaciones críticas mediante triggers.

6. Se recomienda:
   - Implementar SSL/TLS para conexiones
   - Usar Oracle Wallet para credenciales
   - Configurar Oracle Advanced Security para encriptación de datos
   - Implementar Oracle Database Vault en producción
*/

