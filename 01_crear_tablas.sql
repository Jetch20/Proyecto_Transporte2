-- =====================================================
-- PROYECTO: Sistema de Transporte de Pasajeros y Encomiendas
-- AUTOR: Jeferson Stiv González Barrios
-- FECHA: Octubre 2025
-- BASE DE DATOS: Oracle
-- =====================================================

-- =====================================================
-- SECUENCIAS
-- =====================================================

CREATE SEQUENCE seq_departamento START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_municipio START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_tipo_bus START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_bus START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_piloto START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_ruta START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_escala START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_viaje START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_cliente START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_tipo_pago START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_reservacion START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_pago START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_boleto START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_encomienda START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_rol START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_usuario START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_permiso START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_rol_permiso START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_bitacora START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_parametro START WITH 1 INCREMENT BY 1;

-- =====================================================
-- TABLA: DEPARTAMENTO
-- =====================================================
CREATE TABLE departamento (
    id_departamento NUMBER(10) PRIMARY KEY,
    nombre VARCHAR2(100) NOT NULL,
    codigo VARCHAR2(10) NOT NULL UNIQUE,
    estado CHAR(1) DEFAULT 'A' NOT NULL,
    CONSTRAINT chk_depto_estado CHECK (estado IN ('A', 'I'))
);

COMMENT ON TABLE departamento IS 'Catálogo de departamentos de Guatemala';
COMMENT ON COLUMN departamento.estado IS 'A=Activo, I=Inactivo';

-- =====================================================
-- TABLA: MUNICIPIO
-- =====================================================
CREATE TABLE municipio (
    id_municipio NUMBER(10) PRIMARY KEY,
    id_departamento NUMBER(10) NOT NULL,
    nombre VARCHAR2(100) NOT NULL,
    codigo VARCHAR2(10) NOT NULL,
    estado CHAR(1) DEFAULT 'A' NOT NULL,
    CONSTRAINT fk_municipio_depto FOREIGN KEY (id_departamento) 
        REFERENCES departamento(id_departamento),
    CONSTRAINT chk_municipio_estado CHECK (estado IN ('A', 'I')),
    CONSTRAINT uk_municipio_codigo UNIQUE (id_departamento, codigo)
);

COMMENT ON TABLE municipio IS 'Catálogo de municipios por departamento';

-- =====================================================
-- TABLA: TIPO_BUS
-- =====================================================
CREATE TABLE tipo_bus (
    id_tipo_bus NUMBER(10) PRIMARY KEY,
    nombre VARCHAR2(50) NOT NULL UNIQUE,
    descripcion VARCHAR2(200),
    estado CHAR(1) DEFAULT 'A' NOT NULL,
    CONSTRAINT chk_tipo_bus_estado CHECK (estado IN ('A', 'I'))
);

COMMENT ON TABLE tipo_bus IS 'Catálogo de tipos de buses (Ejecutivo, Económico, VIP)';

-- =====================================================
-- TABLA: BUS
-- =====================================================
CREATE TABLE bus (
    id_bus NUMBER(10) PRIMARY KEY,
    id_tipo_bus NUMBER(10) NOT NULL,
    numero_bus VARCHAR2(20) NOT NULL UNIQUE,
    placa VARCHAR2(15) NOT NULL UNIQUE,
    marca VARCHAR2(50) NOT NULL,
    modelo VARCHAR2(50) NOT NULL,
    anio NUMBER(4) NOT NULL,
    capacidad_pasajeros NUMBER(3) NOT NULL,
    estado VARCHAR2(20) DEFAULT 'ACTIVO' NOT NULL,
    fecha_registro DATE DEFAULT SYSDATE NOT NULL,
    CONSTRAINT fk_bus_tipo FOREIGN KEY (id_tipo_bus) 
        REFERENCES tipo_bus(id_tipo_bus),
    CONSTRAINT chk_bus_estado CHECK (estado IN ('ACTIVO', 'MANTENIMIENTO', 'FUERA_SERVICIO')),
    CONSTRAINT chk_bus_capacidad CHECK (capacidad_pasajeros > 0),
    CONSTRAINT chk_bus_anio CHECK (anio >= 1990 AND anio <= 2030)
);

