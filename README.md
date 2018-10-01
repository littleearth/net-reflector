# NetReflector
NetReflector is a TCP and UDP port reflector.

Use NetReflector to redirect a port to another port on the same machine or another port on another device.

This tool is great for server migrations allow you to migrate services, and either upgrade client PC's prior or after upgrade using this tool

A real world example

    Install MySQL on new server migrate
    Migrate database
    Stop old server MySQL service
    Install Netflector and configure port 3306- New server
    Clients will contnue to function
    Upgrade client configurations
    Remove reflector

Other examples

    Testing development web services, keep 1 external port forward to a test machine but adjust destination port for testing
    RDP on another port, while also keeping port 3389 available. Great for routers that have limited port forward abilities


Installation Downloads
https://www.littleearthsolutions.net/?page_id=126
