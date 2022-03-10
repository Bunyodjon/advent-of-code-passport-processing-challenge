USE SimpleUnitTestDB	
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SolveChallenge] 
AS


/* dbo.task4 table has the input file*/

DROP TABLE IF EXISTS #temp

SELECT *
INTO #temp
FROM [SimpleUnitTestDB].[dbo].[task4]


UPDATE T 
SET 
PassportString = CASE WHEN PassportString='' THEN '-'
						ELSE PassportString END 
-- select * 	
FROM #temp T
--264


DROP TABLE IF EXISTS #temp2

SELECT Passport = TRIM(value), AttributeCount = 0 
INTO #temp2
FROM STRING_SPLIT(SUBSTRING( 
( 
     SELECT '' + t.PassportString AS 'data()'
         FROM #temp  t FOR XML PATH('') 
), 0 , 30000), '-') 


DROP TABLE IF EXISTS #temp3

SELECT *
,	Decision = CASE WHEN cid +  byr + iyr+eyr +hgt+ hcl+ ecl+pid = 8 THEN 'Approved'
					WHEN byr + iyr+eyr +hgt+ hcl+ ecl+pid = 7 THEN 'Approved 2'
					ELSE 'Denied' END 
INTO #temp3
FROM (
	SELECT 
		cid		= CASE WHEN Passport LIKE '%cid:%' THEN 1 ELSE 0 END 
	,	byr		= CASE WHEN Passport LIKE '%byr:%' THEN 1 ELSE 0 END 
	,	iyr		= CASE WHEN Passport LIKE '%iyr:%' THEN 1 ELSE 0 END 
	,	eyr		= CASE WHEN Passport LIKE '%eyr:%' THEN 1 ELSE 0 END 
	,	hgt		= CASE WHEN Passport LIKE '%hgt:%' THEN 1 ELSE 0 END 
	,	hcl		= CASE WHEN Passport LIKE '%hcl:%' THEN 1 ELSE 0 END 
	,	ecl		= CASE WHEN Passport LIKE '%ecl:%' THEN 1 ELSE 0 END 
	,	pid		= CASE WHEN Passport LIKE '%pid:%' THEN 1 ELSE 0 END 
	,	Passport 
	FROM #temp2 
) K


SELECT [Approved Passport]=COUNT(*) 
FROM #temp3 t
WHERE t.Decision LIKE '%Approved%'
