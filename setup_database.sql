DROP DATABASE IF EXISTS surveysystem;

CREATE DATABASE surveysystem;

\c surveysystem

CREATE TABLE users (
  user_id SERIAL PRIMARY KEY,

  -- users can have the same name
  user_name text NOT NULL
);

CREATE TABLE classes (
  class_id text PRIMARY KEY,

  class_name text NOT NULL
);

CREATE TABLE questions (
  question_id serial PRIMARY KEY,

  question_text text NOT NULL
);

CREATE TABLE answers (
  answer_id serial PRIMARY KEY,

  answer_text text NOT NULL, 
  is_correct boolean NOT NULL
);

CREATE TABLE questions_and_answers (
  qa_id serial PRIMARY KEY,

  question_id integer NOT NULL REFERENCES questions(question_id),
  answer_id integer NOT NULL REFERENCES answers(answer_id)
);

CREATE TABLE question_lists (
  ql_id serial PRIMARY KEY,

  qa_id integer NOT NULL REFERENCES questions_and_answers(qa_id), 
  class_id text NOT NULL REFERENCES classes(class_id)
);

CREATE TABLE class_lists (
  cl_id serial PRIMARY KEY,

  class_id text NOT NULL REFERENCES classes(class_id),
  user_id integer NOT NULL REFERENCES users(user_id)
);

CREATE TABLE student_answers (
  sa_id serial PRIMARY KEY,

  user_id integer NOT NULL REFERENCES users(user_id),
  question_id integer NOT NULL REFERENCES questions(question_id),
  answer_id integer NOT NULL REFERENCES answers(answer_id)
);

--Create classes
INSERT INTO classes (class_id, class_name)
VALUES ('G6H0', 'CMPT101');
INSERT INTO classes (class_id, class_name)
VALUES ('5rY7', 'ECON102');
INSERT INTO classes (class_id, class_name)
VALUES ('T6H8', 'PHYS114');
INSERT INTO classes (class_id, class_name)
VALUES ('JiGe', 'CMPT315');
INSERT INTO classes (class_id, class_name)
VALUES ('Hve1', 'ENGL290');

--Questions for class G6H0
INSERT INTO questions (question_text)
VALUES ('Which of these is an infinite loop?');
INSERT INTO answers (answer_text, is_correct)
VALUES ('x=0 do x+=1 <code> while (x<10)', false);
INSERT INTO questions_and_answers (question_id, answer_id)
VALUES (1, 1);
INSERT INTO question_lists (qa_id, class_id)
VALUES (1, 'G6H0');
INSERT INTO answers (answer_text, is_correct)
VALUES ('x=0 do x-=1 <code> while (x<10)', true);
INSERT INTO questions_and_answers (question_id, answer_id)
VALUES (1, 2);
INSERT INTO question_lists (qa_id, class_id)
VALUES (2, 'G6H0');

INSERT INTO questions (question_text)
VALUES ('How do you declare a string in GO?');
INSERT INTO answers (answer_text, is_correct)
VALUES ('var s = "string"', true);
INSERT INTO questions_and_answers (question_id, answer_id)
VALUES (2, 3);
INSERT INTO question_lists (qa_id, class_id)
VALUES (3, 'G6H0');
INSERT INTO answers (answer_text, is_correct)
VALUES ('s = "string"', false);
INSERT INTO questions_and_answers (question_id, answer_id)
VALUES (2, 4);
INSERT INTO question_lists (qa_id, class_id)
VALUES (4, 'G6H0');

--Questions for class 5rY7
INSERT INTO questions (question_text)
VALUES ('What does GDP stand for?');
INSERT INTO answers (answer_text, is_correct)
VALUES ('gross domestic product', true);
INSERT INTO questions_and_answers (question_id, answer_id)
VALUES (3, 5);
INSERT INTO question_lists (qa_id, class_id)
VALUES (5, '5rY7');
INSERT INTO answers (answer_text, is_correct)
VALUES ('great domestic product', false);
INSERT INTO questions_and_answers (question_id, answer_id)
VALUES (3, 6);
INSERT INTO question_lists (qa_id, class_id)
VALUES (6, '5rY7');
INSERT INTO answers (answer_text, is_correct)
VALUES ('good dogs party', false);
INSERT INTO questions_and_answers (question_id, answer_id)
VALUES (3, 7);
INSERT INTO question_lists (qa_id, class_id)
VALUES (7, '5rY7');

