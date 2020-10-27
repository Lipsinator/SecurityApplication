#! /bin/bash
#==============================================================
# simple security script
#==============================================================
# CHANGELOG
#==============================================================
# 26-10-2020 - starboard aan de praat en polaris scan werkende.
# 27-10-2020 - poaris scan schrijf logs nu naar eigen map en maakt file aan per deployment.
#
#
#
clear
echo -e "\e[32m================================="  
echo -e "+ Starting security application +"
echo -e "=================================\e[0m"
echo -e "\e[31mPlease note that in order for this application to work you need to be logged in on your OpenShift platform and have root access\e[0m"

# place the starboard binary in $PATH
sudo cp starboard /usr/local/bin

startStop="y"
while [[ $startStop == "y" ]]; do
	
	# get and write all the namespaces running on the platform to screen
	nameSpaces=`oc get namespaces | awk '{print $1, $8}' |  sed 1,1d`
	
	echo -e "\e[32mYour current namespaces: \e[0m"  
	while read line; do echo "$line"; done <<< "$nameSpaces"	
	
	# select and switch to a chosen namespace.
	read -p "Enter a namespace to see scannable deployments: " selectedNamespace
	oc project $selectedNamespace
	clear

	# list the deployments running in selected namespace and select one
	echo -e "\e[32mYour current deployments in $selectedNamespace: \e[0m" 
	oc get deployments | awk '{print $1, $8}' |  sed 1,1d

	read -p "Enter a deployment to initaite a polaris scan: " selectedDeployment
	
	# initiate polaris scan over chosen depoyment and write the logs to a file in the polarislogs dir
	starboard polaris deployment/$selectedDeployment --namespace $selectedNamespace & 
	touch polarislogs/$selectedNamespace$selectedDeployment.txt
	starboard get configaudit deployment/$selectedDeployment \
  	--namespace $selectedNamespace \
  	--output yaml > polarislogs/$selectedNamespace$selectedDeployment.txt
	echo -e "\e[32mThe result of the scan has been saved in the polarislogs folder\e[0m"

	# ask to start the sequence again
	read -s -p "Do you want to scan another namespace? [y/n]: " startStop
done

clear

echo -e "\e[31m================================="  
echo -e "+ Thank you for using this app  +"
echo -e "=================================\e[0m"




