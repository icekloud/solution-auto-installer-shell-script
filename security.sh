#! /bin/bash

function example()
{
	stat=$1
	
	#검사
	if [ $stat == "check" ]   
	then
		echo ""

	#수정
	elif [ $stat == "mod" ]
	then
		echo ""
	else
		echo "Error"
	fi
}



#U-01
function U-01()
{
	stat=$1
		
	if [ $stat == "check" ]
	then
		cnt1=$(cat /etc/securetty | grep pts | wc -l)
		cnt2=$(cat /etc/ssh/sshd_config | grep -x "PermitRootLogin no" | wc -l)

		echo -n "U-01 "
		
		if [ $cnt1 == 0 -a $cnt2 == 1 ]
		then
			echo "good"
		else
			echo "bad"
		fi

		
		
		

	elif [ $stat == "mod" ]
	then
		sed -i "s/pts/#pts/" /etc/securetty

		sed -i "s/#PermitRootLogin/PermitRootLogin/" /etc/ssh/sshd_config
		sed -i "s/PermitRootLogin yes/PermitRootLogin no/" /etc/ssh/sshd_config
	
	else
		echo "Error"
	fi
}

#U-01 check
#U-01 mod
#U-01 check

#U-02
function U-02()
{
	stat=$1
	
	if [ $stat == "check" ]
	then
		echo "N/A"
	
	elif [ $stat == "mod" ]
	then
		sed -i '/password    requisite/d' /etc/pam.d/system-auth
		sed -i '/password    sufficient/i\password    requisite     pam_cracklib.so retry=3 minlen=8 lcredit=-1 ucredit=-1 dcredit=-1 ocredit=-1' /etc/pam.d/system-auth
	
		sed -i '25s/99999/60/g' /etc/login.defs
		sed -i '26s/0/1/g' /etc/login.defs
		



	else
		echo "Error"
	fi
}

#U-03
function U-03()
{
	stat=$1
	
	if [ $stat == "check" ]
	then
		cnt1=$(cat /etc/pam.d/password-auth | grep -x "\/lib\/security\/pam_tally.so deny=5 unlock_time=120 no_magic_root" | wc -l)
			if [ $cnt1 == 0 ]
			then
				echo "bad"
			else
				echo "good"
			fi

	elif [ $stat == "mod" ]
	then
		sed -i '8a\auth        required      \/lib\/security\/pam_tally.so deny=5 unlock_time=120 no_magic_root' /etc/pam.d/password-auth
		sed -i '14a\account     required      \/lib\/security\/pam_tally.so no_magic_root reset' /etc/pam.d/password-auth

	else
		echo "Error"
	fi
}


#U-06
function U-06()
{
	stat=$1
	
	if [ $stat == "check" ]
	then
		echo "N/A"

	elif [ $stat == "mod" ]
	then
		find / -nouser -exec rm -rf {} \;
		find / -nogroup -exec rm -rf {} \;

		
	else
		echo "Error"
	fi
}

#U-09
function U-09()
{
	stat=$1
	
	if [ $stat == "check" ]
	then
		echo "N/A"

	elif [ $stat == "mod" ]
	then
		chown root /etc/hosts
		chmod 600 /etc/hosts

		
	else
		echo "Error"
	fi
}

#U-10
function U-10()
{
	stat=$1
	
	if [ $stat == "check" ]
	then
		echo "N/A"

	elif [ $stat == "mod" ]
	then
		find / -type f -perm -4000 -exec chmod g-s {} \;
		find / -type f -perm -2000 -exec chmod g-s {} \;

		
	else
		echo "Error"
	fi
}

#U-15
function U-15()
{
	stat=$1
	
	if [ $stat == "check" ]
	then
		echo "N/A"

	elif [ $stat == "mod" ]
	then
		find / -perm -2 -type f -ls -exec chmod o-w {} \;
		find / -perm -2 -type d -ls -exec chmod o-w {} \;

		
	else
		echo "Error"
	fi
}







#U-02 check
#U-02 mod
#U-02 check

echo "1) Security vulnerability check "
echo "2) Security vulnerability update "
echo " "
read input
	if [ $input == "1" ]
		then
			U-01 check
			U-02 check

			
			
	fi
