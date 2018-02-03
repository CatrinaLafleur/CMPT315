// Catrina Lafleur
// CMPT 315 Assignment 1
// Student response system (back end)
// Due: Tuesday Feb 6, 2018
//
// Connects to the database and handles the HTTP requests 

package main

import (
	"bytes"
	"fmt"
	"net/http"
	"os"
	
	"github.com/jmoiron/sqlx"
	"github.com/lib/pq"
)

var variable *bytes.Buffer = &bytes.Buffer{}

//Create the structures that mirror the database
type users struct {
	UserID int    `db:"user_id"`
	UserName string `db:"user_name"`
}

type classes struct {
	ClassId     string    `db:"class_id"`
	ClassName   string `db:"class_name"`
}

type questions struct {
	QuestionId     int    `db:"question_id"`
	QuestionText   string `db:"question_text"`
}

type answers struct {
	AnswerID     int    `db:"answer_id"`
	AnswerText   string `db:"answer_text"`
	IsCorrect   bool `db:"is_correct"`
}

type questionsAndAnswers struct {
	QAID     int    `db:"qa_id"`
	QuestionId     int    `db:"question_id"`
	AnswerID     int    `db:"answer_id"`
}

type questionLists struct {
	ClassId     string    `db:"class_id"`
	QAID     int    `db:"qa_id"`
}

type classLists struct {
	ClassId     string    `db:"class_id"`
	UserID int    `db:"user_id"`
}

type studentAnswers struct {
	UserID int    `db:"user_id"`
	QuestionId     int    `db:"question_id"`
	AnswerID     int    `db:"answer_id"`
}

func main() {
	db, err := connectToDB()
	if err != nil {
		fmt.Fprintf(os.Stderr, "cannot connect to database: %v\n", err)
		os.Exit(1)
	}

	if db == db {
	      fmt.Printf("hello")
	}
     	http.HandleFunc("/api/v1", handleHome)

	http.ListenAndServe(":8080", nil)
}

//Database connection string
func connectToDB() (*sqlx.DB, error) {
	return sqlx.Connect("postgres", "dbname=surveysystem user=catrina sslmode=disable")
}

//Ensures that the unique constraint on studentAnswers is upheld 
func isUniqueViolation(err error) bool {
	if err, ok := err.(*pq.Error); ok {
		return err.Code == "23505"
	}

	return false
}

//Temporary function to see that the localhost:8080 is working
func handleHome(w http.ResponseWriter, r *http.Request) {
	fmt.Printf("This is the home screen.")
}



