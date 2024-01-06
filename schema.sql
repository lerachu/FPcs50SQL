-- Represent students in school
CREATE TABLE "students" (
    "id" INTEGER,
    "first_name" TEXT NOT NULL,
    "last_name" TEXT NOT NULL,
    "grade" INTEGER CHECK("grade" BETWEEN 1 AND 10),
    "grade_label" TEXT CHECK("grade_label" IN ("A", "B", "C")),
    PRIMARY KEY("id")
);

-- Represent teachers in school
CREATE TABLE "teachers" (
    "id" INTEGER,
    "first_name" TEXT NOT NULL,
    "last_name" TEXT NOT NULL,
    PRIMARY KEY("id")
);

-- Represent school subjects
CREATE TABLE "subjects" (
    "id" INTEGER,
    "subject" TEXT NOT NULL UNIQUE,
    PRIMARY KEY("id")
);

-- Represent teacher-subject connection
CREATE TABLE "teacher_subject" (
    "teacher_id" INTEGER,
    "subject_id" INTEGER,
    FOREIGN KEY("teacher_id") REFERENCES "teachers"("id"),
    FOREIGN KEY("subject_id") REFERENCES "subjects"("id")
);

-- Unique index on "teacher_subject"
CREATE UNIQUE INDEX "teacher_subject_unique_index"
ON "teacher_subject"("teacher_id", "subject_id");

-- Represent time schedule of lessons
CREATE TABLE "day_schedule" (
    "lesson_number" INTEGER CHECK("lesson_number" BETWEEN 1 AND 7),
    "start_time" NUMERIC NOT NULL,
    "end_time" NUMERIC NOT NULL,
    PRIMARY KEY("lesson_number")
);

-- Represent student attendances of school building
CREATE TABLE "student_attendances" (
    "id" INTEGER,
    "date" NUMERIC DEFAULT CURRENT_DATE,
    "student_id" INTEGER,
    "enter_time" NUMERIC DEFAULT CURRENT_TIME,
    "exit_time" NUMERIC DEFAULT NULL,
    PRIMARY KEY("id"),
    FOREIGN KEY("student_id") REFERENCES "students"("id")
);

-- Represent teacher attendances of school building
CREATE TABLE "teacher_attendances" (
    "id" INTEGER,
    "date" NUMERIC DEFAULT CURRENT_DATE,
    "teacher_id" INTEGER,
    "enter_time" NUMERIC DEFAULT CURRENT_TIME,
    "exit_time" NUMERIC DEFAULT NULL,
    PRIMARY KEY("id"),
    FOREIGN KEY("teacher_id") REFERENCES "teachers"("id")
);

-- Represent school's syllabus
CREATE TABLE "syllabus" (
    "day_of_the_week" INTEGER CHECK("day_of_the_week" BETWEEN 1 AND 6),   -- 1 for Monday
    "grade" INTEGER CHECK("grade" BETWEEN 1 AND 10),
    "grade_label" TEXT CHECK("grade_label" IN ("A", "B", "C")),
    "lesson_number" INTEGER,
    "classroom_number" INTEGER NOT NULL,
    "subject_id" INTEGER,
    "teacher_id" INTEGER,
    FOREIGN KEY("teacher_id") REFERENCES "teachers"("id"),
    FOREIGN KEY("subject_id") REFERENCES "subjects"("id"),
    FOREIGN KEY("lesson_number") REFERENCES "day_schedule"("lesson_number")
);

-- Unique index on "syllabus"
CREATE UNIQUE INDEX "syllabus_unique_index"
ON "syllabus"("day_of_the_week", "grade", "grade_label", "lesson_number");

-- Represent academic performances of students
CREATE TABLE "marks" (
    "student_id" INTEGER,
    "subject_id" INTEGER,
    "mark" INTEGER CHECK("mark" BETWEEN 2 AND 5),
    "date" NUMERIC DEFAULT CURRENT_DATE,
    FOREIGN KEY("student_id") REFERENCES "students"("id"),
    FOREIGN KEY("subject_id") REFERENCES "subjects"("id")
);

-- Represent home tasks
CREATE TABLE "home_tasks" (
    "id" INTEGER,
    "subject_id" INTEGER,
    "grade" INTEGER CHECK("grade" BETWEEN 1 AND 10),
    "grade_label" TEXT CHECK("grade_label" IN ("A", "B", "C")),
    "dead_line" NUMERIC NOT NULL,
    "home_task" TEXT NOT NULL,
    PRIMARY KEY("id"),
    FOREIGN KEY("subject_id") REFERENCES "subjects"("id")
);

-- Create view for simplifying queries on everage marks
CREATE VIEW "average_marks" AS
SELECT "first_name", "last_name", "grade", "grade_label", "subject", ROUND(AVG("mark"), 2) AS "average_mark_for_student_for_subject"
FROM "marks"
JOIN "students" ON "students"."id" = "marks"."student_id"
JOIN "subjects" ON "subjects"."id" = "marks"."subject_id"
GROUP BY "students"."id", "subject";

-- Create view on student marks
CREATE VIEW "student_marks" AS
SELECT "first_name", "last_name", "grade", "grade_label", "subject", "mark", "date" FROM "marks"
JOIN "students" ON "students"."id" = "marks"."student_id"
JOIN "subjects" ON "subjects"."id" = "marks"."subject_id";

-- Create view on syllabus for all grades including the day of the week, grade, grade label, time lesson starts, subject, number of the classroom and teachers name
CREATE VIEW "full_syllabus" AS
SELECT "day_of_the_week", "grade", "grade_label", "start_time" , "subject", "classroom_number", "first_name", "last_name" FROM "syllabus"
JOIN "subjects" ON "syllabus"."subject_id" = "subjects"."id"
JOIN "day_schedule" ON "day_schedule"."lesson_number" = "syllabus"."lesson_number"
JOIN "teachers" ON "syllabus"."teacher_id" = "teachers"."id"
ORDER BY "day_of_the_week", "grade", "grade_label", "start_time";

-- Create indexes to speed common searches
CREATE INDEX "student_search" ON "students" ("first_name", "last_name", "grade", "grade_label");
CREATE INDEX "subject_search" ON "subjects" ("subject");
CREATE INDEX "date_attendance_for_student" ON "student_attendances" ("date", "student_id");