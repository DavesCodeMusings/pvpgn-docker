# pvpgn-docker
Dockerfile and compose.yml to build and run pvpgn in a Docker container.

## What is it?
[PvPGN](https://en.wikipedia.org/wiki/PvPGN) is a Battle.net clone you can run on your own computer. The repository you're in now exists to help those wishing to "Dockerize" their PvPGN instances. What you'll find here are the _Dockerfile_ to build PvPGN and a _compose.yml_ to save yourself some work.

## Why?
Personally, I wanted to host Warcraft II games on my local area network (LAN), but the IPX protocol used by Warcraft II multi-player is no longer supported in modern Windows versions. IPX to TCP/IP wrappers are available, but require configuration on each client computer.

PvPGN looked like a good solution for a centralized server. I wanted to run it in a Docker container. Thus, this repository was born.

## How Can I Use It?
You'll need a host running Docker with Docker Compose available. If you've got that, follow the steps below.

1. Copy the Dockerfile and compose.yml to a suitable subdirectory.
2. Run `docker compose build` to create the pvpgn container image.
3. Run `docker compose up -d` to start the pvpgn server.
4. Configure your clients to use the server.

## Notes About Configuring Clients
Configuring Warcraft II was a pain in the tuchus, so here are some notes.

* You'll need Warcraft II BNE for Windows, not DOS.
* Be sure to apply the [latest patch](https://www.moddb.com/games/warcraft-ii/downloads/warcraft-ii-battlenet-edition-v202-patch) to bring it up to version 2.02.
* Adding your server entry requires manually editing the Windows registry. [HKEY_CURRENT_USER\Software\Battle.net\Configuration\Battle.net gateways](https://www.reddit.com/r/slashdiablo/comments/u4jtj/how_to_manually_edit_the_battlenet_registry_to/)
* Warcraft II must be run in compatibility mode for Windows XP Service Pack 3 to avoid immediate disconnection when joining the server.

## Notes About Configuring the Server
The Dockerfile is setup so that PvPGN is installed with a file-based backend (as opposed to SQL database) and tracking is turned off. This is probably fine for most LAN installations.

* If you need to have access to the configuration, it's in /usr/local/etc/pvpgn/
* Data and log files are written to /usr/local/var/pvgn/
* You can use Docker volumes to map them to your own copies to customize.

For example, this compose.yml:

```
services:
    pvpgn:
        build:
            context: .
        image: davescodemusings/pvpgn
        container_name: pvpgn
        hostname: pvpgn
        restart: unless-stopped
        ports:
          - 6112:6112
        volumes:
          - ./config:/usr/local/etc/pvpgn
          - ./data:/usr/local/var/pvpgn
```

The trick is [copying the files from the container to the host](https://duckduckgo.com/?q=copy+files+from+docker+container+to+host) before running the container. 

## Caveats
This works, but...
* PvPGN hasn't had a release since 2018.
* Warcraft II was released in the 1990s.

If you can get it to work, great. If not, there's always [IPX wrapper](http://www.solemnwarning.net/ipxwrapper/).

## Where's This Going?
Nowhere. Not being familiar with Battle.net, I didn't realize you can only play against other human players. (I suppose the Player vs. Player aspect of PvPGN should have clued me in, but I missed it.) So I've got a nice working Docker container that I'll never use, because I want to play cooperative LAN games. Still, it works. So if someone else can benefit, here it is.
