
------ Insert Stored Procedure
-------------------------------------------------- INSERT EVENT_PERSON
CREATE OR ALTER PROCEDURE insert_Event_Person
@EvDate DATETIME2,
@PerFName varchar(50),
@PerLName varchar(50),
@DofB DATETIME2,
@RoleName varchar(50)
AS
DECLARE @Eventid INT, @Perid INT, @Roleid INT

EXECUTE GetEventID
@EventD = @EvDate, 
@Event_ID = @Eventid OUTPUT

IF @Eventid IS NULL
   BEGIN
      PRINT '@Eventid is empty...check spelling';
      THROW 51111, '@Eventid cannot be NULL; process is terminating', 1;
   END

EXECUTE GetPersonID
@F = @PerFName,
@L = @PerLName,
@DOB = @DofB,
@Person_ID = @Perid OUTPUT

IF @Perid IS NULL
   BEGIN
      PRINT '@Perid is empty...check spelling';
      THROW 51112, '@Perid cannot be NULL; process is terminating', 1;
   END

EXECUTE GetRoleID
@RoleN = @RoleName,
@Role_ID = @Roleid OUTPUT

IF @Roleid IS NULL
   BEGIN
      PRINT '@Roleid is empty...check spelling';
      THROW 51113, '@Roleid cannot be NULL; process is terminating', 1;
   END

INSERT INTO tblEVENT_PERSON(EventID, PersonID, RoleID)
VALUES (@Eventid, @Perid, @Roleid)
GO

------------------------------------------------- INSERT EVENT Procedure
CREATE OR ALTER PROCEDURE INSERT_Event
@SC varchar(10),
@EvT varchar(50),
@ReaN varchar(50),
@EvN varchar(50),
@EvDate DATETIME2,
@EvDes varchar(50),
@AniN2 varchar(50),
@AniBirth2 DATE
AS
DECLARE @Shelterid INT, @EventTypeid INT, @Reasonid INT, @Animalid INT

EXECUTE GetShelterID
@ShelterC = @SC,
@Shelter_ID = @Shelterid OUTPUT

IF @Shelterid IS NULL
   BEGIN
      PRINT '@Shelterid is empty...check spelling';
      THROW 51121, '@Shelterid cannot be NULL; process is terminating', 1;
   END

EXECUTE GetEventTypeID
@ET = @EvT,
@EventType_ID = @EventTypeid OUTPUT

IF @EventTypeid IS NULL
   BEGIN
      PRINT '@EventTypeid is empty...check spelling';
      THROW 51122, '@EventTypeid cannot be NULL; process is terminating', 1;
   END

EXECUTE GetReasonID
@ReasonN = @ReaN,
@Reason_ID = @Reasonid OUTPUT

IF @Reasonid IS NULL
   BEGIN
      PRINT '@Reasonid is empty...check spelling';
      THROW 51123, '@Reasonid cannot be NULL; process is terminating', 1;
   END

EXECUTE GetAnimalID
@AniN = @AniN2,
@AniBirth = @AniBirth2,
@AID = @Animalid OUTPUT
IF @Animalid IS NULL
   BEGIN
      PRINT '@Animalid is empty...check spelling';
      THROW 51124, '@Animalid cannot be NULL; process is terminating', 1;
   END

BEGIN TRANSACTION T2
INSERT INTO tblEVENT(ShelterID, EventTypeID, ReasonID, AnimalID, EventName, EventDate, EventDescr)
VALUES (@Shelterid, @EventTypeid, @Reasonid, @Animalid, @EvN, @EvDate, @EvDes)
IF @@ERROR <> 0
    BEGIN
        ROLLBACK TRANSACTION T2
    END
ELSE
    COMMIT TRANSACTION T2
GO

---------------------------------------------------------- INSERT SHELTER
GO
CREATE OR ALTER PROCEDURE INSERT_Shelter
@LN2 varchar(50),
@ShelterC2 varchar(10),
@ShelterDes2 varchar(50),
@ShelterN2 varchar(50)
AS
DECLARE @locationid INT

EXECUTE GetLocationID
@LN = @LN2,
@Location_ID = @locationid OUTPUT

IF @locationid IS NULL
   BEGIN
      PRINT '@locationid is empty...check spelling';
      THROW 51131, '@locationid cannot be NULL; process is terminating', 1;
   END

BEGIN TRANSACTION T2
INSERT INTO tblShelter(LocationID, ShelterCode, ShelterDescr, ShelterName)
VALUES (@locationid, @ShelterC2, @ShelterDes2, @ShelterN2)
IF @@ERROR <> 0
    BEGIN
        ROLLBACK TRANSACTION T2
    END
ELSE
   COMMIT TRANSACTION T2
GO

----------------------------------------------------------- Insert Animal_Breed
CREATE OR ALTER PROCEDURE INSERT_Animal_Breed
@AniN2 varchar(50),
@AniBirth2 DATE,
@BN2 varchar(50)
AS
DECLARE @animalid INT, @breedid INT

