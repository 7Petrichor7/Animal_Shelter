--SYNTHETIC TRANSACTION & Explicit Trans

------------------------------------------------------Event 
CREATE OR ALTER PROCEDURE wrapper_xxb_INSERT_Event
@RUN INT
AS
DECLARE @SC2 varchar(10),
@EvT2 varchar(50),
@ReaN2 varchar(50),
@EvN2 varchar(50),
@EvDate2 DATETIME2,
@EvDes2 varchar(50),
@AniN3 varchar(50),
@AniBirth3 DATE 

-- establish rowcount for each table that pulling a randon FK from
DECLARE @SheRowCount INT = (SELECT COUNT(*) FROM tblSHELTER) 
DECLARE @EvTypeRowCount INT = (SELECT COUNT(*) FROM tblEVENT_TYPE) 
DECLARE @ReasonRowCount INT = (SELECT COUNT(*) FROM tblREASON) 
DECLARE @AniRowCount INT = (SELECT COUNT(*) FROM tblANIMAL) 
-- must create variables to hold PK values for each FK table
DECLARE @ShelterPK INT, @EvTypePK INT, @ReasonPK INT, @AnimalPK INT
DECLARE @RAND INT

WHILE @Run > 0
BEGIN

SET @EvTypePK = (SELECT RAND() * @EvTypeRowCount + 1)
SET @ReasonPK = (SELECT RAND() * @ReasonRowCount +1)
SET @ShelterPK = (SELECT RAND() * @SheRowCount + 1)
SET @AnimalPK = (SELECT RAND() * @AniRowCount + 1)

SET @SC2 = (SELECT ShelterCode FROM tblSHELTER WHERE ShelterID = @ShelterPK)
    IF @SC2 IS NULL
        BEGIN
            SET @ShelterPK = (SELECT RAND() * @SheRowCount + 1)
            SET @SC2 = (SELECT ShelterCode FROM tblSHELTER WHERE ShelterID = @ShelterPK)
        END
SET @EvT2 = (SELECT EventTypeName FROM tblEVENT_TYPE WHERE EventTypeID = @EvTypePK)
SET @ReaN2 = (SELECT ReasonName FROM tblREASON WHERE ReasonID = @ReasonPK)

SET @EvTypePK = (SELECT RAND() * 100)
    IF @EvTypePK < 70
        BEGIN
            SET @EvN2 = 'Movement'
        END
    IF @EvTypePK >=70
        BEGIN
            SET @EvN2 = 'Others'
        END
SET @EvDate2 = (SELECT DISTINCT GetDate() - (SELECT RAND() * 4000 +1))
SET @EvDes2 = ''
SET @AniN3 = (SELECT AnimalName FROM tblANIMAL WHERE AnimalID = @AnimalPK)
SET @AniBirth3  = (SELECT AnimalBirth FROM tblANIMAL WHERE AnimalID = @AnimalPK)


EXEC INSERT_Event
@SC = @SC2,
@EvT = @EvT2,
@ReaN = @ReaN2,
@EvN = @EvN2,
@EvDate = @EvDate2,
@EvDes = @EvDes2,
@AniN2 = @AniN3,
@AniBirth2 = @AniBirth3

SET @Run = @Run -1
END

GO
---------------------------------------------------------------- Event_Person 
CREATE OR ALTER PROCEDURE wrapper_xxb_INSERT_Event_Person
@RUN INT
AS
DECLARE 
@EvDate2 DATETIME2,
@PerFName2 varchar(50),
@PerLName2 varchar(50),
@DofB2 Datetime2,
@RoleName2 varchar(50)

-- establish rowcount for each table that pulling a randon FK from
DECLARE @PersonRowCount INT = (SELECT COUNT(*) FROM tblPerson) 
DECLARE @RoleRowCount INT = (SELECT COUNT(*) FROM tblRole) 
DECLARE @EventRowCount INT = (SELECT COUNT(*) FROM tblEvent) 
-- must create variables to hold PK values for each FK table
DECLARE @PersonPK INT, @RolePK INT, @EventPK INT
DECLARE @RAND INT

WHILE @Run > 0
BEGIN

SET @PersonPK = (SELECT RAND() * @PersonRowCount + 1)
SET @RolePK = (SELECT RAND() * @RoleRowCount +1)
SET @EventPK = (SELECT RAND() * @EventRowCount + 1)

SET @EvDate2 = (SELECT EventDate FROM tblEvent WHERE EventID = @EventPK)
SET @PerFName2 = (SELECT PersonFName FROM tblPerson WHERE PersonID = @PersonPK)
SET @PerLName2 = (SELECT PersonLName FROM tblPerson WHERE PersonID = @PersonPK)
SET @DofB2 = (SELECT PersonBirth FROM tblPerson WHERE PersonID = @PersonPK)
SET @RoleName2 = (SELECT RoleName FROM tblRole WHERE RoleID = @RolePK)

