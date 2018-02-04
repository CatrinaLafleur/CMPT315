// Catrina Lafleur
// CMPT 315 Assignment 1
// Student response system (back end)
// Due: Tuesday Feb 6, 2018
//
// Connects to the database and handles the HTTP requests 

package main

import (
	"fmt"
	"os"
	"strings"
	"math/rand"
	"time"
	"net/http"
	"io"
	"bytes"

	"github.com/jmoiron/sqlx"
	"github.com/lib/pq"
)

var variable *bytes.Buffer = &bytes.Buffer{}
var db *sqlx.DB

//Create the structures that mirror the database
type user struct {
	UserId int    `db:"user_id"`
	UserName string `db:"user_name"`
}

type class struct {
	ClassId     string    `db:"class_id"`
	ClassName   string `db:"class_name"`
}

type question struct {
	QuestionId     int    `db:"question_id"`
	QuestionText   string `db:"question_text"`
}

type answer struct {
	AnswerId     int    `db:"answer_id"`
	AnswerText   string `db:"answer_text"`
	IsCorrect   bool `db:"is_correct"`
}

type questionAndAnswer struct {
	QAID     int    `db:"qa_id"`
	QuestionId     int    `db:"question_id"`
	AnswerId     int    `db:"answer_id"`
}

type questionList struct {
	QLID     int    `db:"ql_id"`
	ClassId     string    `db:"class_id"`
	QAID     int    `db:"qa_id"`
}

type classList struct {
	CLID 	int    `db:"cl_id"`
	ClassId     string    `db:"class_id"`
	UserId int    `db:"user_id"`
}

type studentAnswer struct {
	SAID	 int    `db:"sa_id"`
	UserID int    `db:"user_id"`
	QuestionId     int    `db:"question_id"`
	AnswerId     int    `db:"answer_id"`
}
 
func main() {
	var err error
	//Connect to the database if fails, exit the program
	db, err = connectToDB()
	if err != nil {
		fmt.Fprintf(os.Stderr, "cannot connect to database: %v\n", err)
		os.Exit(1)
	}
	
	//The API handlers
	http.HandleFunc("/api/v1/classes", handleClasses)

	http.ListenAndServe(":8080", nil)
}
//Ensures that the unique constraint is upheld 
func isUniqueViolation(err error) bool {
	if err, ok := err.(*pq.Error); ok {
		return err.Code == "23505"
	}
	return false
}

//Database connection string
func connectToDB() (*sqlx.DB, error) {
	return sqlx.Connect("postgres", "dbname=surveysystem user=catrina sslmode=disable")
}

//Handles /api/v1/classes
func handleClasses(w http.ResponseWriter, r *http.Request) {
	switch r.Method {
	case "GET":
		err := listClasses(w)
		if err != nil {
			http.Error(w, http.StatusText(http.StatusInternalServerError), http.StatusInternalServerError)
			return
		}
		_, err = io.Copy(w, variable)
		if err != nil {
			http.Error(w, http.StatusText(http.StatusInternalServerError), http.StatusInternalServerError)
			return
		}
	case "POST":
		err := createClass()
		if err != nil {
			http.Error(w, http.StatusText(http.StatusInternalServerError), http.StatusInternalServerError)
			return
		}
		_, err = io.Copy(variable, r.Body)
		if err != nil {
			http.Error(w, http.StatusText(http.StatusInternalServerError), http.StatusInternalServerError)
			return
		}
	default:
		http.Error(w, http.StatusText(http.StatusBadRequest), http.StatusBadRequest)
		return
	}
}

// createClass inserts a new class into the database
func createClass() error {
	//With the front end this would be gathered from text boxes
	var response string
	fmt.Printf("Enter the class name: ")
	_, err := fmt.Scanln(&response)
	if err != nil {
		return err
	}

	id := makeString()
	// insert the data
	q := `INSERT INTO classes (class_id, class_name)
                   VALUES ($1, $2)`
	result, err := db.Exec(q, id, response)
	if err != nil {
		if isUniqueViolation(err) {
			createClass()
		}
		return err
	}
	count, err := result.RowsAffected()
	if err != nil {
		return err
	}
	fmt.Printf("%d class(es) created.\n", count)
	return nil
}

