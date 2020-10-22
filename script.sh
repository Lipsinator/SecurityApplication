#! /bin/bash
#==============================================================
# security script
#==============================================================
# CHANGELOG
#==============================================================
# 21-10-2020 first check including selinux check enabled.
#
#
#
#
clear
echo -e "\e[32mStarting security application\e[0m"  

starboard polaris deployment/nginx --namespace test

starboard get configaudit deployment/nginx \
  --namespace dev \
  --output yaml


