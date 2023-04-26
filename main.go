/*
Copyright © 2023 Julian Easterling julian@julianscorner.com

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

	http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/
package main

import (
	"fmt"
	"os"
	"os/exec"
	"strings"
)

func main() {
	args := os.Args[1:]
	pwd, _ := os.Getwd()
	data := strings.ReplaceAll(fmt.Sprintf("%s:/data", pwd), "\\", "/")
	docker := []string{
		"run",
		"--rm",
		"-it",
	}

	for _, e := range os.Environ() {
		if strings.HasPrefix(e, "OPENSSL") {
			docker = append(docker, "-e")
			docker = append(docker, e)
		}
	}

	docker = append(docker, "-v")
	docker = append(docker, data)
	docker = append(docker, "dcjulian29/openssl:latest")
	docker = append(docker, args...)

	cmd := exec.Command("docker", docker...)
	cmd.Stderr = os.Stderr
	cmd.Stdin = os.Stdin
	cmd.Stdout = os.Stdout

	if err := cmd.Run(); err != nil {
		fmt.Printf("\033[1;31m%s\033[0m\n", err)
		os.Exit(1)
	}

	os.Exit(0)
}
