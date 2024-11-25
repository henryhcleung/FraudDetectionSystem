FROM openjdk:17-slim
VOLUME /tmp
COPY target/eureka-server-0.0.1-SNAPSHOT.jar eureka-server.jar
ENTRYPOINT ["java","-jar","/eureka-server.jar"]