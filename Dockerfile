FROM golang:1.19-alpine AS build
RUN apk add --no-cache git
COPY . /app
WORKDIR /app
RUN CGO_ENABLED=0 go build -ldflags="-s -w" -o /mtg
FROM scratch
COPY --from=build /mtg /mtg
COPY --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
ENTRYPOINT ["/mtg"]
