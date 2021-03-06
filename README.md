# Graylog Collector Sidecar

[![Build Status](https://travis-ci.org/Graylog2/collector-sidecar.svg?branch=master)](https://travis-ci.org/Graylog2/collector-sidecar)

**Required Graylog version:** 2.0 and later + installed [graylog-plugin-collector](https://github.com/Graylog2/graylog-plugin-collector/blob/master/README.md)

The Graylog Collector Sidecar is a supervisor process for 3rd party log collectors like NXLog. The Sidecar program is able to fetch configurations from a Graylog server and render
them as a valid configuration file for various log collectors. You can think of it like a centralized configuration management system for your log collectors.

Documentation
-------------

Please check our official [documentation](http://docs.graylog.org/en/latest/pages/collector_sidecar.html) for more information.

Installation
------------

[Download a package](https://github.com/Graylog2/collector-sidecar/releases) and install it on the target system.


**Ubuntu**

Install the NXLog package from the offical download [page](https://nxlog.org/products/nxlog-community-edition/download)

```
  $ sudo /etc/init.d/nxlog stop
  $ sudo update-rc.d -f nxlog remove
  $ sudo gpasswd -a nxlog adm
 
  $ sudo dpkg -i collector-sidecar_0.0.8-1_amd64.deb
```

Edit `/etc/graylog/collector-sidecar/collector_sidecar.yml`, you should set at least the correct URL to your Graylog server and proper tags.
The tags are used to define which configurations the host should receive.

```
  $ sudo graylog-collector-sidecar -service install
  $ sudo start collector-sidecar
```

**CentOS**

```
  $ sudo service nxlog stop
  $ sudo chkconfig --del nxlog
  $ sudo gpasswd -a nxlog root

  $ sudo rpm -i collector-sidecar-0.0.8-1.x86_64.rpm
```

Activate the Sidecar as a system service

```
  $ sudo graylog-collector-sidecar -service install
  $ sudo systemctl start collector-sidecar
```

**Windows**

Install the NXLog package from the offical download [page](https://nxlog.org/products/nxlog-community-edition/download)

```
  $ C:\Program Files (x86)\nxlog\nxlog -u

  $ graylog_collector_sidecar_installer.exe
```

It's also possible to run the installer in silent mode with

```
  $ graylog_collector_sidecar_installer.exe /S
```

Edit `C:\Program Files (x86)\graylog\collector-sidecar\collector_sidecar.yml`, you should set at least the correct URL to your Graylog server and proper tags.

```
  $ C:\Program Files (x86)\graylog\collector-sidecar\graylog-collector-sidecar.exe -service install
  $ C:\Program Files (x86)\graylog\collector-sidecar\graylog-collector-sidecar.exe -service start
```

You can also run the Sidecar in foreground for debugging purposes. Simply call it like this and watch for error messages:

```
  $ graylog-collector-sidecar -c /etc/graylog/collector-sidecar/collector_sidecar.yml
```

Configuration
-------------

There are a couple of configuration settings for the Sidecar:

| Parameter         | Description                                                                                                                           |
|-------------------|---------------------------------------------------------------------------------------------------------------------------------------|
| server_url        | URL to the Graylog API, e.g. `http://127.0.0.1:12900`                                                                                 |
| tls_skip_verify   | Ignore errors when the REST API was started with a self-signed certificate                                                            |
| node_id           | Name of the Sidecar instance, will also show up in the web interface                                                                  |
| collector_id      | Unique ID (UUID) of the instance. This can be an ID string or a path to an ID file                                                    |
| tags              | List of configuration tags. All configurations on the server side that match the tag list will be fetched and merged by this instance |
| log_path          | A path to a directory where the Sidecar can store the output of each running collector backend                                        |
| log_rotation_time | Rotate the stdout and stderr logs of each collector after X seconds                                                                   |
| log_max_age       | Delete rotated log files older than Y seconds                                                                                         |
| update_interval   | The interval in seconds the sidecar will fetch new configurations from the Graylog server                                             |
| backends          | A list of collector backends the user wants to run on the target host                                                                 |

Each backend can be enabled/disabled and should point to a binary of the actual collector and a path to a configuration file the Sidecar can write to:

| Parameter          | Description                                                       |
|--------------------|-------------------------------------------------------------------|
| name               | The type name of the collector                                    |
| enabled            | Weather this backend should be started by the Sidecar or not      |
| binary_path        | Path to the actual collector binary                               |
| configuration_path | A path for this collector configuration file Sidecar can write to |
    
Compile
-------

  * Clone the repository into your `$GOPATH` under `src/github.com/Graylog2/collector-sidecar`
  * Install the [glide package manager](https://glide.sh)
  * run `glide install` in the collector-sidecar directory
  * (for Go <1.6 `export GO15VENDOREXPERIMENT=1`)
  * run `make build`

Development
-----------

There is a collector mock programm in order to use the collector-sidecar without actually running a collector like NXLog. Simply build it with
`make misc` und use the option `binary_path: misc/nxmock/nxlog`.
