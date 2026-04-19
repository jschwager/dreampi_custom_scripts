#!/bin/bash
# Script name: DCNET ON/OFF Script for DreamPi
# Original author: scrivanidc
# Updated and maintained by: jschwager (onlycodered)

# Updated 2025-09-15
ACTION=$1

if [ "$ACTION" = "enable" ]; then
  option="1"
elif [ "$ACTION" = "disable" ]; then
  option="2"
else
  echo "DCNET Server ON/OFF Script Switch"
  echo ""
  echo "Choose option number"
  echo "1. DCNET Script ON"
  echo "2. DCNET Script OFF (Standard DreamPi)"
  echo "3. Delete DCNET Files"
  read -p "Type 1, 2 or 3 and press Enter: " option
fi

cd /home/pi/dreampi/
echo ""
check_dcnet_files() {
  if [ ! -f "dreampi_dcnet.py" ]; then
    echo "dreampi_dcnet.py backup and dcnet.rpi does not exist. Downloading..."
    echo ">>"
    wget -q --show-progress -O dreampi_dcnet.py https://github.com/scrivanidc/dreampi_custom_scripts/raw/main/DCNET_V2/dreampi_dcnet.py
    wget -q --show-progress -O dcnet.rpi https://github.com/scrivanidc/dreampi_custom_scripts/raw/main/DCNET_V2/dcnet.rpi
    #wget -q --show-progress -O dcnet.rpi https://github.com/flyinghead/flycast/raw/refs/heads/dev/tools/dreampi/dcnet.rpi
    chmod +x dreampi_dcnet.py dcnet.rpi
  else
    echo "dreampi_dcnet.py and dcnet.rpi exists. OK."
    echo ">>"
  fi
}

check_standard_backup() {
  if [ ! -f "dreampi_standard.py" ]; then
    echo "dreampi_standard.py backup does not exist. Creating..."
    cp dreampi.py dreampi_standard.py
    cp dreampi.py dreampi_standard2.py
  else
    echo "dreampi_standard.py backup exists. OK."
    echo ">>"
  fi
}

copy_dcnet_script() {
  cp dreampi_dcnet.py dreampi.py
  echo "dreampi_dcnet.py copied to dreampi.py"
  echo ">>"
}

copy_standard_script() {
  cp dreampi_standard.py dreampi.py
  echo "dreampi_standard.py copied to dreampi.py"
  echo ">>"
}

delete_dcnet_files() {
  copy_standard_script
  rm dreampi_dcnet.py dcnet.rpi
  echo "Deleting DCNET files: dreampi_dcnet.py and dcnet.rpi"
  echo "You're now able to download DCNET updated files at option 1"
  echo ">>"
}

check_standard_backup
check_dcnet_files

if [ "$option" -eq 1 ]; then
  copy_dcnet_script
  echo "Done. DCNET Script ON (Standard DreamPi Script disabled)"
elif [ "$option" -eq 2 ]; then
  copy_standard_script
  echo "Done. DCNET Script OFF (Standard DreamPi Script enabled)"
elif [ "$option" -eq 3 ]; then
  delete_dcnet_files 
  echo "Done. DCNET files deleted"
else
  echo "Invalid option. Please choose 1, 2 or 3."
fi

echo ">>"
echo "Restarting RaspberryPi, ready to dial soon"
sleep 5
sudo reboot &