FROM alpine:3.20
RUN apk add --no-cache bash curl jq
COPY pipe /pipe
COPY LICENSE pipe.yml README.md /
ENTRYPOINT ["bash", "/pipe/pipe.sh"]
