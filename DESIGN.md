# Design Document

By Valeria Chuprina

Video overview: <https://youtu.be/_vkte949JKo>

## Scope

The database for schools includes all entities necessary to facilitate the process of tracking student school attandencies (and teachers'), their progress on school subjects, the database keeps syllabus for every grade, time schedual of the day, and also all hometasks. Implies that students and teachers has their unique cards by which they are able to enter and leave the school. As such, included in the database's scope is:

* Students, including basic identifying information
* Teachers, including basic identifying information
* Subjects taught at school
* Schedule of the day, meaning at what time the lesson(by number) starts and ends
* Student attendance including the date, the time at which the student entered and exited the school building
* Teachers attendance including the date, the time at which the teacher entered and exited the school building
* Syllabus, meaning what subject at what lesson  which teacher in what classroom will teach for each grade for each day of the week
* Marks for student on subjects including the date the mark was given
* Home tasks, including for which grade on what subject it was given and deadline

Out of scope are elements like final grades, and other non-core attributes.

## Functional Requirements

This database will support:

* Students and teachers can update the attendance table via their student card or teacher card
* Students are able to check their progress on any subject, find home tasks, teacher names
* Teachers and students are able to find their syllabus
* Teachers and students are able to find in what classroom the lesson will be
* Teachers can track the grade's progress on their subject
* The school are able to keep track on student attendane, to check the lateness of the student
* Teachers can give the marks to students and add new home tasks

The users will not be able to mark their tasks completed

## Representation

Entities are captured in SQLite tables with the following schema.

### Entities

The database includes the following entities:

#### Students

The `students` table includes:

* `id`, which specifies the unique ID for the student as an `INTEGER`. This column thus has the `PRIMARY KEY` constraint applied.
* `first_name`, which specifies the student's first name as `TEXT`, given `TEXT` is appropriate for name fields.
* `last_name`, which specifies the student's last name. `TEXT` is used for the same reason as `first_name`.
* `grade`, which specifies the student's grade. `INTEGER` is used implying the fact that there are 10 grades in the school. A `CHECK("grade" BETWEEN 1 AND 10)` constraint ensures the grade is between 1 and 10.
* `grade_label`, which specifies the label of student's grade, meaning there are several parallel classes at school. `TEXT CHECK("grade_label" IN ("A", "B", "C"))` used to imply that there are 3 possible "grade labels" to distinct classes: "A", "B" and "C". `TEXT` is appropriate for char value.

All columns in the `students` table are required and hence should have the `NOT NULL` constraint applied.

#### Teachers

The `teachers` table includes:

* `id`, which specifies the unique ID for the teacher as an `INTEGER`. This column thus has the `PRIMARY KEY` constraint applied.
* `first_name`, which specifies the teacher's first name as `TEXT`.
* `last_name`, which specifies the teacher's last name as `TEXT`.

All columns in the `instructors` table are required and hence should have the `NOT NULL` constraint applied. No other constraints are necessary.

#### Subjects

The `subjects` table includes:

* `id`, which specifies the unique ID for the subject as an `INTEGER`. This column thus has the `PRIMARY KEY` constraint applied.
* `subject`, which is the name of the subject as `TEXT`. The column is required and hence should have the `NOT NULL` constraint applied. A `UNIQUE` constraint ensures there are no repetition of subjects in the table.

#### Teacher subject

The `teacher_subject` table includes:

* `teacher_id`, which in 'id' of the teacher who teach the subject, represented as an `INTEGER`. This column thus has the `FOREIGN KEY` constraint applied, referencing the `id` column in the `teachers` table to ensure data integrity.
* `subject_id`, which specifies the unique ID for the subject that teacher teaches as an `INTEGER`. This column thus has the `FOREIGN KEY` constraint applied, referencing the `id` column in the `subjects` table to ensure data integrity.

Unique index `teacher_subject_unique_index` on this table ensures there are no duplicates of `teacher_id`, `subject_id` columns (no pair with the same values).

#### Day schedule

The `day_schedule` table includes:

* `lesson_number`, which is the number of the lesson as `INTEGER`. There are only one time schedule for every day, hence `PRIMARY KEY` constraint is required to ensure uniqueness and be able further reference to this column. `CHECK("lesson_number" BETWEEN 1 AND 7)` implies there are maximum 7 lessons in a day.
* `start_time`, which specifies the time when the lesson under some number starts. Time in SQLite3 can be conveniently stored as `NUMERIC`. The column is required and hence should have the `NOT NULL` constraint applied.
* `end_time`, which specifies the time when the lesson under some number ends. Time in SQLite3 can be conveniently stored as `NUMERIC`. The column is required and hence should have the `NOT NULL` constraint applied.

#### Student attendances

The `student_attendances` table includes:

* `id`, which specifies the unique ID for the attendance as an `INTEGER`. This column thus has the `PRIMARY KEY` constraint applied.
* `date`, which is the date when student entered the school. Date in SQLite3 can be conveniently stored as `NUMERIC`. The default value for the `date` attribute is the current date, as denoted by `DEFAULT CURRENT_DATE`.
* `student_id`, which is 'id' of the student entered the school as an `INTEGER`( the student card provides this information to the admissions system). This column thus has the `FOREIGN KEY` constraint applied, referencing the `id` column in the `students` table to ensure data integrity.
* `enter_time`, which is the time when student entered the school, represented as `NUMERIC`. The default value for the `enter_time` attribute is the current time, as denoted by `DEFAULT CURRENT_TIME`.
* `exit_time`, which is the time when student exited the school, represented as `NUMERIC`. The default value for the `exit_time` attribute is NULL value, as denoted by `DEFAULT NULL`.

Implies that when student uses his card for entering, the system inserts 'card id', which is student id, the current date and entering time and NULL value for exit time to further update this row when student will leave the school building by changing NULL value on CURRENT_TIME of exiting.

#### Teacher attendances

The `teacher_attendances` table includes:

* `id`, which specifies the unique ID for the attendance as an `INTEGER`. This column thus has the `PRIMARY KEY` constraint applied.
* `date`, which is the date when teacher entered the school. Date in SQLite3 can be conveniently stored as `NUMERIC`. The default value for the `date` attribute is the current date, as denoted by `DEFAULT CURRENT_DATE`.
* `teacher_id`, which in 'id' of the teacher entered the school as an `INTEGER`( the teacher card provides this information to the admissions system). This column thus has the `FOREIGN KEY` constraint applied, referencing the `id` column in the `teachers` table to ensure data integrity.
* `enter_time`, which is the time when teacher entered the school, represented as `NUMERIC`. The default value for the `enter_time` attribute is the current time, as denoted by `DEFAULT CURRENT_TIME`.
* `exit_time`, which is the time when teacher exited the school, represented as `NUMERIC`. The default value for the `exit_time` attribute is NULL value, as denoted by `DEFAULT NULL`.

Implies that when teacher uses his card for entering, the system inserts 'card id', which is teacher id, the current date and entering time and NULL value for exit time to further update this row when teacher will leave the school building by changing NULL value on CURRENT_TIME of exiting.

#### Syllabus

The `syllabus` table includes:

* `day_of_the_week`, which is the number of the day of the week as an `INTEGER`. `CHECK("day_of_the_week" BETWEEN 1 AND 6)` implies 1 for Monday, ... , 6 for Saturday, Sunday is rest day.
* `grade`, which specifies the grade for which the lesson is being taught. `INTEGER` is used implying the fact that there are 10 grades in the school. A `CHECK("grade" BETWEEN 1 AND 10)` constraint ensures the grade is between 1 and 10.
* `grade_label`, which specifies the grade's label, meaning there are several parallel classes at school. `TEXT CHECK("grade_label" IN ("A", "B", "C"))` used to imply that there are 3 possible "grade labels" to distinct classes: "A", "B" and "C". `TEXT` is appropriate for char value.
* `lesson_number`, which is the number of the lesson as an `INTEGER`. This column has the `FOREIGN KEY` constraint applied, referencing the `lesson_number` column in the `day_schedule` table to ensure data integrity.
* `classroom_number`, which is the number of the classroom as an `INTEGER`. Each lesson has to have the classroom where it is held, hence `NOT NULL` constraint is provided.
* `subject_id`, which specifies the unique ID for the subject of the lesson as an `INTEGER`. This column thus has the `FOREIGN KEY` constraint applied, referencing the `id` column in the `subjects` table to ensure data integrity.
* `teacher_id`, which in 'id' of the teacher who teach the lesson, represented as an `INTEGER`. This column thus has the `FOREIGN KEY` constraint applied, referencing the `id` column in the `teachers` table to ensure data integrity.

Unique index `syllabus_unique_index` on this table ensures there are no duplicates for `day_of_the_week`, `grade`, `grade_label`, `lesson_number` columns - there could not be two lessons in the same day, for one class at the same time.

#### Marks

The `marks` table includes:

* `student_id`, which is 'id' of the student who got the mark, id is represented as an `INTEGER`. This column thus has the `FOREIGN KEY` constraint applied, referencing the `id` column in the `students` table to ensure data integrity.
* `subject_id`, which specifies the unique ID for the subject for which student got the mark, id is represented as an `INTEGER`. This column thus has the `FOREIGN KEY` constraint applied, referencing the `id` column in the `subjects` table to ensure data integrity.
* `mark`, which is the mark student got, represented as an `INTEGER`. `CHECK("mark" BETWEEN 2 AND 5)` implies that there are 4 possible marks: 2, 3, 4, 5.
* `date`, which is the date when student got the mark. Date in SQLite3 can be conveniently stored as `NUMERIC`. The default value for the `date` attribute is the current date, as denoted by `DEFAULT CURRENT_DATE`.

#### Home tasks

The `home_tasks` table includes:

* `id`, which specifies the unique ID for the home task as an `INTEGER`. This column thus has the `PRIMARY KEY` constraint applied.
* `subject_id`, which specifies the unique ID for the subject for which the task is given, id is represented as an `INTEGER`. This column thus has the `FOREIGN KEY` constraint applied, referencing the `id` column in the `subjects` table to ensure data integrity.
* `grade`, which specifies the grade for which the task is given. `INTEGER` is used implying the fact that there are 10 grades in the school. A `CHECK("grade" BETWEEN 1 AND 10)` constraint ensures the grade is between 1 and 10.
* `grade_label`, which specifies the grade's label, meaning there are several parallel classes at school. `TEXT CHECK("grade_label" IN ("A", "B", "C"))` used to imply that there are 3 possible "grade labels" to distinct classes: "A", "B" and "C". `TEXT` is appropriate for char value.
* `home_task`, which is home task as `TEXT`, given that `TEXT` can still store long-form text. The column is required and hence should have the `NOT NULL` constraint.

### Relationships

The below entity relationship diagram describes the relationships among the entities in the database.

![ER Diagram](https://github.com/lerachu/diagram/blob/main/qHOz-BymY_0.jpg)

As detailed by the diagram:

* One student can make 0 to many attendances in the school building. 0, if they haven't been to school yet, and many if they have already attendened it several times. One attendance can only be made by one student.
* One student can have 0 to many home tasks. One home task given to some class is given to all students in the class, hence is given 1 to many students in this class (1 implies that if home task for class exists - there is at least one student in the class).
* One student can have 0 to many marks. 0 if student haven't yet received any mark. One mark can be given to only one student.
* One student can have 1 to many lessons in syllabus (1 implies that every class has lessons on the week). One row in syllabus table refference to some class, there could be 1 to many students in this class (1 implies that if syllabus for class exists - there is at least one student in the class).
* One teacher can have 1 to many lessons in syllabus (1 implies that if teacher works at school - he teaches lessons). One row in syllabus table refference to only one teacher.
* One teacher can teach 1 to many subjects (1 implies that if teacher works at school - he teaches lessons). Many if teacher has several aducations. One subject can be taught by 1 to many teachers (1 implies if subject is listed, then there is at least one teacher who teaches it). Many if there are several teachers who teaches the same subject.
* One teacher can make 0 to many attendances in the school building. 0, if they haven't been to school yet, and many if they have already attendened it several times. One attendance can only be made by one teacher.
* One home task refference only 1 subject. There could be 0 to many tasks on one subject. 0, if there are no home tasks on some subject. Many if there are several tasks on one subject.
* One mark can be given only on 1 subject. Subject can have 0 to many marks. 0, if there are no marks on some subject yet, and many if student or students have several marks on some subject.
* One row in syllabus refference only 1 subject. There are 1 to many lessons on one subject in syllabus. Implies if subject is listed, then there is at least 1 lesson on this subject in a week.
* One row in syllabus refference only 1 lesson number in day schedule. There can be 0 to many rows in syllabus with one lesson number. 0, if there is no, for ex., first lessons on any day of the week for any grade. Many if for some lesson number there are several lessons for one or several classes in one(if several classes) or some days of the week. For ex., two grades can have lessons at the same time.

## Optimizations

Per the typical queries in `queries.sql`, it is common for users of the database to quiry the average marks. But this quiry requires to join many tables, therefore the view `average_marks` is created to simplify the quiry - to allow to use selection from only one "view" table.

For the same reason as above, the `student_marks` view was created for quiring the separate marks.

View `full_syllabus` represents syllabus for all grades including the day of the week, grade, grade label, time lesson starts, subject of the lesson, number of the classroom where lesson goes and teacher's name who teaches the lesson. This view simplifies the student's and teacher's quiries on their syllabus.

Per the typical queries in `queries.sql`, it is common for users of the database to access information about marks, attendance of any particular student. For that reason, indexes are created on the `first_name`, `last_name`, `grade` and `grade_label` columns in the `students` table to speed the identification of students by those columns.

Similarly, it is also common practice for a user of the database to use search by subject on different quiries, such as finding marks on subjects, home tasks on subjects, syllabus showing subjects. As such, an index is created on the `subject` column in the `subjects` table to speed the identification of subjects by name.

The indexes on the `date`, `student_id` column in the `student_attendances` table are created to speed the finding attendance time of student by student id and date of interest.

## Limitations

My database do not allow to represent for what exactly the mark for the student was given and at what exact lesson (assuming there could be several lessons on one subject in a day for one grade).
Also student or teacher can not mark task completed. Students see all the tasks for their class, even if they have completed them.
The database do not keep information about other staff attendance.
