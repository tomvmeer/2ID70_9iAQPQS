CREATE MATERIALIZED VIEW pointsPerS(studentId, studentregistrationid, sumECTS, GPA) as
SELECT  CR.studentid, CR.studentregistrationid, sum(ECTS), sum(CR.Grade * C.ECTS)/sum(C.ECTS)
FROM courseRegistrations CR, CourseOffers CO, Courses C
WHERE CR.CourseOfferId = CO.CourseOfferId And CO.CourseId = C.CourseId and CR.Grade >= 5
GROUP BY CR.studentid, CR.studentregistrationid;

CREATE MATERIALIZED VIEW studentNoFails(studentRegistrationId) as
SELECT CR.StudentRegistrationID
FROM courseRegistrations CR
EXCEPT 
SELECT CR2.StudentRegistrationId
FROM CourseRegistrations CR2
WHERE CR2.grade < 5;

CREATE INDEX idx_grade on courseRegistrations(grade);
CREATE UNIQUE INDEX idx_pointsPerS on pointsPerS(studentregistrationid);
CREATE INDEX idx_studRegIdandCourseOfferI on courseRegistrations(studentRegistrationId, courseofferId);


CREATE MATERIALIZED VIEW activeStudents(studentId, DegreeId, Gender, Birthyear) as
WITH have_not_taken_yet(studentregistrationid, sumECTS) as (
SELECT studentregistrationid, 0
FROM (
SELECT studentregistrationid
FROM studentRegistrationsToDegrees D
EXCEPT
SELECT studentregistrationid
FROM pointsPerS) as new)

SELECT SD.StudentId, D.DegreeId, S.Gender, S.birthyearstudent
FROM  pointsPerS as almost, studentRegistrationsToDegrees SD, degrees D, students s
WHERE almost.studentregistrationid = sd.studentregistrationid and D.degreeid = SD.DegreeID and D.totalects > almost.sumECTS and SD.studentId = S.studentId
UNION
SELECT SD.studentid, SD.DegreeID, S.Gender, S.birthyearstudent
FROM studentRegistrationsToDegrees SD, have_not_taken_yet HY, students s
WHERE SD.studentregistrationid = HY.studentregistrationid and SD.studentId = S.studentId;
