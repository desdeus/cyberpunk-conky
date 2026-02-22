## Arasaka Cyberdeck HUD - Conky Theme
An advanced, Cyberpunk 2077 inspired HUD for Linux desktops, optimized for high-resolution displays (2K/4K). This project simulates an Arasaka Cyberdeck interface with dynamic scaling and a fully parametric hardware configuration.

<img width="2560" height="1440" alt="ScreenShoot Desktop Cyberpunk" src="https://github.com/user-attachments/assets/6bea6c2d-af71-45d5-b056-7b0c2b739c39" />


To achieve the overall look of my desktop, I used: 
* **Theme and Colors**: https://github.com/Roboron3042/Cyberpunk-Neon
* **Cursors**: https://github.com/clayrisser/breeze-hacked-cursor-theme
* **Icons**: https://github.com/dreifacherspass/cyberpunk-technotronic-icon-theme
* **Wallpaper**: https://hdqwalls.com/wallpaper/2560x1440/cyberpunk-2077-minimal-dark-4k

## Technical Specifications
* **Tested Conky Version**: 1.19.6 (compiled 2024-04-01 for Linux x86_64).
* **Lua Engine**: Lua 5.3 (required for dynamic UI positioning and string parsing).
* **X.Org version**: 21.1.11
* **Compatibility**: Fully tested on Linux Mint and Ubuntu.

## Key Features
* **Dynamic Resolution Scaling**: Uses percentage-based logic to automatically position elements regardless of your exact screen resolution.
* **Parametric Configuration**: Change your hardware sensors, network interface, and timezone directly in the .conf file without touching the Lua logic.
* **Real-time Diagnostics**: Monitoring for CPU/System temperatures, GPU load, Disk I/O, and Network traffic.
* **Arasaka Visual Identity**: High-fidelity ASCII logo and custom-styled data boxes.
* **UTF-8 Precision Padding**: Custom Lua logic to ensure pixel-perfect box alignment, handling multi-byte characters like `°C` without breaking the borders.


