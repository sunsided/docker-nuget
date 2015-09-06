# NuGet Feed

This docker image provides a NuGet feed based on the [simple-nuget-server](https://github.com/Daniel15/simple-nuget-server/) project. It runs on top of the official [nginx](https://github.com/docker-library/docs/tree/master/nginx) image and uses [HHVM](http://hhvm.com) for PHP execution. [Supervisor](http://supervisord.org) is used for tracking the processes.

## Building the image

To build the image named `simple-nuget-server`, execute the following command:

```bash
docker build -t simple-nuget-server .
```

At build time, a random API key is generated and printed out to the console. Note that this implies that every new image has a different *default* API key.

## Running the image

To run a container off the `simple-nuget-server` image, execute the following command:

```bash
docker run -d --name nuget-server -p 80:80 -e "NUGET_API_KEY=<your secret>" simple-nuget-server
```

Note that some NuGet clients might be picky about the port, so be sure to have your feed available on either port `80` or `443`, e.g. by having a reverse proxy in front on the container.

### Environment configuration

* `NUGET_API_KEY` sets the NuGet feed's API key to your own private key

### Exported volumes

* `/var/www/db` contains the SQLite database
* `/var/www/packagefiles` contains uploaded the NuGet packages

## NuGet configuration

In order to push a package to your new NuGet feed, use the following command:

```bash
nuget push -src http://url.to/your/feed/ -ApiKey <your secret> path/to/package.nupkg
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
