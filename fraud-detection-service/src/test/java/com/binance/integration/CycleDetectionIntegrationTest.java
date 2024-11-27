package com.binance.integration;

import com.binance.model.ListNode;
import com.binance.FraudDetectionServiceApplication;
import com.binance.service.CycleDetectionService;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;

import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest(classes = FraudDetectionServiceApplication.class)
@ActiveProfiles("test")
public class CycleDetectionIntegrationTest {

    @Autowired
    private CycleDetectionService cycleDetectionService;

    @Test
    public void detectCycle() {
        ListNode node1 = new ListNode(1);
        ListNode node2 = new ListNode(2);
        ListNode node3 = new ListNode(3);
        ListNode node4 = new ListNode(4);
        ListNode node5 = new ListNode(5);
        node1.next = node2;
        node2.next = node3;
        node3.next = node4;
        node4.next = node5;
        node5.next = node3;

        boolean hasCycle = cycleDetectionService.detectCycle(node1);
        assertThat(hasCycle).isTrue();
    }
}