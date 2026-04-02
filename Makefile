.PHONY: build build-ctf build-ai build-cpp build-python build-go build-binary-analysis \
        ctf ai cpp python go binary-analysis \
        stop clean help

## build: Build all development environment images
build:
	docker compose build

## build-ctf: Build the CTF image only
build-ctf:
	docker compose build ctf

## build-ai: Build the AI coding image only
build-ai:
	docker compose build ai-coding

## build-cpp: Build the C++ image only
build-cpp:
	docker compose build cpp

## build-python: Build the Python image only
build-python:
	docker compose build python

## build-go: Build the Go image only
build-go:
	docker compose build go

## build-binary-analysis: Build the binary analysis image only
build-binary-analysis:
	docker compose build binary-analysis

## ctf: Enter the CTF environment shell
ctf:
	docker compose run --rm ctf

## ai: Start the AI coding environment (Jupyter at http://localhost:8888)
ai:
	docker compose up ai-coding

## cpp: Enter the C++ development environment shell
cpp:
	docker compose run --rm cpp

## python: Enter the Python development environment shell
python:
	docker compose run --rm python

## go: Enter the Go development environment shell
go:
	docker compose run --rm go

## binary-analysis: Enter the binary analysis environment shell
binary-analysis:
	docker compose run --rm binary-analysis

## stop: Stop all running containers
stop:
	docker compose down

## clean: Remove all containers, images, and volumes for this project
clean:
	docker compose down --rmi local --volumes --remove-orphans

## help: Show this help message
help:
	@grep -E '^## ' Makefile | sed 's/## //'