//Generates a random code for the class_id
func makeString() string {
	var lettersAndNumbers = "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
	id := []string{"", "", "", ""}

	for i := 0; i < 4; i++ {
		s1 := rand.NewSource(time.Now().UnixNano())
    		r1 := rand.New(s1)
		r := r1.Intn(len(lettersAndNumbers))
		id[i] = string(lettersAndNumbers[r])
	}
	return strings.Join(id, "")
}

// listClasses displays a table of all the classes in the database
func listClasses(w http.ResponseWriter) error {
	// obtain the data
	q := `SELECT class_id, class_name
                FROM classes`
	classes := []class{}
	err := db.Select(&classes, q)
	if err != nil {
		return err
	}

	// display the data
	fmt.Fprintf(w, "ID   name\n")
	fmt.Fprintf(w, "--------------------------------\n")
	for _, class := range classes {
		fmt.Fprintf(w, "%s %s\n", class.ClassId, class.ClassName)
	}

	return nil
}

// createQuestion inserts a new Question into the database
func createQuestion() error {
	// check the arguments
	args := os.Args[2:]
	if len(args) != 1 {
		return fmt.Errorf("one argument required: prompt")
	}
	// insert the data
	q := `INSERT INTO questions (question_text)
                   VALUES ($1)`
	result, err := db.Exec(q, args[0])
	if err != nil {
		return err
	}
	count, err := result.RowsAffected()
	if err != nil {
		return err
	}
	fmt.Printf("%d question(s) created.\n", count)
	return nil
}

// listQuestions displays a table of all the questions in the database
func listQuestions(w http.ResponseWriter) error {
	// obtain the data
	q := `SELECT question_id, question_text
                FROM questions`
	questions := []question{}
	err := db.Select(&questions, q)
	if err != nil {
		return err
	}

	// display the data
	fmt.Fprintf(w, "ID   prompt\n")
	fmt.Fprintf(w, "--------------------------------\n")
	for _, question := range questions {
		fmt.Fprintf(w, "%-4d %s\n", question.QuestionId, question.QuestionText)
	}

	return nil
}

// deleteQuestion deletes a question from the database
func deleteQuestion() error {
	// check the arguments
	args := os.Args[2:]
	if len(args) != 1 {
		return fmt.Errorf("one argument required: question ID")
	}

	// insert the data
	q := `DELETE FROM questions
                    WHERE question_id = $1`
	result, err := db.Exec(q, args[0])
	if err != nil {
		return err
	}

	count, err := result.RowsAffected()
	if err != nil {
		return err
	}

	fmt.Printf("%d question(s) deleted.\n", count)

	return nil
}

// createAnswer inserts a new answer into the database
func createAnswer() error {
	// check the arguments
	args := os.Args[2:]
	if len(args) != 2 {
		return fmt.Errorf("two arguments required: text and isCorrect")
	}
	// insert the data
	q := `INSERT INTO answers (answer_text, is_correct)
                   VALUES ($1, $2)`
	result, err := db.Exec(q, args[0], args[1])
	if err != nil {
		return err
	}
	count, err := result.RowsAffected()
	if err != nil {
		return err
	}
	fmt.Printf("%d answers(s) created.\n", count)
	return nil
}



// listAnswers displays a table of all the answers in the database
func listAnswers() error {
	// obtain the data
	q := `SELECT answer_id, answer_text, is_correct
                FROM answers`
	answers := []answer{}
	err := db.Select(&answers, q)
	if err != nil {
		return err
	}

	// display the data
	fmt.Printf("ID   text	isCorrect\n")
	fmt.Printf("--------------------------------\n")
	for _, answer := range answers {
		fmt.Printf("%-4d %s \t%v\n", answer.AnswerId, answer.AnswerText, answer.IsCorrect)
	}

	return nil
}

