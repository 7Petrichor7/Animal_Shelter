--- Group14_Project

-- Begin Try
--    Use Master;
--    If Exists(Select Name From SysDatabases Where Name = 'Group14_Project')
--     Begin
--      Alter Database [Group14_Project] set Single_user With Rollback Immediate;
--      Drop Database Group14_Project;
--     End
--    Create Database Group14_Project;
-- End Try
-- Begin Catch
--    Print Error_Number();
-- End Catch
-- go


-----CREATE TABLE & GetID

Use Group14_Project;
 

CREATE TABLE tblSTATUS
(StatusID INT IDENTITY (1,1) Primary key,
StatusName varchar(50) NOT NULL,
StatusDescr varchar(1000) NULL)
GO

CREATE TABLE tblBASECOLOR
(BaseColorID INT IDENTITY (1,1) Primary key,
BaseColor varchar(50) NOT NULL,
BaseColorDescr varchar(1000) NULL)
GO

CREATE TABLE tblSPECIES
(SpeciesID INT IDENTITY (1,1) Primary key,
SpeciesName varchar(50) NOT NULL,
SpeciesDescr varchar(1000) NULL)
GO

CREATE TABLE tblGENDER
(GenderID INT IDENTITY (1,1) Primary key,
GenderName varchar(50) NOT NULL,
SpeciesDescr varchar(1000) NULL)
GO


CREATE TABLE tblBREED
(BreedID INT IDENTITY (1,1) Primary key,
BreedName varchar(50) Not NULL,
BreedDescr varchar(1000) NULL)
GO

CREATE TABLE tblLOCATION
(LocationID INT IDENTITY (1,1) Primary key,
LocationName varchar(1000) NOT NULL,
LocationDescr varchar(1000) NULL)
GO

CREATE TABLE tblPERSON
(PersonID INT IDENTITY (1,1) Primary key,
PersonFname varchar(50) NOT NULL,
PersonLname varchar(50) NOT NULL,
PersonBirth DATE NOT NULL)
GO

CREATE TABLE tblROLE
(RoleID INT IDENTITY (1,1) Primary key,
RoleName varchar (50) NOT NULL,
RoleDescr varchar(1000) NULL)
GO

CREATE TABLE tblEVENT_TYPE
(EventTypeID INT IDENTITY (1,1) Primary key,
EventTypeName varchar(50) NOT NULL,
EventTypeDescr varchar(1000) NULL)
GO

CREATE TABLE tblREASON
(ReasonID INT IDENTITY (1,1) Primary key,
ReasonName varchar(50) NOT NULL,
ReasonDescr varchar(1000) NULL)
GO

CREATE TABLE tblSHELTER
(ShelterID INT IDENTITY (1,1) Primary key,
LocationID INT FOREIGN KEY REFERENCES tblLOCATION (LocationID) NOT NULL,
ShelterCode varchar (10) NOT NULL,
ShelterDescr varchar(1000) NULL,
ShelterName varchar(50) NULL)
GO

Alter Table tblSHELTER
Alter column ShelterName varchar(50) NULL

CREATE TABLE tblANIMAL
(AnimalID INT IDENTITY (1,1) Primary key,
SpeciesID INT FOREIGN KEY REFERENCES tblSPECIES (SpeciesID) NOT NULL,
GenderNameID INT FOREIGN KEY REFERENCES tblGENDER (GenderID) NOT NULL,
AnimalName varchar(50) NOT NULL,
AnimalBirth DATE NULL)
GO

CREATE TABLE tblEVENT
(EventID INT IDENTITY (1,1) Primary key,
EventTypeID INT FOREIGN KEY REFERENCES tblEVENT_TYPE (EventTypeID) NOT NULL,
ShelterID INT FOREIGN KEY REFERENCES tblSHELTER (ShelterID) NOT NULL,
ReasonID INT FOREIGN KEY REFERENCES tblREASON (ReasonID) NOT NULL,
AnimalID INT FOREIGN KEY REFERENCES tblANIMAL (AnimalID) NOT NULL,
EventName varchar(50) NOT NULL,
EventDate DATETIME2 NOT NULL,
EventDescr varchar(1000) NULL)
GO

CREATE TABLE tblANIMAL_BASECOLOR
(AnimalBaseColorID INT IDENTITY (1,1) Primary key,
AnimalID INT FOREIGN KEY REFERENCES tblANIMAL (AnimalID) NOT NULL,
BaseColorID INT FOREIGN KEY REFERENCES tblBASECOLOR (BaseColorID) NOT NULL)
GO
 
