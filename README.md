# Gdnsd docker  

**Source repository** [gdnsd](https://github.com/gdnsd/gdnsd)  
**Docs** [wiki](https://github.com/gdnsd/gdnsd/wiki)  

*Current tags:* [`latest`](https://github.com/1it/docker_gdnsd/blob/master/Dockerfile), [`3.2.2`](https://github.com/1it/docker-gdnsd/blob/3.2.2/Dockerfile)

## Usage:  

Please, read wiki carefully this not a complete solution.  

Create directory and config files.  
`mkdir /etc/gdnsd`  
`touch /etc/gdnsd/config`  
`touch /etc/gdnsd/zones/example.com`  

If GeoIP functionality is needed, go to MaxMind [website](https://www.maxmind.com/en/geolite2/signup) and register to get Account ID and License Key.  

**docker-compose.yaml**  
```yaml
version: "2"

volumes:
  geoipdb:

services:
  geoipupdater:
    image: kefirgames/geoipupdate-cron:latest
    environment:
      - GeoIP_AccountID=12345
      - GeoIP_LicenseKey=keypassphrase
      - JOBS_LIST="* */12 * * * root /usr/bin/geoipupdate"
    volumes:
      - geoipdb:/usr/share/GeoIP

  gdnsd:
    image: kefirgames/gdnsd
    volumes:
      - /etc/gdnsd:/etc/gdnsd
      - geoipdb:/usr/share/GeoIP:ro
    ports:
      - "53:53/tcp"
      - "53:53/udp"
```  

