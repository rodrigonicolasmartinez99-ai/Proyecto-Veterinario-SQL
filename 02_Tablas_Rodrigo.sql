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

-- MEJORAS:

-- * IDENTITY(1,1): SQL Server genera automáticamente los identificadores 1, 2, 3…
-- * PRIMARY KEY: identifica cada servicio de manera única.
-- * NOT NULL: obliga a ingresar un valor.
-- * DEFAULT 1: indica que el servicio estará activo por defecto.
-- * CHECK (precioActual >= 0): impide registrar precios negativos.

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

-- MEJORAS:

-- * NOT NULL: los tres campos son obligatorios.
-- * PRIMARY KEY (idAtencion, idServicio): mantiene la clave primaria compuesta.
-- * CONSTRAINT: permite ponerle un nombre a cada restricción.
-- * CHECK (precioAplicado >= 0): impide registrar precios negativos.

-- Además, conservamos las dos claves foráneas que relacionan esta tabla con Atencion y Servicio.

-- Importante: no agregamos IDENTITY porque esta tabla utiliza una clave primaria compuesta.

-- 10. ESTUDIO
-- En nuestra veterinaria, un profesional puede solicitar estudios para un animal, 
-- por ejemplo, un análisis de sangre, una radiografía o una ecografía.
-- La tabla Estudio permite registrar qué estudio se solicitó, cuándo, cuál fue su resultado y cuánto costó.

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

-- MEJORAS:

-- * IDENTITY(1,1): Genera automáticamente el número identificador del estudio.
-- * NOT NULL: Obliga a completar los datos importantes.
-- * FOREIGN KEY: Relaciona cada estudio con una atención veterinaria existente.
-- * CHECK (precio >= 0): Evita registrar precios negativos.
-- * DEFAULT 1: Asigna el estado inicial si no indicamos otro.
-- * CHECK (estado IN (1, 2, 3)):Solo permite tres valores para el estado.

-- Para este proyecto, podemos definir los estados de la siguiente manera:
-- 1 = Solicitado.
-- 2 = Realizado.
-- 3 = Cancelado.

-- Estos valores son una propuesta nuestra para organizar el sistema.
-- Una observación importante: resultado no tiene NOT NULL, porque cuando el veterinario solicita el estudio, 
-- todavía puede no existir ningún resultado.

-- 11. MEDICAMENTO
-- Esta tabla nos permite registrar los medicamentos que tiene la veterinaria, su precio y la cantidad disponible.

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

-- MEJORAS:

-- * IDENTITY(1,1): genera automáticamente el identificador del medicamento.
-- * NOT NULL: obliga a completar determinados datos.
-- * DEFAULT 0: si no indicamos el stock, comienza en cero.
-- * DEFAULT 1: el medicamento se registra como activo.
-- * CHECK (precioVenta >= 0): impide precios negativos.
-- * CHECK (stock >= 0): impide cantidades negativas.

-- 12. PRESCRIPCION
-- Esta tabla registra los medicamentos que el veterinario receta durante una atención.

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

-- MEJORAS:

-- * IDENTITY(1,1): genera automáticamente el identificador de la prescripción.
-- * NOT NULL: obliga a indicar la atención, el medicamento, la frecuencia y la duración.
-- * FOREIGN KEY: garantiza que la atención y el medicamento existan en sus respectivas tablas.
-- * indicaciones: puede quedar vacío (NULL) si no hay instrucciones adicionales.

-- 13. VENTAMEDICAMENTO
-- Esta tabla registra los medicamentos que se venden durante una atención veterinaria.

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

--MEJORAS:

-- * IDENTITY(1,1): genera automáticamente el identificador de la venta.
-- * NOT NULL: obliga a completar los datos de la venta.
-- * FOREIGN KEY: relaciona la venta con una atención y un medicamento existente.
-- * CHECK (cantidad > 0): exige vender al menos una unidad.
-- * CHECK (precioUnitario >= 0): impide precios negativos.

--También conservamos precioUnitario para registrar el precio al momento de la venta, 
--aunque posteriormente cambie precioVenta en la tabla Medicamento.

-- 14. PAGO
-- Esta tabla registra los pagos realizados en la veterinaria.

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

-- MEJORAS:

-- * IDENTITY(1,1): genera automáticamente el identificador del pago.
-- * DEFAULT GETDATE(): registra la fecha y hora actual si no indicamos otra.
-- * CHECK (monto > 0): impide registrar pagos de cero pesos o negativos.
-- * CHECK (medioPago IN (1, 2, 3)): limita los medios de pago a los valores que definamos.
-- * DEFAULT 1: establece el estado inicial del pago. 

-- Campo	      Valores propuestos

-- medioPago	  1 = Efectivo, 2 = Débito, 3 = Transferencia
-- estadoPago	  1 = Registrado, 2 = Anulado

-- 15. PAGOATENCION
-- Esta es otra de nuestras tablas intermedias. Sirve para relacionar los pagos con las atenciones veterinarias.

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

-- MEJORAS:

-- * idPago: identifica el pago registrado.
-- * idAtencion: identifica la atención a la que se aplica ese pago.
-- * montoAplicado: indica cuánto dinero de ese pago corresponde a esa atención.
-- * PRIMARY KEY (idPago, idAtencion): evita repetir la misma combinación de pago y atención.
-- * FOREIGN KEY: garantiza que el pago y la atención existan.
-- * CHECK (montoAplicado > 0): impide asignar montos iguales a cero o negativos.
