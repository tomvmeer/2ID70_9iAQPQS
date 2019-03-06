CREATE UNLOGGED TABLE Students(StudentId int, StudentName varchar(50), Address varchar(200),BirthyearStudent smallint, Gender char);
COPY Students(StudentId, StudentName, Address,BirthyearStudent, Gender) FROM '/mnt/ramdisk/tables/Students.table' DELIMITER ',' CSV HEADER;
ALTER TABLE Students add primary key (studentid);
CREATE UNLOGGED TABLE StudentRegistrationsToDegrees(StudentRegistrationId int, StudentId int, DegreeId int, RegistrationYear smallint);
COPY StudentRegistrationsToDegrees(StudentRegistrationId, StudentId, DegreeId, RegistrationYear) FROM '/mnt/ramdisk/tables/StudentRegistrationsToDegrees.table' DELIMITER ',' CSV HEADER;
ALTER TABLE StudentRegistrationsToDegrees add primary key (StudentRegistrationId);
CREATE UNLOGGED TABLE Degrees(DegreeId int, Dept varchar(50), DegreeDescription varchar(200), TotalECTS smallint);
CREATE UNLOGGED TABLE Courses(CourseId int, CourseName varchar(50), CourseDescription varchar(200), DegreeId int, ECTS smallint);
COPY Courses(CourseId, CourseName, CourseDescription,  DegreeId, ECTS) FROM '/mnt/ramdisk/tables/Courses.table' DELIMITER ',' CSV HEADER;
ALTER TABLE Courses add primary key (CourseId);

CREATE UNLOGGED TABLE CourseOffers_temp(CourseOfferId int, CourseId int, year smallint, Quartile smallint);
COPY CourseOffers_temp(CourseOfferId, CourseId, year,  Quartile) FROM '/mnt/ramdisk/tables/CourseOffers.table' DELIMITER ',' CSV HEADER;

SELECT CO.*, courses.CourseName INTO CourseOffers FROM CourseOffers_temp CO, Courses WHERE Courses.CourseId = CO.CourseID; 
ALTER TABLE CourseOffers add primary key (CourseOfferId);

DROP TABLE CourseRegistrations_temp;

CREATE UNLOGGED TABLE CourseRegistrations_temp(CourseOfferId int, StudentRegistrationId int, Grade smallint);
COPY CourseRegistrations_temp(CourseOfferId, StudentRegistrationId, Grade) FROM '/mnt/ramdisk/tables/CourseRegistrations.table' DELIMITER ',' CSV HEADER NULL 'null';

select courseregistrations_temp.*, studentregistrationstodegrees.studentid, courseoffers.courseid into CourseRegistrations from courseregistrations_temp, studentregistrationstodegrees, courseoffers where courseregistrations_temp.studentregistrationid = studentregistrationstodegrees.studentregistrationid and courseregistrations_temp.courseofferid = courseoffers.courseofferid;

DROP TABLE CourseRegistrations_temp;

COPY Degrees(DegreeId, Dept, DegreeDescription, TotalECTS) FROM '/mnt/ramdisk/tables/Degrees.table' DELIMITER ',' CSV HEADER;
ALTER TABLE Degrees add primary key (DegreeId);
CREATE UNLOGGED TABLE Teachers(TeacherId int, TeacherName varchar(50), Address varchar(200), BirthyearTeacher smallint, Gender char);
COPY Teachers(TeacherId, TeacherName, Address,  BirthyearTeacher, Gender) FROM '/mnt/ramdisk/tables/Teachers.table' DELIMITER ',' CSV HEADER;
ALTER TABLE Teachers add primary key (TeacherId);
CREATE UNLOGGED TABLE TeacherAssignmentsToCourses(CourseOfferId int, TeacherId int);
COPY TeacherAssignmentsToCourses(CourseOfferId, TeacherId) FROM '/mnt/ramdisk/tables/TeacherAssignmentsToCourses.table' DELIMITER ',' CSV HEADER;
CREATE UNLOGGED TABLE StudentAssistants(CourseOfferId int, StudentRegistrationId int);
COPY StudentAssistants(CourseOfferId, StudentRegistrationId) FROM '/mnt/ramdisk/tables/StudentAssistants.table' DELIMITER ',' CSV HEADER;
ANALYZE VERBOSE
