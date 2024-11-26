package com.binance.model;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonProperty;

public class ListNode {
    public int val;
    public ListNode next;

    public ListNode() {
    }

    @JsonCreator
    public ListNode(@JsonProperty("val") int val) {
        this.val = val;
    }
}