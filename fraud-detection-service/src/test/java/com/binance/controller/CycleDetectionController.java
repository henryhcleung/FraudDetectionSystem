package com.binance.controller;

import com.binance.model.ListNode;
import com.binance.service.CycleDetectionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/detectCycle")
public class CycleDetectionController {

    @Autowired
    private CycleDetectionService cycleDetectionService;

    @PostMapping
    public ResponseEntity<String> detectCycle(@RequestBody ListNode head) {
        boolean hasCycle = cycleDetectionService.detectCycle(head);
        if (hasCycle) {
            return ResponseEntity.ok("Cycle Detected.");
        } else {
            return ResponseEntity.ok("No Cycle Detected.");
        }
    }
}