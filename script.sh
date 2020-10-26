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
echo -e "\e[32m================================="  
echo -e "+ Starting security application +"
echo -e "=================================\e[0m"
sudo cp starboard /usr/local/bin
echo -e "\e[31mPlease note that in order for this application to work you need to be logged in on your OpenShift platform and have root access\e[0m"
read -p "Do you want to continue? [y/n]: " yesOrNoVar


if [ $yesOrNoVar = 'y' ]
then
	oc get namespaces | awk '{print $1, $8}' |  sed 1,1d > namespaceslist.txt
	nameSpaceCount=$(wc -l namespaceslist.txt | cut -f1 -d' ')
	
	echo -e "\e[32mYour current namespaces: \e[0m"	
	
	for ((i = 0; i < nameSpaceCount; i++ ));
	do
		awk '{if(NR=='$i') print $0}' namespaceslist.txt		
	done

	read -p "Enter a namespace to see scannable deployments: " selectedNamespace
	
	oc project $selectedNamespace
	clear
	echo -e "\e[32mYour current deployments in $selectedNamespace: \e[0m" 
	oc get deployments | awk '{print $1, $8}' |  sed 1,1d

	read -p "Enter a deployment to initaite a polaris scan: " selectedDeployment
	
	starboard polaris deployment/$selectedDeployment --namespace $selectedNamespace & 
	starboard get configaudit deployment/$selectedDeployment \
  	--namespace $selectedNamespace \
  	--output yaml


	#starboard polaris deployment/nginx --namespace test
else	
	clear
	echo -e "\e[31m================================="  
	echo -e "+ Thank you for using this app  +"
	echo -e "=================================\e[0m"

fi