COMMENT ON TABLE bus IS 'Registro de buses de la flota';

-- =====================================================
-- TABLA: PILOTO
-- =====================================================
CREATE TABLE piloto (
    id_piloto NUMBER(10) PRIMARY KEY,
    nombres VARCHAR2(100) NOT NULL,
    apellidos VARCHAR2(100) NOT NULL,
    dpi VARCHAR2(20) NOT NULL UNIQUE,
    numero_licencia VARCHAR2(30) NOT NULL UNIQUE,
    tipo_licencia VARCHAR2(10) NOT NULL,
    fecha_vencimiento_licencia DATE NOT NULL,
    telefono VARCHAR2(20) NOT NULL,
    email VARCHAR2(100),
    direccion VARCHAR2(200),
    fecha_contratacion DATE DEFAULT SYSDATE NOT NULL,
    estado CHAR(1) DEFAULT 'A' NOT NULL,
    CONSTRAINT chk_piloto_estado CHECK (estado IN ('A', 'I')),
    CONSTRAINT chk_piloto_tipo_lic CHECK (tipo_licencia IN ('A', 'B', 'C', 'M'))
);

COMMENT ON TABLE piloto IS 'Registro de pilotos de la empresa';

-- =====================================================
-- TABLA: RUTA
-- =====================================================
CREATE TABLE ruta (
    id_ruta NUMBER(10) PRIMARY KEY,
    id_departamento_origen NUMBER(10) NOT NULL,
    id_departamento_destino NUMBER(10) NOT NULL,
    nombre_ruta VARCHAR2(150) NOT NULL,
    distancia_km NUMBER(8,2) NOT NULL,
    es_directo CHAR(1) DEFAULT 'S' NOT NULL,
    descripcion VARCHAR2(300),
    estado CHAR(1) DEFAULT 'A' NOT NULL,
    CONSTRAINT fk_ruta_origen FOREIGN KEY (id_departamento_origen) 
        REFERENCES departamento(id_departamento),
    CONSTRAINT fk_ruta_destino FOREIGN KEY (id_departamento_destino) 
        REFERENCES departamento(id_departamento),
    CONSTRAINT chk_ruta_directo CHECK (es_directo IN ('S', 'N')),
    CONSTRAINT chk_ruta_estado CHECK (estado IN ('A', 'I')),
    CONSTRAINT chk_ruta_distancia CHECK (distancia_km > 0),
    CONSTRAINT chk_ruta_diferente CHECK (id_departamento_origen != id_departamento_destino)
);

COMMENT ON TABLE ruta IS 'Rutas de transporte entre departamentos';

-- =====================================================
-- TABLA: ESCALA
-- =====================================================
CREATE TABLE escala (
    id_escala NUMBER(10) PRIMARY KEY,
    id_ruta NUMBER(10) NOT NULL,
    id_departamento NUMBER(10) NOT NULL,
    orden_escala NUMBER(2) NOT NULL,
    tiempo_parada_minutos NUMBER(3) DEFAULT 15 NOT NULL,
    CONSTRAINT fk_escala_ruta FOREIGN KEY (id_ruta) 
        REFERENCES ruta(id_ruta),
    CONSTRAINT fk_escala_depto FOREIGN KEY (id_departamento) 
        REFERENCES departamento(id_departamento),
    CONSTRAINT uk_escala_orden UNIQUE (id_ruta, orden_escala),
    CONSTRAINT chk_escala_orden CHECK (orden_escala > 0),
    CONSTRAINT chk_escala_tiempo CHECK (tiempo_parada_minutos >= 0)
);

COMMENT ON TABLE escala IS 'Escalas intermedias en rutas no directas';

