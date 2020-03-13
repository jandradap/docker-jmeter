FROM alpine:3.11

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
LABEL org.label-schema.build-date=$BUILD_DATE \
			org.label-schema.name="docker-jmeter" \
			org.label-schema.description="Apache JMeter Docker no root container image for Openshift" \
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
ENV TZ="Europe/Amsterdam"

RUN apk --update --clean-protected --no-cache add ca-certificates \
  && update-ca-certificates \
  && apk --update --clean-protected --no-cache add \ 
    openjdk8-jre \
    tzdata \
    curl \
    unzip \
    bash \
    nss \
    rsync \
    vim \
  && rm -rf /var/cache/apk/*

# JMETER
RUN mkdir -p /tmp/dependencies /opt /test /tmp/test \
  && curl -L --silent ${JMETER_DOWNLOAD_URL} > /tmp/dependencies/apache-jmeter-${JMETER_VERSION}.tgz  \
  && tar -xzf /tmp/dependencies/apache-jmeter-${JMETER_VERSION}.tgz -C /opt  \
  && rm -rf /tmp/dependencies \
  && chmod -R 777 /tmp/test /test \
  && chmod -R +rX /opt/apache-jmeter-${JMETER_VERSION} \
  && chmod -R a+x /opt/apache-jmeter-${JMETER_VERSION}/bin/*

COPY assets/test /test

ENV PATH $PATH:$JMETER_BIN

# JMETER PLUGINS MANAGER
RUN cd /opt/apache-jmeter-${JMETER_VERSION}/lib/ \
  && wget -q https://repo1.maven.org/maven2/kg/apc/cmdrunner/${CMDRUNNER_VERSION}/cmdrunner-${CMDRUNNER_VERSION}.jar \
  && curl -s -Lo /opt/apache-jmeter-5.2/lib/ext/jmeter-plugins-manager.jar https://jmeter-plugins.org/get/ \
  && java -cp /opt/apache-jmeter-5.2/lib/ext/jmeter-plugins-manager.jar org.jmeterplugins.repository.PluginManagerCMDInstaller \
  && chmod +x /opt/apache-jmeter-5.2/bin/PluginsManagerCMD.sh \
  && sed -i "s/2.2/${CMDRUNNER_VERSION}/g" /opt/apache-jmeter-5.2/bin/PluginsManagerCMD.sh \
  && /opt/apache-jmeter-5.2/bin/PluginsManagerCMD.sh install-for-jmx /test/test-plan.jmx


COPY assets/entrypoint.sh /

RUN chmod +x /entrypoint.sh \
  && chmod +x /test/test.sh

WORKDIR /test

ENTRYPOINT ["/entrypoint.sh"]

USER 1001