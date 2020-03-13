FROM alpine:3.11

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
LABEL org.label-schema.build-date=$BUILD_DATE \
			org.label-schema.name="docker-jmeter" \
			org.label-schema.description="Jmeter in Docker" \
			org.label-schema.url="http://andradaprieto.es" \
			org.label-schema.vcs-ref=$VCS_REF \
			org.label-schema.vcs-url="https://github.com/jandradap/docker-jmeter" \
			org.label-schema.vendor="Jorge Andrada Prieto" \
			org.label-schema.version=$VERSION \
			org.label-schema.schema-version="1.0" \
			maintainer="Jorge Andrada Prieto <jandradap@gmail.com>"

ARG JMETER_VERSION="5.2"
ENV JMETER_HOME /opt/apache-jmeter-${JMETER_VERSION}
ENV	JMETER_BIN	${JMETER_HOME}/bin
ENV	JMETER_DOWNLOAD_URL  https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-${JMETER_VERSION}.tgz
ENV CMDRUNNER_VERSION="2.2.1"

# Install extra packages
# See https://github.com/gliderlabs/docker-alpine/issues/136#issuecomment-272703023
# Change TimeZone TODO: TZ still is not set!
ARG TZ="Europe/Amsterdam"
RUN    apk update \
	&& apk upgrade \
	&& apk add ca-certificates \
	&& update-ca-certificates \
	&& apk add --update openjdk8-jre tzdata curl unzip bash \
	&& apk add --no-cache nss \
	&& rm -rf /var/cache/apk/* \
	&& mkdir -p /tmp/dependencies  \
	&& curl -L --silent ${JMETER_DOWNLOAD_URL} >  /tmp/dependencies/apache-jmeter-${JMETER_VERSION}.tgz  \
	&& mkdir -p /opt  \
	&& tar -xzf /tmp/dependencies/apache-jmeter-${JMETER_VERSION}.tgz -C /opt  \
	&& rm -rf /tmp/dependencies \
	&& mkdir /test /tmp/test \
	&& chmod -R 777 /tmp/test \
	&& chmod -R 777 /test \
	&& chmod -R +rX /opt/apache-jmeter-${JMETER_VERSION} \
	&& chmod -R a+x /opt/apache-jmeter-${JMETER_VERSION}/bin/*

ENV PATH $PATH:$JMETER_BIN

COPY assets/test /test
COPY assets/entrypoint.sh /

RUN cd /opt/apache-jmeter-${JMETER_VERSION}/lib/ \
  && wget https://repo1.maven.org/maven2/kg/apc/cmdrunner/${CMDRUNNER_VERSION}/cmdrunner-${CMDRUNNER_VERSION}.jar \
  && curl -Lo /opt/apache-jmeter-5.2/lib/ext/jmeter-plugins-manager.jar https://jmeter-plugins.org/get/ \
  && java -cp /opt/apache-jmeter-5.2/lib/ext/jmeter-plugins-manager.jar org.jmeterplugins.repository.PluginManagerCMDInstaller \
  && chmod +x /opt/apache-jmeter-5.2/bin/PluginsManagerCMD.sh \
  && sed -i "s/2.2/${CMDRUNNER_VERSION}/g" /opt/apache-jmeter-5.2/bin/PluginsManagerCMD.sh \
  && /opt/apache-jmeter-5.2/bin/PluginsManagerCMD.sh install-for-jmx /test/test-plan.jmx

RUN chmod +x /entrypoint.sh \
  && chmod +x /test/test.sh

WORKDIR /test

ENTRYPOINT ["/entrypoint.sh"]

USER 1001