# Restoration checklist

The backup produced by `image-backup` is a standard raw image containing the Raspberry Pi boot and root partitions.

## Before a failure

1. Run `image-check` against both partitions after creating the initial image.
2. Confirm scheduled updates complete successfully in the systemd journal.
3. Keep another copy on a separate physical device.
4. Perform a real restoration test with a spare drive.

## Restoring

> [!CAUTION]
> Writing an image destroys the existing contents of the selected target drive. Confirm the target model, capacity and device identity before proceeding.

1. Stop the failed Pi and disconnect its system drive.
2. Connect a replacement NVMe, SSD or microSD card to another computer.
3. Select the `.img` file in Raspberry Pi Imager, balenaEtcher or another trusted raw-image writer.
4. Select the replacement drive as the destination.
5. Re-check the target identity, then write the image.
6. Install the restored drive and boot the Pi.
7. Allow the automatic first-boot expansion and reboot to complete.
8. Verify networking, Docker containers, external mounts and application data.

External disks excluded from the system image must be restored or reconnected separately.

## Validate the stored image

When the image is not being updated, inspect both filesystems:

```bash
sudo image-check /path/to/backup.img W95
sudo image-check /path/to/backup.img Linux
```

A successful filesystem check is valuable, but only a test restoration proves that the complete recovery workflow works.
