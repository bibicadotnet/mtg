

FROM golang:1.19-alpine AS build

RUN apk --no-cache --update add \
    bash \
    ca-certificates \
    curl \
    git \
    make


COPY . /app
WORKDIR /app


RUN CGO_ENABLED=0 go build -ldflags="-s -w" -o mtg .


FROM scratch

ENTRYPOINT ["/mtg"]
CMD ["run", "/config.toml"]

COPY --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=build /app/mtg /mtg
COPY --from=build /app/example.config.toml /config.toml
