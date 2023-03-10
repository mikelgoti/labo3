#!/bin/bash

echo "Introduce la interfaz para aplicar las reglas del script: "
read i

#Eliminar posibles reglas existentes
iptables -t filter -F
iptables -t nat -F

#Reiniciar contadores
iptables -t filter -Z
iptables -t nat -Z

#DENEGAR TODO
iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP

#LOOPBACK (/etc/resolv.conf)
iptables -I INPUT 1 -i lo -j ACCEPT
iptables -I OUTPUT 1 -o lo -j ACCEPT

#ENABLE PING
iptables -A OUTPUT -o $i -p icmp -j ACCEPT
iptables -A INPUT -i $i -p icmp -j ACCEPT

#ENABLE DNS
#PROTOCOLO UPD
iptables -A OUTPUT -o $i -p udp --dport 53 -j ACCEPT
iptables -A INPUT -i $i -p udp --sport 53 -j ACCEPT

#PROTOCOLO TCP
iptables -A OUTPUT -o $i -p tcp --dport 53 -j ACCEPT
iptables -A INPUT -i $i -p tcp --sport 53 -j ACCEPT

#HTTP
iptables -A OUTPUT -o $i -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -i $i -p tcp --sport 80 -j ACCEPT

#HTTPS
iptables -A OUTPUT -o $i -p tcp --dport 443 -j ACCEPT
iptables -A INPUT -i $i -p tcp --sport 443 -j ACCEPT


#MOSTRAR REGLAS
iptables -L -nv --line-numbers
