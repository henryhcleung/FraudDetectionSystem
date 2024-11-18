# FraudDetectionSystem

## Overview

The FraudDetectionSystem is a Java-based application designed to detect cycles in linked lists and manage transactions. It uses Spring Boot for the backend and provides a web interface for user interaction.

## Project Structure

```
FRAUDDETECTIONSYSTEM
├── src
│   ├── main
│   │   ├── java/com/binance
│   │   │   ├── config
│   │   │   │   └── SecurityConfig.java
│   │   │   ├── controller
│   │   │   │   ├── CycleDetectionController.java
│   │   │   │   └── LoginController.java
│   │   │   ├── model
│   │   │   │   ├── ListNode.java
│   │   │   │   └── Transaction.java
│   │   │   ├── repository
│   │   │   │   └── TransactionRepository.java
│   │   │   └── service
│   │   │       ├── CustomUserDetailsService.java
│   │   │       └── CycleDetectionService.java
│   │   ├── resources
│   │   │   ├── templates
│   │   │   │   ├── index.html
│   │   │   │   └── login.html
│   │   │   ├── application.properties
│   │   │   ├── data.sql
│   │   │   └── schema.sql
│   ├── test
│   │   ├── java/com/binance
│   │   │   ├── controller
│   │   │   │   └── CycleDetectionControllerTest.java
│   │   │   ├── integration
│   │   │   │   ├── CycleDetectionIntegrationTest.java
│   │   │   │   └── LoginIntegrationTest.java
│   │   │   ├── repository
│   │   │   │   └── TransactionRepositoryTest.java
│   │   │   └── service
│   │   │       └── CycleDetectionServiceTest.java
├── target
├── .gitignore
├── custom-settings.xml
├── pom.xml
└── README.md
```

## Components

### Config
- **SecurityConfig.java**: Configuration for security settings.

### Controller
- **CycleDetectionController.java**: Handles requests related to cycle detection and transaction management.
- **LoginController.java**: Manages user login and authentication.

### Model
- **ListNode.java**: Represents a node in a linked list.
- **Transaction.java**: Represents a transaction entity.

### Repository
- **TransactionRepository.java**: Interface for CRUD operations on transactions.

### Service
- **CustomUserDetailsService.java**: Service for user details and authentication.
- **CycleDetectionService.java**: Contains business logic for cycle detection and transaction management.

### Resources
- **templates/index.html**: Web interface for cycle detection and transaction management.
- **templates/login.html**: Web interface for user login.
- **application.properties**: Configuration properties for the application.
- **data.sql**: Initial data for the database.
- **schema.sql**: Database schema definition.

### Tests
- **controller/CycleDetectionControllerTest.java**: Unit tests for `CycleDetectionController`.
- **integration/CycleDetectionIntegrationTest.java**: Integration tests for cycle detection functionality.
- **integration/LoginIntegrationTest.java**: Integration tests for login functionality.
- **repository/TransactionRepositoryTest.java**: Unit tests for `TransactionRepository`.
- **service/CycleDetectionServiceTest.java**: Unit tests for `CycleDetectionService`.

## Running the Application

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

## Testing

To run the tests, use the following command:
```sh
mvn test
```

## Dependencies

The project uses the following dependencies:
- Spring Boot
- Spring Data JPA
- Spring Security
- H2 Database (for testing)
- Maven

## Contributing

Contributions are welcome! Please fork the repository and submit a pull request.

## License

This project is licensed under the MIT License.