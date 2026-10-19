-- TPI Base de Datos II
-- Sistema de Gestion Veterinaria
-- Script integrado de creacion de tablas

USE [Base de datos de prueba];
GO

-- 1. PERSONA

CREATE TABLE Persona (
    idPersona INT IDENTITY(1,1) PRIMARY KEY,
    dni VARCHAR(15) NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    fechaNacimiento DATE,
    telefono VARCHAR(20),
    mail VARCHAR(100),
    domicilio VARCHAR(100),
    localidad VARCHAR(60),
    activo BIT NOT NULL DEFAULT 1,

    CONSTRAINT UQ_Persona_DNI
        UNIQUE (dni)
);

-- 2. ANIMAL

CREATE TABLE Animal (
    idAnimal INT IDENTITY(1,1) PRIMARY KEY,
    idPersonaResponsable INT NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    especie VARCHAR(30) NOT NULL,
    raza VARCHAR(50),
    sexo VARCHAR(15),
    fechaNacimiento DATE,
    activo BIT NOT NULL DEFAULT 1,

    CONSTRAINT FK_Animal_Persona
        FOREIGN KEY (idPersonaResponsable)
        REFERENCES Persona(idPersona),

    CONSTRAINT CK_Animal_Sexo
        CHECK (sexo IN ('Macho', 'Hembra'))
);

-- 3. VETERINARIO

CREATE TABLE Veterinario (
    idVeterinario INT IDENTITY(1,1) PRIMARY KEY,
    idPersona INT NOT NULL UNIQUE,
    matricula VARCHAR(30) NOT NULL UNIQUE,
    titulo VARCHAR(100) NOT NULL,
    universidad VARCHAR(100),
    activo BIT NOT NULL DEFAULT 1,

    CONSTRAINT FK_Veterinario_Persona
        FOREIGN KEY (idPersona)
        REFERENCES Persona(idPersona)
);

-- 4. ESPECIALIDAD

CREATE TABLE Especialidad (
    idEspecialidad INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    descripcion VARCHAR(150),

    CONSTRAINT UQ_Especialidad_Nombre
        UNIQUE (nombre)
);

-- 5. VETERINARIOESPECIALIDAD

CREATE TABLE VeterinarioEspecialidad (
    idVeterinario INT NOT NULL,
    idEspecialidad INT NOT NULL,

    CONSTRAINT PK_VeterinarioEspecialidad
        PRIMARY KEY (idVeterinario, idEspecialidad),

    CONSTRAINT FK_VeterinarioEspecialidad_Veterinario
        FOREIGN KEY (idVeterinario)
        REFERENCES Veterinario(idVeterinario),

    CONSTRAINT FK_VeterinarioEspecialidad_Especialidad
        FOREIGN KEY (idEspecialidad)
        REFERENCES Especialidad(idEspecialidad)
);

-- 6. TURNO

CREATE TABLE Turno (
    idTurno INT IDENTITY(1,1) PRIMARY KEY,
    idAnimal INT NOT NULL,
    idVeterinario INT NOT NULL,
    fecha DATE NOT NULL,
    hora TIME NOT NULL,
    estado INT NOT NULL DEFAULT 1,
    tipoTurno INT NOT NULL,

    CONSTRAINT FK_Turno_Animal
        FOREIGN KEY (idAnimal)
        REFERENCES Animal(idAnimal),

    CONSTRAINT FK_Turno_Veterinario
        FOREIGN KEY (idVeterinario)
        REFERENCES Veterinario(idVeterinario),

    CONSTRAINT CK_Turno_Estado
        CHECK (estado IN (1, 2, 3, 4)),

    CONSTRAINT CK_Turno_Tipo
        CHECK (tipoTurno IN (1, 2))
);

-- 7. ATENCION

CREATE TABLE Atencion (
    idAtencion INT IDENTITY(1,1) PRIMARY KEY,
    idTurno INT NOT NULL UNIQUE,
    motivoConsulta VARCHAR(200) NOT NULL,
    prioridad INT NOT NULL DEFAULT 2,
    peso DECIMAL(6,2),
    temperatura DECIMAL(4,1),
    frecuenciaCardiaca INT,
    diagnostico VARCHAR(500),

    CONSTRAINT FK_Atencion_Turno
        FOREIGN KEY (idTurno)
        REFERENCES Turno(idTurno),

    CONSTRAINT CK_Atencion_Prioridad
        CHECK (prioridad IN (1, 2, 3)),

    CONSTRAINT CK_Atencion_Peso
        CHECK (peso > 0),

    CONSTRAINT CK_Atencion_Temperatura
        CHECK (temperatura > 0),

    CONSTRAINT CK_Atencion_Frecuencia
        CHECK (frecuenciaCardiaca > 0)
);

-- 8. SERVICIO

CREATE TABLE Servicio (
    idServicio INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(60) NOT NULL,
    descripcion VARCHAR(200),
    precioActual DECIMAL(12,2) NOT NULL,
    activo BIT NOT NULL DEFAULT 1,

    CONSTRAINT CK_Servicio_Precio
        CHECK (precioActual >= 0)
);

-- 9. ATENCIONSERVICIO

