--- no deceased animal can participate event 
--- no rattle snack can be intake
--- caculate total number of adoption
--- caculate total number of intake 


--BUSINESS RULE & COMPUTED COLUMN & VIEWS
------------------------------------------------------------------------------------
--No deceased animal can participate in event
CREATE FUNCTION fn_Nodeceased_Event()
RETURNS INT
AS
BEGIN
 
DECLARE @RET INT = 0
IF EXISTS (SELECT *
            FROM tblSTATUS S
                JOIN tblANIMAL_STATUS ANIS ON S.StatusID = ANIS.StatusID
                JOIN tblANIMAL A ON ANIS.AnimalID = A.AnimalID
                JOIN tblEVENT E ON A.AnimalID = E.EventID
            WHERE S.StatusName = 'deceased'
)
SET @RET = 1
RETURN @RET
END
GO
 
ALTER TABLE tblEVENT WITH NOCHECK
ADD CONSTRAINT CK_Nodeceased_Event
CHECK (dbo.fn_Nodeceased_Event() = 0)
GO

--No rattle snake can be intake
CREATE FUNCTION fn_Nosnake_Intake()
RETURNS INT
AS
BEGIN
 
DECLARE @RET INT = 0
IF EXISTS (SELECT *
            FROM tblSPECIES S
                JOIN tblANIMAL A ON S.SpeciesID = A.SpeciesID
                JOIN tblEVENT E ON A.AnimalID = E.EventID
                JOIN tblEVENT_TYPE ET ON E.EventTypeID = ET.EventTypeID
            WHERE ET.EventTypeName = '%Intake%'
            AND S.SpeciesName = 'rattle snake'
)
SET @RET = 1
RETURN @RET
END
GO
 
ALTER TABLE tblEVENT WITH NOCHECK
ADD CONSTRAINT CK_Nosnake_Intake
CHECK (dbo.fn_Nosnake_Intake() = 0)
GO

--No person older than 80 years old can participate in event
CREATE FUNCTION fn_NoOldPEEPS_Event()
RETURNS INT
AS
BEGIN
 
DECLARE @RET INT = 0
IF EXISTS (SELECT *
            FROM tblPERSON P
                JOIN tblEVENT_PERSON EP ON P.PersonID = EP.PersonID
                JOIN tblEVENT E ON EP.EventID = E.EventID
            WHERE P.PersonBirth < DateAdd(Year, -80, GetDate())
)
SET @RET = 1
RETURN @RET
END
GO
 
ALTER TABLE tblEVENT WITH NOCHECK
ADD CONSTRAINT CK_NoOldPEEPS_Event
CHECK (dbo.fn_NoOldPEEPS_Event() = 0)
GO

--No Animal named Lucas can be intake
CREATE FUNCTION fn_NoLucas_Intake()
RETURNS INT
AS
BEGIN
 
DECLARE @RET INT = 0
IF EXISTS (SELECT *
            FROM tblANIMAL A
                JOIN tblEVENT E ON A.AnimalID = E.EventID
                JOIN tblEVENT_TYPE ET ON E.EventTypeID = ET.EventTypeID
            WHERE ET.EventTypeName = '%Intake%'
            AND A.AnimalName = 'Lucas'
)
SET @RET = 1
RETURN @RET
END
GO
 
ALTER TABLE tblEVENT WITH NOCHECK
ADD CONSTRAINT CK_NoLucas_Intake
CHECK (dbo.fn_NoLucas_Intake() = 0)
GO

--Establish a computed column that displays the number of dogs under each shelter
CREATE FUNCTION group14_CalcNumDogs(@PK INT)
RETURNS INTEGER
AS
BEGIN
 
DECLARE @RET INTEGER = (SELECT COUNT(A.AnimalID)
                                FROM tblANIMAL A
                                    JOIN tblSPECIES S ON A.SpeciesID = S.SpeciesID
                                    JOIN tblEVENT E ON A.AnimalID = E.AnimalID
                                    JOIN tblSHELTER SH ON E.ShelterID = SH.ShelterID
                                WHERE S.SpeciesName = 'dog'
                                AND SH.ShelterID = @PK)