EXEC insert_Event_Person
@EvDate = @EvDate2,
@PerFName = @PerFName2,
@PerLName = @PerLName2,
@DofB = @DofB2,
@RoleName = @RoleName2

SET @Run = @Run -1
END

-------------------------------------------------------------------------------------Animal 
create table #insertAnimal (
    PK_ID int not null IDENTITY(1,1) primary KEY,
    AnimalName varchar(60),
    Species varchar(60),
    Gender varchar(60)
)

insert into #insertAnimal (AnimalName, Species, Gender)
select animalname, speciesname, sexname from dataset1

declare @Run INT = (select count(*) from #insertAnimal)
DECLARE @Gender varchar(10), @Species varchar(60), @animal varchar(60), @BD DATE
declare @PK INT
while @Run > 0
    BEGIN
        set @PK = @Run
        set @Species = (select Species from #insertAnimal where PK_ID = @PK)
        SET @Gender = (select Gender from #insertAnimal where PK_ID = @PK)
        SET @animal = (select animalname from #insertAnimal where PK_ID = @PK)
        SET @BD = (SELECT GetDate() - (SELECT RAND() * 4000 +1))

        EXEC insert_animal
        @SpeciesName = @Species,
        @GenderName = @Gender,
        @AnimalName = @animal,
        @AnimalBirth = @BD

        SET @RUN = @RUN-1

    END
GO

select * from tblANIMAL
GO

------------------------------------------------------------------------------------Shelter
create table #insertShelter (
    PK_ID int not null IDENTITY(1,1) primary KEY,
    LocationName varchar(1000),
    ShelterCode varchar(60)
)

insert into #insertShelter (LocationName, ShelterCode)
select location, sheltercode from dataset1

declare @Run INT = (select count(*) from #insertShelter)
DECLARE @sheltercode varchar(60), @sheltername varchar(60), @location varchar(60), @SD varchar(1000)
declare @PK INT
while @Run > 0
    BEGIN
        set @PK = @Run
        set @sheltercode = (select ShelterCode from #insertShelter where PK_ID = @PK)
        SET @sheltername = 'Animal Shelter'
        SET @location = (select LocationName from #insertShelter where PK_ID = @PK)
        SET @SD = ''

        EXEC INSERT_Shelter
        @LN2 = @location,
        @ShelterC2 = @sheltercode,
        @ShelterDes2 = @SD,
        @ShelterN2 = @sheltername

        SET @RUN = @RUN-1

    END
GO

------------------------------------------------------------------------------------Animal_Basecolor
CREATE OR ALTER PROCEDURE wrapper_animal_basecolor
@RUN INT
AS

DECLARE @ColorN2 varchar(100), @AniN2 varchar(50), @AniDOB2 DATE

DECLARE @AnimalCount INT = (SELECT COUNT(*) FROM tblANIMAL)
DECLARE @BaseColorCount INT = (SELECT COUNT(*) FROM tblBASECOLOR)

DECLARE @BaseColorPK INT, @AnimalPK INT

WHILE @RUN > 0
BEGIN

SET @BaseColorPK = (SELECT RAND() * @BaseColorCount + 1)
SET @AnimalPK = (SELECT RAND() * @AnimalCount + 1)

SET @ColorN2 = (SELECT BaseColor FROM tblBASECOLOR WHERE BaseColorID = @BaseColorPK)
    IF @ColorN2 IS NULL
        BEGIN
            SET @BaseColorPK = (SELECT RAND() * @BaseColorCount + 1)
            SET @ColorN2 = (SELECT BaseColor FROM tblBASECOLOR WHERE BaseColorID = @BaseColorPK)
        END

SET @AniN2 = (SELECT AnimalName FROM tblANIMAL WHERE AnimalID = @AnimalPK)
    IF @AniN2 IS NULL
        BEGIN
            SET @AnimalPK = (SELECT RAND() * @AnimalCount + 1)
            SET @AniN2 = (SELECT AnimalName FROM tblANIMAL WHERE AnimalID = @AnimalPK)
        END

SET @AniDOB2 = (SELECT AnimalBirth FROM tblANIMAL WHERE AnimalID = @AnimalPK)
    IF @AniDOB2 IS NULL
        BEGIN
            SET @AnimalPK = (SELECT RAND() * @AnimalCount + 1)
            SET @AniDOB2 = (SELECT AnimalBirth FROM tblANIMAL WHERE AnimalID = @AnimalPK)
        END

EXEC insert_animal_basecolor
@ColorName = @ColorN2,
@AnimalName = @AniN2,
@AnimalBirth = @AniDOB2

SET @Run = @Run -1
END
GO

------------------------------------------------------------------------------------Animal_Status
CREATE OR ALTER PROCEDURE wrapper_animal_status
@RUN INT
AS

DECLARE @StatusN2 varchar(100), @AniN2 varchar(50), @AniDOB2 DATE, @BD2 DATE, @ED2 DATE

DECLARE @AnimalCount INT = (SELECT COUNT(*) FROM tblANIMAL)
DECLARE @StatusCount INT = (SELECT COUNT(*) FROM tblSTATUS)

DECLARE @StatusPK INT, @AnimalPK INT

WHILE @RUN > 0
BEGIN

SET @StatusPK = (SELECT RAND() * @StatusCount + 1)
SET @AnimalPK = (SELECT RAND() * @AnimalCount + 1)

SET @StatusN2 = (SELECT StatusName FROM tblSTATUS WHERE StatusID = @StatusPK)
    IF @StatusN2 IS NULL
        BEGIN
            SET @StatusPK = (SELECT RAND() * @StatusCount + 1)
            SET @StatusN2 = (SELECT StatusName FROM tblSTATUS WHERE StatusID = @StatusPK)
        END

SET @AniN2 = (SELECT AnimalName FROM tblANIMAL WHERE AnimalID = @AnimalPK)
    IF @AniN2 IS NULL
        BEGIN
            SET @AnimalPK = (SELECT RAND() * @AnimalCount + 1)
            SET @AniN2 = (SELECT AnimalName FROM tblANIMAL WHERE AnimalID = @AnimalPK)
        END

SET @AniDOB2 = (SELECT AnimalBirth FROM tblANIMAL WHERE AnimalID = @AnimalPK)
    IF @AniDOB2 IS NULL
        BEGIN
            SET @AnimalPK = (SELECT RAND() * @AnimalCount + 1)
            SET @AniDOB2 = (SELECT AnimalBirth FROM tblANIMAL WHERE AnimalID = @AnimalPK)
        END

SET @BD2 =  (SELECT GetDate() - (SELECT RAND() * 4000 +1))
SET @ED2 = (SELECT DateAdd(DAY,(SELECT RAND() * 5000 +1),  @BD2))

EXEC insert_animal_status
@StatusName = @StatusN2,
@AnimalName = @AniN2,
@AnimalBirth = @AniDOB2,
@BeginDate = @BD2,
@EndDate = @ED2

SET @Run = @Run -1
END
GO

------------------------------------------------------------------------------------Animal_breed
CREATE OR ALTER PROCEDURE wrapper_animal_breed
@RUN INT
AS

DECLARE @BreedN3 varchar(300), @AniN3 varchar(50), @AniDOB3 DATE

DECLARE @BreedCount INT = (SELECT COUNT(*) FROM tblBREED)
DECLARE @AnimalCount INT = (SELECT COUNT(*) FROM tblANIMAL)

DECLARE @BreedPK INT, @AnimalPK INT

WHILE @RUN > 0
BEGIN

SET @BreedPK = (SELECT RAND() * @BreedCount + 1)
SET @AnimalPK = (SELECT RAND() * @AnimalCount + 1)

SET @BreedN3 = (SELECT BreedName FROM tblBREED WHERE CAST(BreedID AS int) = CAST(@BreedPK AS INT))
    IF @BreedN3 IS NULL
        BEGIN
            SET @BreedPK = (SELECT RAND() * @BreedCount + 1)
            SET @BreedN3 = (SELECT BreedName FROM tblBREED WHERE BreedID = @BreedPK)
        END

SET @AniN3 = (SELECT AnimalName FROM tblANIMAL WHERE CAST(AnimalID AS INT) = CAST(@AnimalPK AS INT))
    IF @AniN3 IS NULL
        BEGIN
            SET @AnimalPK = (SELECT RAND() * @AnimalCount + 1)
            SET @AniN3 = (SELECT AnimalName FROM tblANIMAL WHERE AnimalID = @AnimalPK)
        END

SET @AniDOB3 = (SELECT AnimalBirth FROM tblANIMAL WHERE CAST(AnimalID AS INT) = CAST(@AnimalPK AS INT))
    IF @AniDOB3 IS NULL
        BEGIN
            SET @AnimalPK = (SELECT RAND() * @AnimalCount + 1)
            SET @AniDOB3 = (SELECT AnimalBirth FROM tblANIMAL WHERE AnimalID = @AnimalPK)
        END

EXEC INSERT_Animal_Breed
@AniN2 = @AniN3,
@AniBirth2 = @AniDOB3,
@BN2 = @BreedN3

SET @Run = @Run -1
END
GO

