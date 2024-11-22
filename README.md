# FraudDetectionSystem

## Overview

The FraudDetectionSystem is a Java-based microservices application designed to detect cycles in linked lists and manage transactions. It uses Spring Boot for the backend and provides a web interface for user interaction. The system is designed to be scalable and maintainable, leveraging Kubernetes for deployment and GitHub Actions for CI/CD.

## Project Structure

```
FRAUDDETECTIONSYSTEM
├── src
│   ├── main
│   │   ├── java/com/binance
│   │   │   ├── config
│   │   │   ├── controller
│   │   │   ├── model
│   │   │   ├── repository
│   │   │   └── service
│   │   └── resources
│   ├── test
│       └── java/com/binance
├── k8s
│   ├── deployment.yaml
│   ├── service.yaml
│   └── configmap.yaml
├── scripts
│   ├── build.sh
│   └── deploy.sh
├── .github
│   └── workflows
│       └── ci.yml
├── .gitignore
├── Dockerfile
├── Jenkinsfile
├── custom-settings.xml
├── pom.xml
└── README.md
```

## Key Components

### Config
- **SecurityConfig.java**: Manages security settings and configurations.

### Controller
- **CycleDetectionController.java**: Handles API requests related to cycle detection.
- **LoginController.java**: Manages user authentication and login processes.

### Model
- **ListNode.java**: Represents a node in a linked list.
- **Transaction.java**: Represents a transaction entity.

### Repository
- **TransactionRepository.java**: Provides CRUD operations for transactions.

### Service
- **CustomUserDetailsService.java**: Handles user details and authentication logic.
- **CycleDetectionService.java**: Contains business logic for cycle detection.

### Resources
- **templates**: HTML templates for the web interface.
- **application.properties**: Application configuration properties.
- **data.sql** and **schema.sql**: Database initialization scripts.

### Tests
- **Unit Tests**: Located in `src/test/java/com/binance`, covering controllers, services, and repositories.
- **Integration Tests**: Validate the integration of components.

## Deployment

### Kubernetes
- **deployment.yaml**: Defines the deployment configuration.
- **service.yaml**: Configures the service for accessing the application.
- **configmap.yaml**: Manages configuration data for the application.

### Docker
- **Dockerfile**: Defines the Docker image for the application.

### CI/CD
- **GitHub Actions**: Automated workflows defined in `.github/workflows/ci.yml`.
- **Jenkinsfile**: Pipeline configuration for Jenkins (if applicable).

## Getting Started

1. **Build the Project**:
   ```sh
   mvn clean install -s custom-settings.xml
   ```

2. **Run the Application**:
   ```sh
   mvn spring-boot:run
   ```

3. **Access the Web UI**:
   - Open your browser and navigate to `http://localhost:8080/`.

4. **Deploy to Kubernetes**:
   - Use the provided `deploy.sh` script to deploy the application to your Kubernetes cluster.

## Testing

To run the tests, use the following command:
```sh
mvn test
```

## Contributing

Contributions are welcome! Please fork the repository and submit a pull request. Ensure that your code adheres to the project's coding standards and includes appropriate tests.

## License

This project is licensed under the MIT License. 