--Questions for class T6H8
INSERT INTO questions (question_text)
VALUES ('Which of the following equations is correct?');
INSERT INTO answers (answer_text, is_correct)
VALUES ('force = mass x acceleration', true);
INSERT INTO questions_and_answers (question_id, answer_id)
VALUES (4, 8);
INSERT INTO question_lists (qa_id, class_id)
VALUES (8, 'T6H8');
INSERT INTO answers (answer_text, is_correct)
VALUES ('mass = force x acceleration', false);
INSERT INTO questions_and_answers (question_id, answer_id)
VALUES (4, 9);
INSERT INTO question_lists (qa_id, class_id)
VALUES (9, 'T6H8');
INSERT INTO answers (answer_text, is_correct)
VALUES ('acceleration = mass x force', false);
INSERT INTO questions_and_answers (question_id, answer_id)
VALUES (4, 10);
INSERT INTO question_lists (qa_id, class_id)
VALUES (10, 'T6H8');

--Questions for class JiGe
INSERT INTO questions (question_text)
VALUES ('Which of the following is NOT a RESTful constraint?');
INSERT INTO answers (answer_text, is_correct)
VALUES ('simplicity', true);
INSERT INTO questions_and_answers (question_id, answer_id)
VALUES (5, 11);
INSERT INTO question_lists (qa_id, class_id)
VALUES (11, 'JiGe');
INSERT INTO answers (answer_text, is_correct)
VALUES ('uniform interface', false);
INSERT INTO questions_and_answers (question_id, answer_id)
VALUES (5, 12);
INSERT INTO question_lists (qa_id, class_id)
VALUES (12, 'JiGe');
INSERT INTO answers (answer_text, is_correct)
VALUES ('stateless', false);
INSERT INTO questions_and_answers (question_id, answer_id)
VALUES (5, 13);
INSERT INTO question_lists (qa_id, class_id)
VALUES (13, 'JiGe');
INSERT INTO answers (answer_text, is_correct)
VALUES ('client-server', false);
INSERT INTO questions_and_answers (question_id, answer_id)
VALUES (5, 14);
INSERT INTO question_lists (qa_id, class_id)
VALUES (14, 'JiGe');

--Questions for class Hve1
INSERT INTO questions (question_text)
VALUES ('Which of the Brontë sisters wrote The Tenant of Wildfell Hall?');
INSERT INTO answers (answer_text, is_correct)
VALUES ('Anne Brontë', true);
INSERT INTO questions_and_answers (question_id, answer_id)
VALUES (5, 15);
INSERT INTO question_lists (qa_id, class_id)
VALUES (15, 'Hve1');
INSERT INTO answers (answer_text, is_correct)
VALUES ('Charlotte Brontë', false);
INSERT INTO questions_and_answers (question_id, answer_id)
VALUES (5, 16);
INSERT INTO question_lists (qa_id, class_id)
VALUES (16, 'Hve1');
INSERT INTO answers (answer_text, is_correct)
VALUES ('Emily Brontë', false);
INSERT INTO questions_and_answers (question_id, answer_id)
VALUES (5, 17);
INSERT INTO question_lists (qa_id, class_id)
VALUES (17, 'Hve1');

--Create the users
INSERT INTO users (user_name)
VALUES ('Eileen');
INSERT INTO class_lists (class_id, user_id)
VALUES ('G6H0', 1);
INSERT INTO users (user_name)
VALUES ('Priscilla');
INSERT INTO class_lists (class_id, user_id)
VALUES ('G6H0', 2);
INSERT INTO users (user_name)
VALUES ('Salvatore');
INSERT INTO class_lists (class_id, user_id)
VALUES ('G6H0', 3);
INSERT INTO users (user_name)
VALUES ('Melissa');
INSERT INTO class_lists (class_id, user_id)
VALUES ('G6H0', 4);
INSERT INTO users (user_name)
VALUES ('Loyd');
INSERT INTO class_lists (class_id, user_id)
VALUES ('G6H0', 5);
INSERT INTO users (user_name)
VALUES ('Randall');
INSERT INTO class_lists (class_id, user_id)
VALUES ('G6H0', 6);
INSERT INTO users (user_name)
VALUES ('Rebecca');
INSERT INTO class_lists (class_id, user_id)
VALUES ('G6H0', 7);
INSERT INTO users (user_name)
VALUES ('Roberto');
INSERT INTO class_lists (class_id, user_id)
VALUES ('G6H0', 8);
INSERT INTO users (user_name)
VALUES ('Jennifer');
INSERT INTO class_lists (class_id, user_id)
VALUES ('G6H0', 9);
INSERT INTO users (user_name)
VALUES ('David');
INSERT INTO class_lists (class_id, user_id)
VALUES ('G6H0', 10);

