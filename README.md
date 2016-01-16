# docker-wormhole
Wormhole Docker base image (Based on Ubuntu 14.04)

This image automatically connects your container to Wormhole Network, an overlay network solution that enables networking between your Docker containers on different hosts. This way you can move your containers to different servers, even on different hosting locations, without having to change your application's architecture.

The image is meant to serve as a base image for your own containers.

You'll need a free account in [Wormhole Network](https://wormhole.network) and to create a hub and a hub user. See [How do I start?](https://wormhole.zendesk.com/hc/en-gb/articles/207287035) for simple instructions.

## Building docker-wormhole

    git clone https://github.com/pjperez/docker-wormhole
    cd docker-wormhole
    Download your config (.vpn) and linuxconfig files from your dashboard at [Wormhole Network](https://wormhole.network)
    sudo docker build -t wormhole/client .
  
## Running docker-wormhole

    sudo docker run -t -i --privileged=true wormhole/client

It is important to include the **--privileged=true** parameter to be able to create a new interface for the overlay network and the **-i** flag to make the session interactive, as you'll be asked to input your hub user's password twice.

This is what you'll see after running it:

	The SoftEther VPN Client service has been started.
	The commands written in the file "linuxconfig" will be used instead of input from keyboard.
	vpncmd command - SoftEther VPN Command Line Management Utility
	SoftEther VPN Command Line Management Utility (vpncmd command)
	Version 4.19 Build 9599   (English)
	Compiled 2015/10/19 20:28:20 by yagi at pc30
	Copyright (c) SoftEther VPN Project. All Rights Reserved.
	
	Connected to VPN Client "127.0.0.1:5555".
	
	VPN Client>AccountImport MyHUB-myuser.vpn
	AccountImport command - Import VPN Connection Setting
	The VPN Connection Setting "MyHUB" has been imported.
	The command completed successfully.
	
	VPN Client>AccountPasswordSet MyHUB /TYPE:STANDARD
	AccountPasswordSet command - Set User Authentication Type of VPN Connection Setting to Password Authentication
	Please enter the password. To cancel press the Ctrl+D key.
	
	Password: ************************
	Confirm input: ************************
	
	
	The command completed successfully.
	
	VPN Client>NicCreate wormhole
	NicCreate command - Create New Virtual Network Adapter
	The command completed successfully.
	
	VPN Client>AccountNicSet MyHUB /NIC:wormhole
	AccountNicSet command - Set Virtual Network Adapter for VPN Connection Setting to Use
	The command completed successfully.
	
	VPN Client>AccountConnect MyHUB
	AccountConnect command - Start Connection to VPN Server using VPN Connection Setting
	The command completed successfully.
	
	Acquiring IP address...
	IP address acquired!
	
And this is what the server sees:

	2016-01-15 19:42:26.406 The connection "CID-743" (IP address: 1.2.3.4, Host name: 1.2.3.4, Port number: 1168, Client name: "SoftEther VPN Client", Version: 4.19, Build: 9599) is attempting to connect to the Virtual Hub. The auth type provided is "Password authentication" and the user name is "myuser".
	
	2016-01-15 19:42:26.406 Connection "CID-743": Successfully authenticated as user "myuser".
	2016-01-15 19:42:26.406 Connection "CID-743": The new session "SID-MYUSER-19" has been created. (IP address: 1.2.3.4, Port number: 1168, Physical underlying protocol: "Standard TCP/IP (IPv4)")
	
	2016-01-15 19:42:26.406 Session "SID-MYUSER-19": The parameter has been set. Max number of TCP connections: 2, Use of encryption: Yes, Use of compression: No, Use of Half duplex communication: No, Timeout: 20 seconds.
	
	2016-01-15 19:42:26.406 Session "SID-MYUSER-19": VPN Client details: (Client product name: "SoftEther VPN Client", Client version: 419, Client build number: 9599, Server product name: "SoftEther VPN Server (64 bit)", Server version: 419, Server build number: 9599, Client OS name: "Linux", Client OS version: "Unknown Linux Version", Client product ID: "--", Client host name: "6bb06fc1b280", Client IP address: "172.17.0.2", Client port number: 43429, Server host name: "amsterdam-hub.wormhole.network", Server IP address: "4.3.2.1", Server port number: 443, Proxy host name: "", Proxy IP address: "0.0.0.0", Proxy port number: 0, Virtual Hub name: "MyHUB", Client unique ID: "30D35CC2852F39D4B062A070BDE3FCF1")
	
	2016-01-15 19:42:26.519 SecureNAT: The DHCP entry 555 has been created. MAC address: 00-AC-34-56-78-12, IP address: 100.64.0.13, host name: 6bb06fc1b280, expiration span: 7200 seconds
	
	2016-01-15 19:42:26.519 Session "SID-SECURENAT-1": The DHCP server of host "00-AC-34-A7-D3-1F" (100.64.0.1) on this session allocated, for host "SID-MYUSER-19" on another session "00-AC-34-56-78-12", the new IP address 100.64.0.13.

Now your container is reachable on 100.64.0.13 inside your virtual network. Of course, all the traffic inside the network is encrypted for privacy and security purposes.

## Use cases

The main use case for docker-wormhole is to make network reachability easier between your microservices, without having to expose ports, configure NAT or work with firewalls.