CREATE TABLE AtencionServicio (
    idAtencion INT NOT NULL,
    idServicio INT NOT NULL,
    precioAplicado DECIMAL(12,2) NOT NULL,

    CONSTRAINT PK_AtencionServicio
        PRIMARY KEY (idAtencion, idServicio),

    CONSTRAINT FK_AtencionServicio_Atencion
        FOREIGN KEY (idAtencion)
        REFERENCES Atencion(idAtencion),

    CONSTRAINT FK_AtencionServicio_Servicio
        FOREIGN KEY (idServicio)
        REFERENCES Servicio(idServicio),

    CONSTRAINT CK_AtencionServicio_Precio
        CHECK (precioAplicado >= 0)
);

-- 10. ESTUDIO

CREATE TABLE Estudio (
    idEstudio INT IDENTITY(1,1) PRIMARY KEY,
    idAtencion INT NOT NULL,
    tipoEstudio VARCHAR(60) NOT NULL,
    fechaSolicitud DATE NOT NULL,
    resultado VARCHAR(500),
    estado INT NOT NULL DEFAULT 1,
    precio DECIMAL(12,2) NOT NULL,

    CONSTRAINT FK_Estudio_Atencion
        FOREIGN KEY (idAtencion)
        REFERENCES Atencion(idAtencion),

    CONSTRAINT CK_Estudio_Precio
        CHECK (precio >= 0),

    CONSTRAINT CK_Estudio_Estado
        CHECK (estado IN (1, 2, 3))
);

-- 11. MEDICAMENTO

CREATE TABLE Medicamento (
    idMedicamento INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(60) NOT NULL,
    tipo VARCHAR(40) NOT NULL,
    presentacion VARCHAR(60),
    precioVenta DECIMAL(12,2) NOT NULL,
    stock INT NOT NULL DEFAULT 0,
    activo BIT NOT NULL DEFAULT 1,

    CONSTRAINT CK_Medicamento_Precio
        CHECK (precioVenta >= 0),

    CONSTRAINT CK_Medicamento_Stock
        CHECK (stock >= 0)
);

-- 12. PRESCRIPCION

CREATE TABLE Prescripcion (
    idPrescripcion INT IDENTITY(1,1) PRIMARY KEY,
    idAtencion INT NOT NULL,
    idMedicamento INT NOT NULL,
    frecuencia VARCHAR(50) NOT NULL,
    duracion VARCHAR(50) NOT NULL,
    indicaciones VARCHAR(200),

    CONSTRAINT FK_Prescripcion_Atencion
        FOREIGN KEY (idAtencion)
        REFERENCES Atencion(idAtencion),

    CONSTRAINT FK_Prescripcion_Medicamento
        FOREIGN KEY (idMedicamento)
        REFERENCES Medicamento(idMedicamento)
);

-- 13. VENTAMEDICAMENTO

CREATE TABLE VentaMedicamento (
    idVentaMedicamento INT IDENTITY(1,1) PRIMARY KEY,
    idAtencion INT NOT NULL,
    idMedicamento INT NOT NULL,
    cantidad INT NOT NULL,
    precioUnitario DECIMAL(12,2) NOT NULL,

    CONSTRAINT FK_VentaMedicamento_Atencion
        FOREIGN KEY (idAtencion)
        REFERENCES Atencion(idAtencion),

    CONSTRAINT FK_VentaMedicamento_Medicamento
        FOREIGN KEY (idMedicamento)
        REFERENCES Medicamento(idMedicamento),

    CONSTRAINT CK_VentaMedicamento_Cantidad
        CHECK (cantidad > 0),

    CONSTRAINT CK_VentaMedicamento_Precio
        CHECK (precioUnitario >= 0)
);

-- 14. PAGO

CREATE TABLE Pago (
    idPago INT IDENTITY(1,1) PRIMARY KEY,
    fechaPago DATETIME NOT NULL DEFAULT GETDATE(),
    monto DECIMAL(12,2) NOT NULL,
    medioPago INT NOT NULL,
    estadoPago INT NOT NULL DEFAULT 1,

    CONSTRAINT CK_Pago_Monto
        CHECK (monto > 0),

    CONSTRAINT CK_Pago_Medio
        CHECK (medioPago IN (1, 2, 3)),

    CONSTRAINT CK_Pago_Estado
        CHECK (estadoPago IN (1, 2))
);

-- 15. PAGOATENCION

CREATE TABLE PagoAtencion (
    idPago INT NOT NULL,
    idAtencion INT NOT NULL,
    montoAplicado DECIMAL(12,2) NOT NULL,

    CONSTRAINT PK_PagoAtencion
        PRIMARY KEY (idPago, idAtencion),

    CONSTRAINT FK_PagoAtencion_Pago
        FOREIGN KEY (idPago)
        REFERENCES Pago(idPago),

    CONSTRAINT FK_PagoAtencion_Atencion
        FOREIGN KEY (idAtencion)
        REFERENCES Atencion(idAtencion),

    CONSTRAINT CK_PagoAtencion_Monto
        CHECK (montoAplicado > 0)
);

SELECT name
FROM [Base de datos de prueba].sys.tables;