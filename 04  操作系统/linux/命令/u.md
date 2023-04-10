---
dg-publish: true
---
```toc
```
## udevadm

```bash
liuwh@liuwh-PC ~/Desktop> udevadm --help 
udevadm [--help] [--version] [--debug] COMMAND [COMMAND OPTIONS]

Send control commands or test the device manager.

Commands:
  info          Query sysfs or the udev database
  trigger       Request events from the kernel
  settle        Wait for pending udev events
  control       Control the udev daemon
  monitor       Listen to kernel and udev events
  test          Test an event run
  test-builtin  Test a built-in command

See the udevadm(8) man page for details.
```

### monitor
监控udev事件 usb设备插入,硬盘插入等....
```bash
liuwh@liuwh-PC /dev> udevadm monitor
monitor will print the received events for:
UDEV - the event which udev sends out after rule processing
KERNEL - the kernel uevent

KERNEL[114285.303105] remove   /devices/pci0000:00/0000:00:14.0/usb1/1-1/1-1:1.0/ttyUSB0/tty/ttyUSB0 (tty)
KERNEL[114285.303147] unbind   /devices/pci0000:00/0000:00:14.0/usb1/1-1/1-1:1.0/ttyUSB0 (usb-serial)
KERNEL[114285.303159] remove   /devices/pci0000:00/0000:00:14.0/usb1/1-1/1-1:1.0/ttyUSB0 (usb-serial)
KERNEL[114285.303177] unbind   /devices/pci0000:00/0000:00:14.0/usb1/1-1/1-1:1.0 (usb)
KERNEL[114285.303207] remove   /devices/pci0000:00/0000:00:14.0/usb1/1-1/1-1:1.0 (usb)
KERNEL[114285.303798] unbind   /devices/pci0000:00/0000:00:14.0/usb1/1-1 (usb)
KERNEL[114285.303849] remove   /devices/pci0000:00/0000:00:14.0/usb1/1-1 (usb)
UDEV  [114285.312239] remove   /devices/pci0000:00/0000:00:14.0/usb1/1-1/1-1:1.0/ttyUSB0/tty/ttyUSB0 (tty)
UDEV  [114285.313514] unbind   /devices/pci0000:00/0000:00:14.0/usb1/1-1/1-1:1.0/ttyUSB0 (usb-serial)
UDEV  [114285.315010] remove   /devices/pci0000:00/0000:00:14.0/usb1/1-1/1-1:1.0/ttyUSB0 (usb-serial)
UDEV  [114285.316009] unbind   /devices/pci0000:00/0000:00:14.0/usb1/1-1/1-1:1.0 (usb)
UDEV  [114285.318221] remove   /devices/pci0000:00/0000:00:14.0/usb1/1-1/1-1:1.0 (usb)
UDEV  [114285.319917] unbind   /devices/pci0000:00/0000:00:14.0/usb1/1-1 (usb)
UDEV  [114285.363130] remove   /devices/pci0000:00/0000:00:14.0/usb1/1-1 (usb)
KERNEL[114286.648918] add      /devices/pci0000:00/0000:00:14.0/usb1/1-1 (usb)
KERNEL[114286.651505] add      /devices/pci0000:00/0000:00:14.0/usb1/1-1/1-1:1.0 (usb)
KERNEL[114286.651572] add      /devices/pci0000:00/0000:00:14.0/usb1/1-1/1-1:1.0/ttyUSB0 (usb-serial)
KERNEL[114286.652244] add      /devices/pci0000:00/0000:00:14.0/usb1/1-1/1-1:1.0/ttyUSB0/tty/ttyUSB0 (tty)
KERNEL[114286.652288] bind     /devices/pci0000:00/0000:00:14.0/usb1/1-1/1-1:1.0/ttyUSB0 (usb-serial)
KERNEL[114286.652330] bind     /devices/pci0000:00/0000:00:14.0/usb1/1-1/1-1:1.0 (usb)
KERNEL[114286.652362] bind     /devices/pci0000:00/0000:00:14.0/usb1/1-1 (usb)
UDEV  [114286.885762] add      /devices/pci0000:00/0000:00:14.0/usb1/1-1 (usb)
UDEV  [114287.108581] add      /devices/pci0000:00/0000:00:14.0/usb1/1-1/1-1:1.0 (usb)
UDEV  [114287.114454] add      /devices/pci0000:00/0000:00:14.0/usb1/1-1/1-1:1.0/ttyUSB0 (usb-serial)
UDEV  [114287.130760] add      /devices/pci0000:00/0000:00:14.0/usb1/1-1/1-1:1.0/ttyUSB0/tty/ttyUSB0 (tty)
UDEV  [114287.132609] bind     /devices/pci0000:00/0000:00:14.0/usb1/1-1/1-1:1.0/ttyUSB0 (usb-serial)
UDEV  [114287.135383] bind     /devices/pci0000:00/0000:00:14.0/usb1/1-1/1-1:1.0 (usb)
UDEV  [114287.162218] bind     /devices/pci0000:00/0000:00:14.0/usb1/1-1 (usb)

```