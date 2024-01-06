-- Find average mark for given subject for given student
SELECT "average_mark_for_student_for_subject" FROM "average_marks"
WHERE "first_name" = 'John' AND "last_name" = 'White' AND "grade" = 2 AND "grade_label" = 'C' AND "subject" = 'literature';

-- Find average mark for all subjects for given student
SELECT "subject", "average_mark_for_student_for_subject" FROM "average_marks"
WHERE "first_name" = 'John' AND "last_name" = 'White' AND "grade" = 2 AND "grade_label" = 'C';

-- Find average mark for all subjects for every student in a given grade
SELECT "first_name", "last_name", "subject", "average_mark_for_student_for_subject" FROM "average_marks"
WHERE "grade" = 2 AND "grade_label" = 'C';

-- Find average mark of all students in every grade for a given subject
SELECT "grade", ROUND(AVG("average_mark_for_student_for_subject"), 2) AS "average_mark_for_grade" FROM "average_marks"
WHERE "subject" = "french" GROUP BY "grade";

-- Find the classroom where lesson will be given for a given grade, subject and day of the week
SELECT "classroom_number" FROM "syllabus"
JOIN "subjects" ON "syllabus"."subject_id" = "subjects"."id"
WHERE "grade" = 8 AND "grade_label" = 'C' AND "subject" = "biology" AND "day_of_the_week" = 6;

-- Find at what time the given student entered the school and at what time the lessons began at given day
SELECT "enter_time", "start_time" FROM "student_attendances"
JOIN "students" ON "students"."id" = "student_attendances"."student_id"
CROSS JOIN "syllabus"
JOIN "day_schedule" ON "day_schedule"."lesson_number" = "syllabus"."lesson_number"
WHERE "first_name" = 'John' AND "last_name" = 'White' AND "students"."grade" = 2 AND "students"."grade_label" = 'C' AND "syllabus"."grade" = 2 AND "syllabus"."grade_label" = 'C' AND "date" = '2023-10-30' AND "day_of_the_week" = STRFTIME('%w', '2023-10-30')
ORDER BY "enter_time", "syllabus"."lesson_number" LIMIT 1;

-- Find at what time the given student left the school and at what time the lessons ended at given day
SELECT "exit_time", "end_time" FROM "student_attendances"
JOIN "students" ON "students"."id" = "student_attendances"."student_id"
CROSS JOIN "syllabus"
JOIN "day_schedule" ON "day_schedule"."lesson_number" = "syllabus"."lesson_number"
WHERE "first_name" = 'John' AND "last_name" = 'White' AND "students"."grade" = 2 AND "students"."grade_label" = 'C' AND "syllabus"."grade" = 2 AND "syllabus"."grade_label" = 'C' AND "date" = '2023-10-30' AND "day_of_the_week" = STRFTIME('%w', '2023-10-30')
ORDER BY "exit_time" DESC, "syllabus"."lesson_number" DESC LIMIT 1;

-- Find mark student got for given subject for given date
SELECT "mark" FROM "student_marks"
WHERE "first_name" = 'John' AND "last_name" = 'White' AND "grade" = 2 AND "grade_label" = 'C' AND "subject" = 'literature' AND "date" = '2023-10-25';

-- Find when and in what classroom each lesson starts, subject of the lesson and who teaches the lesson for a given grade and day of the week
SELECT "start_time" , "subject", "classroom_number", "first_name", "last_name" FROM "full_syllabus"
WHERE "grade" = 4 AND "grade_label" = 'B' AND "day_of_the_week" = 5;

-- Find all the lessons given teacher teaches on a week
SELECT "day_of_the_week", "start_time", "grade", "grade_label", "subject", "classroom_number" FROM "full_syllabus"
WHERE "first_name" = 'Novac' AND "last_name" = 'Rys'
ORDER BY "day_of_the_week", "start_time";

-- Find the average number of students which attended school at given week
WITH "distinct_number_of_students_in_a_day" AS (
    SELECT "date", COUNT(DISTINCT("student_id")) AS "number_of_students_in_a_day" FROM "student_attendances"
    GROUP BY "date"
)
SELECT AVG("number_of_students_in_a_day") AS "avg_number_of_students_in_the_week" FROM "distinct_number_of_students_in_a_day"
WHERE "date" BETWEEN '2023-10-23' AND '2023-10-30';

