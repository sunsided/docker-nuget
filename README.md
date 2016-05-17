# Docker NuGet Feed v0.4.1

This project provides a NuGet feed based on the [simple-nuget-server](https://github.com/Daniel15/simple-nuget-server/) project. It runs on top of the official [nginx](https://github.com/docker-library/docs/tree/master/nginx) image and uses [HHVM](http://hhvm.com) for PHP execution. [Supervisor](http://supervisord.org) is used for tracking the processes.

The corresponding docker image is `sunside/simple-nuget-server` and can be found [here](https://hub.docker.com/r/sunside/simple-nuget-server/).

NuGet packages currently are allowed to have a maximum size of 20 MB on upload.

## Quickstart

```bash
docker run --detach=true \
           --publish 5000:80 \
           --env NUGET_API_KEY=<your secret> \
           --volume /srv/docker/nuget/database:/var/www/db \
           --volume /srv/docker/nuget/packages:/var/www/packagefiles \
           --name nuget-server \
           sunside/simple-nuget-server
```

## Building the image

To build the image named `simple-nuget-server`, execute the following command:

```bash
docker build -t simple-nuget-server .
```

At build time, a random API key is generated and printed out to the console. Note that this implies that every new image has a different *default* API key.

## Running the image

Make sure to have the submodule available by either cloning with `git clone --recursive` or executing

```bash
git submodule init
git submodule update
```

To run a container off the `simple-nuget-server` image, execute the following command:

```bash
docker run -d --name nuget-server -p 80:80 \
           -e NUGET_API_KEY=<your secret> simple-nuget-server
```

Note that some NuGet clients might be picky about the port, so be sure to have your feed available on either port `80` or `443`, e.g. by having a reverse proxy in front on the container.

### Environment configuration

* `NUGET_API_KEY` sets the NuGet feed's API key to your own private key
* `BASE_URL` sets the base path of the feed, e.g. `/nuget` if it is available under `http://your.tld/nuget/`

### Exported volumes

* `/var/www/db` contains the SQLite database
* `/var/www/packagefiles` contains uploaded the NuGet packages
* `/var/cache/nginx` nginx' cache files

## NuGet configuration

In order to push a package to your new NuGet feed, use the following command:

```bash
nuget push -Source http://url.to/your/feed/ -ApiKey <your secret> path/to/package.nupkg
```

Deleting package version `<Version>` of package `<Package>` is done using

```bash
nuget delete -Source http://url.to/your/feed/ -ApiKey <your secret> <Package> <Version>
```

Listing packages including prereleases can be done using

```bash
nuget list -Source http://url.to/your/feed/ -Prerelease
```

You can add your feed to a specific `NuGet.config` file using:

```bash
nuget sources add -Name "Your Feed's Name" -Source http://url.to/your/feed/ -ConfigFile NuGet.config
```

In order to store the API key in a specifig `NuGet.config` file you can use:

```bash
nuget setapikey -Source http://url.to/your/feed/ -ConfigFile NuGet.config
```

This will create or update the `apikeys` section of your configuration file. Make sure to not check anything sensitive into source control.

In both cases, if you omit the `-ConfigFile <file>` option, your user configuration file will be used.

## Apache example configuration

The following configuration sets up passwordless access from the local network `192.168.0.0/24` as well as the Docker network `172.17.42.0/24` and requires
basic authentication from the outside world.

```
<Location /nuget/>
	Require all denied
	Require local
	Require ip 192.168.0.0/24
	Require ip 172.17.42.0/24

	AuthType Basic
	AuthName "NuGet Feed"
	AuthBasicProvider file
	AuthUserFile "/srv/docker/nuget/auth-file"
	Require valid-user

	RequestHeader set X-Forwarded-Proto "https"
	ProxyPass http://127.0.0.1:16473/nuget/
	ProxyPassReverse http://127.0.0.1:16473/nuget/
</Location>

```

## License

This project is licensed under the MIT license. See the `LICENSE` file for more information.