## Inspiration
This project was inspired by the amazing work found on **r/unixporn**:
* [Conky inspired by Cyberpunk 2077 hack screen](https://www.reddit.com/r/unixporn/comments/1pi7bd7/conky_inspired_by_cyberpunk_2077_hack_screen/) by u/S_S_R_I.

## Documentation

The [GitHub Wiki](https://github.com/brndnmtthws/conky/wiki) is the central hub for all of Conky's documentation

## Dependencies

sudo apt update && sudo apt install conky-all lm-sensors neofetch upower lua5.3 fonts-firacode

# Core requirements
   - Conky-all 
   - lua5.3
   - lm-sensors
   - neofetch
   - upower
   - nvidia-smi 
   - fonts-firacode


## Installation

First and foremost we need to obtain the conky-all and lua5.3 package

  `sudo apt update && apt install conky-all lua5.3`

You can also visit GitHub's Conky Wiki for more [Installation options and information](https://github.com/brndnmtthws/conky/wiki/Installation)

Next, we need to install a few dependencies that did not come with our 'conky-all' package that we are going to need to get all these configs to run.


**Install & Configure lm-sensors**

Install  lm-sensors for info on hardware sensor info:

  `sudo apt install lm-sensors`

Configure Hardware Sensors
You must detect your system sensors for temperature monitoring to work:

 1. Run sudo sensors-detect.
 2. Answer YES to all prompts.
 3. Restart the kmod service or reboot your system.
 4. Test by running sensors in your terminal.
 5. Identify the Sensor Chip and Sensor Label for the CPU and Motherboard Temperature.
 6. Make String for Template 4 and 5
  
Example:
  
                                                                                                                                                                                                                   `sensors`                               
    `it8689-isa-0a40`
    `Adapter: ISA adapter`
    `in0:           1.16 V  (min =  +0.00 V, max =  +3.06 V)`
    `in1:           2.06 V  (min =  +0.00 V, max =  +3.06 V)`
    `in2:           2.02 V  (min =  +0.00 V, max =  +3.06 V)`
    `in3:           2.05 V  (min =  +0.00 V, max =  +3.06 V)`
    `in4:          36.00 mV (min =  +0.00 V, max =  +3.06 V)`
    `in5:         768.00 mV (min =  +0.00 V, max =  +3.06 V)`
    `in6:         672.00 mV (min =  +0.00 V, max =  +3.06 V)`
    `3VSB:          3.34 V  (min =  +0.00 V, max =  +6.12 V)`
    `Vbat:          3.10 V  `
    `fan1:        1171 RPM  (min =    0 RPM)`
    `fan2:         553 RPM  (min =    0 RPM)`
    `fan3:           0 RPM  (min =    0 RPM)`
    `fan4:           0 RPM  (min =    0 RPM)`
    `fan5:        2596 RPM  (min =    0 RPM)`
    `fan6:         620 RPM  (min =    0 RPM)`
    `temp1:        +29.0°C  (low  = +127.0°C, high = +127.0°C)`
    `temp2:        +38.0°C  (low  = +127.0°C, high = +127.0°C)`
    `temp3:        +34.0°C  (low  = +127.0°C, high = +127.0°C)`
    `temp4:        +34.0°C  (low  = +127.0°C, high = +127.0°C)`
    `temp5:        +35.0°C  (low  =  +0.0°C, high = -124.0°C) `
    `temp6:        +37.0°C  (low  = +127.0°C, high = +127.0°C)`


    `coretemp-isa-0000`
    `Adapter: ISA adapter`
    `Package id 0:  +34.0°C  (high = +80.0°C, crit = +100.0°C)`
    `Core 0:        +30.0°C  (high = +80.0°C, crit = +100.0°C)`
    `Core 4:        +30.0°C  (high = +80.0°C, crit = +100.0°C)`
    `Core 8:        +30.0°C  (high = +80.0°C, crit = +100.0°C)`
    `Core 12:       +32.0°C  (high = +80.0°C, crit = +100.0°C)`
    `Core 16:       +31.0°C  (high = +80.0°C, crit = +100.0°C)`
    `Core 20:       +31.0°C  (high = +80.0°C, crit = +100.0°C)`
    `Core 24:       +33.0°C  (high = +80.0°C, crit = +100.0°C)`
    `Core 28:       +30.0°C  (high = +80.0°C, crit = +100.0°C)`
    `Core 32:       +34.0°C  (high = +80.0°C, crit = +100.0°C)`
    `Core 33:       +34.0°C  (high = +80.0°C, crit = +100.0°C)`
    `Core 34:       +34.0°C  (high = +80.0°C, crit = +100.0°C)`
    `Core 35:       +34.0°C  (high = +80.0°C, crit = +100.0°C)`
    `Core 36:       +32.0°C  (high = +80.0°C, crit = +100.0°C)`
    `Core 37:       +31.0°C  (high = +80.0°C, crit = +100.0°C)`
    `Core 38:       +32.0°C  (high = +80.0°C, crit = +100.0°C)`
    `Core 39:       +32.0°C  (high = +80.0°C, crit = +100.0°C)`
    `Core 40:       +33.0°C  (high = +80.0°C, crit = +100.0°C)`
    `Core 41:       +33.0°C  (high = +80.0°C, crit = +100.0°C)`
    `Core 42:       +33.0°C  (high = +80.0°C, crit = +100.0°C)`
    `Core 43:       +33.0°C  (high = +80.0°C, crit = +100.0°C)`
    `Core 44:       +30.0°C  (high = +80.0°C, crit = +100.0°C)`
    `Core 45:       +31.0°C  (high = +80.0°C, crit = +100.0°C)`
    `Core 46:       +31.0°C  (high = +80.0°C, crit = +100.0°C)`
    `Core 47:       +31.0°C  (high = +80.0°C, crit = +100.0°C)`
    
For CPU Temperature Template 4, the String will be `coretemp-isa-0000|Package id 0`
For MD Temperature Template 5, the String will be `it8689-isa-0a40|temp1`

Note: It is essential to place a `|` between the chip name and the temperature label.

**Install & Configure upower**
 
Install upower for info on for battery info :

  `sudo apt install upower`

Configure upower Sensors
1. Run upower -e
2. Find your device
3. Run upower -i your device path

Note: The point 3 is a key for Template 7 
 
**Install GPU** 

Install tool for your gpu info :

*NVIDIA*:

`sudo apt install nvidia-smi`

Check nvidia-smi Sensors
1. Run nvidia-smi
2. Check your GPU Load 
3. Run nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits
4. Check if the value is equal at previous Load

*AMD*:

`sudo apt install radeontop`

Check radeontop Sensors
1. Run radeontop
2. Check your GPU Load 
3. Run radeontop -d - | head -n 1 | awk '{print $5}' | cut -d'%' -f1
4. Check if the value is equal at previous Load

*INTEL*: 

`sudo apt install intel-gpu-tools`

Check intel_gpu_top Sensors
1. Run intel_gpu_top
2. Check your GPU Load 
3. Run intel_gpu_top -s 1 | grep "Render/3D" | awk '{print $2}' | cut -d'%' -f1 
4. Check if the value is equal at previous Load

Note: For AMD/Intel, They are untested. The point 3 is a key for Template 6


**Install neofetch**
 
Install neofetch for info on for battery info :

  `sudo apt install neofetch`

Verify neofetch
1. Run neofetch
2. Check you device information

**Network Interface** 

To identify the network interface for the Template 2 the command is:

`ifconfig`

The result is list of Network inteface. If it starts with `e` it is usually an ethernet port; if it starts with `w` it is wireless. `lo' is the loopback ignore it.

    `enp5s0: flags=4099<UP,BROADCAST,MULTICAST>  mtu 1500
            ether 74:56:3c:b3:a1:67  txqueuelen 1000  (Ethernet)
            RX packets 0  bytes 0 (0.0 B)
            RX errors 0  dropped 0  overruns 0  frame 0
            TX packets 0  bytes 0 (0.0 B)
            TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

    lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
            inet 127.0.0.1  netmask 255.0.0.0
            inet6 ::1  prefixlen 128  scopeid 0x10<host>
            loop  txqueuelen 1000  (Loopback locale)
            RX packets 48988  bytes 4788329 (4.7 MB)
            RX errors 0  dropped 0  overruns 0  frame 0
            TX packets 48988  bytes 4788329 (4.7 MB)
            TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

    wlo1: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
            inet 192.168.68.51  netmask 255.255.252.0  broadcast 192.168.71.255
            inet6 fe80::7fc2:9723:d8bc:ef7c  prefixlen 64  scopeid 0x20<link>
            ether ac:19:8e:9e:41:43  txqueuelen 1000  (Ethernet)
            RX packets 434371  bytes 391709688 (391.7 MB)
            RX errors 0  dropped 150  overruns 0  frame 0
            TX packets 190042  bytes 61321786 (61.3 MB)
            TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0`

For Network Inteface Template 2, the String will be `wlo1` or `enp5s0`

**Timezone** 

To identify the time zone for the Template 3 the command is:

`timedatectl` 
The result is Time info including the Time Zone.
               Local time: dom 2026-02-22 19:10:11 CET
           Universal time: dom 2026-02-22 18:10:11 UTC
                 RTC time: dom 2026-02-22 18:10:11
                Time zone: Europe/Rome (CET, +0100)
System clock synchronized: yes
              NTP service: active
          RTC in local TZ: no

For Network Inteface Template 3, the String will be `Europe/Rome`


## Font Requirements

This HUD relies heavily on precise ASCII art alignment. You must use a Monospaced font.

Recommended: Fira Code (Tested).

Alternative: JetBrains Mono, Iosevka, or Cascadia Code.

Installation on Ubuntu/Mint:

  `sudo apt install fonts-firacode`

Note: If you change the font in Template 1, ensure the name matches exactly the one installed on your system (use fc-list to check).


## setup the Project
Clone or download this repository into your local directory:

1. Need set all of our conky files into a folder called `.conky` (The period indicates that this is a hidden file). 
    + If don't exisit Create a directory in your home folder 

      `sudo mkdir ~/.conky`
    
    - Note: [CTRL + h] toggles hidden files from view
  
2. Clone this repository:

    `git clone https://github.com/desdeus/cyberpunk-conky.git ~/.conky --depth 1`
   
    + Note: if you downlad file move folder `cyberpunk-conky` into your new `~/.conky` directory
    
      `mv ~/cyberpunk-conky/ ~/.conky/`
    
  
3. Included in this repo is a file named "start-cyberpunk-conky" which we need to issue a `chmod` command to in order to make it executable: 

      `chmod +x ~/.conky/cyberpunk-conky/start-cyberpunk-conky.sh`
         
4. Now conky can be started by issuing the command:
    
      `./start-cyberpunk-conky.sh`

7. Autorun at start:
   - Commands can be run at login by placing a launcher in the `~/.config/autostart` or by adding an entry to your 'Startup Applications' gui
    

## Configuration Guide

Personalizations are handled via the template system in cyberpunk-conky.conf:

| Template   | Description            | Example Value                                |
|------------|------------------------|----------------------------------------------|
| Template 1 | Primary UI Font        | Fira Code                                    |
| Template 2 | Network Interface      | wlo1 or eth0                                 |
| Template 3 | Timezone               | Europe/Rome                                  |
| Template 4 | CPU Sensor (Chip Label)| coretemp-isa-0000&#124Package id 0           |
| Template 5 | Sys Sensor (Chip Label)| it8689-isa-0a40&#124temp1"                   |
| Template 6 | GPU Monitoring Command | nvidia-smi --query-gpu=...                   |
| Template 7 | Power/Battery Path     | upower -i /org/freedesktop/UPower/devic...   | 

Note: The Lua engine is designed to handle standard shell syntax. You do not need to use special escaping for awk or grep commands in the config file.


## Acknowledgments & Inspiration
   - Thanks to CD Projekt for a magnificent game.
   - Thanks to Mike Pondsmith and R. Talsorian Games for giving us this magnificent universe.
   - Thanks to u/S_S_R_I. [Conky inspired by Cyberpunk 2077 hack screen](https://www.reddit.com/r/unixporn/comments/1pi7bd7/conky_inspired_by_cyberpunk_2077_hack_screen/) for inspiring me,
   - Thanks to Community Contributors to the developers and artists whose original ASCII designs and layouts inspired this version.
   - Thanks to [ascii-image-converter](https://github.com/TheZoraiz/ascii-image-converter) for allowing me to convert the Arasaka logo into ASCII Art
![Arasaka_2077](https://github.com/user-attachments/assets/4b1f2b74-9b2b-4a65-b20c-71b6ac40efa1)
   
## License
MIT License - Feel free to modify and share your own version of the Arasaka Cyberdeck!


