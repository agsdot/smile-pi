#!/usr/bin/env bash

OPTIONS=$(whiptail --title "Stanford GSE-IT Raspberry Pi Installation Kit" --checklist  "Select the script to run" 24 130 16 \
"maximizeImageSize.sh" "Increase image size of freshly imaged SD card, partition and filesystem." OFF \
"basic_setup.sh" "Install common utilities and programs needed across the board, e.g. node, python, etc" OFF \
"smile_setup.sh" "Install and implement Smile, including scripts to autostart services" OFF \
"kiwix_wikipedia_setup.sh" "Install wikipedia" OFF \
"kalite_setup.sh" "Install khan academy lite" OFF \
"ck12_setup.sh" "Install CK12 textbooks" OFF \
"app_programming_setup.sh" "Install code-monster and snap" OFF \
"soe_setup.sh" "Install Seeds of Empowerment children books" OFF \
"portal_page_setup.sh" "Setup the smile plug portal page, configure nginx and links properly" OFF \
"sensehat_setup.sh" "Setup if sensehat LED is attached, reboot required" OFF \
"update_ap.sh" "Update the wireless access point name, e.g. SMILE_12AS" OFF \
"update_portal.sh" "Update the smile portal page, refresh what the network id of the smile device is" OFF \
"update_smile.sh" "Update smile subsystems" OFF 3>&1 1>&2 2>&3)

exitstatus=$?

setup_scripts_path="/home/alarm/vagrant-archbox/setup_scripts/"
if [ $exitstatus = 0 ]; then
  echo "The chosen scripts are:" $OPTIONS

  if [[ -z "${OPTIONS// }" ]]; then
    echo "No scripts were selected"
  else
    for script in ${OPTIONS[@]}; do
      #http://stackoverflow.com/questions/9733338/shell-script-remove-first-and-last-quote-from-a-variable
      script_name="${script%\"}"
      script_name="${script_name#\"}"
      bash "$setup_scripts_path$script_name"
    done
  fi
else
  echo "You chose Cancel."
fi