EXECUTE GetAnimalID
@AniN = @AniN2,
@AniBirth = @AniBirth2,
@AID =  @animalid OUTPUT

IF @animalid IS NULL
   BEGIN
      PRINT '@animalid is empty...check spelling';
      THROW 51141, '@animalid cannot be NULL; process is terminating', 1;
   END

EXECUTE GetBreedID
@BN = @BN2,
@Breed_ID = @breedid OUTPUT
IF @breedid IS NULL
   BEGIN
      PRINT '@breedid is empty...check spelling';
      THROW 51142, '@breedid cannot be NULL; process is terminating', 1;
   END

BEGIN TRANSACTION T2
INSERT INTO tblANIMAL_BREED(BreedID, AnimalID)
VALUES (@breedid, @animalid)
IF @@ERROR <> 0
    BEGIN
        ROLLBACK TRANSACTION T2
    END
ELSE
   COMMIT TRANSACTION T2
GO

-------------------------------------------------INSERT Animal Base Color Procedure
CREATE OR ALTER PROCEDURE insert_animal_basecolor
@ColorName VARCHAR(100),
@AnimalName VARCHAR(50),
@AnimalBirth DATE
AS

DECLARE @basecolorid INT, @animalid INT

EXEC GetColorID
@BC = @ColorName,
@BaseColor_ID = @basecolorid OUTPUT

IF @basecolorid IS NULL
    BEGIN
        PRINT '@basecolorid is empty...check spelling';
        THROW 55555, '@basecolorid cannot be NULL; process is terminating', 1;
    END

EXEC GetAnimalID
@AniN = @AnimalName,
@AniBirth = @AnimalBirth,
@AID = @animalid OUTPUT

IF @animalid IS NULL
    BEGIN
        PRINT '@animalid is empty...check spelling';
        THROW 56666, '@animalid cannot be NULL; process is terminating', 1;
    END

BEGIN TRANSACTION T1
INSERT INTO tblANIMAL_BASECOLOR (AnimalID, BaseColorID)
VALUES (@animalid, @basecolorid)
IF @@ERROR <> 0
    BEGIN
        ROLLBACK TRANSACTION T1
    END
ELSE
    COMMIT TRANSACTION T1
GO

------------------------------------------------- INSERT Animal Procedure
CREATE OR ALTER PROCEDURE insert_animal
@SpeciesName varchar(50),
@GenderName varchar(50),
@AnimalName varchar(50),
@AnimalBirth DATE
AS

DECLARE @speciesid INT, @genderid INT

EXEC GetSpeciesID
@SN = @SpeciesName,
@Species_ID = @speciesid OUTPUT

IF @speciesid IS NULL
    BEGIN
        PRINT '@speciesid is empty...check spelling';
        THROW 55555, '@speciesid cannot be NULL; process is terminating', 1;
    END

EXEC GetGenderID
@GN = @GenderName,
@Gender_ID = @genderid OUTPUT

IF @genderid IS NULL
    BEGIN
        PRINT '@genderid is empty...check spelling';
        THROW 56666, '@genderid cannot be NULL; process is terminating', 1;
    END

BEGIN TRANSACTION T2
INSERT INTO tblANIMAL (SpeciesID, GenderNameID, AnimalName, AnimalBirth)
VALUES (@speciesid, @genderid, @AnimalName, @AnimalBirth)
IF @@ERROR <> 0
    BEGIN
        ROLLBACK TRANSACTION T2
    END
ELSE
    COMMIT TRANSACTION T2
GO

------------------------------------------------- INSERT Animal STATUS Procedure
CREATE OR ALTER PROCEDURE insert_animal_status
@StatusName VARCHAR(100),
@BeginDate DATE,
@EndDate DATE,
@AnimalName VARCHAR(50),
@AnimalBirth DATE
AS

DECLARE @statusid INT, @animalid INT

EXEC GetStatusID
@SN = @StatusName,
@Status_ID = @statusid OUTPUT

IF @statusid IS NULL
    BEGIN
        PRINT '@statusid is empty...check spelling';
        THROW 55555, '@statusid cannot be NULL; process is terminating', 1;
    END

EXEC GetAnimalID
@AniN = @AnimalName,
@AniBirth = @AnimalBirth,
@AID = @animalid OUTPUT

IF @animalid IS NULL
    BEGIN
        PRINT '@animalid is empty...check spelling';
        THROW 56666, '@animalid cannot be NULL; process is terminating', 1;
    END

BEGIN TRANSACTION T1
INSERT INTO tblANIMAL_STATUS (AnimalID, StatusID, BeginDate, EndDate)
VALUES (@animalid, @statusid, @BeginDate, @EndDate)
IF @@ERROR <> 0
    BEGIN
        ROLLBACK TRANSACTION T1
    END
ELSE
    COMMIT TRANSACTION T1
GO