-- =====================================================
-- TABLA: VIAJE
-- =====================================================
CREATE TABLE viaje (
    id_viaje NUMBER(10) PRIMARY KEY,
    id_ruta NUMBER(10) NOT NULL,
    id_bus NUMBER(10) NOT NULL,
    id_piloto NUMBER(10) NOT NULL,
    fecha_salida DATE NOT NULL,
    hora_salida TIMESTAMP NOT NULL,
    tiempo_estimado_minutos NUMBER(5) NOT NULL,
    fecha_llegada_estimada DATE NOT NULL,
    hora_llegada_estimada TIMESTAMP NOT NULL,
    lugares_disponibles NUMBER(3) NOT NULL,
    precio_boleto NUMBER(10,2) NOT NULL,
    estado VARCHAR2(20) DEFAULT 'PROGRAMADO' NOT NULL,
    fecha_registro TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,
    CONSTRAINT fk_viaje_ruta FOREIGN KEY (id_ruta) 
        REFERENCES ruta(id_ruta),
    CONSTRAINT fk_viaje_bus FOREIGN KEY (id_bus) 
        REFERENCES bus(id_bus),
    CONSTRAINT fk_viaje_piloto FOREIGN KEY (id_piloto) 
        REFERENCES piloto(id_piloto),
    CONSTRAINT chk_viaje_estado CHECK (estado IN ('PROGRAMADO', 'EN_CURSO', 'FINALIZADO', 'CANCELADO')),
    CONSTRAINT chk_viaje_lugares CHECK (lugares_disponibles >= 0),
    CONSTRAINT chk_viaje_precio CHECK (precio_boleto > 0),
    CONSTRAINT chk_viaje_tiempo CHECK (tiempo_estimado_minutos > 0)
);

COMMENT ON TABLE viaje IS 'Viajes programados en rutas específicas';

-- =====================================================
-- TABLA: CLIENTE
-- =====================================================
CREATE TABLE cliente (
    id_cliente NUMBER(10) PRIMARY KEY,
    nombres VARCHAR2(100) NOT NULL,
    apellidos VARCHAR2(100) NOT NULL,
    dpi VARCHAR2(20) NOT NULL UNIQUE,
    nit VARCHAR2(20),
    telefono VARCHAR2(20) NOT NULL,
    email VARCHAR2(100) NOT NULL UNIQUE,
    direccion VARCHAR2(200),
    fecha_nacimiento DATE,
    fecha_registro DATE DEFAULT SYSDATE NOT NULL,
    estado CHAR(1) DEFAULT 'A' NOT NULL,
    CONSTRAINT chk_cliente_estado CHECK (estado IN ('A', 'I'))
);

COMMENT ON TABLE cliente IS 'Registro de clientes del sistema';

-- =====================================================
-- TABLA: TIPO_PAGO
-- =====================================================
CREATE TABLE tipo_pago (
    id_tipo_pago NUMBER(10) PRIMARY KEY,
    nombre VARCHAR2(50) NOT NULL UNIQUE,
    descripcion VARCHAR2(200),
    requiere_verificacion CHAR(1) DEFAULT 'N' NOT NULL,
    estado CHAR(1) DEFAULT 'A' NOT NULL,
    CONSTRAINT chk_tipo_pago_verif CHECK (requiere_verificacion IN ('S', 'N')),
    CONSTRAINT chk_tipo_pago_estado CHECK (estado IN ('A', 'I'))
);

COMMENT ON TABLE tipo_pago IS 'Catálogo de métodos de pago (Tarjeta, Depósito, Efectivo)';

-- =====================================================
-- TABLA: RESERVACION
-- =====================================================
CREATE TABLE reservacion (
    id_reservacion NUMBER(10) PRIMARY KEY,
    id_viaje NUMBER(10) NOT NULL,
    id_cliente NUMBER(10) NOT NULL,
    codigo_reservacion VARCHAR2(20) NOT NULL UNIQUE,
    fecha_reservacion TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,
    cantidad_pasajeros NUMBER(2) NOT NULL,
    numero_asiento VARCHAR2(50),
    monto_total NUMBER(10,2) NOT NULL,
    estado VARCHAR2(20) DEFAULT 'PENDIENTE' NOT NULL,
    fecha_expiracion TIMESTAMP,
    fecha_confirmacion TIMESTAMP,
    CONSTRAINT fk_reserva_viaje FOREIGN KEY (id_viaje) 
        REFERENCES viaje(id_viaje),
    CONSTRAINT fk_reserva_cliente FOREIGN KEY (id_cliente) 
        REFERENCES cliente(id_cliente),
    CONSTRAINT chk_reserva_estado CHECK (estado IN ('PENDIENTE', 'CONFIRMADA', 'CANCELADA', 'EXPIRADA')),
    CONSTRAINT chk_reserva_cantidad CHECK (cantidad_pasajeros > 0),
    CONSTRAINT chk_reserva_monto CHECK (monto_total > 0)
);

