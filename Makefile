run: environment
	docker run -it rua

environment:
	docker build -t rua .
