# Changelog

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

## 1.1.1

* 🆕 Added support for custom `secrets.yaml` location. This is espcially useful for testing and debugging.
* 🐞 Bugfix: Fixed upper to lower case conversion on field names
* 🐞 Bugfix: Prevent initial double Bitwarden check for login and Bitwarden sync
* Reworked logic inside the startup script, preparing for new functionality.

## 1.1.0

* 🆕 Added ability to use item names as secret keys after [community input](https://reddit.com/r/homeassistant/comments/jqw4gf/addon_release_bitwarden_secrets_for_home_assistant/?ref=share&ref_source=link)
    * Special characters (`[]{}#*!|>?:&,%@- `) will be replaced with an underscore
    * Repeated underscores will be replaced with a single occurrence
    * The item name will be converted to lowercase
* 🆕 For each username in an item, an entry will be created: `item_name_username`
* 🆕 For each password in an item, an entry will be created: `item_name_password`
* 🆕 Also retained the old functionality with a feature flag
* 🐞 Fix: Added single quotes to YAML values in `secrets.yaml`

## 1.0.3

* 🐞 Added missing sync action when updating passwords
    * Syncing Bitwarden CLI with your Bitwarden vault was not built-in thus not updating your secrets.
* 🐞 Slight optimization to Bitwarden CLI Docker image
* 🆕 Pinned version number of Bitwarden CLI

## 1.0.2

* 🐞 Fixed newlines within secret files

## 1.0.1

* 🆕 Added support for subdirectories with secret files

## 1.0.0

* 🆕 Initial release
