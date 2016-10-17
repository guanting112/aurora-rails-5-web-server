#!/bin/bash

function run_script_init_system()
{
  setup_base
  setup_swap
}

function setup_base()
{
  echo "Update system locale" | shell_log
  sudo locale-gen zh_TW.UTF-8 en_US.UTF-8 | shell_message "locale-gen"
  export LC_ALL=en_US.UTF-8
  export LANGUAGE=en_US.UTF-8
  sudo update-locale LC_ALL=$LC_ALL LANGUAGE=$LANGUAGE | shell_message "update-locale"
  sudo dpkg-reconfigure locales | shell_message "reconfigure-locale"

  echo "Update timezone" | shell_log
  echo "Asia/Taipei" | sudo tee /etc/timezone > /dev/null
  sudo dpkg-reconfigure -f noninteractive tzdata 2>&1 | shell_message reconfigure-timezone

  echo "Update and upgrade system" | shell_log
  sudo apt-get -y update | shell_message update-system
  sudo apt-get -y upgrade | shell_message upgrade-system

  echo "Add HTTPS support to APT" | shell_log
  sudo apt-get install -y apt-transport-https ca-certificates | shell_message "apt-get/https-support"

  echo "Install toolkit" | shell_log
  sudo apt-get install -y vim git tmux htop bmon ncdu iptraf pwgen | shell_message "apt-get/toolkit-1"
  sudo apt-get install -y git-core curl libffi-dev zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev python-software-properties | shell_message "apt-get/toolkit-2"
  sudo apt-get install -y nodejs | shell_message "apt-get/nodejs"

  echo "Setting Host Name Server" | shell_log
  echo -e "nameserver 8.8.4.4\nnameserver 208.67.220.220" | sudo tee /etc/resolv.conf > /dev/null
}

function setup_swap()
{
  echo "Update /swap size" | shell_log

  sudo dd if=/dev/zero of=/swap bs=1M count=1024
  sudo mkswap /swap
  sudo swapon /swap
}

run_script_init_system