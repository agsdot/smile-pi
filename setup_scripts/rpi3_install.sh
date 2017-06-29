#!/usr/bin/env bash

#https://www.cyberciti.biz/faq/howto-find-out-or-learn-harddisk-size-in-linux-or-unix/
#http://stackoverflow.com/questions/19703621/get-free-disk-space-with-df-to-just-display-free-space-in-kb
diskspace=$(sudo fdisk -l | grep "GiB" | awk '{print $3}' | tail -1)
setup_scripts_path="/home/pi/vagrant-archbox/setup_scripts/"

#http://xmodulo.com/create-dialog-boxes-interactive-shell-script.html
if (whiptail --title "Maximize Hard Drive Yes/No Box" --yes-button "Yes" --no-button "No"  --yesno "Does your ${diskspace} gb SD Card need to be resized / maximized?" 10 70) then
  clear
  echo ""
  echo ""
  echo ""
  echo "maximizeImageSize.sh will be run. It will increase the image size of your imaged SD card, partition and filesystem."
  echo ""
  echo "The script will cause a reboot of the system. Upon reboot, run the rpi3_script.sh once again and resume."
  echo ""
  echo ""
  bash "${setup_scripts_path}maximizeImageSize.sh"

else
  #echo "You chose M&M's. Exit status was $?."
  OPTIONS=$(whiptail --title "Edify SMILE Raspberry Pi Installation Kit" --checklist  "Select the script to run" 24 130 16 \
  "basic_setup.sh" "Install common utilities and programs needed, e.g. node, python, etc" OFF \
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

  setup_scripts_path="/home/pi/vagrant-archbox/setup_scripts/"

  if [ $exitstatus = 0 ]; then
    clear

    #http://unix.stackexchange.com/questions/146942/how-can-i-test-if-a-variable-is-empty-or-contains-only-spaces
    if [[ -z "${OPTIONS// }" ]]; then
      echo "No scripts were selected"
    else
      echo "The chosen scripts are:" $OPTIONS
      for script in ${OPTIONS[@]}; do
        #http://stackoverflow.com/questions/9733338/shell-script-remove-first-and-last-quote-from-a-variable
        script_name="${script%\"}"
        script_name="${script_name#\"}"
        bash "$setup_scripts_path$script_name"
      done
    fi
  else
    clear
    echo "You chose Cancel."
  fi

fi