COMMENT ON TABLE reservacion IS 'Reservaciones de pasajeros';

-- =====================================================
-- TABLA: ROL
-- =====================================================
CREATE TABLE rol (
    id_rol NUMBER(10) PRIMARY KEY,
    nombre VARCHAR2(50) NOT NULL UNIQUE,
    descripcion VARCHAR2(200),
    estado CHAR(1) DEFAULT 'A' NOT NULL,
    CONSTRAINT chk_rol_estado CHECK (estado IN ('A', 'I'))
);

COMMENT ON TABLE rol IS 'Roles de usuario del sistema';

-- =====================================================
-- TABLA: USUARIO
-- =====================================================
CREATE TABLE usuario (
    id_usuario NUMBER(10) PRIMARY KEY,
    id_rol NUMBER(10) NOT NULL,
    id_cliente NUMBER(10),
    id_piloto NUMBER(10),
    username VARCHAR2(50) NOT NULL UNIQUE,
    password_hash VARCHAR2(256) NOT NULL,
    email VARCHAR2(100) NOT NULL UNIQUE,
    fecha_creacion TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,
    ultimo_acceso TIMESTAMP,
    estado CHAR(1) DEFAULT 'A' NOT NULL,
    intentos_fallidos NUMBER(2) DEFAULT 0 NOT NULL,
    bloqueado CHAR(1) DEFAULT 'N' NOT NULL,
    CONSTRAINT fk_usuario_rol FOREIGN KEY (id_rol) 
        REFERENCES rol(id_rol),
    CONSTRAINT fk_usuario_cliente FOREIGN KEY (id_cliente) 
        REFERENCES cliente(id_cliente),
    CONSTRAINT fk_usuario_piloto FOREIGN KEY (id_piloto) 
        REFERENCES piloto(id_piloto),
    CONSTRAINT chk_usuario_estado CHECK (estado IN ('A', 'I')),
    CONSTRAINT chk_usuario_bloqueado CHECK (bloqueado IN ('S', 'N')),
    CONSTRAINT chk_usuario_intentos CHECK (intentos_fallidos >= 0)
);

COMMENT ON TABLE usuario IS 'Usuarios del sistema con autenticación';

-- =====================================================
-- TABLA: PAGO
-- =====================================================
CREATE TABLE pago (
    id_pago NUMBER(10) PRIMARY KEY,
    id_tipo_pago NUMBER(10) NOT NULL,
    id_reservacion NUMBER(10),
    id_encomienda NUMBER(10),
    monto NUMBER(10,2) NOT NULL,
    fecha_pago TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,
    numero_transaccion VARCHAR2(100),
    numero_autorizacion VARCHAR2(100),
    imagen_comprobante VARCHAR2(300),
    estado VARCHAR2(20) DEFAULT 'PENDIENTE' NOT NULL,
    fecha_verificacion TIMESTAMP,
    verificado_por NUMBER(10),
    observaciones VARCHAR2(500),
    CONSTRAINT fk_pago_tipo FOREIGN KEY (id_tipo_pago) 
        REFERENCES tipo_pago(id_tipo_pago),
    CONSTRAINT fk_pago_reserva FOREIGN KEY (id_reservacion) 
        REFERENCES reservacion(id_reservacion),
    CONSTRAINT fk_pago_verificador FOREIGN KEY (verificado_por) 
        REFERENCES usuario(id_usuario),
    CONSTRAINT chk_pago_estado CHECK (estado IN ('PENDIENTE', 'VERIFICADO', 'RECHAZADO')),
    CONSTRAINT chk_pago_monto CHECK (monto > 0),
    CONSTRAINT chk_pago_origen CHECK (id_reservacion IS NOT NULL OR id_encomienda IS NOT NULL)
);

COMMENT ON TABLE pago IS 'Pagos realizados por reservaciones o encomiendas';

