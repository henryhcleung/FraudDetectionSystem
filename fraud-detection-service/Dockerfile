FROM openjdk:17-slim
VOLUME /tmp
COPY target/fraud-detection-service-0.0.1-SNAPSHOT.jar fraud-detection-service.jar
ENTRYPOINT ["java","-jar","/fraud-detection-service.jar"]