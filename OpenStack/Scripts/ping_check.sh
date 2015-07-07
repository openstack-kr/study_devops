
ping -c 1 -w 1 10.0.0.11 &> /dev/null
if [ "$?" == "0" ] ; then 
	echo "정상"
else
	echo "비정상"
fi 

while ! ping -c1 10.0.0.11 &>/dev/null; do :; done