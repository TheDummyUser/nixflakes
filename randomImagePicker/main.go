package main

import (
	"crypto/rand"
	"log"
	"math/big"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
)

func main() {
	dirFolder := "/home/gabbar/Pictures/wall"
	files, err := os.ReadDir(dirFolder)
	if err != nil {
		log.Fatal(err)
	}

	// Filter: only image files, skip directories
	var imageFiles []os.DirEntry
	validExts := []string{".jpg", ".jpeg", ".png", ".webp"}

	for _, f := range files {
		if f.IsDir() {
			continue
		}
		ext := strings.ToLower(filepath.Ext(f.Name()))
		for _, v := range validExts {
			if ext == v {
				imageFiles = append(imageFiles, f)
				break
			}
		}
	}

	// No valid images found
	if len(imageFiles) == 0 {
		exec.Command("notify-send", "No image files found").Run()
		log.Fatal("No image files in the directory")
	}

	// Pick a random image
	maxIndex := big.NewInt(int64(len(imageFiles)))
	randomIndex, err := rand.Int(rand.Reader, maxIndex)
	if err != nil {
		log.Fatal(err)
	}
	selectedFile := imageFiles[randomIndex.Int64()].Name()
	selectedFilePath := filepath.Join(dirFolder, selectedFile)

	// Ensure swww daemon is running
	exec.Command("swww", "daemon").Run()

	// Set wallpaper
	cmd := exec.Command(
		"swww",
		"img",
		"--transition-type", "wipe",
		"--transition-step", "60",
		selectedFilePath,
	)

	if err := cmd.Run(); err != nil {
		log.Fatalf("Error running swww command: %v", err)
	}
}
