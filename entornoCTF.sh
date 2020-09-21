#!/bin/bash

#Script creado para agilizar la creacion de entorno para CTFs
#Se hace uso de Tmux

#Uso: entornoCTF.sh <nombreMaquina> <ip> 

tiempoEspera=0.5

ruta='/home/alux/tryhackme'		##Cambiame

function acceso(){
	cd "$ruta"
	mkdir "$1"
	cd "$1"
	mkdir {scan,content,exploits,scripts}
}

function sesionTmux(){
	##Creacion de sesion de tmux
	tmux new-session -d -t $1 && sleep $tiempoEspera
	tmux rename-window "scan" && tmux select-pane -t 1
	tmux send-keys "cd $ruta/$1/scan" C-m && sleep $tiempoEspera
	tmux new-window -t $1:2 -n "content" && tmux select-pane -t 1
	tmux send-keys "cd $ruta/$1/content" C-m && sleep $tiempoEspera
 	tmux new-window -t $1:3 -n "exploits" && tmux select-pane -t 1
	tmux send-keys "cd $ruta/$1/exploits" C-m && sleep $tiempoEspera
	tmux new-window -t $1:4 -n "scripts" && tmux select-pane -t 1
	tmux send-keys "cd $ruta/$1/scripts" C-m && sleep $tiempoEspera
}

function agregarHost(){
	##Agregar maquina al hosts
	echo "$1 $2" >> /etc/hosts
}

if [ "$(id -u)" -eq "0" ]; then
	if [ $# -eq 2 ]; then
		acceso $1
		sesionTmux $1
		agregarHost $1 $2
		tmux attach -t $1
	else
		echo "Uso: $0 <nombremaquina> <ip>"
	fi
else
	echo -e "Necesario root, para modificar archivo /etc/hosts"
fi
