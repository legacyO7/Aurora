
# Aurora
[![MIT License](https://img.shields.io/badge/License-MIT-green.svg)](https://choosealicense.com/licenses/mit/)


Aurora is an alternate to Aura Sync for linux to control the keyboard backlights and charging threshold settings. This utility acts as an interface for the Faustus Kernel Module to achieve these functions.


![App Screenshot](https://github.com/legacyO7/Aurora/blob/stable/assets/images/snaps/arsrceen_1.png)


## Installation

Aurora comes with an AppImage release which can be opened on any common linux distros.
Find the latest release from [here](https://github.com/legacyO7/Aurora/releases).

#### Prerequisites

- [PolKit](https://en.wikipedia.org/wiki/Polkit) to obtain root privileges `pkexec`
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

- [Install Flutter SDK](https://docs.flutter.dev/get-started/install/linux)
- Install additional requirements 
`sudo apt-get install libgtk-3-0 libblkid1 liblzma5`
- Enable linux desktop
`flutter config --enable-linux-desktop`
- Run the project
`flutter run`
- Build the project
`flutter build linux`


## Limitations
- Although this utility comes with an AppImage, its functionality is only tested on debian/RHEL-based distros. Aurora will work out of the box if the prerequisites are satisfied
- Battery manager will not work on distros without systemd
 

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

