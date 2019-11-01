#!/bin/bash
/usr/bin/echo "00:17.0=" > /tmp/pcie_conf
/usr/bin/setpci -s "00:17.0" 3e.b >> /tmp/pcie_conf
/usr/bin/echo "02:00.0=" >> /tmp/pcie_conf
/usr/bin/setpci -s "02:00.0" 04.b >> /tmp/pcie_conf
/usr/bin/setpci -s "00:17.0" 3e.b=8
/usr/bin/echo "00:17.0=" >> /tmp/pcie_conf
/usr/bin/setpci -s "00:17.0" 3e.b >> /tmp/pcie_conf
