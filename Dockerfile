FROM alpine:latest
COPY test.sh ./
CMD ["sh", "test.sh"]
