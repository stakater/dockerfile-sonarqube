FROM  stakater/java8-alpine:1.8.0_144
LABEL authors="Ahmad <ahmadiq@gmail.com>"

ARG SONAR_VERSION=6.4

ENV SONAR_VERSION=${SONAR_VERSION} \
    SONARQUBE_HOME=/opt/sonarqube \
    # Database configuration
    # Defaults to using H2
    SONARQUBE_JDBC_USERNAME=sonar \
    SONARQUBE_JDBC_PASSWORD=sonar \
    SONARQUBE_JDBC_URL=

# Http port
EXPOSE 9000

RUN set -x \
    && apk add --no-cache gnupg unzip \
    && apk add --no-cache libressl wget \

    # pub   2048R/D26468DE 2015-05-25
    #       Key fingerprint = F118 2E81 C792 9289 21DB  CAB4 CFCA 4A29 D264 68DE
    # uid                  sonarsource_deployer (Sonarsource Deployer) <infra@sonarsource.com>
    # sub   2048R/06855C1D 2015-05-25 \
    && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys F1182E81C792928921DBCAB4CFCA4A29D26468DE \

    && cd /opt \
    && wget -O sonarqube.zip --no-verbose https://sonarsource.bintray.com/Distribution/sonarqube/sonarqube-$SONAR_VERSION.zip \
    && wget -O sonarqube.zip.asc --no-verbose https://sonarsource.bintray.com/Distribution/sonarqube/sonarqube-$SONAR_VERSION.zip.asc \
    && gpg --batch --verify sonarqube.zip.asc sonarqube.zip \
    && unzip sonarqube.zip \
    && mv sonarqube-$SONAR_VERSION sonarqube \
    && rm sonarqube.zip* \
    && rm -rf $SONARQUBE_HOME/bin/*

VOLUME "$SONARQUBE_HOME/data"

#WORKDIR $SONARQUBE_HOME
#COPY run.sh $SONARQUBE_HOME/bin/

# Make daemon service dir for sonarqube and place file
# It will be started and maintained by the base image
RUN mkdir -p /etc/service/sonarqube
ADD start.sh /etc/service/sonarqube/run

ENV COMMAND "java -jar lib/sonar-application-$SONAR_VERSION.jar \
            -Dsonar.log.console=true \
            -Dsonar.jdbc.username=\"$SONARQUBE_JDBC_USERNAME\" \
            -Dsonar.jdbc.password=\"$SONARQUBE_JDBC_PASSWORD\" \
            -Dsonar.jdbc.url=\"$SONARQUBE_JDBC_URL\" \
            -Dsonar.web.javaAdditionalOpts=\"$SONARQUBE_WEB_JVM_OPTS -Djava.security.egd=file:/dev/./urandom\""

#RUN sed -i 's|#wrapper.java.additional.6=-server|wrapper.java.additional.6=-server|g' /opt/sonar/conf/wrapper.conf

#RUN sed -i 's|#sonar.jdbc.password=sonar|sonar.jdbc.password=123qwe|g' /opt/sonar/conf/sonar.properties
#RUN sed -i 's|#sonar.jdbc.user=sonar|sonar.jdbc.user=sonar|g' /opt/sonar/conf/sonar.properties
#RUN sed -i 's|sonar.jdbc.url=jdbc:h2|#sonar.jdbc.url=jdbc:h2|g' /opt/sonar/conf/sonar.properties
#RUN sed -i 's|#sonar.jdbc.url=jdbc:mysql://localhost|sonar.jdbc.url=jdbc:mysql://${env:DB_PORT_3306_TCP_ADDR}|g' /opt/sonar/conf/sonar.properties
