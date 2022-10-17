
# Aurora
[![MIT License](https://img.shields.io/badge/License-MIT-green.svg)](https://choosealicense.com/licenses/mit/)


Aurora is a simple tool that controls the keyboard lighting and charging threshold settings. This utility acts as an interface for the Faustus Kernel Module to achieve these functions.


![App Screenshot](https://github.com/legacyO7/Aurora/blob/canary/assets/images/snaps/arsrceen_1.png)


## Installation

Aurora comes with an AppImage release which can be opened on any linux distros.
Here you can find the most recent release.

#### Post Installation
Aurora will direct you to the installation screen if the module is not already installed on your system.

![App Screenshot](https://github.com/legacyO7/Aurora/blob/canary/assets/images/snaps/arsrceen_2.png)

Aurora also provides an option to choose the faustus module repo. If the device is compatible with the module but isn't supported officially, you can create yourown fork that adds support to the device
(Read the [documentation](https://github.com/hackbnw/faustus) for more information on the process and any potential dangers.)
By default, Aurora uses [this fork](https://github.com/legacyO7/faustus.git) that adds support for "FA706IH"

![App Screenshot](https://github.com/legacyO7/Aurora/blob/canary/assets/images/snaps/arsrceen_3.png)

Secureboot enabled devices need to enroll MOK

## Build and Run 

##### - Automated [WIP]


##### - Manual

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
- Although this utility comes with an AppImage, its functionality is only tested on debian-based distros. Aurora will work out of the box if the module supports the device and is installed manually
- Battery manager will not work on distros without systemd
- Aurora installer is an experimental feature. If the installer fails, install the packages and module manually
 

## Contributing

Contributions are always welcome!

Feel free to send a PR


## Authors

- [@legacyO7](https://www.github.com/legacyO7)


## Credits

- [i3](https://github.com/i3) (i3-sensible-terminal)

- [hackbnw](https://github.com/hackbnw) (faustus module)

