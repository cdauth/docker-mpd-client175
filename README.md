Starts an [MPD](http://www.musicpd.org/) with a [client175](https://code.google.com/p/client175/) web interface.


Usage
=====

```bash
docker create \
	--name "mpd-client175" \
	-v /directory/to/music:/music \
	--device=/dev/snd:/dev/snd \
	-p 6600:6600 \
	-p 8080:8080 \
	cdauth/mpd-client175
```

To make avahi work, add this parameter:

```bash
	--device=/run/dbus:/run/dbus
```


Volumes
=======

* `/music`: The directory containing your music


Ports
=====

* `6600`: The MPD server
* `8080`: The client175 web interface