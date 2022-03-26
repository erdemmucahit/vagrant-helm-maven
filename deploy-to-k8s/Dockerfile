FROM openjdk:8-alpine
ARG APPLICATION
ADD target/$APPLICATION*.jar /service/service.jar
EXPOSE 8080
ENTRYPOINT java -Djava.security.egd=file:/dev/./urandom $JAVA_OPTS  -jar /service/service.jar
