# Unofficial Home Assistant Add-ons: Bitwarden secrets for Home Assistant

![Bitwarden Secrets for Home Assistant logo](logo.png)

Easily manage your Home Assistant secrets from Bitwarden.

## Installation

Follow these steps to get the add-on installed on your system:

1. Navigate in your Home Assistant frontend to __Supervisor -> Add-on Store__
2. Add this new repository by URL (`https://github.com/alex3305/home-assistant-addons`)
3. Find the "Bitwarden secrets for Home Assistant" add-on and click it.
4. Click on the "INSTALL" button

## How to use

You will need to have a Bitwarden account to use. It is also recommended that you use the [Bitwarden Add-on](https://github.com/hassio-addons/addon-bitwarden) for Home Assistant for easy local access to all your secrets.

> _**WARNING** Running this add-on will overwrite your `secrets.yaml` file and other secret files you retrieve from Bitwarden! Make a snapshot/backup of your Home Assistant configuration before proceeding._

> _See my personal [Bitwarden set up](https://alex3305.github.io/home-assistant-docs/add-ons/bitwarden/) for more information regarding the Bitwarden setup._

### Bitwarden management

For every **Login** item the _Username_ and _Password_ fields are leveraged into key-value pairs that are parsed into yaml. For instance:

| Item | Username | Password |
| ---- | -------- | -------- |
| My Super Secret API Key | some_api_key | 1Wp08FwDFa4aEP39 |
| MariaDB password | mariadb_password | this-is-my-database-password! |

is parsed into:

```yaml
# Home Assistant secrets file, managed by Bitwarden.

some_api_key: 1Wp08FwDFa4aEP39
mariadb_password: this-is-my-database-password!
```

> _**NOTE** YAML formatting still applies!_

Besides creating a `secrets.yaml` file, you can also easily manage secret files. For every for **Note** item in the Bitwarden vault, a secret file will be created from the _Name_ with the _Note contents_. For instance:

| Item | Note contents (partial) |
| ---- | ----------------------- |
| google_assistant_service_key.json | `{"type": "service_account","project_id": "my-google-assistant-project-1273"...` |

is parsed into `google_assistant_service_key.json` in your Home Assistant configuration directory with the contents:

```json
{
  "type": "service_account",
  "project_id": "my-google-assistant-project-1273",
  "private_key_id": "priv-key-id",
  "private_key": "-----BEGIN PRIVATE KEY-----\n[REDACTED]\n-----END PRIVATE KEY-----\n",
  "client_email": "homeassistant@my-google-assistant-project-1273.iam.gserviceaccount.com",
  "client_id": "13743492346842924234",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/my-google-assistant-project-1273.iam.gserviceaccount.com"
}
```

## Configuration

```yaml
log_level: info
bitwarden:
  server: 'http://a0d7b954-bitwarden'
  username: homeassistant@localhost.lan
  password: homeassistant
  organization: Home Assistant
repeat:
  active: false
  interval: 300
```

### Option `log_level` (required)

The `log_level` option controls the level of log output by the addon and can
be changed to be more or less verbose, which might be useful when you are
dealing with an unknown issue. Possible values are:

- `trace`: Show every detail, like all called internal functions.
- `debug`: Shows detailed debug information.
- `info`: Normal (usually) interesting events.
- `warning`: Exceptional occurrences that are not errors.
- `error`:  Runtime errors that do not require immediate action.
- `fatal`: Something went terribly wrong. Add-on becomes unusable.

Please note that each level automatically includes log messages from a
more severe level, e.g., `debug` also shows `info` messages. By default,
the `log_level` is set to `info`, which is the recommended setting unless
you are troubleshooting.

### Option `bitwarden.server` (required)

Bitwarden server. This defaults to the DNS name of the Bitwarden Home Assistand add-on, but can be changed to your liking.

### Option `bitwarden.username` (required)

The username to login to Bitwarden with.

### Option `bitwarden.password` (required)

The password to login to Bitwarden with. This can optinoally be changed to a secret value (ie. `!secret bitwarden_password`) after the first sync.

### Option `bitwarden.organization` (required)

The required organization that is used to retrieve your secret items.

### Option `repeat.enabled` (required)

When `true` this enables automatic refreshing of your secrets.

### Option `repeat.interval` (required)

Interval, in seconds, to refresh your secrets from Bitwarden.
