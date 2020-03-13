# docker-jmeter
[![](https://images.microbadger.com/badges/image/jorgeandrada/docker-jmeter.svg)](https://microbadger.com/images/jorgeandrada/docker-jmeter "Get your own image badge on microbadger.com")[![](https://images.microbadger.com/badges/version/jorgeandrada/docker-jmeter.svg)](https://microbadger.com/images/jorgeandrada/docker-jmeter "Get your own version badge on microbadger.com")[![](https://images.microbadger.com/badges/commit/jorgeandrada/docker-jmeter.svg)](https://microbadger.com/images/jorgeandrada/docker-jmeter "Get your own commit badge on microbadger.com")

<a href='https://ko-fi.com/A417UXC' target='_blank'><img height='36' style='border:0px;height:36px;' src='https://az743702.vo.msecnd.net/cdn/kofi2.png?v=0' border='0' alt='Buy Me a Coffee at ko-fi.com' /></a>

Apache Jmeter 5.2 for OpenShift

## Test

```bash
/test/test.sh
```

## Plugins

```bash
/opt/apache-jmeter-5.2/bin/PluginsManagerCMD help
/opt/apache-jmeter-5.2/bin/PluginsManagerCMD status
/opt/apache-jmeter-5.2/bin/PluginsManagerCMD upgrades
/opt/apache-jmeter-5.2/bin/PluginsManagerCMD available
/opt/apache-jmeter-5.2/bin/PluginsManagerCMD install jpgc-fifo,jpgc-json=2.2
/opt/apache-jmeter-5.2/bin/PluginsManagerCMD install-all-except jpgc-casutg,jpgc-autostop
/opt/apache-jmeter-5.2/bin/PluginsManagerCMD uninstall jmeter-tcp,jmeter-ftp,jmeter-jdbc
```

## OpenShift

It is necessary to add the variable:

```bash
JVM_ARGS=-Xmn56m -Xms224m -Xmx224m
```

## Credits

Thanks to https://github.com/hauptmedia/docker-jmeter
and https://github.com/hhcordero/docker-jmeter-server for providing
the Dockerfiles that inspired me.   @wilsonmar for contributing detailed instructions. Others
that tested/reported after version updates.