-- =====================================================
-- TABLA: BOLETO
-- =====================================================
CREATE TABLE boleto (
    id_boleto NUMBER(10) PRIMARY KEY,
    id_reservacion NUMBER(10) NOT NULL,
    id_viaje NUMBER(10) NOT NULL,
    id_cliente NUMBER(10) NOT NULL,
    codigo_boleto VARCHAR2(30) NOT NULL UNIQUE,
    numero_asiento VARCHAR2(10) NOT NULL,
    nombre_pasajero VARCHAR2(200) NOT NULL,
    dpi_pasajero VARCHAR2(20),
    fecha_emision TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,
    precio NUMBER(10,2) NOT NULL,
    estado VARCHAR2(20) DEFAULT 'ACTIVO' NOT NULL,
    CONSTRAINT fk_boleto_reserva FOREIGN KEY (id_reservacion) 
        REFERENCES reservacion(id_reservacion),
    CONSTRAINT fk_boleto_viaje FOREIGN KEY (id_viaje) 
        REFERENCES viaje(id_viaje),
    CONSTRAINT fk_boleto_cliente FOREIGN KEY (id_cliente) 
        REFERENCES cliente(id_cliente),
    CONSTRAINT chk_boleto_estado CHECK (estado IN ('ACTIVO', 'USADO', 'CANCELADO')),
    CONSTRAINT chk_boleto_precio CHECK (precio > 0)
);

COMMENT ON TABLE boleto IS 'Boletos emitidos para pasajeros';

-- =====================================================
-- TABLA: ENCOMIENDA
-- =====================================================
CREATE TABLE encomienda (
    id_encomienda NUMBER(10) PRIMARY KEY,
    id_viaje NUMBER(10) NOT NULL,
    id_cliente_remitente NUMBER(10) NOT NULL,
    codigo_encomienda VARCHAR2(30) NOT NULL UNIQUE,
    nombre_destinatario VARCHAR2(200) NOT NULL,
    telefono_destinatario VARCHAR2(20) NOT NULL,
    direccion_destinatario VARCHAR2(300) NOT NULL,
    descripcion_contenido VARCHAR2(500) NOT NULL,
    peso_libras NUMBER(8,2) NOT NULL,
    volumen_m3 NUMBER(8,4) NOT NULL,
    tarifa NUMBER(10,2) NOT NULL,
    fecha_registro TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,
    fecha_entrega TIMESTAMP,
    estado VARCHAR2(20) DEFAULT 'REGISTRADA' NOT NULL,
    observaciones VARCHAR2(500),
    CONSTRAINT fk_encom_viaje FOREIGN KEY (id_viaje) 
        REFERENCES viaje(id_viaje),
    CONSTRAINT fk_encom_remitente FOREIGN KEY (id_cliente_remitente) 
        REFERENCES cliente(id_cliente),
    CONSTRAINT chk_encom_estado CHECK (estado IN ('REGISTRADA', 'EN_TRANSITO', 'ENTREGADA', 'DEVUELTA')),
    CONSTRAINT chk_encom_peso CHECK (peso_libras > 0),
    CONSTRAINT chk_encom_volumen CHECK (volumen_m3 > 0 AND volumen_m3 < 1),
    CONSTRAINT chk_encom_tarifa CHECK (tarifa > 0)
);

COMMENT ON TABLE encomienda IS 'Encomiendas registradas para transporte';

-- Agregar FK de encomienda a pago
ALTER TABLE pago ADD CONSTRAINT fk_pago_encom 
    FOREIGN KEY (id_encomienda) REFERENCES encomienda(id_encomienda);

-- =====================================================
-- TABLA: PERMISO
-- =====================================================
CREATE TABLE permiso (
    id_permiso NUMBER(10) PRIMARY KEY,
    nombre VARCHAR2(100) NOT NULL UNIQUE,
    descripcion VARCHAR2(200),
    modulo VARCHAR2(50) NOT NULL,
    accion VARCHAR2(50) NOT NULL
);

COMMENT ON TABLE permiso IS 'Permisos del sistema por módulo y acción';

