# ใช้ base image ของ Go
FROM golang:1.21-alpine AS build
WORKDIR /assignment
COPY go.mod ./
RUN go mod tidy
COPY . .
RUN go build -o myapp ./main.go

FROM alpine:latest
COPY --from=build /assignment/myapp /assignment
CMD ["/assignment"]
EXPOSE 8080