INSERT INTO users (user_name)
VALUES ('Arnold');
INSERT INTO class_lists (class_id, user_id)
VALUES ('5rY7', 11);
INSERT INTO users (user_name)
VALUES ('Michael');
INSERT INTO class_lists (class_id, user_id)
VALUES ('5rY7', 12);
INSERT INTO users (user_name)
VALUES ('Mandy');
INSERT INTO class_lists (class_id, user_id)
VALUES ('5rY7', 13);
INSERT INTO users (user_name)
VALUES ('Suzanne');
INSERT INTO class_lists (class_id, user_id)
VALUES ('5rY7', 14);
INSERT INTO users (user_name)
VALUES ('Roy');
INSERT INTO class_lists (class_id, user_id)
VALUES ('5rY7', 15);
INSERT INTO users (user_name)
VALUES ('Myung');
INSERT INTO class_lists (class_id, user_id)
VALUES ('5rY7', 16);
INSERT INTO users (user_name)
VALUES ('Stephen');
INSERT INTO class_lists (class_id, user_id)
VALUES ('5rY7', 17);
INSERT INTO users (user_name)
VALUES ('Dave');
INSERT INTO class_lists (class_id, user_id)
VALUES ('5rY7', 18);
INSERT INTO users (user_name)
VALUES ('Jeremy');
INSERT INTO class_lists (class_id, user_id)
VALUES ('5rY7', 19);
INSERT INTO users (user_name)
VALUES ('Elizabeth');
INSERT INTO class_lists (class_id, user_id)
VALUES ('5rY7', 20);

INSERT INTO users (user_name)
VALUES ('Earl');
INSERT INTO class_lists (class_id, user_id)
VALUES ('T6H8', 21);
INSERT INTO users (user_name)
VALUES ('Wilburn');
INSERT INTO class_lists (class_id, user_id)
VALUES ('T6H8', 22);
INSERT INTO users (user_name)
VALUES ('Arturo');
INSERT INTO class_lists (class_id, user_id)
VALUES ('T6H8', 23);
INSERT INTO users (user_name)
VALUES ('Richard');
INSERT INTO class_lists (class_id, user_id)
VALUES ('T6H8', 24);
INSERT INTO users (user_name)
VALUES ('Nathaniel');
INSERT INTO class_lists (class_id, user_id)
VALUES ('T6H8', 25);
INSERT INTO users (user_name)
VALUES ('Stanley');
INSERT INTO class_lists (class_id, user_id)
VALUES ('T6H8', 26);
INSERT INTO users (user_name)
VALUES ('Donald');
INSERT INTO class_lists (class_id, user_id)
VALUES ('T6H8', 27);
INSERT INTO users (user_name)
VALUES ('Brian');
INSERT INTO class_lists (class_id, user_id)
VALUES ('T6H8', 28);
INSERT INTO users (user_name)
VALUES ('Carlos');
INSERT INTO class_lists (class_id, user_id)
VALUES ('T6H8', 29);
INSERT INTO users (user_name)
VALUES ('Johanna');
INSERT INTO class_lists (class_id, user_id)
VALUES ('T6H8', 30);