CREATE TABLE tblANIMAL_STATUS
(AnimalStatusID INT IDENTITY (1,1) Primary key,
AnimalID INT FOREIGN KEY REFERENCES tblANIMAL (AnimalID) NOT NULL,
StatusID INT FOREIGN KEY REFERENCES tblSTATUS (StatusID) NOT NULL,
BeginDate DATE NULL,
EndDate DATE NULL)
GO
 
CREATE TABLE tblANIMAL_BREED
(AnimalBreedID INT IDENTITY (1,1) Primary key,
BreedID INT FOREIGN KEY REFERENCES tblBREED (BreedID) NOT NULL,
AnimalID INT FOREIGN KEY REFERENCES tblANIMAL (AnimalID) NOT NULL)
GO

CREATE TABLE tblEVENT_PERSON
(EventPerosnID INT IDENTITY (1,1) Primary key,
EventID INT FOREIGN KEY REFERENCES tblEVENT (EventID) NOT NULL,
PersonID INT FOREIGN KEY REFERENCES tblPERSON (PersonID) NOT NULL,
RoleID INT FOREIGN KEY REFERENCES tblROLE (RoleID) NOT NULL)
GO

 
------------------------------------------------------------------------------------
CREATE PROCEDURE GetStatusID
@SN varchar(50),
@Status_ID INT OUTPUT
AS
SET @Status_ID = (SELECT StatusID FROM tblSTATUS WHERE StatusName = @SN)
GO             

CREATE PROCEDURE GetAnimalStatusID
@BDate Date,
@EDate Date,
@ASID INT OUTPUT
AS
SET @ASID = (SELECT AnimalStatusID FROM tblANIMAL_STATUS WHERE BeginDate = @BDate)
GO

CREATE PROCEDURE GetAnimalID
@AniN varchar(50),
@AniBirth DATE,
@AID INT OUTPUT
AS
SET @AID = (SELECT AnimalID FROM tblANIMAL WHERE AnimalName = @AniN AND AnimalBirth = @AniBirth)
GO

CREATE PROCEDURE GetColorID
@BC varchar(50),
@BaseColor_ID INT OUTPUT
AS
SET @BaseColor_ID = (SELECT BaseColorID FROM tblBASECOLOR WHERE BaseColor = @BC)
GO
 
CREATE PROCEDURE GetGenderID
@GN varchar(50),
@Gender_ID INT OUTPUT
AS
SET @Gender_ID = (SELECT GenderID FROM tblGENDER WHERE GenderName = @GN)
GO
 
CREATE PROCEDURE GetSpeciesID
@SN varchar(50),
@Species_ID INT OUTPUT
AS
SET @Species_ID = (SELECT SpeciesID FROM tblSPECIES WHERE SpeciesName = @SN)
GO

CREATE OR ALTER PROCEDURE GetBreedID
@BN varchar(300),
@Breed_ID INT OUTPUT
AS
SET @Breed_ID = (SELECT BreedID FROM tblBREED WHERE BreedName = @BN)
GO
 
CREATE PROCEDURE GetLocationID
@LN varchar(50),
@Location_ID INT OUTPUT
AS
SET @Location_ID = (SELECT LocationID FROM tblLOCATION WHERE LocationName = @LN)
GO
 
CREATE PROCEDURE GetEventTypeID
@ET varchar(50),
@EventType_ID INT OUTPUT
AS
SET @EventType_ID = (SELECT EventTypeID FROM tblEVENT_TYPE WHERE EventTypeName = @ET)
GO
 
CREATE PROCEDURE GetReasonID
@ReasonN varchar(50),
@Reason_ID INT OUTPUT
AS
SET @Reason_ID = (SELECT ReasonID FROM tblREASON WHERE ReasonName = @ReasonN)
GO
 
CREATE PROCEDURE GetPersonID
@F varchar(50),
@L varchar(50),
@DOB DATE,
@Person_ID INT OUTPUT
AS
SET @Person_ID = (SELECT PersonID FROM tblPERSON WHERE PersonFname = @F AND PersonLname = @L AND PersonBirth = @DOB)
GO
 
CREATE PROCEDURE GetRoleID
@RoleN varchar(50),
@Role_ID INT OUTPUT
AS
SET @Role_ID = (SELECT RoleID FROM tblROLE WHERE RoleName = @RoleN)
GO

CREATE OR ALTER PROCEDURE GetEventID
@EventD Datetime2,
@Event_ID INT OUTPUT
AS
SET @Event_ID = (SELECT EventID FROM tblEvent WHERE EventDate = @EventD)
GO
-- EventName = @EventN

CREATE PROCEDURE GetShelterID
@ShelterC varchar(10),
@Shelter_ID INT OUTPUT
AS
SET @Shelter_ID = (SELECT ShelterID FROM tblSHELTER WHERE ShelterCode = @ShelterC)
GO
