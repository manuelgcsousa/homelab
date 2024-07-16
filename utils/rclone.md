# Rclone utils

## Example rclone config using 'jottacloud'
```conf
[jottacloud]
type = jottacloud
configVersion = 1
client_id = jottacli
client_secret = 
tokenURL = https://id.jottacloud.com/auth/realms/jottacloud/protocol/openid-connect/token
token = <INSERT_TOKEN>
device = 
mountpoint = 

[jottacloud-crypt]
type = crypt
remote = jottacloud:<INSERT_REMOTE_PATH>
password = <INSERT_PWD1>
password2 = <INSERT_PWD2>
```

## Mount remote drive
```bash
rclone mount \
  jottacloud-crypt: /mnt/.../jottacloud \
  --daemon
```

## Unmount remove drive
```bash
fusermount -u /mnt/.../jottacloud
```

## Clean remote drive's trash
```bash
rclone cleanup jottacloud-crypt:
```
