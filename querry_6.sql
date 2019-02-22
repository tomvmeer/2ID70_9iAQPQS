explain analyze
WITH HighestGrade(CourseOfferId, Grade) as (
SELECT CR.CourseOfferId, max(CR.Grade)
FROM CourseRegistrations CR, CourseOffers CO
WHERE CR.CourseOfferId = CO.CourseOfferId and CO.year = 2018 and CO.Quartile = 1
GROUP BY CR.CourseOfferId) 
SELECT SR.studentId, count(SR.StudentId)
FROM CourseRegistrations CR, HighestGrade HG, StudentRegistrationsToDegrees SR
WHERE CR.StudentRegistrationId = SR.StudentRegistrationId and HG.Grade= CR.Grade and CR.CourseOfferId = HG.CourseOfferId
GROUP BY SR.StudentId
HAVING count(SR.StudentId) >= 1
