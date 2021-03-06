# Changelog

## 1.4.1

* 🐞 Properly return incorrect login (#20)
* 🐞 Improved `secret_file` configuration parameter within generation script (#21)

## 1.4.0

* 🆕 Additional check to ensure at least 1 secret is available before generating `secrets.yaml`. (#18)
* 📈 Updated Bitwarden CLI to 1.14.0
* ❗ This add-on will now start after Home Assistant
* ❗ Removed the deprecated `use_username_as_key` option

## 1.3.0

* 🆕 Do not replace `secrets.yaml` when nothing has changed
    * This will fix an issue when Home Assistant indicates that it couldn't find a secret
* 📈 Updated Bitwarden CLI to 1.13.3

## 1.2.1

* 📈 Updated Bitwarden CLI to 1.13.2

## 1.2.0

* 🆕 Added support for Bitwarden custom fields
    * Special characters (`[]{}#*!|>?:&,%@- `) will be replaced with an underscore
    * Repeated underscores will be replaced with a single occurrence
    * The custom field name will be converted to lowercase
* 🆕 Added support for Bitwarden URI's
* 🆕 Added more debug logging
* 🐞 Bugifx: Made `repeat.interval` optional in config.
* ❗ Deprecated `use_username_as_key`, this option will be removed in version 1.4.0.
