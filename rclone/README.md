# Unofficial Home Assistant Add-ons: Rclone

Rclone bundled as an Home Assistant add-on.

## About

Rclone ("rsync for cloud storage") is a command line program to sync files and directories to and from different cloud storage providers.

[Click here for the full Rclone documentation](https://rclone.org/docs/)

## Known issues and limitations

* You will have to manually create a rclone config

### Google Drive Root Folder ID

When creating a Google Drive remote you will have to specify the ID of the root folder. If you don't specify this value, the sync will fail. 

The root folder ID can easily be found after you have ran your `rclone config` step with `rclone ls [drive]:[path]` (of course replacing `[drive]` and `[path]` with your remote name and remote path respectively). This ID will than be filled in, in your `rclone.conf` file. 

## Final notes

This project is not affiliated with Rclone, the Rclone Maintainers Team or Nick Craig-Wood, but simply a community effort. Rclone itself is distributed under the [MIT License](https://rclone.org/licence/).
