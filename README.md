# wodocker
The goal of this image is to easely test WOA's on a laptop before going to production.
Containers launched with this image will run apache/wodapator/wotaskd/JavaMonitor, it's based on a basic debian/jessie with :
- apache 2.4
- java 1.8.45 
- woadaptor compiled for apache 2.4
- wonder wotaskd 6.1
- wonder javamonitor 6.1

You should NOT use this image in production. Instead, using Docker, you could run your woa in simple java-based containers and use a generic load-balancing container based on some nginx ou haproxy. 

## Prerequisites
- Docker !
On Mac OS X, you can install all you need with Dockertoolbox : https://www.docker.com/toolbox
Or Homebrew.

- Nothing else

## Run

# Command line

`docker run -ti --rm -p 80:80 -p 56789:56789 -v $HOME/wodocker/apps:/mywoapps -v $HOME/wodocker/conf:/opt/Local/Library/WebObjects/Configuration -v $HOME/wodocker/htdocs:/usr/local/apache2/htdocs/WebObjects -v $HOME/wodocker/logs:/var/log/WebObjects wofull`

Okay the command line is quite large due to volume sharing :
Create a wodocker directory in your $HOME
 After running the command line, it will create the following directories mapped to the container directories :
 - apps : put here your woa
 - conf : wotaskd will persist here the SiteConfig.xml, thus you will not lose the config after container restart
 - htdocs : put here your webserver resources
 - logs : apps will write logs here, if you configure them in JavaMonitor to write to /var/log/WebObjects

Beware on Mac OS X, by default you can't share folders not contained in your home directory : https://docs.docker.com/userguide/dockervolumes/

# Running JavaMonitor and your apps
You can access JavaMonitor on http://${hostip}:56789
You can view your $hostip with `docker-machine ls` if you use docker-machine.

You should add localhost as a host of type UNIX in the "Hosts" tab.

You can access your apps on http://${hostip}/apps/WebObjects/MyApp.woa