INSERT INTO users (user_name)
VALUES ('Linda');
INSERT INTO class_lists (class_id, user_id)
VALUES ('JiGe', 31);
INSERT INTO users (user_name)
VALUES ('Christa');
INSERT INTO class_lists (class_id, user_id)
VALUES ('JiGe', 32);
INSERT INTO users (user_name)
VALUES ('Leslie');
INSERT INTO class_lists (class_id, user_id)
VALUES ('JiGe', 33);
INSERT INTO users (user_name)
VALUES ('Aaron');
INSERT INTO class_lists (class_id, user_id)
VALUES ('JiGe', 34);
INSERT INTO users (user_name)
VALUES ('Julius');
INSERT INTO class_lists (class_id, user_id)
VALUES ('JiGe', 35);
INSERT INTO users (user_name)
VALUES ('Marie');
INSERT INTO class_lists (class_id, user_id)
VALUES ('JiGe', 36);
INSERT INTO users (user_name)
VALUES ('Karri');
INSERT INTO class_lists (class_id, user_id)
VALUES ('G6H0', 37);
INSERT INTO users (user_name)
VALUES ('Bryan');
INSERT INTO class_lists (class_id, user_id)
VALUES ('JiGe', 38);
INSERT INTO users (user_name)
VALUES ('Richard');
INSERT INTO class_lists (class_id, user_id)
VALUES ('JiGe', 39);
INSERT INTO users (user_name)
VALUES ('Murray');
INSERT INTO class_lists (class_id, user_id)
VALUES ('JiGe', 40);

INSERT INTO users (user_name)
VALUES ('Joseph');
INSERT INTO class_lists (class_id, user_id)
VALUES ('Hve1', 41);
INSERT INTO users (user_name)
VALUES ('Diana');
INSERT INTO class_lists (class_id, user_id)
VALUES ('Hve1', 42);
INSERT INTO users (user_name)
VALUES ('Kathryn');
INSERT INTO class_lists (class_id, user_id)
VALUES ('Hve1', 43);
INSERT INTO users (user_name)
VALUES ('Celeste');
INSERT INTO class_lists (class_id, user_id)
VALUES ('Hve1', 44);
INSERT INTO users (user_name)
VALUES ('Betsy');
INSERT INTO class_lists (class_id, user_id)
VALUES ('Hve1', 45);
INSERT INTO users (user_name)
VALUES ('Michael');
INSERT INTO class_lists (class_id, user_id)
VALUES ('Hve1', 46);
INSERT INTO users (user_name)
VALUES ('Adam');
INSERT INTO class_lists (class_id, user_id)
VALUES ('Hve1', 47);
INSERT INTO users (user_name)
VALUES ('Jacqueline');
INSERT INTO class_lists (class_id, user_id)
VALUES ('Hve1', 48);
INSERT INTO users (user_name)
VALUES ('John');
INSERT INTO class_lists (class_id, user_id)
VALUES ('Hve1', 49);
INSERT INTO users (user_name)
VALUES ('David');
INSERT INTO class_lists (class_id, user_id)
VALUES ('Hve1', 50);

--Create the student answers
INSERT INTO student_answers (user_id, question_id, answer_id)
VALUES (1, 1, 1);
INSERT INTO student_answers (user_id, question_id, answer_id)
VALUES (1, 2, 3);
INSERT INTO student_answers (user_id, question_id, answer_id)
VALUES (2, 1, 1);
INSERT INTO student_answers (user_id, question_id, answer_id)
VALUES (2, 2, 3);
INSERT INTO student_answers (user_id, question_id, answer_id)
VALUES (3, 1, 1);
INSERT INTO student_answers (user_id, question_id, answer_id)
VALUES (3, 2, 4);
INSERT INTO student_answers (user_id, question_id, answer_id)
VALUES (4, 1, 2);
INSERT INTO student_answers (user_id, question_id, answer_id)
VALUES (4, 2, 3);
INSERT INTO student_answers (user_id, question_id, answer_id)
VALUES (5, 1, 2);
INSERT INTO student_answers (user_id, question_id, answer_id)
VALUES (5, 2, 4);
INSERT INTO student_answers (user_id, question_id, answer_id)
VALUES (6, 1, 1);
INSERT INTO student_answers (user_id, question_id, answer_id)
VALUES (6, 2, 3);
INSERT INTO student_answers (user_id, question_id, answer_id)
VALUES (7, 1, 1);
INSERT INTO student_answers (user_id, question_id, answer_id)
VALUES (7, 2, 4);
INSERT INTO student_answers (user_id, question_id, answer_id)
VALUES (8, 1, 2);
INSERT INTO student_answers (user_id, question_id, answer_id)
VALUES (8, 2, 3);
INSERT INTO student_answers (user_id, question_id, answer_id)
VALUES (9, 1, 1);
INSERT INTO student_answers (user_id, question_id, answer_id)
VALUES (9, 2, 3);
INSERT INTO student_answers (user_id, question_id, answer_id)
VALUES (10, 1, 1);
INSERT INTO student_answers (user_id, question_id, answer_id)
VALUES (10, 2, 3);

