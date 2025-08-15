package main

import (
	"crypto/rand"
	"log"
	"math/big"
	"os"
	"os/exec"
	"path/filepath"
)

func main() {
	dirFolder := "/home/gabbar/Pictures/wall"
	files, err := os.ReadDir(dirFolder)
	if err != nil {
		log.Fatal(err)
	}
	if len(files) == 0 {
		log.Fatal("No files in the directory")
	}
	maxIndex := big.NewInt(int64(len(files)))
	randomIndex, err := rand.Int(rand.Reader, maxIndex)
	if err != nil {
		log.Fatal(err)
	}
	selectedIndex := int(randomIndex.Int64())
	selectedFile := files[selectedIndex].Name()
	selectedFilePath := filepath.Join(dirFolder, selectedFile)
	cmd := exec.Command("swww", "img", selectedFilePath)

	if err := cmd.Run(); err != nil {
		log.Fatalf("Error running swww command: %v", err)
	}
}
