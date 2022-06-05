# pihole

## Fresh Git Config

> git config --global user.name "Rene Fibus"

> git config --global user.email "youremail@yourdomain.com"

## Environment Variables

[Check source readme](https://raw.githubusercontent.com/pi-hole/docker-pi-hole/master/README.md)
| Variable | Default | Value | Description |
| -------- | ------- | ----- | ---------- |
| `TZ` | UTC | `<Timezone>` | Set your [timezone](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones) to make sure logs rotate at local midnight instead of at UTC midnight.
| `WEBPASSWORD` | random | `<Admin password>` | http://pi.hole/admin password. Run `docker logs pihole \| grep random` to find your random pass.
| `FTLCONF_REPLY_ADDR4` | unset | `<Host's IP>` | Set to your server's LAN IP, used by web block modes and lighttpd bind address.
