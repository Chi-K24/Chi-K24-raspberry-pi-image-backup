# Troubleshooting

## The service says `inactive (dead)`

That is expected after a successful `Type=oneshot` service finishes. Check the exit result:

```bash
systemctl status rpi-image-backup.service --no-pager -l
```

Look for `status=0/SUCCESS`.

## View recent backup logs

```bash
sudo journalctl -u rpi-image-backup.service -n 100 --no-pager
```

## Check the next scheduled run

```bash
systemctl list-timers rpi-image-backup.timer
```

## The service says the backup mount is missing

Confirm that the expected device is mounted at the configured destination:

```bash
findmnt /mnt/backup
lsblk -o NAME,SIZE,FSTYPE,LABEL,MODEL,MOUNTPOINTS
```

Do not create the image inside an unmounted destination directory. That could fill the Pi's root filesystem.

## The wrong-device safety check failed

Compare the configured label link with the mounted source:

```bash
readlink -f /dev/disk/by-label/BACKUP
findmnt -rn -T /mnt/backup -o SOURCE
```

Update `/etc/rpi-image-backup.conf` only after confirming the correct physical disk.

## Containers did not restart

List all containers and inspect Docker logs:

```bash
sudo docker ps -a
sudo journalctl -u docker.service -n 100 --no-pager
```

The wrapper records the containers that were running at the beginning of the job and attempts to restart exactly that set when it exits.

## The image ran out of internal free space

The initial image needs spare root-filesystem capacity for later updates. Create a new image with more added space or use the upstream image utilities to safely enlarge the existing image. Never truncate or repartition the only backup copy without another verified restore point.