INSERT INTO student_answers (user_id, question_id, answer_id)
VALUES (11, 3, 5);
INSERT INTO student_answers (user_id, question_id, answer_id)
VALUES (12, 3, 6);
INSERT INTO student_answers (user_id, question_id, answer_id)
VALUES (13, 3, 5);
INSERT INTO student_answers (user_id, question_id, answer_id)
VALUES (14, 3, 7);
INSERT INTO student_answers (user_id, question_id, answer_id)
VALUES (15, 3, 5);
INSERT INTO student_answers (user_id, question_id, answer_id)
VALUES (16, 3, 5);
INSERT INTO student_answers (user_id, question_id, answer_id)
VALUES (17, 3, 6);
INSERT INTO student_answers (user_id, question_id, answer_id)
VALUES (18, 3, 6);
INSERT INTO student_answers (user_id, question_id, answer_id)
VALUES (19, 3, 5);
INSERT INTO student_answers (user_id, question_id, answer_id)
VALUES (20, 3, 5);

INSERT INTO student_answers (user_id, question_id, answer_id)
VALUES (21, 4, 8);
INSERT INTO student_answers (user_id, question_id, answer_id)
VALUES (22, 4, 10);
INSERT INTO student_answers (user_id, question_id, answer_id)
VALUES (23, 4, 9);
INSERT INTO student_answers (user_id, question_id, answer_id)
VALUES (24, 4, 9);
INSERT INTO student_answers (user_id, question_id, answer_id)
VALUES (25, 4, 8);
INSERT INTO student_answers (user_id, question_id, answer_id)
VALUES (26, 4, 8);
INSERT INTO student_answers (user_id, question_id, answer_id)
VALUES (27, 4, 8);
INSERT INTO student_answers (user_id, question_id, answer_id)
VALUES (28, 4, 10);
INSERT INTO student_answers (user_id, question_id, answer_id)
VALUES (29, 4, 9);
INSERT INTO student_answers (user_id, question_id, answer_id)
VALUES (30, 4, 8);

INSERT INTO student_answers (user_id, question_id, answer_id)
VALUES (31, 5, 11);
INSERT INTO student_answers (user_id, question_id, answer_id)
VALUES (32, 5, 12);
INSERT INTO student_answers (user_id, question_id, answer_id)
VALUES (33, 5, 13);
INSERT INTO student_answers (user_id, question_id, answer_id)
VALUES (34, 5, 11);
INSERT INTO student_answers (user_id, question_id, answer_id)
VALUES (35, 5, 13);
INSERT INTO student_answers (user_id, question_id, answer_id)
VALUES (36, 5, 11);
INSERT INTO student_answers (user_id, question_id, answer_id)
VALUES (37, 5, 14);
INSERT INTO student_answers (user_id, question_id, answer_id)
VALUES (38, 5, 14);
INSERT INTO student_answers (user_id, question_id, answer_id)
VALUES (39, 5, 11);
INSERT INTO student_answers (user_id, question_id, answer_id)
VALUES (40, 5, 13);

INSERT INTO student_answers (user_id, question_id, answer_id)
VALUES (41, 6, 15);
INSERT INTO student_answers (user_id, question_id, answer_id)
VALUES (42, 6, 16);
INSERT INTO student_answers (user_id, question_id, answer_id)
VALUES (43, 6, 17);
INSERT INTO student_answers (user_id, question_id, answer_id)
VALUES (44, 6, 15);
INSERT INTO student_answers (user_id, question_id, answer_id)
VALUES (45, 6, 15);
INSERT INTO student_answers (user_id, question_id, answer_id)
VALUES (46, 6, 17);
INSERT INTO student_answers (user_id, question_id, answer_id)
VALUES (47, 6, 16);
INSERT INTO student_answers (user_id, question_id, answer_id)
VALUES (48, 6, 15);
INSERT INTO student_answers (user_id, question_id, answer_id)
VALUES (49, 6, 15);
INSERT INTO student_answers (user_id, question_id, answer_id)
VALUES (50, 6, 16);
