-- Creación Tabla Usuarios
create table Usuarios (
    id serial primary key not null,
    rol varchar(50) not null CHECK(rol = 'SUP' or rol = 'Padre' or rol = 'Maestro' or rol = 'Administrativo' or rol = 'Director')
);

-- Creación Tabla SuperUsuarios
CREATE TABLE IF NOT EXISTS SuperUsuarios (
  id serial primary key not null,
  rol int not null,
  nombre varchar(50) not null,
  apellido varchar(50) not null,
  email varchar(50) unique not null,
  telefono varchar(14) unique not null,
  password varchar(255) not null,
  activo boolean DEFAULT true,
  foreign key (rol) references Usuarios (id)
);

CREATE TABLE IF NOT EXISTS Directores (
    id serial primary key not null,
    rol int not null,
    nombre varchar(50) not null,
    apellido varchar(50) not null,
    email varchar(50) unique not null,
    telefono varchar(14) unique not null,
    password varchar(255) not null,
    activo boolean DEFAULT true,
    foreign key (rol) references Usuarios (id)
);

-- Creación Tabla Materias
create table Materias (
    id serial primary key not null,
    nombre varchar(50) not null
);

-- Creación Tabla Grados
create table Grados (
    id serial primary key not null,
    grado varchar(50) not null
);

-- Relacion de los grados con los directores
CREATE TABLE IF NOT EXISTS Grados_director (
    id serial primary key not null,
    id_grado int not null,
    id_director int not null,
    foreign key (id_grado) references Grados (id),
    foreign key (id_director) references Directores (id)
);

-- Creación Tabla Maestros
create table Maestros (
  id serial primary key not null,
  rol int not null,
  nombre varchar(50) not null,
  apellido varchar(50) not null,
  email varchar(50) unique not null,
  telefono varchar(14) unique not null,
  password varchar(255) not null,
  activo boolean DEFAULT true,
  foreign key (rol) references Usuarios (id)
);

-- Creación Tabla Estudiantes
create table Estudiantes (
  carnet int primary key not null,
  nombre varchar(50) not null,
  apellido varchar(50) not null,
  fecha_nacimiento date not null,
  grado int not null,
  foreign key (grado) references Grados (id)
);

-- Creación tabla Padres
CREATE TABLE Padres (
  id serial primary key not null,
  rol int not null,
  nombre varchar(50) not null,
  apellido varchar(50) not null,
  email varchar(50) unique not null,
  telefono varchar(14) unique not null,
  password varchar(255) not null,
  activo boolean DEFAULT true,
  foreign key (rol) references Usuarios(id)
);

-- Creación tabla Familia
-- Tabla para relacionar a los padres/tutores con los alumnos
Create table Familias (
  id serial primary key not null,
  id_padre int not null,
  carnet_estudiante int not null,
  foreign key (id_padre) references padres (id),
  foreign key (carnet_estudiante) references estudiantes (carnet)
);

-- Creación tabla Administrativos
Create table Administrativos (
  id serial primary key not null,
  rol int not null,
  nombre varchar(50) not null,
  apellido varchar(50) not null,
  email varchar(50) unique not null,
  telefono varchar(14) unique not null,
  password varchar(255) not null,
  activo boolean DEFAULT true,
  foreign key (rol) references usuarios (id)
);

-- Creación tabla Secciones
Create table Secciones (
  id serial primary key not null,
  carnet_estudiante int not null,
  foreign key (carnet_estudiante) references Estudiantes (carnet)
);

-- Creación tabla pagos
Create table Pagos (
	id serial primary key not null,
	id_padre int references Padres(id),
	carnet_estudiante int references Estudiantes (carnet)
);

-- Creación tabla solvencias
Create table Solvencias (
	id serial primary key not null,
	id_pagos int references Pagos (id) not null,
	mes_solvencia date not null,
	fecha_pago date not null
);

-- Creación tabla cursos
Create table Cursos (
	id serial primary key not null,
	id_materia int not null references Materias(id),
	id_maestro int not null references Maestros(id),
	id_seccion int not null references Secciones(id),
	id_grado int not null references Grados(id)
);

-- Creación de la tabla Tareas
CREATE TABLE Tareas (
    id SERIAL PRIMARY KEY NOT NULL,
    titulo VARCHAR(255) NOT NULL,
    valor FLOAT NOT NULL, 
    fecha_entrega DATE NOT NULL
);

-- Creación tabla 
Create table Cursos_tareas (
	id serial primary key not null,
	id_curso int not null references Cursos(id),
	id_tareas int not null references Tareas(id)
);

-- Creación de la tabla Asistencia
CREATE TABLE Asistencia (
    id SERIAL PRIMARY KEY NOT NULL,
    id_curso INT NOT NULL,
    carnet_estudiante INT NOT NULL,
    fecha TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_curso) REFERENCES Cursos(id),
    FOREIGN KEY (carnet_estudiante) REFERENCES Estudiantes(carnet)
);

-- Creación de la tabla Calificaciones
CREATE TABLE Calificaciones (
    id SERIAL PRIMARY KEY NOT NULL,
    carnet_estudiante INT NOT NULL,
    id_curso INT NOT NULL,
    nota FLOAT NOT NULL CHECK(nota >= 0 and nota <= 100), 
    fecha DATE NOT NULL DEFAULT CURRENT_DATE,
    FOREIGN KEY (carnet_estudiante) REFERENCES Estudiantes(carnet),
    FOREIGN KEY (id_curso) REFERENCES Cursos(id)
);

-- Creación de la tabla Observaciones
CREATE TABLE Observaciones (
    id SERIAL PRIMARY KEY NOT NULL,
    carnet_estudiante INT NOT NULL,
    id_curso INT NOT NULL,
    observaciones TEXT,
    puntos_de_accion TEXT,
    FOREIGN KEY (carnet_estudiante) REFERENCES Estudiantes(carnet),
    FOREIGN KEY (id_curso) REFERENCES Cursos(id)
);

-- Creación de la tabla para las planificaciones de los cursos
CREATE TABLE Planificaciones (
    id SERIAL PRIMARY KEY,
    id_curso INT NOT NULL REFERENCES Cursos(id),
    mes VARCHAR(15) NOT NULL CHECK (
        mes IN ('enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
                'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre')
    ),
    ciclo_escolar VARCHAR(4) NOT NULL,
    estado VARCHAR(20) NOT NULL DEFAULT 'en revision' CHECK (estado IN ('en revision', 'aceptada', 'rechazada'))
);

-- Detalle de las planificaciones
CREATE TABLE Detalle_planificacion (
    id SERIAL PRIMARY KEY,
    id_planificacion INT NOT NULL REFERENCES Planificaciones(id),
    tema_tarea VARCHAR(255) NULL,
    puntos_tarea FLOAT NOT NULL CHECK (puntos_tarea >= 0)
);

-- Revisiones de las planificaciones
CREATE TABLE Revisiones_planificacion (
    id SERIAL PRIMARY KEY,
    id_planificacion INT NOT NULL REFERENCES Planificaciones(id),
    id_director INT NOT NULL REFERENCES Directores(id),
    observaciones TEXT NOT NULL,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
