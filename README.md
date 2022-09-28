# SoapUI OS for Flatpak

Unofficial SoapUI Open Source Flatpak package.

<a href='https://flathub.org/apps/details/org.soapui.SoapUI'><img width='120' alt='Download on Flathub' src='https://flathub.org/assets/badges/flathub-badge-en.png'/></a>

Waiting for [official response](https://github.com/SmartBear/soapui/issues/744) in order to give them the control of this repository.

## Permissions

- GUI: x11,ipc,dri
- Network (to allow perfonming the actual tests)
- Documents folder (to load and save project files)

## Known issues

Currently accessing to external web pages is not working due to this [external issue](https://github.com/flathub/org.freedesktop.Sdk.Extension.openjdk17/issues/1).

## Special configurations and workarrounds

Since the application folder is readonly it has been enabled the following paths have been set:

- User external actions: `~/.var/app/org.soapui.SoapUI/.soapuios/actions/`
- User external extensions: `~/.var/app/org.soapui.SoapUI/.soapuios/ext/`
- User external listeners: `~/.var/app/org.soapui.SoapUI/.soapuios/listeners/`
- User plugins: `~/.var/app/org.soapui.SoapUI/.soapuios/plugins/`
- User properties: `~/.var/app/org.soapui.SoapUI/.soapuios/soapui.properties`

This variables has been set by coping the functionality of the `soapui.sh` into the `soapui-launcher.sh` (in this repository) since the former don't allow us to change the `JAVA_OPTS`.

Also since SoapUI is using the root of the home folder to store some configuration files (`soapui-settings.xml` and `default-soapui-workspace.xml`), the launcher (if they don't already exist) symlinks them into the `.soapuios` folder so that the settings can be persisted.
