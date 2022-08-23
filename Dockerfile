# syntax=docker/dockerfile:1
FROM --platform=linux/amd64 golang:1.16-alpine
WORKDIR /app
COPY *.go ./
RUN go build -o greeter greeter.go
EXPOSE 8080
CMD ["./greeter"]