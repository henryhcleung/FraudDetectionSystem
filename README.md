```
FRAUDDETECTIONSYSTEM
├── fraud-detection-service
│   ├── src
│   │   ├── main
│   │   │   ├── java/com/binance/frauddetection
│   │   │   │   ├── config
│   │   │   │   │   └── SecurityConfig.java
│   │   │   │   ├── controller
│   │   │   │   │   ├── CycleDetectionController.java
│   │   │   │   │   └── LoginController.java
│   │   │   │   ├── model
│   │   │   │   │   ├── ListNode.java
│   │   │   │   │   └── Transaction.java
│   │   │   │   ├── repository
│   │   │   │   │   └── TransactionRepository.java
│   │   │   │   └── service
│   │   │   │       ├── CustomUserDetailsService.java
│   │   │   │       └── CycleDetectionService.java
│   │   │   ├── resources
│   │   │   │   ├── templates
│   │   │   │   │   ├── index.html
│   │   │   │   │   └── login.html
│   │   │   │   ├── application.properties
│   │   │   │   ├── data.sql
│   │   │   │   └── schema.sql
│   ├── test
│   │   ├── java/com/binance/frauddetection
│   │   │   ├── controller
│   │   │   │   └── CycleDetectionControllerTest.java
│   │   │   ├── integration
│   │   │   │   ├── CycleDetectionIntegrationTest.java
│   │   │   │   └── LoginIntegrationTest.java
│   │   │   ├── repository
│   │   │   │   └── TransactionRepositoryTest.java
│   │   │   └── service
│   │   │       └── CycleDetectionServiceTest.java
├── config-service
│   ├── src
│   │   ├── main
│   │   │   ├── java/com/binance/config
│   │   │   │   └── ConfigServiceApplication.java
│   │   ├── resources
│   │   │   ├── application.yml
│   │   │   └── bootstrap.yml
├── eureka-server
│   ├── src
│   │   ├── main
│   │   │   ├── java/com/binance/eureka
│   │   │   │   └── EurekaServerApplication.java
│   │   ├── resources
│   │   │   ├── application.yml
├── gateway-service
│   ├── src
│   │   ├── main
│   │   │   ├── java/com/binance/gateway
│   │   │   │   └── GatewayServiceApplication.java
│   │   ├── resources
│   │   │   ├── application.yml
├── docker-compose.yml
├── .gitignore
├── custom-settings.xml
├── pom.xml
└── README.md
```

## Components

### Fraud Detection Service
- **Config**
  - **SecurityConfig.java**: Configuration for security settings.
- **Controller**
  - **CycleDetectionController.java**: Handles requests related to cycle detection and transaction management.
  - **LoginController.java**: Manages user login and authentication.
- **Model**
  - **ListNode.java**: Represents a node in a linked list.
  - **Transaction.java**: Represents a transaction entity.
- **Repository**
  - **TransactionRepository.java**: Interface for CRUD operations on transactions.
- **Service**
  - **CustomUserDetailsService.java**: Service for user details and authentication.
  - **CycleDetectionService.java**: Contains business logic for cycle detection and transaction management.
- **Resources**
  - **templates/index.html**: Web interface for cycle detection and transaction management.
  - **templates/login.html**: Web interface for user login.
  - **application.properties**: Configuration properties for the application.
  - **data.sql**: Initial data for the database.
  - **schema.sql**: Database schema definition.
- **Tests**
  - **controller/CycleDetectionControllerTest.java**: Unit tests for `CycleDetectionController`.
  - **integration/CycleDetectionIntegrationTest.java**: Integration tests for cycle detection functionality.
  - **integration/LoginIntegrationTest.java**: Integration tests for login functionality.
  - **repository/TransactionRepositoryTest.java**: Unit tests for `TransactionRepository`.
  - **service/CycleDetectionServiceTest.java**: Unit tests for `CycleDetectionService`.

### Config Service
- **ConfigServiceApplication.java**: Main class for the configuration service.
- **application.yml**: Configuration properties for the config service.
- **bootstrap.yml**: Bootstrap configuration for the config service.

### Eureka Server
- **EurekaServerApplication.java**: Main class for the Eureka server.
- **application.yml**: Configuration properties for the Eureka server.

### Gateway Service
- **GatewayServiceApplication.java**: Main class for the API gateway.
- **application.yml**: Configuration properties for the gateway service.

## Running the Application

1. **Build the Project**:
   ```sh
   mvn clean install -s custom-settings.xml
   ```

2. **Start the Services**:
   ```sh
   docker-compose up --build
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
- Spring Cloud Config
- Spring Cloud Netflix Eureka
- Spring Cloud Gateway
- Spring Data JPA
- Spring Security
- H2 Database (for testing)
- Maven

## Contributing

Contributions are welcome! Please fork the repository and submit a pull request.

## License

This project is licensed under the MIT License.
