FROM golang:1.21 AS builder

COPY ./ /app
WORKDIR /app

RUN go build -o gemini main.go
RUN mkdir -p /tmp/app
RUN cp gemini /tmp/app && chmod +x /tmp/app/gemini

FROM debian:bookworm-slim
COPY --from=builder /tmp/app /app
RUN useradd -u 3000 recv
RUN apt-get update -y && apt-get install -y ca-certificates && rm -rf /var/lib/apt/lists/* && update-ca-certificates

USER 3000
CMD ["/app/gemini"]
