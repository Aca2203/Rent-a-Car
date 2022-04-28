-- Kreiranje baze podataka:

CREATE DATABASE Rent_a_Car;
USE Rent_a_Car;

-- Kreiranje tabela:

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

-- Strani kljucevi su vec definisani, zbog toga necu raditi ALTER TABLE naredbe!

-- Kreiranje stor procedura:

CREATE PROCEDURE Korisnik_Email
@ime NVARCHAR(50),
@prezime NVARCHAR(100),
@email NVARCHAR(100),
@lozinka NVARCHAR(50)
AS
SET LOCK_TIMEOUT 3000;
BEGIN TRY
  IF EXISTS(SELECT TOP 1 email FROM Korisnik
            WHERE (ime = @ime) AND (prezime = @prezime) AND (email = @email) AND (lozinka = @lozinka))            
  BEGIN
    RETURN 0;
  END
  RETURN 1;
END TRY
BEGIN CATCH
  RETURN @@ERROR;
END CATCH;

CREATE PROCEDURE Korisnik_Insert
@ime NVARCHAR(50),
@prezime NVARCHAR(100),
@email NVARCHAR(100),
@lozinka NVARCHAR(50),
@uloga INT
AS
SET LOCK_TIMEOUT 3000;
BEGIN TRY
  IF EXISTS(SELECT TOP 1 email FROM Korisnik
            WHERE email = @email)
  RETURN 1
  ELSE
    INSERT INTO Korisnik (ime, prezime, email, lozinka, uloga) VALUES (@ime, @prezime, @email, @lozinka, @uloga)
  RETURN 0;
END TRY
BEGIN CATCH
  RETURN @@ERROR;
END CATCH;

CREATE PROCEDURE Korisnik_Update
@ime NVARCHAR(50),
@prezime NVARCHAR(100),
@email NVARCHAR(100),
@lozinka NVARCHAR(50),
@uloga INT
AS
SET LOCK_TIMEOUT 3000;
BEGIN TRY
  IF EXISTS(SELECT TOP 1 email FROM Korisnik
            WHERE email = @email)
  BEGIN
    UPDATE Korisnik SET
    ime = @ime,
    prezime = @prezime,
    email = @email,
    lozinka = @lozinka,
    uloga = @uloga
    WHERE email = @email;
    
    RETURN 0;
  END;
  RETURN -1;
END TRY
BEGIN CATCH
  RETURN @@ERROR;
END CATCH;