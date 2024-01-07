#!/bin/bash

# Architecture
arch=$(uname -a)

# CPU Physical
cpup=$(grep -c "physical id" /proc/cpuinfo)

# CPU Virtual
cpuv=$(grep -c "processor" /proc/cpuinfo)

# RAM
ram_total=$(free --mega | awk '$1 == "Mem:" {print $2}')
ram_use=$(free --mega | awk '$1 == "Mem:" {print $3}')
ram_percent=$(free --mega | awk '$1 == "Mem:" {printf("%.2f", $3/$2*100)}')

# Disk
disk_total=$(df -m | grep -v "tmpfs" | grep -v "udev" | awk '{disk_t += $2} END {printf ("%d", disk_t/1024)}')
disk_use=$(df -m | grep -v "tmpfs" | grep -v "udev" | awk '{disk_u += $3} END {print disk_u}')
disk_percent=$(df -m | grep -v "tmpfs" | grep -v "udev" | awk '{disk_t += $2; disk_u += $3} END {printf("%d", disk_u/disk_t*100)}')

# CPU Load
cpu_load=$(vmstat 1 2 | tail -1 | awk '{printf ("%.1f", 100 - $15)}')

# Last Boot
last_boot=$(who -b | awk '{print $3, $4}')

# LVM Usage
is_using_lvm=$(if [ $(lsblk | grep -c "lvm") -gt 0 ]; then echo yes; else echo no; fi)

# Active TCP Connections
tcp_connections=$(ss -ta | grep -c "ESTAB")

# Number of users
user_num=$(users | wc -w)

# IP Address
ip=$(hostname -I)

# MAC Address
mac=$(ip link | grep "link/ether" | awk '{print $2}')

# Number of SUDO commands executed
sudo_num=$(journalctl _COMM=sudo | grep -c "COMMAND")

wall "	#Architecture: $arch
	#CPU physical : $cpup
	#vCPU : $cpuv
	#Memory Usage: $ram_use/$ram_total$(echo "MB") ($ram_percent%)
	#Disk Usage: $disk_use/$disk_total$(echo "Gb") ($disk_percent%)
	#CPU load: $cpu_load%
	#Last boot: $last_boot
	#LVM use: $is_using_lvm
	#TCP Connections : $tcp_connections ESTABLISHED
	#User log: $user_num
	#Network: IP $ip ($mac)
	#Sudo : $sudo_num cmd"
