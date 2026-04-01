FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /build

# Cache dependencies first for faster rebuilds.
COPY pom.xml .
RUN mvn -B -DskipTests dependency:go-offline

# Build WAR from source.
COPY src ./src
RUN mvn -B -DskipTests clean package

FROM tomcat:10.1-jdk21-temurin

# Harden Tomcat defaults and prepare non-root runtime user.
RUN rm -rf /usr/local/tomcat/webapps/* \
    && sed -i 's/<Host name="localhost"  appBase="webapps"/<Host name="localhost"  appBase="webapps" unpackWARs="false" autoDeploy="false"/' /usr/local/tomcat/conf/server.xml \
    && groupadd -g 10001 app \
    && useradd -u 10001 -g app -M -s /usr/sbin/nologin app \
    && chown -R app:app /usr/local/tomcat

WORKDIR /usr/local/tomcat

# Final image only contains WAR artifact (no source code).
COPY --from=build /build/target/*.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
USER 10001:10001

CMD ["catalina.sh", "run"]
