# Unofficial Home Assistant Add-ons: Ansible Vault

Ansible Vault bundled as an Home Assistant add-on.

## Installation

Follow these steps to get the add-on installed on your system:

1. Navigate in your Home Assistant frontend to __Supervisor -> Add-on Store__
2. Add this new repository by URL (`https://github.com/alex3305/home-assistant-addons`)
3. Find the "Ansible Vault" add-on and click it.
4. Click on the "INSTALL" button

## How to use

Ansible does not have an user interface and everything is done through a CLI. However using Ansible is quite straight forward once you get used to it.

### Installing Ansible locally

First you will need to install Ansible. The simplest way to install Ansible is through Python:

1. Install Python3:
    * **Windows** `winget install python`
    * **Ubuntu/Debian** `apt-get install python3`
    * **MacOS** `brew install python`
2. Install Pip3:
    * **Windows** _Included in Python package_
    * **Ubuntu/Debian** `apt-get install python3-pip`
    * **MacOS** _Included in Python package_
3. Install Ansible: `python3 -m pip install ansible`

> _**Note** You could also try Ansible within a Docker container_

After you have installed Ansible, the `ansible-vault` executable should be available on your system.

### Creating an encrypted secrets file

Creating an encrypted secrets with Ansible Vault seems hard, but it is actually fairly trivial. Just run the following command to create an encrypted version of your `secrets.yaml` file:

```bash
ansible-vault encrypt --output-file-encrypted_secrets.yaml secrets.yaml
``` 

After you have entered a password (which you can use with this add-on to decrypt your file), you should have a new and fairly unreadable `encrypted_secrets.yaml` file. The contents should be something like this:

```
$ANSIBLE_VAULT;1.1;AES256
32623862623464663435363237623233643261396130613764383233303337383264626430613332
6532306230313562616639636136313630373564346635390a633030646264643832303930646533
39386364633839343033636664653732613634666130303661313066643662623536643136373735
6630626339653362300a313536353030636464343564623533363462643864653231326536303362
65333733373835376238376635656438643961323666326333373531626436393231336238336166
30386230323464323231643962336463646530356334336265373133633031366236396335623234
393035326563343533383733336338313339
```

## Configuration

Example add-on configuration for Let's Encrypt with Cloudflare DNS proxy and dynamic configuration within your Home Assistant configuration directory:

```yaml
log_level: info
encrypted_file: /config/encrypted_secrets.yaml
output_file: /config/secrets.yaml
password: mySuP3RS3CR3Tp455W0RD1337!!
```

### Option `log_level` (required)

The log_level option controls the level of log output by the addon and can be changed to be more or less verbose, which might be useful when you are dealing with an unknown issue. Possible values are:

* `trace`: Show every detail, like all called internal functions.
* `debug`: Shows detailed debug information.
* `info`: Normal (usually) interesting events.
* `warning`: Exceptional occurrences that are not errors.
* `error`: Runtime errors that do not require immediate action.
* `fatal`: Something went terribly wrong. Add-on becomes unusable.

### Option `encrypted_file` (required)

This is the encrypted input file that is used by Ansible Vault to decrypt to. This file could be your encrypted secrets that you have stored in source control.

### Option `output_file` (required)

The output file that is created when Ansible Vault decrypts your `encrypted_file`. This output file could be your Home Assistant secrets file that you don't want in plain text in source control.

### Option `password` (optional)

The password that you want to use to decrypt your `encrypted_file` with.

> _**Note** Mutually exclusive with the option `password_file`_

### Option `password_file` (optional)

If you rather use a password file instead of a password, you can point this option to a file on the file system.

> _**Note** Mutually exclusive with the option `password`_
