
# Aurora
[![MIT License](https://img.shields.io/badge/License-MIT-green.svg)](https://choosealicense.com/licenses/mit/)


Aurora is an alternate to Aura Sync for linux to control the keyboard backlight and charging threshold settings.This utility allows you to set battery charging threshold and control keyboard backlight color, brightness and modes.


Aurora provides two modes

- **Mainline** for kernel version 6.1 +
- **Faustus** for kernel version < 6.1

The modes will be auto-selected depending on the kernel version



## Installation

Aurora comes with an AppImage release which can be opened on any common linux distros.
Find the latest release from [here](https://github.com/legacyO7/Aurora/releases).


[PolKit](https://en.wikipedia.org/wiki/Polkit) is required to obtain root privileges



### Mainline Mode

![App Screenshot](https://github.com/legacyO7/Aurora/blob/stable/assets/images/snaps/arscreen_mainline_1.png)
This doesn't require any further configurations

### Faustus Mode

![App Screenshot](https://github.com/legacyO7/Aurora/blob/stable/assets/images/snaps/arsrceen_1.png)

#### Prerequisites

- [faustus module](https://github.com/hackbnw/faustus)
- If the module is not installed, `dkms openssl mokutil git make cmake` are required for installing the module

#### First Run
Aurora will direct you to the installation screen if the prerequisites are not satisfied on your system.

![App Screenshot](https://github.com/legacyO7/Aurora/blob/stable/assets/images/snaps/arsrceen_2.png)

Aurora also provides an option to choose the faustus module repo. If the device is compatible with the module but isn't supported officially, you can create your own fork that adds support to your device
(Read the [documentation](https://github.com/hackbnw/faustus) for more information on the process and any potential dangers.)
By default, Aurora uses [this fork](https://github.com/legacyO7/faustus.git) that adds support for "FA706IH"

![App Screenshot](https://github.com/legacyO7/Aurora/blob/stable/assets/images/snaps/arsrceen_3.png)

Secureboot enabled devices need to enroll MOK

## Build and Run

##### - Manual

- [Install Flutter SDK](https://docs.flutter.dev/get-started/install/linux)
- Install additional requirements
  `libgtk-3-0 libblkid1 liblzma5`
- Enable linux desktop
  `flutter config --enable-linux-desktop`
- Run the project
  `flutter run`
- Build the project
  `flutter build linux`



## Contributing

Contributions are always welcome!

Feel free to send a PR


## Authors

- [@legacyO7](https://www.github.com/legacyO7)

#### Quires
legacy07.git@gmail.com


## Credits

- [i3](https://github.com/i3) (i3-sensible-terminal)

- [hackbnw](https://github.com/hackbnw) (faustus module)

## Older Versions
- [TUF-Aurora](https://github.com/legacyO7/TUF-Aurora) (deprecated)

