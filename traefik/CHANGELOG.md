# Changelog

## 4.0.0

* Migrated to use S6 init system
* Added Hassio role / api access to remove an error from startup [hassio-addons/addon-base](https://github.com/hassio-addons/addon-base/issues/41)
* **[BREAKING]** converted log level to lowercase

## 3.2.0

* Removed Python dependency
* Replaced Jinja2 templates with Go templates
    * _This will reduce build speed significantly_
* Added support for all arch types (`armhf`, `armv7`, `amd64`, `aarch64`, `i386`)
* Added changelog

## 3.1.0

* Updated Traefik to 2.3.1

## 3.0.5

* **[BREAKING]** Added `letsencrypt.resolvers` as an option
    * This will let you decied which DNS resolvers that you want to use

## 3.0.4

* Merged PR [#12](https://github.com/alex3305/hassio-addons/pull/12) from [leakypixel](https://github.com/leakypixel)
    * Added custom DNS resolvers for LAN networks
    * Added `letsencrypt.delayBeforeCheck` option
* Merged PR [#11](https://github.com/alex3305/hassio-addons/pull/11) from [leakypixel](https://github.com/leakypixel)
    * Added Raspberry Pi (arm) support

## 3.0.3

* Updated Traefik to 2.2.11

## 3.0.2

* Updated Traefik to 2.2.5

## 3.0.1

* Reworked Treafik / Bashio logging

## 3.0.0

* Added Treafik dashboard support through Home Assistant Ingress

