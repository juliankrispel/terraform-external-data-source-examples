package main

import (
	"encoding/json"
	"fmt"
)

type thing struct {
	Hello string
}

func main() {
	res, er := json.Marshal(thing{Hello: "world"})
	if er != nil {
		panic("cannot marshal json")
	}
	fmt.Println(string(res))
}
