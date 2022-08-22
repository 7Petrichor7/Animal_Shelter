
USE Group14_Project
GO
SELECT* FROM dataset1
-- SELECT* FROM dataset2
GO


-- SELECT*FROM dataset2

-- SELECT DISTINCT intakedate FROM dataset2 

-- SELECT DISTINCT EventDate FROM tblEVENT


GO

WITH cte AS (
    SELECT 
        id, 
        intakedate, 
        intakereason,
        istransfer,
        sheltercode,
        identichipnumber,
        animalname,
        breedname,
        basecolour,
        speciesname,
        animalage,
        sexname,
        location,
        movementdate,
        movementtype,
        istrial,
        returndate,
        returnedreason,
        deceaseddate,
        deceasedreason,
        ROW_NUMBER() OVER (
            PARTITION BY 
                -- intakedate, 
                -- intakereason,
                -- sheltercode,
                -- identichipnumber,
                animalname
                -- breedname,
                -- basecolour,
                -- speciesname,
                -- animalage,
                -- sexname,
                -- location,
                -- movementdate,
                -- movementtype,
                -- istrial,
                -- returndate,
                -- returnedreason,
                -- deceaseddate,
                -- deceasedreason
            ORDER BY 
                -- intakedate, 
                -- intakereason,
                -- sheltercode,
                -- identichipnumber,
                animalname
                -- breedname,
                -- basecolour,
                -- speciesname,
                -- animalage,
                -- sexname,
                -- location,
                -- movementdate,
                -- movementtype,
                -- istrial,
                -- returndate,
                -- returnedreason,
                -- deceaseddate,
                -- deceasedreason
        ) row_num
     FROM 
        dbo.dataset2
)
DELETE FROM cte
WHERE row_num > 1;


----------------------------- Process data

delete from dataset1 where location IS NULL;
delete from dataset1 where sexname IS NULL;
delete from dataset1 where animalname IS NULL;
delete from dataset1 where intakereason IS NULL;
delete from dataset1 where speciesname IS NULL;

-- delete duplicate insert data

WITH cte AS (
    SELECT 
        id, 
        intakedate, 
        intakereason,
        istransfer,
        sheltercode,
        identichipnumber,
        animalname,
        breedname,
        basecolour,
        speciesname,
        animalage,
        sexname,
        location,
        movementdate,
        movementtype,
        istrial,
        returndate,
        returnedreason,
        deceaseddate,
        deceasedreason,
        ROW_NUMBER() OVER (
            PARTITION BY 
                -- intakedate, 
                -- intakereason,
                -- sheltercode,
                -- identichipnumber,
                animalname
                -- breedname,
                -- basecolour,
                -- speciesname,
                -- animalage,
                -- sexname,
                -- location,
                -- movementdate,
                -- movementtype,
                -- istrial,
                -- returndate,
                -- returnedreason,
                -- deceaseddate,
                -- deceasedreason
            ORDER BY 
                -- intakedate, 
                -- intakereason,
                -- sheltercode,
                -- identichipnumber,
                animalname
                -- breedname,
                -- basecolour,
                -- speciesname,
                -- animalage,
                -- sexname,
                -- location,
                -- movementdate,
                -- movementtype,
                -- istrial,
                -- returndate,
                -- returnedreason,
                -- deceaseddate,
                -- deceasedreason
        ) row_num
     FROM 
        dbo.dataset1
)
DELETE FROM cte
WHERE row_num > 1;

--- populate tables
--- populate lookup tables

SELECT DISTINCT breedname FROM dataset1 

INSERT INTO tblGENDER (GenderName) SELECT DISTINCT sexname FROM dataset1 WHERE sexname IS NOT NULL
SELECT*FROM tblGENDER
INSERT INTO tblREASON (ReasonName) SELECT DISTINCT intakereason FROM dataset1 WHERE intakereason IS NOT NULL
SELECT*FROM tblREASON
INSERT INTO tblSPECIES (speciesName) SELECT DISTINCT speciesname FROM dataset1 WHERE speciesname IS NOT NULL
SELECT*FROM tblSPECIES
INSERT INTO tblBASECOLOR (BaseColor) SELECT DISTINCT basecolour FROM dataset1 WHERE basecolour IS NOT NULL
SELECT*FROM tblBASECOLOR
INSERT INTO tblLOCATION (LocationName) SELECT DISTINCT location FROM dataset1 WHERE location IS NOT NULL
SELECT*FROM tblLOCATION
INSERT INTO tblBREED (BreedName) SELECT DISTINCT breedname FROM dataset1 WHERE breedname IS NOT NULL
SELECT*FROM tblBREED
SELECT DISTINCT Top 20000 CustomerFname, CustomerLname, DateOfBirth FROM PEEPS.dbo.tblCUSTOMER
INSERT INTO tblPERSON (PersonFname, PersonLname, PersonBirth) SELECT DISTINCT Top 20000 CustomerFname, CustomerLname, DateOfBirth FROM PEEPS.dbo.tblCUSTOMER
SELECT*FROM tblPERSON
INSERT INTO tblSTATUS (statusName,StatusDescr) VALUES ('death', ''),('ill', ''),('healthy', '')
SELECT*FROM tblSTATUS
INSERT INTO tblEVENT_TYPE (EventTypeName, EventTypeDescr) VALUES ('intake',''),('movement',''), ('return','')
SELECT*FROM tblEVENT_TYPE
INSERT INTO tblRole (RoleName, RoleDescr) VALUES ('Employee',''),('Adopter',''), ('Owner','')
SELECT*FROM tblRole



