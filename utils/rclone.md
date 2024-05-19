# Utils

## Mount remote drive
```bash
rclone mount \
  jottacloud-crypt: /mnt/ssd1/ENTRYPOINT/usr/remote/jottacloud \
  --daemon
```

## Unmount remove drive
```bash
fusermount -u /mnt/ssd1/ENTRYPOINT/usr/remote/jottacloud
```

## Clean remote drive's trash
```bash
rclone cleanup jottacloud-crypt:
```
