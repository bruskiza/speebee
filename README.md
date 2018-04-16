
SpeeBee
=======

This repository contains the code for a simple speed test command line that
posts to BeeBotte.com.

Intention
---------

I wanted something that would run consistent tests consistently and would be
easily deployable.

Technologies used
-----------------

* SpeedTest cli
* BeeBotte.com
* Docker

Beebotte Setup
==============

Before you deploy your docker container, register with BeeBotte.com.

Once logged into Beebotte:

* Click Channels
* Click Create New
* Under 'Channel Name' enter ***speebee***
* Under ***configured resources*** add four as follows:
  * public_ip - Type: string
  * ping - Type: number
  * download - Type: speed
  * upload - Type: speed
* Click 'Create Channel'

Leave SoS unticked for each resource.

The result should look like this:

![BeeBotte Channel Setup](https://raw.githubusercontent.com/bruskiza/speebee/master/img/beebotte_channel_setup.png)

***Take note of the 'Channel Token'. We will use that in the next step.***

Getting the Container
=====================

To get the container, do the following:

```
docker pull bruskiza/speebee
```

Starting the Docker container
-----------------------------

```
docker run -e _SPEEBEE_TOKEN=<TOKEN FROM YOUR CHANNEL> \
-e _SPEEBEE_TIMER=<INTERVAL IN SECONDS FOR COLLECTION: 3600 DEFAULT>\
 -d --name speebee bruskiza/speebee
```

Environment variables supported
-------------------------------

```
_SPEEBEE_API - defaults to api.beebotte.com
_SPEEBEE_TOKEN - the channel token - REQUIRED
_SPEEBEE_CHANNEL - channel to post to: defaults to 'speebee'
_SPEEBEE_TIMER - Interval in seconds: defaults to 3600
```

Checking It Is Working
======================

The container
-------------

The first thing to check is the logs of the docker container.
Do this by:

```
docker logs speebee
```

Beebotte
--------

If the docker container posting, there should be data on Beebotte itself.

Go into your 'speebee' channel and check which resources are updated.

--
