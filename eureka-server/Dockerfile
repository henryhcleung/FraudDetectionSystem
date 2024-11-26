# Use an official OpenJDK runtime as a parent image
FROM openjdk:17-jdk-slim AS builder

# Set the working directory
WORKDIR /app

# Copy the application JAR file to the container
COPY target/fraud-detection-service-*.jar app.jar

# Extract the layers
RUN java -Djarmode=layertools -jar app.jar extract

# Use a new stage for the final image
FROM openjdk:17-jdk-slim

# Set the working directory
WORKDIR /app

# Copy the extracted layers from the builder stage
COPY --from=builder /app/dependencies/ ./
COPY --from=builder /app/spring-boot-loader/ ./
COPY --from=builder /app/snapshot-dependencies/ ./
COPY --from=builder /app/application/ ./

# Expose the port the application runs on
EXPOSE 8081

# Run the application
ENTRYPOINT ["java", "org.springframework.boot.loader.JarLauncher"]