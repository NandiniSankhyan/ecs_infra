package main

import (
	"fmt"
	"net/http"
	"os"
	"os/user"
	"math/rand"
	"time"
	"log"

)

func main() {
	finish := make(chan bool)
	path, err := os.Getwd()
	if err != nil {
		log.Println(err)
	}
	user, err := user.Current()
	if err != nil {
		log.Fatalf(err.Error())
	}

	username := user.Username

	fmt.Printf("Username: %s\n", username)
	fmt.Println(path)
	fmt.Println("Hivemind's Go Greeter")
	rand.Seed(time.Now().UnixNano())
	stri:= RandomString(6)
	os.Setenv("HELLO_TAG", stri)
	fmt.Println("You are running the service with this tag: ", os.Getenv("HELLO_TAG"))	
	server8080 := http.NewServeMux()
	server8080.HandleFunc("/", HelloServer)
	server8080.HandleFunc("/param", NameServer)


	go func() {
		http.ListenAndServe(":8080", server8080)
	}()

	<-finish
}

func RandomString(n int) string {
    var letters = []rune("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
 
    s := make([]rune, n)
    for i := range s {
        s[i] = letters[rand.Intn(len(letters))]
    }
    return string(s)
}

func HelloServer(w http.ResponseWriter, r *http.Request) {
	fmtStr := fmt.Sprintf("Hello, %s! I'm %s", GetIPFromRequest(r), os.Getenv("HOSTNAME"))
	fmt.Println(fmtStr)
	fmt.Fprintln(w, fmtStr)
}

func GetIPFromRequest(r *http.Request) string {
	if fwd := r.Header.Get("x-forwarded-for"); fwd != "" {
		return fwd
	}

	return r.RemoteAddr
}

func NameServer(w http.ResponseWriter, req *http.Request) {
	v := req.FormValue("name")
	fmt.Fprintln(w, "Your name is: "+v)
}


// http://localhost:8080/
// http://localhost:8080/param?name=nandini