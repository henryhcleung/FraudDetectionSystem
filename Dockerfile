FROM openjdk:11-jre-slim

# Set the working directory
WORKDIR /app

# Copy the application JAR file to the container
COPY target/FraudDetectionSystem.jar /app/FraudDetectionSystem.jar

# Expose the port the application runs on
EXPOSE 8080

# Run the application
CMD ["java", "-jar", "/app/FraudDetectionSystem.jar"]