// deleteAnswer deletes an answer from the database
func deleteAnswer() error {
	// check the arguments
	args := os.Args[2:]
	if len(args) != 1 {
		return fmt.Errorf("one argument required: answer ID")
	}

	// insert the data
	q := `DELETE FROM answers
                    WHERE answer_id = $1`
	result, err := db.Exec(q, args[0])
	if err != nil {
		return err
	}

	count, err := result.RowsAffected()
	if err != nil {
		return err
	}

	fmt.Printf("%d answer(s) deleted.\n", count)

	return nil
}

// createQA inserts a new question answer pair into the database
func createQA() error {
	// check the arguments
	args := os.Args[2:]
	if len(args) != 2 {
		return fmt.Errorf("two arguments required: question_id and answer_id")
	}
	// insert the data
	q := `INSERT INTO questions_and_answers (question_id, answer_id)
                   VALUES ($1, $2)`
	result, err := db.Exec(q, args[0], args[1])
	if err != nil {
		return err
	}
	count, err := result.RowsAffected()
	if err != nil {
		return err
	}
	fmt.Printf("%d question answer pair(s) created.\n", count)
	return nil
}

// listQA displays a table of all the question answer pairs in the database
func listQA() error {
	// obtain the data
	q := `SELECT qa_id, question_id, answer_id
                FROM questions_and_answers`
	questionAndAnswers := []questionAndAnswer{}
	err := db.Select(&questionAndAnswers, q)
	if err != nil {
		return err
	}

	// display the data
	fmt.Printf("ID   question_id	answer_id\n")
	fmt.Printf("--------------------------------\n")
	for _, questionAndAnswer := range questionAndAnswers {
		fmt.Printf("%-4d %-4d \t\t%-4d\n", questionAndAnswer.QAID, questionAndAnswer.QuestionId, questionAndAnswer.AnswerId)
	}

	return nil
}

// deleteQA deletes a question answer pair from the database
func deleteQA() error {
	// check the arguments
	args := os.Args[2:]
	if len(args) != 1 {
		return fmt.Errorf("one argument required: QA_ID")
	}

	// insert the data
	q := `DELETE FROM questions_and_answers
                    WHERE qa_id = $1`
	result, err := db.Exec(q, args[0])
	if err != nil {
		return err
	}

	count, err := result.RowsAffected()
	if err != nil {
		return err
	}

	fmt.Printf("%d question answer pair(s) deleted.\n", count)

	return nil
}

// createQuestionList inserts a new question/answer class pair into the database
func createQuestionList() error {
	// check the arguments
	args := os.Args[2:]
	if len(args) != 2 {
		return fmt.Errorf("two arguments required: qa_id and class_id")
	}
	// insert the data
	q := `INSERT INTO question_lists (qa_id, class_id)
                   VALUES ($1, $2)`
	result, err := db.Exec(q, args[0], args[1])
	if err != nil {
		return err
	}
	count, err := result.RowsAffected()
	if err != nil {
		return err
	}
	fmt.Printf("%d question list(s) created.\n", count)
	return nil
}

// listQuestionList displays a table of all the question/answer class pairs in the database
func listQuestionList() error {
	// obtain the data
	q := `SELECT ql_id, qa_id, class_id
                FROM question_lists`
	question_lists := []questionList{}
	err := db.Select(&question_lists, q)
	if err != nil {
		return err
	}

	// display the data
	fmt.Printf("ID   qa_id	class_id\n")
	fmt.Printf("--------------------------------\n")
	for _, question_list := range question_lists {
		fmt.Printf("%-4d %-4d \t%s\n", question_list.QLID, question_list.QAID, question_list.ClassId)
	}

	return nil
}

// deleteQuestionList deletes a question/answer class pair from the database
func deleteQuestionList() error {
	// check the arguments
	args := os.Args[2:]
	if len(args) != 1 {
		return fmt.Errorf("one argument required: QL_ID")
	}

	// insert the data
	q := `DELETE FROM question_lists
                    WHERE ql_id = $1`
	result, err := db.Exec(q, args[0])
	if err != nil {
		return err
	}

	count, err := result.RowsAffected()
	if err != nil {
		return err
	}

	fmt.Printf("%d question list(s) deleted.\n", count)

	return nil
}

