# Unofficial Home Assistant Add-ons: Bitwarden secrets for Home Assistant

Easily manage your Home Assistant secrets from Bitwarden.

## Installation

Follow these steps to get the add-on installed on your system:

1. Navigate in your Home Assistant frontend to __Supervisor -> Add-on Store__
2. Add this new repository by URL (`https://github.com/alex3305/hassio-addons`)
3. Find the "Bitwarden secrets for Home Assistant" add-on and click it.
4. Click on the "INSTALL" button

## How to use

You will need to have a Bitwarden account to use. It is also recommended that you use the [Bitwarden Add-on](https://github.com/hassio-addons/addon-bitwarden) for Home Assistant for easy local access to all your secrets.

When you use a local Bitwarden installation you can also create a local Bitwarden user to use with Home Assistant. You can than share items through a (required) organization. This is easier and also safer than sharing your personal credentials with Home Assistant.

### Bitwarden management

For every **Login** item the Username and Password are leveraged into key-value pairs that are parsed into yaml. For instance:

| Item | Username | Password |
| ---- | -------- | -------- |
| My Super Secret API Key | some_api_key | 1Wp08FwDFa4aEP39 |

is parsed into:

```yaml
# Home Assistant secrets file, managed by Bitwarden.

some_api_key: 1Wp08FwDFa4aEP39
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
