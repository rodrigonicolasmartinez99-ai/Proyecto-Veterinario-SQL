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

-- MEJORAS:

-- * IDENTITY(1,1): genera automáticamente el identificador de cada persona.
-- * NOT NULL: obliga a ingresar el DNI, nombre y apellido.
-- * DEFAULT 1: registra a la persona como activa si no indicamos otro valor.
-- * UNIQUE (dni): impide registrar dos personas con el mismo DNI.

-- En nuestro sistema, la tabla Persona sirve tanto para registrar a los responsables de los animales como para almacenar los datos personales de los veterinarios.

-- 2. ANIMAL
-- Esta tabla permite registrar las mascotas y relacionarlas con sus responsables.

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

-- MEJORAS:

-- * IDENTITY(1,1): genera automáticamente el identificador del animal.
-- * NOT NULL: obliga a ingresar un responsable, un nombre y una especie.
-- * FOREIGN KEY: garantiza que el responsable exista en Persona.
-- * DEFAULT 1: registra al animal como activo.
-- * CHECK (sexo IN (...)): permite solamente los valores Macho y Hembra cuando se informa el sexo. También admite NULL, porque no definimos NOT NULL.

-- 3. VETERINARIO
-- Esta tabla guarda los datos profesionales de los veterinarios. Sus datos personales, como nombre, apellido y DNI, ya están registrados en Persona.

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

-- MEJORAS:

-- * IDENTITY(1,1): genera automáticamente el identificador del veterinario.
-- * NOT NULL: obliga a completar la persona asociada, la matrícula y el título.
-- * UNIQUE (idPersona): impide registrar a una misma persona dos veces como veterinario.
-- * UNIQUE (matricula): evita registrar dos veterinarios con la misma matrícula.
-- * FOREIGN KEY: garantiza que el veterinario esté vinculado a una persona existente.
-- * DEFAULT 1: registra al veterinario como activo.

-- 4. ESPECIALIDAD
-- Esta tabla guarda las especialidades que pueden tener los veterinarios, como cardiología, dermatología o cirugía.


CREATE TABLE Especialidad (
    idEspecialidad INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    descripcion VARCHAR(150),

    CONSTRAINT UQ_Especialidad_Nombre
        UNIQUE (nombre)
);

-- MEJORAS:

-- * IDENTITY(1,1): genera automáticamente el identificador de cada especialidad.
-- * NOT NULL: obliga a ingresar el nombre de la especialidad.
-- * UNIQUE (nombre): evita registrar dos especialidades con el mismo nombre.
-- * descripcion: es opcional, por eso puede contener NULL.

-- 5. VETERINARIOESPECIALIDAD
-- Esta es una de las tres tablas intermedias de nuestro Sistema de Gestión Veterinaria.
-- La necesitamos porque un veterinario puede tener varias especialidades y una especialidad puede corresponder a varios veterinarios. Es decir, tenemos una relación muchos a muchos (N:M).


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

-- MEJORAS: 

-- * NOT NULL: ambos identificadores son obligatorios.
-- * PRIMARY KEY (idVeterinario, idEspecialidad): evita repetir una misma combinación.
-- * FOREIGN KEY: garantiza que el veterinario y la especialidad existan.
-- * CONSTRAINT: permite asignar nombres a las restricciones.

-- No necesitamos IDENTITY, porque utilizamos una clave primaria compuesta.

-- 6. TURNO
-- Esta tabla permite registrar los turnos solicitados para los animales y los veterinarios que los atenderán.

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

-- MEJORAS:

-- * IDENTITY(1,1): genera automáticamente el identificador del turno.
-- * NOT NULL: obliga a indicar el animal, veterinario, fecha, hora y tipo de turno.
-- * FOREIGN KEY: comprueba que el animal y el veterinario existan.
-- * DEFAULT 1: asigna automáticamente el estado inicial.
-- * CHECK: limita los valores permitidos para el estado y el tipo de turno.

-- Podemos establecer estos códigos para nuestro sistema:

-- Campo	  Valor	  Significado

-- estado	    1	  Pendiente
-- estado	    2	  Atendido
-- estado	    3	  Cancelado
-- estado	    4	  Ausente
-- tipoTurno	1	  Programado
-- tipoTurno	2	  Urgencia

--Estos códigos son una propuesta que después podemos ajustar con Rodrigo.

-- 7. ATENCION
-- Esta tabla permite registrar lo que sucede durante una consulta veterinaria: el motivo, el peso del animal, su temperatura, el diagnóstico, etc.


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

-- MEJORAS:

-- * IDENTITY(1,1): genera automáticamente el identificador de la atención.
-- * NOT NULL: obliga a registrar el turno y el motivo de consulta.
-- * UNIQUE (idTurno): permite como máximo una atención por turno.
-- * DEFAULT 2: asigna una prioridad normal si no indicamos otra.
-- * CHECK: impide prioridades no válidas y valores negativos o iguales a cero en las mediciones, cuando estas se registran.

-- Para nuestro proyecto podemos definir las prioridades así:

-- Valor	Prioridad

--  1	    Baja
--  2	    Normal
--  3	    Alta