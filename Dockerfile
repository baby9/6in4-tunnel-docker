FROM alpine

COPY entrypoint.sh /

RUN true && \
    apk add --no-cache iproute2 procps bash curl && \
    echo "net.ipv6.conf.all.disable_ipv6 = 0" >> /etc/sysctl.conf && \
    wget https://github.com/0x676e67/vproxy/releases/download/v0.3.1/vproxy-0.3.1-x86_64-unknown-linux-musl.tar.gz -O vproxy.tar.gz && \
    tar zxvf vproxy.tar.gz -C / && \
    rm -rf vproxy.tar.gz && \
    chmod +x /vproxy /entrypoint.sh

HEALTHCHECK --interval=90s --timeout=15s --retries=2 --start-period=120s \
	CMD curl -fsL 'http://edge.microsoft.com/captiveportal/generate_204' --interface 6in4-tunnel

EXPOSE 8100
ENTRYPOINT [ "/bin/bash", "/entrypoint.sh" ]
