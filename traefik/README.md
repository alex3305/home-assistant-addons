# Unofficial Home Assistant Add-ons: Traefik

Traefik bundled as an Home Assistant add-on.

## About

Traefik is a modern HTTP reverse proxy and load balancer that makes deploying microservices easy. This add-on provides dynamic Traefik configuration based on files.

[Click here for the full Treafik documentation](https://docs.traefik.io/)

## Known issues and limitations

* Default port 80 can conflict with other ports
* Special characters such as spaces must be escaped within environment variables

## DNS Challenge specific options
* delayBeforeCheck - by default, the provider will verify the TXT DNS challenge
  record before letting ACME verify. If delayBeforeCheck is greater than zero,
  this check is delayed for the configured duration in seconds. Useful if
  internal networks block external DNS queries. For more information, check the
  [traefik documentation](https://docs.traefik.io/https/acme/#dnschallenge).
* resolvers - manually set the DNS servers to use when performing the
  verification step. Useful for situations where internal DNS does not resolve
  to the same addresses as the public internet (e.g. on a LAN using a FQDN as
  part of hostnames). For more information, see
  [here](https://docs.traefik.io/https/acme/#resolvers).

## Final notes

This project is not affiliated with Traefik, the Traefik Maintainer Team or Containous, but simply a community effort. Traefik itself is distributed under the [MIT License](https://github.com/containous/traefik/blob/master/LICENSE.md).