RETURN @RET
END
GO
 
ALTER TABLE tblSHELTER
ADD CalcDog AS (dbo.group14_CalcNumDogs(ShelterID))
GO

--Establish a computed column that displays the average age of cats under each shelter
CREATE FUNCTION group14_AvgAgeCats(@PK INT)
RETURNS INTEGER
AS
BEGIN
 
DECLARE @RET INTEGER = (SELECT AVG(DateDiff(Year, AnimalBirth, GetDate()))
                                FROM tblANIMAL A
                                    JOIN tblSPECIES S ON A.SpeciesID = S.SpeciesID
                                    JOIN tblEVENT E ON A.AnimalID = E.AnimalID
                                    JOIN tblSHELTER SH ON E.ShelterID = SH.ShelterID
                                WHERE S.SpeciesName = 'cat'
                                AND SH.ShelterID = @PK)
RETURN @RET
END
GO

ALTER TABLE tblSHELTER
ADD CalcAge AS (dbo.group14_AvgAgeCats(ShelterID))
GO

--Establish a computed column that displays the number of abandoned animals for each species
CREATE FUNCTION group14_CalcNumAbandoned(@PK INT)
RETURNS INTEGER
AS
BEGIN
 
DECLARE @RET INTEGER = (SELECT COUNT(A.AnimalID)
                                FROM tblANIMAL A
                                    JOIN tblSPECIES S ON A.SpeciesID = S.SpeciesID
                                    JOIN tblEVENT E ON A.AnimalID = E.AnimalID
                                    JOIN tblREASON R ON E.ReasonID = R.ReasonID
                                WHERE R.ReasonName = 'Abandoned'
                                AND S.SpeciesID = @PK)
RETURN @RET
END
GO

ALTER TABLE tblSPECIES
ADD CalcAbandoned AS (dbo.group14_CalcNumAbandoned(SpeciesID))
GO

--Establish a computed column that displays the number of female animals that has a white based color for each species
CREATE FUNCTION group14_CalcNumFemale(@PK INT)
RETURNS INTEGER
AS
BEGIN
 
DECLARE @RET INTEGER = (SELECT COUNT(A.AnimalID)
                                FROM tblANIMAL A
                                    JOIN tblSPECIES S ON A.SpeciesID = S.SpeciesID
                                    JOIN tblGENDER G ON A.GenderNameID = G.GenderID
                                    JOIN tblANIMAL_BASECOLOR AB ON A.AnimalID = AB.AnimalID
                                    JOIN tblBASECOLOR B ON AB.BaseColorID = B.BaseColorID
                                WHERE B.BaseColor = 'white'
                                AND G.GenderName = 'Female'
                                AND S.SpeciesID = @PK)
RETURN @RET
END
GO

ALTER TABLE tblSPECIES
ADD CalcFemale AS (dbo.group14_CalcNumFemale(SpeciesID))
GO

--SQL to return the shelters that have intake more than 1000 DISTINCT animals since 2015
CREATE VIEW query_1 AS
SELECT S.ShelterID, S.ShelterCode, COUNT(DISTINCT A.AnimalID) AS NumAnimal
FROM tblSHELTER S
    JOIN tblEVENT E ON S.ShelterID = E.ShelterID
    JOIN tblANIMAL A ON E.AnimalID = A.AnimalID
WHERE E.EventDate >= '2015'
GROUP BY S.ShelterID, S.ShelterCode
HAVING COUNT(DISTINCT A.AnimalID) > 1000
GO

--SQL to find all animals that are over 10 years old and have at least two base colors
CREATE VIEW query_2 AS
SELECT A.AnimalID, A.AnimalName, COUNT(AB.BaseColorID) AS NumColor
FROM tblANIMAL A
    JOIN tblANIMAL_BASECOLOR AB ON A.AnimalID = AB.AnimalID
WHERE A.AnimalBirth < DateAdd(Year, -10, GetDate())
GROUP BY A.AnimalID, A.AnimalName
HAVING COUNT(AB.BaseColorID) >= 2
GO
