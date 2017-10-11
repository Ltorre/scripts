#!/usr/bin/env bash

LEADER=$(docker node ls | grep Leader |  grep -o  'ip-[^ ]*')

MANAGER0=$(docker node ls | grep Reachable |  grep -o  'ip-[^ ]*' | sort -n | head -1 | tail -1)
MANAGER1=$(docker node ls | grep Reachable |  grep -o  'ip-[^ ]*' | sort -n | head -2 | tail -1)
MANAGER2=$(docker node ls | grep Reachable |  grep -o  'ip-[^ ]*' | sort -n | head -3 | tail -1)
MANAGER3=$(docker node ls | grep Reachable |  grep -o  'ip-[^ ]*' | sort -n | tail -1)

NODE0=$(docker node ls  | grep -v Leader | grep -v Reachable |  grep -o  'ip-[^ ]*' | sort -n | head -1 | tail -1)
NODE1=$(docker node ls  | grep -v Leader | grep -v Reachable |  grep -o  'ip-[^ ]*' | sort -n | head -2 | tail -1)
NODE2=$(docker node ls  | grep -v Leader | grep -v Reachable |  grep -o  'ip-[^ ]*' | sort -n | head -3 | tail -1)
NODE3=$(docker node ls  | grep -v Leader | grep -v Reachable |  grep -o  'ip-[^ ]*' | sort -n | head -4 | tail -1)
NODE4=$(docker node ls  | grep -v Leader | grep -v Reachable |  grep -o  'ip-[^ ]*' | sort -n | tail -1)

echo " "
echo "Found the leader : "
echo -n " " 
echo $LEADER
echo " "                    
echo "Found managers : "
echo -n " 0 : "   
echo -n $MANAGER0                                                    
echo -n " 1 : "                                                       
echo -n $MANAGER1                                                    
echo -n " 2 : "                                                       
echo -n $MANAGER2                                                    
echo -n " 3 : "                    
echo -n $MANAGER3 
                                                           
echo " "                                                       
echo " "                                                       
echo "Found nodes : "
echo -n " 0 : "
echo -n $NODE0
echo -n " 1 : "
echo -n $NODE1
echo -n " 2 : "
echo -n $NODE2
echo -n " 3 : "   
echo -n $NODE3
echo -n " 4 : "   
echo -n $NODE4
echo " "                    
echo " "  
echo "We need to connect to each one to authent them on aws "
echo " "

echo " Leader : "

echo " "
scp -i SysDataCenter.pem aws.log docker@$LEADER:/home/docker/
ssh -i SysDataCenter.pem docker@$LEADER " eval \$(cat aws.log) "

echo " "
echo " "
echo " Managers : " 
echo " "

scp -i SysDataCenter.pem aws.log docker@$MANAGER0:/home/docker/
ssh -i SysDataCenter.pem docker@$MANAGER0 " eval \$(cat aws.log) "
scp -i SysDataCenter.pem aws.log docker@$MANAGER1:/home/docker/
ssh -i SysDataCenter.pem docker@$MANAGER1 " eval \$(cat aws.log) "
scp -i SysDataCenter.pem aws.log docker@$MANAGER2:/home/docker/
ssh -i SysDataCenter.pem docker@$MANAGER2 " eval \$(cat aws.log) "
scp -i SysDataCenter.pem aws.log docker@$MANAGER3:/home/docker/
ssh -i SysDataCenter.pem docker@$MANAGER3 " eval \$(cat aws.log) "


echo " "
echo " "
echo " Nodes : "
echo " "
scp -i SysDataCenter.pem aws.log docker@$NODE0:/home/docker/
ssh -i SysDataCenter.pem docker@$NODE0 " eval \$(cat aws.log) "
scp -i SysDataCenter.pem aws.log docker@$NODE1:/home/docker/
ssh -i SysDataCenter.pem docker@$NODE1 " eval \$(cat aws.log) "
scp -i SysDataCenter.pem aws.log docker@$NODE2:/home/docker/
ssh -i SysDataCenter.pem docker@$NODE2 " eval \$(cat aws.log) "
scp -i SysDataCenter.pem aws.log docker@$NODE3:/home/docker/
ssh -i SysDataCenter.pem docker@$NODE3 " eval \$(cat aws.log) "
scp -i SysDataCenter.pem aws.log docker@$NODE4:/home/docker/
ssh -i SysDataCenter.pem docker@$NODE4 " eval \$(cat aws.log) "