// createUser inserts a new user into the database
func createUser() error {
	// check the arguments
	args := os.Args[2:]
	if len(args) != 1 {
		return fmt.Errorf("one argument required: name")
	}
	// insert the data
	q := `INSERT INTO users (user_name)
                   VALUES ($1)`
	result, err := db.Exec(q, args[0])
	if err != nil {
		return err
	}
	count, err := result.RowsAffected()
	if err != nil {
		return err
	}
	fmt.Printf("%d user(s) created.\n", count)
	return nil
}

// listUsers displays a table of all the users in the database
func listUsers() error {
	// obtain the data
	q := `SELECT user_id, user_name
                FROM users`
	users := []user{}
	err := db.Select(&users, q)
	if err != nil {
		return err
	}

	// display the data
	fmt.Printf("ID   name\n")
	fmt.Printf("--------------------------------\n")
	for _, user := range users {
		fmt.Printf("%-4d %s\n", user.UserId, user.UserName)
	}

	return nil
}

// createClassList inserts a new class list into the database
func createClassList() error {
	// check the arguments
	args := os.Args[2:]
	if len(args) != 2 {
		return fmt.Errorf("two arguments required: class_id and user_id")
	}
	// insert the data
	q := `INSERT INTO class_lists (class_id, user_id)
                   VALUES ($1, $2)`
	result, err := db.Exec(q, args[0], args[1])
	if err != nil {
		return err
	}
	count, err := result.RowsAffected()
	if err != nil {
		return err
	}
	fmt.Printf("%d class list(s) created.\n", count)
	return nil
}

// listClassList displays a table of all the class lists in the database
func listClassList() error {
	// obtain the data
	q := `SELECT cl_id, class_id, user_id
                FROM class_lists`
	classLists := []classList{}
	err := db.Select(&classLists, q)
	if err != nil {
		return err
	}

	// display the data
	fmt.Printf("ID   class_id	user_id\n")
	fmt.Printf("--------------------------------\n")
	for _, classList := range classLists {
		fmt.Printf("%-4d %s \t%d\n", classList.CLID, classList.ClassId, classList.UserId)
	}

	return nil
}

// createStudentAnswer inserts a new student answer into the database
func createStudentAnswer() error {
	// check the arguments
	args := os.Args[2:]
	if len(args) != 3 {
		return fmt.Errorf("three arguments required: user_id, question_id, and answer_id")
	}
	// insert the data
	q := `INSERT INTO student_answers (user_id, question_id, answer_id)
                   VALUES ($1, $2, $3)`
	result, err := db.Exec(q, args[0], args[1], args[2])
	if err != nil {
		return err
	}
	count, err := result.RowsAffected()
	if err != nil {
		return err
	}
	fmt.Printf("%d student answers(s) created.\n", count)
	return nil
}

// listStudentAnswers displays a table of all the student answers in the database
func listStudentAnswers() error {
	// obtain the data
	q := `SELECT sa_id, user_id, question_id, answer_id
                FROM student_answers`
	studentAnswers := []studentAnswer{}
	err := db.Select(&studentAnswers, q)
	if err != nil {
		return err
	}

	// display the data
	fmt.Printf("ID   user_id	question_id	answer_id\n")
	fmt.Printf("--------------------------------------------------\n")
	for _, studentAnswer := range studentAnswers {
		fmt.Printf("%-4d \t%d \t%d \t\t%d\n", studentAnswer.SAID, studentAnswer.UserID, studentAnswer.QuestionId, studentAnswer.AnswerId)
	}

	return nil
}

// updateStudentAnswer changes a student answer in the database
func updateStudentAnswer() error {
	// check the arguments
	args := os.Args[2:]
	if len(args) != 2 {
		return fmt.Errorf("two arguments required: sa_id and answer_id")
	}
	// insert the data
	q := `UPDATE student_answers 
		SET answer_id = $1
                   Where sa_id = $2`
	result, err := db.Exec(q, args[1], args[0])
	if err != nil {
		return err
	}
	count, err := result.RowsAffected()
	if err != nil {
		return err
	}
	fmt.Printf("%d student answers(s) updated.\n", count)
	return nil
}
