#! /bin/bash


echo "----------------------------IP ADDRESS CHECK----------------------------"

hostname -I | cut -d' ' -f1



echo "------------------------------------INSTALL ------------------------------------"

CON1=$(yum -y install nfs-utils|tail -2)
echo $CON1
CON1=$(echo $CON1 | rev | cut -d' ' -f3 | rev)


echo "--------------------------------"

CON2=$(yum -y install ntp|tail -2)
echo $CON2
CON2=$(echo $CON2 | rev | cut -d' ' -f3 | rev)

echo "--------------------------------"

CON3=$(yum -y install sysstat*|tail -2)
echo $CON3
CON3=$(echo $CON3 | rev | cut -d' ' -f3 | rev)  

echo "--------------------------------------------------------------------------------"

echo "-------------------------------GET ENFORCE--------------------------------"


sed -i "s/SELINUX=enforcing/SELINUX=disabled/" /etc/sysconfig/selinux
sed -i "s/SELINUX=enforcing/SELINUX=disabled/" /etc/selinux/config

CON4=$(getenforce)
echo $CON4

echo "--------------------------------------------------------------------------------"


if [[ $CON1 == "Nothing" && $CON2 == "Nothing" && $CON3 == "Nothing" && $CON4 == "Disabled" ]]
then
	echo "OK TO GO"
	echo -n "Enter Y to install OFKSOLUTION, R to restart, else to cancle : "
	read input

	if [ $input == "Y" -o $input == "y" ]
	then
		echo "Really Ready? [y/n]"
		read input2

		if [ $input2 == "Y" -o $input2 == "y" ]
		then 


			echo "---------------------------OFKSOLUTION INSTALL-----------------------------"
			
			cd /home
			yum install -y https://repo.ius.io/ius-release-el7.rpm
			yum install -y python36u python36u-libs python36u-devel python36u-pip wget php
			pip3.6 install requests

			wget '회사 정보가 담긴 부분이라 제거하였습니다'


			python3.6 setup.py

			echo -e "\nEnter to DOCKER COMPOSE"
			read input

		
			echo -e "\n-----------------------------DOCKER COMPOSE---------------------------------"
			
			sed -i "s/\/home\/docker\/storage/\/home\/storage/" /home/docker/docker-compose.yml

			cp -a /home/docker/storage/* /home/storage
			echo "/home/docker/storage -> /home/storage"

			echo "Press Y to change database location, else to skip "
			read input

			if [ $input == Y -o $input == y ]
			then
				
				sed -i "s/\/home\/docker\/mysql_docker/\/home\/mysql\/data/" /home/docker/docker-compose.yml				
				mkdir -p /home/mysql/data
				mv /home/docker/mysql_docker/* /home/mysql/data
				echo "/home/docker/mysql_docker -> /home/mysql/data"
			fi

			echo -e "\n-------------------------DOCKER RESTART---------------------------"


			echo "Enter Y to restart DOCKER, else to cancel"
			read input

			if [ $input == Y -o $input == y ]
			then
				service docker restart
				php /home/docker/docker_start.php
				echo "docker restarted"

				systemctl enable iptables
				systemctl disable firewalld
				echo "iptables enabled, firewalld disabled"

				echo "Everything DONE!"

				echo "-------------------------------CHECK---------------------------------"
				while [ 1 == 1 ]
				do
					echo "1) getenforce"
					echo "2) partition"
					echo "3) docker-compose"
					echo "4) moved files"
					echo "Q) Quit"

					read input

					case $input in 
						"1") getenforce ;;
						"2") fdisk -l ; df -h ;;
						"3") vi /home/docker/docker-compose.yml ;;
						"4") echo "/home/storage" ; cd /home/storage ; ls ; echo "/home/mysql/data" ; cd /home/mysql/data ; ls ;;
						"Q" | "q") break ;;	
						
						
						*) echo "INVALID OPTION" ;;					

					esac

					echo -e "\nPress Enter to continue"
					read input
				done
					


			else
				echo "DOCKER RESTART CANCELED"
			fi		

		else
			echo "INSTALL CANCELED"
		fi
	
	elif [ $input == "R" -o $input == "r" ]
	then
		init 6

	else
		echo "INSTALL CANCELED"
	fi

else
echo -n "Enter R to restart, else to cancle : "
read input
	if [ $input == "R" -o $input == "r" ]
	then
		init 6

	else
		echo "INSTALL CANCELED"
	fi
fi