-- =====================================================
-- TABLA: ROL_PERMISO
-- =====================================================
CREATE TABLE rol_permiso (
    id_rol_permiso NUMBER(10) PRIMARY KEY,
    id_rol NUMBER(10) NOT NULL,
    id_permiso NUMBER(10) NOT NULL,
    CONSTRAINT fk_rolperm_rol FOREIGN KEY (id_rol) 
        REFERENCES rol(id_rol),
    CONSTRAINT fk_rolperm_permiso FOREIGN KEY (id_permiso) 
        REFERENCES permiso(id_permiso),
    CONSTRAINT uk_rol_permiso UNIQUE (id_rol, id_permiso)
);

COMMENT ON TABLE rol_permiso IS 'Relación entre roles y permisos';

-- =====================================================
-- TABLA: BITACORA
-- =====================================================
CREATE TABLE bitacora (
    id_bitacora NUMBER(10) PRIMARY KEY,
    id_usuario NUMBER(10),
    tabla_afectada VARCHAR2(50) NOT NULL,
    operacion VARCHAR2(10) NOT NULL,
    registro_id NUMBER(10),
    valores_anteriores CLOB,
    valores_nuevos CLOB,
    fecha_hora TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,
    ip_address VARCHAR2(50),
    descripcion VARCHAR2(500),
    CONSTRAINT fk_bitacora_usuario FOREIGN KEY (id_usuario) 
        REFERENCES usuario(id_usuario),
    CONSTRAINT chk_bitacora_operacion CHECK (operacion IN ('INSERT', 'UPDATE', 'DELETE', 'LOGIN', 'LOGOUT'))
);

COMMENT ON TABLE bitacora IS 'Registro de auditoría de eventos del sistema';

-- =====================================================
-- TABLA: PARAMETRO
-- =====================================================
CREATE TABLE parametro (
    id_parametro NUMBER(10) PRIMARY KEY,
    nombre VARCHAR2(100) NOT NULL UNIQUE,
    valor VARCHAR2(500) NOT NULL,
    descripcion VARCHAR2(300),
    tipo_dato VARCHAR2(20) NOT NULL,
    fecha_modificacion TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,
    CONSTRAINT chk_param_tipo CHECK (tipo_dato IN ('STRING', 'NUMBER', 'DATE', 'BOOLEAN'))
);

COMMENT ON TABLE parametro IS 'Parámetros de configuración del sistema';

-- =====================================================
-- ÍNDICES ADICIONALES PARA OPTIMIZACIÓN
-- =====================================================

CREATE INDEX idx_municipio_depto ON municipio(id_departamento);
CREATE INDEX idx_bus_tipo ON bus(id_tipo_bus);
CREATE INDEX idx_bus_estado ON bus(estado);
CREATE INDEX idx_ruta_origen ON ruta(id_departamento_origen);
CREATE INDEX idx_ruta_destino ON ruta(id_departamento_destino);
CREATE INDEX idx_viaje_ruta ON viaje(id_ruta);
CREATE INDEX idx_viaje_bus ON viaje(id_bus);
CREATE INDEX idx_viaje_piloto ON viaje(id_piloto);
CREATE INDEX idx_viaje_fecha ON viaje(fecha_salida);
CREATE INDEX idx_viaje_estado ON viaje(estado);
CREATE INDEX idx_reserva_viaje ON reservacion(id_viaje);
CREATE INDEX idx_reserva_cliente ON reservacion(id_cliente);
CREATE INDEX idx_reserva_estado ON reservacion(estado);
CREATE INDEX idx_pago_reserva ON pago(id_reservacion);
CREATE INDEX idx_pago_encom ON pago(id_encomienda);
CREATE INDEX idx_pago_estado ON pago(estado);
CREATE INDEX idx_boleto_reserva ON boleto(id_reservacion);
CREATE INDEX idx_boleto_viaje ON boleto(id_viaje);
CREATE INDEX idx_encom_viaje ON encomienda(id_viaje);
CREATE INDEX idx_encom_cliente ON encomienda(id_cliente_remitente);
CREATE INDEX idx_usuario_rol ON usuario(id_rol);
CREATE INDEX idx_bitacora_usuario ON bitacora(id_usuario);
CREATE INDEX idx_bitacora_fecha ON bitacora(fecha_hora);

COMMIT;

