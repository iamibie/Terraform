#!/bin/bash

        sudo apt-get update -y
        sudo apt-get install \ -y
        ca-certificates \
        curl \
        gnupg \
        lsb-release

                    #install GPG key

        sudo mkdir -p /etc/apt/keyrings -y
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

                    #set-up repository

    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

                    #install docker engine

        sudo apt-get update -y
        sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y

                    #confirm installation was 
        sudo docker run hello-world 

        sudo mkdir /home/Apps

    cd /home/Apps
        sudo git clone https://github.com/iamibie/mern-ecomm-app.git 

    echo "Done"
    exit





