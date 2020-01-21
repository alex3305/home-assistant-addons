# Community Hass.io Add-ons: Rclone (unofficial)

Rclone bundled as an Hass.io add-on.

## About

## Installation

Follow these steps to get the add-on installed on your system:

1. Navigate in your Home Assistant frontend to __Hass.io -> Add-on Store__
2. Add this new repository by URL (`https://github.com/alex3305/hassio-addons`)
3. Find the "Rclone" add-on and click it.
4. Click on the "INSTALL" button

## How to use

After installation you will need to generate a rclone configuration file. This can be done in several ways:

### Generate rclone config locally

1. Download the [latest release](https://rclone.org/downloads/) for your platform and extract the rclone binary
2. Run `rclone config`
3. Set up your remote
4. Copy the generated Rclone config to your Hass.io host

### Generate rclone config through a Docker container

1. Run `docker run --rm -it --entrypoint /bin/sh rclone/rclone`
2. Run `rclone --config /data/rclone.conf config`
3. Set up your remote
4. Run `cat /data/rclone.conf` and copy over the contents to your Hass.io host

> __Note__ For more information regarding Rclone config, please read the [Rclone documentation](https://rclone.org/docs/).

### Example Rclone configuration

```conf
[stack]
type = owncloud
url = https://some.owncloudhost.com/remote.php/webdav/
vendor = owncloud
user = hassio
pass = *** ENCRYPTED PASS ***
```

## Configuration

```json
{
  "configuration_path": "/share/rclone/rclone.conf",
  "remote": "owncloud",
  "remote_path": "/backups/",
  "local_retention_days": 45,
  "remote_retention_days": 15
}
```

### Option `configuration_path` (required)

Path to the Rclone configuration file. You can use the `/share/` or `/config/` directories for storing this file.

### Option `remote` (required)

Name of the remote to copy the Hass.io snapshots to.

### Option `remote_path` (required)

Path on the remote where the copied files should be stored. 

### Option `local_retention_days` (required)

The number of days the local files are kept. Files older than this date are pruned by this application. If for example the set value is 15, local files older than 15 days will be deleted.

> __Note__ This value should be higher than `remote_retention_days`.

### Option `remote_retention_days` (required)

The number of days the remote files are kept. Files older than this date are pruned by this application. If for example the set value is 15, remote files older than 15 days will be deleted.

## Known issues and limitations

* You will have to manually create rclone config
* Only a single remote is allowed

## Final notes

This project is not affiliated with Rclone, the Rclone Maintainers Team or Nick Craig-Wood, but simply a community effort. Rclone itself is distributed under the [MIT License](https://rclone.org/licence/).