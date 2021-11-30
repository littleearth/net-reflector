# NetReflector
NetReflector is a TCP and UDP port reflector.

Use NetReflector to redirect a port to another port on the same machine or another port on another device.

This tool is great for server migrations allow you to migrate services, and either upgrade client PC's prior or after upgrade using this tool

A real world example

    Install MySQL on new server
    Migrate database
    Stop old server MySQL service
    Install NetReflector and configure port 3306 on old server to New server
    Clients will continue to function
    Upgrade client configurations
    Remove NetReflector

Other examples

    Testing development web services
    - External port forward to a test machine but adjust
    - destination port for testing on your development machine
    RDP on another port, while also keeping port 3389 available.
    - Great for routers that have limited port forward abilities



Latest Release
https://github.com/littleearth/net-reflector/releases
