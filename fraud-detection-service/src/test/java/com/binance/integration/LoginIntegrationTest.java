package com.binance.integration;

import com.binance.FraudDetectionServiceApplication;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.web.client.TestRestTemplate;
import org.springframework.http.ResponseEntity;

import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT, classes = FraudDetectionServiceApplication.class)
public class LoginIntegrationTest {

    @Autowired
    private TestRestTemplate restTemplate;

    @Test
    public void loginWithValidCredentials() {
        ResponseEntity<String> response = restTemplate.getForEntity("/login", String.class);
        assertThat(response.getBody()).contains("Fraud Detection System");
    }
}