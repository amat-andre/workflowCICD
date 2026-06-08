FROM golang:1.25.6 AS builder
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download && go mod verify
COPY . ./
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o /parcel

FROM alpine
WORKDIR /app
COPY tracker.db /app/tracker.db
COPY --from=builder /parcel /app/parcel
CMD ["/app/parcel"]