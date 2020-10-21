sudo apt update
sudo apt install redis-server -y
echo -e "\n Running ubuntu? Please update the following: >supervised no< to >supervised systemd<"
read -p "(y/n)" INPUT
if [ "$INPUT" = "y" ]; then
  sudo vim /etc/redis/redis.conf 
else
	echo "Okay. Redis initialized without supervisor."
	sleep 1
fi