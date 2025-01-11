
IPv6-in-IPv4 tunnel in Docker container with random ipv6 outbound and expose http/socks5 proxy

## Usage
`Server_IPv4` & `Client_IPv6` can be found in [tunnelbroker](https://tunnelbroker.net/)

`proxy_protocol` support `http` and `socks5`
```
docker run -d \
    --privileged \
    --restart=unless-stopped \
    --name=6in4-tunnel \
    -e Server_IPv4="" \
    -e Client_IPv6="" \
    -e proxy_protocol="" \
    -p 8100:8100 \
    zenexas/6in4-tunnel
```
proxy server will be listening at port 8100

<br/><br/>
Lookup your outbound ipv6. For example:
````
curl -x socks5h://localhost:8100 ip.sb
````
````
curl -x http://localhost:8100 ip.sb
````

## Reference
- [vproxy](https://github.com/0x676e67/vproxy) - An easy and powerful Rust HTTP/Socks5 proxy that allows initiating network requests using IP binding calculated from CIDR addresses.
