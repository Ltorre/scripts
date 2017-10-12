#!/usr/bin/env bash
set -e


echo -e "Wanna plan ? ( \e[93myes / \e[91mno \e[0m ) "
read answer

if echo "$answer" | grep -iq "^yes$" ;then
	terraform plan
fi


echo -e "Want to create a graph ? [Stored in ~/Documents as graph.png] ( \e[93myes / \e[91mno \e[0m ) "
read answer

if echo "$answer" | grep -iq "^yes$" ;then
	terraform graph -draw-cycles | dot -Tpng -o ~/Documents/graph.png
fi

echo -e "What's next ? ( \e[1mapply / \e[93mupdate / \e[91mdestroy / \e[32mrefresh / \e[0mexit) "
read answer

if echo "$answer" | grep -iq "^apply$" ;then
	terraform apply
	sleep 2
elif echo "$answer" | grep -iq "^update$" ;then
	terraform apply
	exit
elif echo "$answer" | grep -iq "^destroy$" ;then
	terraform destroy
	exit
elif echo "$answer" | grep -iq "^refresh$" ;then
	terraform refresh
	exit
else
	exit
fi

if echo $1 | grep -iq "^allowerrors$" ;then
	echo "Swarm already up from previous apply"
else
	echo "Waiting 5sec to let the swarm joins happen smoothly"
	sleep 1
	echo "*"
	sleep 1
	echo "**"
	sleep 1
	echo "***"
	sleep 1
	echo "****"
	sleep 1
	echo " "
fi

MANAGER_1=$(awless -r eu-central-1 list instances | grep running | grep manager  | head -1 | tail -1 | cut -d '|' -f 7 | sed -e s/' '/''/g)
MANAGER_2=$(awless -r eu-central-1 list instances | grep running | grep manager  | head -2 | tail -1 | cut -d '|' -f 7 | sed -e s/' '/''/g)
MANAGER_3=$(awless -r eu-central-1 list instances | grep running | grep manager  | head -3 | tail -1 | cut -d '|' -f 7 | sed -e s/' '/''/g)

echo "Managers IPS acquired"
echo  "Managers IPS are : "
echo  "Manager 1 : $MANAGER_1"
echo  "Manager 2 : $MANAGER_2"
echo  "Manager 3 : $MANAGER_3"
sleep 2

echo "Retrieving ssh config "
echo " "

# curl https://gist.githubusercontent.com/Ltorre/36b02f9e81a8ebe74b6039b3204cb66c/raw/e1c88581cfec22d632c9998e0f44922298890aca/gistfile1.txt  > ssh_config
# echo "ssh_cfg created" 

echo " "
echo " "


echo  "Deploy from manager # ?  (one/two/three) "
read answer
if echo "$answer" | grep -iq "^one$" ;then
	MANAGER_IP=$(echo -n $MANAGER_1)
elif echo "$answer" | grep -iq "^two$" ;then
	MANAGER_IP=$(echo -n $MANAGER_2)
elif echo "$answer" | grep -iq "^three$" ;then
	MANAGER_IP=$(echo -n $MANAGER_3)
else
	echo "This is not a valid manager, script will now exit"
	exit
fi

# ssh -i ~/.ssh/TestTerraform.pem  -F ssh_config $MANAGER_IP "exit"
# echo "Host authorized"

scp -i ~/.ssh/TestTerraform.pem ~/Docker/traefik.yml docker@$MANAGER_IP:/home/docker
scp -i ~/.ssh/TestTerraform.pem ~/Docker/newconsul.yml docker@$MANAGER_IP:/home/docker
scp -i ~/.ssh/TestTerraform.pem ~/Docker/www-compose.yml docker@$MANAGER_IP:/home/docker
scp -i ~/.ssh/TestTerraform.pem ~/Docker/portainer.yml docker@$MANAGER_IP:/home/docker


if echo $1 | grep -iq "^allowerrors$" ;then
	echo "Stack files added to the remote manager"	
else
	echo "Stack files added to the remote manager"
	echo "*****"
	sleep 1
	echo "******"
	sleep 1
	echo "*******"
	sleep 1
fi

set +e

ssh -i ~/.ssh/TestTerraform.pem docker@$MANAGER_IP "sudo docker network rm consul"

ssh -i ~/.ssh/TestTerraform.pem docker@$MANAGER_IP "sudo docker network rm my-net"

set -e

if echo $1 | grep -iq "^allowerrors$" ;then
	set +e
fi

echo -n "Consul network created :"
ssh -i ~/.ssh/TestTerraform.pem docker@$MANAGER_IP "sudo docker network create --driver overlay  --subnet 10.10.10.0/27 consul"

echo -n "my-net network created :"
ssh -i ~/.ssh/TestTerraform.pem docker@$MANAGER_IP "sudo docker network create --attachable --driver overlay my-net"

#echo -n "docker proxy network created :"
#ssh -i ~/.ssh/TestTerraform.pem -F ssh_config $MANAGER_IP "sudo docker network create --attachable --driver overlay docker-proxy"

if echo $1 | grep -iq "^allowerrors$" ;then
	echo "Consul cluster  already cfg"
else
	ssh -i ~/.ssh/TestTerraform.pem docker@$MANAGER_IP "sudo docker stack deploy -c  newconsul.yml consul"
	echo "Waiting for the consul cluster to be up"
	echo "*****"
	sleep 1
	echo "******"
	sleep 1
	echo "*******"
	sleep 1
fi

#ssh -i ~/.ssh/TestTerraform.pem  -F ssh_config $MANAGER_IP "sudo docker service create --name docker-proxy --network docker-proxy --mount \"type=bind,source=/var/run/docker.sock,target=/var/run/docker.sock\" --constraint 'node.role==manager' rancher/socat-docker"

ssh -i ~/.ssh/TestTerraform.pem docker@$MANAGER_IP "sudo docker stack deploy -c portainer.yml portainer"

ssh -i ~/.ssh/TestTerraform.pem docker@$MANAGER_IP "sudo docker stack deploy -c  traefik.yml traefik"

ssh -i ~/.ssh/TestTerraform.pem docker@$MANAGER_IP "sudo docker stack deploy -c  www-compose.yml www --with-registry-auth "


echo " Swarm's portainer url : $MANAGER_IP:9000" 
echo " Swarm's consul url : $MANAGER_IP:8500"
echo " Swarm's traefik url : $MANAGER_IP:8080"



