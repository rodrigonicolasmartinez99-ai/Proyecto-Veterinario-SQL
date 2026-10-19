
-- TPI Base de Datos II
-- Sistema de Gestion Veterinaria
-- Pruebas de integridad y restricciones

USE [Base de datos de prueba];
GO

-- PRUEBA 1: Verificar registros de Persona
SELECT * FROM Persona;

-- PRUEBA 2: Verificar registros de Animal
SELECT * FROM Animal;

-- PRUEBA 3: Verificar registros de Medicamento
SELECT * FROM Medicamento;

-- Las siguientes pruebas deben ejecutarse
-- individualmente y se espera que produzcan errores.

-- PRUEBA 4: DNI duplicado - UNIQUE
-- INSERT INTO Persona (dni, nombre, apellido)
-- VALUES ('12345678', 'Maria', 'Gomez');

-- PRUEBA 5: Responsable inexistente - FOREIGN KEY
-- INSERT INTO Animal (idPersonaResponsable, nombre, especie)
-- VALUES (999, 'Firulais', 'Perro');

-- PRUEBA 6: Stock negativo - CHECK
-- INSERT INTO Medicamento (nombre, tipo, precioVenta, stock)
-- VALUES ('Amoxicilina', 'Antibiotico', 5000, -10);
