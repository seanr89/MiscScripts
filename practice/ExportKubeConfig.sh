#!/bin/bash
##
# BASH menu script that checks:
#   - Memory usage
#   - CPU load
#   - Number of TCP connections
#   - Kernel version
##
server_name=$(hostname)
function memory_check() {
    echo ""
	echo "Memory usage on ${server_name} is: "
	free -h
	echo ""
}
function updateConfig74() {
	echo ""
	echo "Updating Kube Config"
	echo ""
	export KUBECONFIG=/etc/kubernetes/admin.conf
	echo ""
}
function updateConfig57() {
	echo ""
	echo "Updating Kube Config"
	echo ""
	export KUBECONFIG=/etc/kubernetes/admin.conf
	echo ""
}

function function_name () {
	clear x
   	echo "Parameter #1 is $1"
   	# sleep for 9 seconds  
	sleep 2
	echo "done"
} 

##
# Color  Variables
##
red='\033[0;31m'
green='\033[0;32m'
blue='\033[0;34m'
clear='\033[0;37m'
##
# Color Functions
##
ColorGreen(){
	echo -ne $green$1$clear
}
ColorBlue(){
	echo -ne $blue$1$clear
}


menu(){
echo -ne "
My First Menu
$(ColorGreen '1)') Memory usage
$(ColorGreen '2)') Update 74
$(ColorGreen '3)') Argument Function
$(ColorGreen '0)') Exit
$(ColorBlue 'Choose an option:') "
        read a
        case $a in
	        1) memory_check ; menu ;;
			2) updateConfig74 ; menu ;;
	        3) function_name sean ; menu ;;
	        # 3) tcp_check ; menu ;;
	        # 4) kernel_check ; menu ;;
	        # 5) all_checks ; menu ;;
		0) exit 0 ;;
		*) echo -e $red"Wrong option."$clear; WrongCommand;;
        esac
}
# Call the menu function
menu