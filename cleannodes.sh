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
echo "We need to connect to each one to delete unused images "
echo " "

echo " Leader : "
echo " "
ssh -i SysDataCenter.pem ubuntu@$LEADER " docker rmi \$(docker images -aq) "
echo " "
echo " Managers : " 
echo " "
ssh -i SysDataCenter.pem ubuntu@$MANAGER0 " docker rmi \$(docker images -aq) "
ssh -i SysDataCenter.pem ubuntu@$MANAGER1 " docker rmi \$(docker images -aq) "
ssh -i SysDataCenter.pem ubuntu@$MANAGER2 " docker rmi \$(docker images -aq) "
ssh -i SysDataCenter.pem ubuntu@$MANAGER3 " docker rmi \$(docker images -aq) "
echo " "

echo " Nodes : "

echo " "
ssh -i SysDataCenter.pem ubuntu@$NODE0 " docker rmi \$(docker images -aq) "
ssh -i SysDataCenter.pem ubuntu@$NODE1 " docker rmi \$(docker images -aq) "
ssh -i SysDataCenter.pem ubuntu@$NODE2 " docker rmi \$(docker images -aq) "
ssh -i SysDataCenter.pem ubuntu@$NODE3 " docker rmi \$(docker images -aq) "
ssh -i SysDataCenter.pem ubuntu@$NODE4 " docker rmi \$(docker images -aq) "