-- Find the name of the teacher given lesson number, grade, day of the week they teach
SELECT "first_name", "last_name" FROM "teachers"
JOIN "syllabus" ON "syllabus"."teacher_id" = "teachers"."id"
WHERE "day_of_the_week" = 3 AND "lesson_number" = 4 AND "grade" = 7 AND "grade_label" = 'C';

-- Find how many students of given grade were attendened on given lesson at given day
SELECT COUNT(DISTINCT("student_id")) FROM "student_attendances"
JOIN "students" ON "students"."id" = "student_attendances"."student_id"
CROSS JOIN "day_schedule"
WHERE "date" = '2023.10.7' AND  "lesson_number" = 4 AND "grade" = 7 AND "grade_label" = 'C' AND "enter_time" < "end_time" AND "exit_time" > "start_time";

-- Find all current tasks for the given grade for all subjects
SELECT "dead_line", "subject", "home_task" FROM "home_tasks"
JOIN "subjects" ON "home_tasks"."subject_id" = "subjects"."id"
WHERE "grade" = 8 AND "grade_label" = 'A' AND "dead_line" >= CURRENT_DATE;

-- Find the task for the given grade and subject
SELECT "dead_line", "home_task" FROM "home_tasks"
JOIN "subjects" ON "home_tasks"."subject_id" = "subjects"."id"
WHERE "grade" = 6 AND "grade_label" = 'A' AND "subject" = 'biology' AND "dead_line" >= CURRENT_DATE;

-- Add a new student
INSERT INTO "students" ("first_name", "last_name", "grade", "grade_label")
VALUES ('John', 'White', '1', 'C');

-- Change student's grade
UPDATE "students" SET "grade" = 2
WHERE "first_name" = 'John' AND "last_name" = 'White' AND "grade_label" = 'C';

-- Add a new teacher
INSERT INTO "teachers" ("first_name", "last_name")
VALUES ('Kendal', 'Smith');
INSERT INTO "teacher_subject" ("teacher_id", "subject_id")
VALUES ((SELECT "id" FROM "teachers" WHERE "first_name" ='Kendal' AND "last_name" = 'Smith'), (SELECT "id" FROM "subjects" WHERE "subject" = 'algebra'));

-- Add info about student entering into school building (students use student card with id number)
INSERT INTO "student_attendances" ("student_id")
VALUES (456);

-- Add info about student exiting out of school building (students use student card with id number)
UPDATE "student_attendances" SET "exit_time" = CURRENT_TIME
WHERE "id" = (SELECT "id" FROM "student_attendances" WHERE "student_id" = 67 ORDER BY "id" DESC LIMIT 1);

-- Add info about teacher entering into school building (teahers use teacher card with id number)
INSERT INTO "teacher_attendances" ("teacher_id")
VALUES (15);

-- Add info about teacher exiting out of school building (teachers uses teacher card with id number)
UPDATE "teacher_attendances" SET "exit_time" = CURRENT_TIME
WHERE "id" = (SELECT "id" FROM "teacher_attendances" WHERE "teacher_id" = 14 ORDER BY "id" DESC LIMIT 1);

-- Change classroom of the lesson
UPDATE "syllabus" SET "classroom_number" = 28
WHERE "day_of_the_week" = 2 AND "grade" = 6 AND "grade_label
" = 'A' AND "lesson_number" = 5;

-- Give a mark to student
INSERT INTO "marks" ("student_id", "subject_id", "mark")
VALUES (
    (SELECT "id" FROM "students"
    WHERE "first_name" = 'Kate' AND "last_name" = 'Black' AND "grade" = 4 AND "grade_label" = 'A'),
    (SELECT "id" FROM "subjects" WHERE "subject" = 'english'),
    5
);

-- Add new home task
INSERT INTO "home_tasks" ("subject_id", "grade", "grade_label", "dead_line", "home_task")
VALUES (5, 6, 'A', '2023-11-10', "Learn 10th paragraph");
