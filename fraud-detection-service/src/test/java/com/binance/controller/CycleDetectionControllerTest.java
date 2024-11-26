package com.binance.controller;

import com.binance.model.ListNode;
import com.binance.model.Transaction;
import com.binance.service.CycleDetectionService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;

import java.util.Arrays;
import java.util.List;
import java.util.Optional;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.Mockito.doNothing;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

public class CycleDetectionControllerTest {

    private MockMvc mockMvc;

    @Mock
    private CycleDetectionService cycleDetectionService;

    @InjectMocks
    private CycleDetectionController cycleDetectionController;

    @BeforeEach
    public void setUp() {
        MockitoAnnotations.openMocks(this);
        mockMvc = MockMvcBuilders.standaloneSetup(cycleDetectionController).build();
    }

    @Test
    public void testDetectCycle() throws Exception {
        ListNode node1 = new ListNode(1);
        ListNode node2 = new ListNode(2);
        node1.next = node2;
        node2.next = node1; // Create a cycle

        when(cycleDetectionService.detectCycle(any(ListNode.class))).thenReturn(true);

        mockMvc.perform(post("/api/cycle-detection/detect")
                .contentType(MediaType.APPLICATION_JSON)
                .content("{\"val\":1,\"next\":{\"val\":2,\"next\":{\"val\":1}}}"))
                .andExpect(status().isOk())
                .andExpect(content().string("true"));
    }

    @Test
    public void testGetAllTransactions() throws Exception {
        Transaction transaction1 = new Transaction();
        transaction1.setId(1L);
        transaction1.setDetails("Transaction 1");

        Transaction transaction2 = new Transaction();
        transaction2.setId(2L);
        transaction2.setDetails("Transaction 2");

        List<Transaction> transactions = Arrays.asList(transaction1, transaction2);

        when(cycleDetectionService.getAllTransactions()).thenReturn(transactions);

        mockMvc.perform(get("/api/cycle-detection/transactions"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$[0].id").value(1L))
                .andExpect(jsonPath("$[0].details").value("Transaction 1"))
                .andExpect(jsonPath("$[1].id").value(2L))
                .andExpect(jsonPath("$[1].details").value("Transaction 2"));
    }

    @Test
    public void testGetTransactionById() throws Exception {
        Transaction transaction = new Transaction();
        transaction.setId(1L);
        transaction.setDetails("Transaction 1");

        when(cycleDetectionService.getTransactionById(anyLong())).thenReturn(Optional.of(transaction));

        mockMvc.perform(get("/api/cycle-detection/transactions/1"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.id").value(1L))
                .andExpect(jsonPath("$.details").value("Transaction 1"));
    }

    @Test
    public void testSaveTransaction() throws Exception {
        Transaction transaction = new Transaction();
        transaction.setId(1L);
        transaction.setDetails("Transaction 1");

        when(cycleDetectionService.saveTransaction(any(Transaction.class))).thenReturn(transaction);

        mockMvc.perform(post("/api/cycle-detection/transactions")
                .contentType(MediaType.APPLICATION_JSON)
                .content("{\"details\":\"Transaction 1\"}"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.id").value(1L))
                .andExpect(jsonPath("$.details").value("Transaction 1"));
    }

    @Test
    public void testDeleteTransaction() throws Exception {
        doNothing().when(cycleDetectionService).deleteTransaction(anyLong());

        mockMvc.perform(delete("/api/cycle-detection/transactions/1"))
                .andExpect(status().isNoContent());
    }
}