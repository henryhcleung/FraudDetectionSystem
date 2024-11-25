package com.binance.controller;

import com.binance.model.ListNode;
import com.binance.model.Transaction;
import com.binance.service.CycleDetectionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/cycle-detection")
public class CycleDetectionController {

    @Autowired
    private CycleDetectionService cycleDetectionService;

    @PostMapping("/detect")
    public ResponseEntity<Boolean> detectCycle(@RequestBody ListNode head) {
        boolean hasCycle = cycleDetectionService.detectCycle(head);
        return ResponseEntity.ok(hasCycle);
    }

    @GetMapping("/transactions")
    public ResponseEntity<List<Transaction>> getAllTransactions() {
        List<Transaction> transactions = cycleDetectionService.getAllTransactions();
        return ResponseEntity.ok(transactions);
    }

    @GetMapping("/transactions/{id}")
    public ResponseEntity<Optional<Transaction>> getTransactionById(@PathVariable Long id) {
        Optional<Transaction> transaction = cycleDetectionService.getTransactionById(id);
        return ResponseEntity.ok(transaction);
    }

    @PostMapping("/transactions")
    public ResponseEntity<Transaction> saveTransaction(@RequestBody Transaction transaction) {
        cycleDetectionService.saveTransaction(transaction);
        return ResponseEntity.ok(transaction);
    }

    @DeleteMapping("/transactions/{id}")
    public ResponseEntity<Void> deleteTransaction(@PathVariable Long id) {
        cycleDetectionService.deleteTransaction(id);
        return ResponseEntity.noContent().build();
    }

}