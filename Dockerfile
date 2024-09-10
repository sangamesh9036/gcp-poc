# A simple Dockerfile for testing
FROM alpine:latest
RUN echo "This is a test image" > /test.txt
CMD ["cat", "/test.txt"]
