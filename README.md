# docker-jmeter
[![](https://images.microbadger.com/badges/image/jorgeandrada/docker-jmeter.svg)](https://microbadger.com/images/jorgeandrada/docker-jmeter "Get your own image badge on microbadger.com")[![](https://images.microbadger.com/badges/version/jorgeandrada/docker-jmeter.svg)](https://microbadger.com/images/jorgeandrada/docker-jmeter "Get your own version badge on microbadger.com")[![](https://images.microbadger.com/badges/commit/jorgeandrada/docker-jmeter.svg)](https://microbadger.com/images/jorgeandrada/docker-jmeter "Get your own commit badge on microbadger.com")

<a href='https://ko-fi.com/A417UXC' target='_blank'><img height='36' style='border:0px;height:36px;' src='https://az743702.vo.msecnd.net/cdn/kofi2.png?v=0' border='0' alt='Buy Me a Coffee at ko-fi.com' /></a>

Apache Jmeter 5.2 with nginx for OpenShift

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

## Local

```bash
mkdir jmeterlocal
cp *.jmx jmeterlocal/

docker run --rm -d --name=jmeter \
-v $(pwd)/jmeterlocal:/tmp/jmeterlocal \
-p 8080:8080 \
jorgeandrada/docker-jmeter

docker exec -it jmeter bash
cd /tmp/jmeterlocal
/jvm_args.sh

JMXNAME="test"
JMXPATH="/tmp/jmeterlocal"

cd $JMXPATH
mkdir -p $JMXPATH/$JMXNAME/report

/opt/apache-jmeter-5.2/bin/PluginsManagerCMD.sh install-for-jmx $JMXPATH/$JMXNAME.jmx

jmeter -Dlog_level.jmeter=DEBUG \
-n -t $JMXPATH/$JMXNAME.jmx -l $JMXPATH/$JMXNAME.jtl -j $JMXPATH/jmeter.log \
-e -o $JMXPATH/$JMXNAME/report

tar -czvf $JMXNAME.tar.gz $JMXPATH/$JMXNAME/report
cp $JMXNAME.tar.gz /usr/share/nginx/html/
cp -avr $JMXPATH/$JMXNAM/report/* /usr/share/nginx/html/

# check http://localhost:8080
# download http://localhost:8080/$JMXNAME.tar.gz

# stop
exit
docker stop jmeter

ls -lh jmeterlocal/
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