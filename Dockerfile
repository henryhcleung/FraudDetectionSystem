# Use a multi-stage build for a smaller final image
FROM openjdk:17-slim AS builder

# Set the working directory
WORKDIR /app

# Copy the application JAR file to the container
COPY target/FraudDetectionSystem-*.jar app.jar

# Extract the layers
RUN java -Djarmode=layertools -jar app.jar extract

# Use a new stage for the final image
FROM openjdk:17-slim

# Set the working directory
WORKDIR /app

# Copy the extracted layers from the builder stage
COPY --from=builder /app/dependencies/ ./
COPY --from=builder /app/spring-boot-loader/ ./
COPY --from=builder /app/snapshot-dependencies/ ./
COPY --from=builder /app/application/ ./

# Expose the port the application runs on
EXPOSE 8080

# Run the application
ENTRYPOINT ["java", "org.springframework.boot.loader.JarLauncher"]