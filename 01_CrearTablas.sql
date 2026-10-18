CREATE DATABASE GestionVeterinaria;
GO

USE GestionVeterinaria;
GO
-- 1. PERSONA
CREATE TABLE Persona (
    idPersona INT PRIMARY KEY,
    dni VARCHAR(15),
    nombre VARCHAR(50),
    apellido VARCHAR(50),
    fechaNacimiento DATE,
    telefono VARCHAR(20),
    mail VARCHAR(100),
    domicilio VARCHAR(100),
    localidad VARCHAR(60),
    activo BIT
);

-- 2. ANIMAL
CREATE TABLE Animal (
    idAnimal INT PRIMARY KEY,
    idPersonaResponsable INT,
    nombre VARCHAR(50),
    especie VARCHAR(30),
    raza VARCHAR(50),
    sexo VARCHAR(15),
    fechaNacimiento DATE,
    activo BIT,
    FOREIGN KEY (idPersonaResponsable)
        REFERENCES Persona(idPersona)
);

-- 3. VETERINARIO
CREATE TABLE Veterinario (
    idVeterinario INT PRIMARY KEY,
    idPersona INT UNIQUE,
    matricula VARCHAR(30),
    titulo VARCHAR(100),
    universidad VARCHAR(100),
    activo BIT,
    FOREIGN KEY (idPersona)
        REFERENCES Persona(idPersona)
);

-- 4. ESPECIALIDAD
CREATE TABLE Especialidad (
    idEspecialidad INT PRIMARY KEY,
    nombre VARCHAR(50),
    descripcion VARCHAR(150)
);

-- 5. VETERINARIOESPECIALIDAD
CREATE TABLE VeterinarioEspecialidad (
    idVeterinario INT,
    idEspecialidad INT,

    PRIMARY KEY (idVeterinario, idEspecialidad),

    FOREIGN KEY (idVeterinario)
        REFERENCES Veterinario(idVeterinario),

    FOREIGN KEY (idEspecialidad)
        REFERENCES Especialidad(idEspecialidad)
);

-- 6. TURNO
CREATE TABLE Turno (
    idTurno INT PRIMARY KEY,
    idAnimal INT,
    idVeterinario INT,
    fecha DATE,
    hora TIME,
    estado INT,
    tipoTurno INT,

    FOREIGN KEY (idAnimal)
        REFERENCES Animal(idAnimal),

    FOREIGN KEY (idVeterinario)
        REFERENCES Veterinario(idVeterinario)
);

-- 7. ATENCION
CREATE TABLE Atencion (
    idAtencion INT PRIMARY KEY,
    idTurno INT UNIQUE,
    motivoConsulta VARCHAR(200),
    prioridad INT,
    peso DECIMAL(6,2),
    temperatura DECIMAL(4,1),
    frecuenciaCardiaca INT,
    diagnostico VARCHAR(500),

    FOREIGN KEY (idTurno)
        REFERENCES Turno(idTurno)
);

-- 8. SERVICIO
CREATE TABLE Servicio (
    idServicio INT PRIMARY KEY,
    nombre VARCHAR(60),
    descripcion VARCHAR(200),
    precioActual DECIMAL(12,2),
    activo BIT
);

-- 9. ATENCIONSERVICIO
CREATE TABLE AtencionServicio (
    idAtencion INT,
    idServicio INT,
    precioAplicado DECIMAL(12,2),

    PRIMARY KEY (idAtencion, idServicio),

    FOREIGN KEY (idAtencion)
        REFERENCES Atencion(idAtencion),

    FOREIGN KEY (idServicio)
        REFERENCES Servicio(idServicio)
);

-- 10. ESTUDIO
CREATE TABLE Estudio (
    idEstudio INT PRIMARY KEY,
    idAtencion INT,
    tipoEstudio VARCHAR(60),
    fechaSolicitud DATE,
    resultado VARCHAR(500),
    estado INT,
    precio DECIMAL(12,2),

    FOREIGN KEY (idAtencion)
        REFERENCES Atencion(idAtencion)
);

-- 11. MEDICAMENTO
CREATE TABLE Medicamento (
    idMedicamento INT PRIMARY KEY,
    nombre VARCHAR(60),
    tipo VARCHAR(40),
    presentacion VARCHAR(60),
    precioVenta DECIMAL(12,2),
    stock INT,
    activo BIT
);

-- 12. PRESCRIPCION
CREATE TABLE Prescripcion (
    idPrescripcion INT PRIMARY KEY,
    idAtencion INT,
    idMedicamento INT,
    frecuencia VARCHAR(50),
    duracion VARCHAR(50),
    indicaciones VARCHAR(200),

    FOREIGN KEY (idAtencion)
        REFERENCES Atencion(idAtencion),

    FOREIGN KEY (idMedicamento)
        REFERENCES Medicamento(idMedicamento)
);

-- 13. VENTAMEDICAMENTO
CREATE TABLE VentaMedicamento (
    idVentaMedicamento INT PRIMARY KEY,
    idAtencion INT,
    idMedicamento INT,
    cantidad INT,
    precioUnitario DECIMAL(12,2),

    FOREIGN KEY (idAtencion)
        REFERENCES Atencion(idAtencion),

    FOREIGN KEY (idMedicamento)
        REFERENCES Medicamento(idMedicamento)
);

-- 14. PAGO
CREATE TABLE Pago (
    idPago INT PRIMARY KEY,
    fechaPago DATETIME,
    monto DECIMAL(12,2),
    medioPago INT,
    estadoPago INT
);

-- 15. PAGOATENCION
CREATE TABLE PagoAtencion (
    idPago INT,
    idAtencion INT,
    montoAplicado DECIMAL(12,2),

    PRIMARY KEY (idPago, idAtencion),

    FOREIGN KEY (idPago)
        REFERENCES Pago(idPago),

    FOREIGN KEY (idAtencion)
        REFERENCES Atencion(idAtencion)
);

