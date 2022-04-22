CREATE DATABASE Rent_a_Car;
USE Rent_a_Car;

CREATE TABLE Automobil(
  id INT PRIMARY KEY IDENTITY(1, 1),
  marka NVARCHAR(30) NOT NULL,
  model NVARCHAR(30) NOT NULL,
  cena_iznajmljivanja INT NOT NULL,
  specifikacije NVARCHAR(1000)
);

CREATE TABLE Lokacija(
  id INT PRIMARY KEY IDENTITY(1, 1),
  adresa NVARCHAR(100) NOT NULL
);

CREATE TABLE Automobil_Lokacija(
  id INT PRIMARY KEY IDENTITY(1, 1),
  automobil_id INT FOREIGN KEY REFERENCES Automobil(id),
  lokacija_id INT FOREIGN KEY REFERENCES Lokacija(id),
  kolicina INT NOT NULL
);

CREATE TABLE Korisnik(
  id INT PRIMARY KEY IDENTITY(1, 1),
  ime NVARCHAR(50) NOT NULL,
  prezime NVARCHAR(100) NOT NULL,
  email NVARCHAR(100) NOT NULL,
  lozinka NVARCHAR(50) NOT NULL,
  uloga INT NOT NULL
);

CREATE TABLE Pozajmica(
  id INT PRIMARY KEY IDENTITY(1, 1),
  korisnik_id INT FOREIGN KEY REFERENCES Korisnik(id),
  automobil_lokacija_id INT FOREIGN KEY REFERENCES Automobil_Lokacija(id),
  datum_preuzimanja DATE NOT NULL,
  broj_dana INT NOT NULL,
  obavljeno NVARCHAR(2) NOT NULL
);