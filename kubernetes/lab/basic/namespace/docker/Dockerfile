FROM alpine:3.8

# Copy files
COPY runtime.sh /
# Modify file permissions
RUN chmod +x runtime.sh

# Install curl
RUN cp /etc/apk/repositories /etc/apk/repositories.bak && \
    echo "http://mirrors.shu.edu.cn/alpine/v3.8/main/"      >  /etc/apk/repositories && \
    echo "http://mirrors.shu.edu.cn/alpine/v3.8/community/" >> /etc/apk/repositories && \
    apk add --no-cache ca-certificates && \
    update-ca-certificates && \
    apk add --no-cache --update curl bash


# Run script on startup
CMD [ "/runtime.sh" ]

