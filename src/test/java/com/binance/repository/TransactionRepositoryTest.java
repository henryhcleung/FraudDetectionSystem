package com.binance.repository;

import com.binance.model.Transaction;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;

import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;

@DataJpaTest
public class TransactionRepositoryTest {

    @Autowired
    private TransactionRepository transactionRepository;

    @Test
    public void testFindById() {
        Transaction transaction = new Transaction();
        transaction.setDetails("Test Transaction");
        transaction = transactionRepository.save(transaction);

        Optional<Transaction> foundTransaction = transactionRepository.findById(transaction.getId());
        assertThat(foundTransaction).isPresent();
    }

    @Test
    public void testSave() {
        Transaction transaction = new Transaction();
        transaction.setDetails("Test Transaction");
        Transaction savedTransaction = transactionRepository.save(transaction);

        assertThat(savedTransaction).isNotNull();
        assertThat(savedTransaction.getId()).isNotNull();
    }

    @Test
    public void testDeleteById() {
        Transaction transaction = new Transaction();
        transaction.setDetails("Test Transaction");
        transaction = transactionRepository.save(transaction);

        transactionRepository.deleteById(transaction.getId());
        Optional<Transaction> deletedTransaction = transactionRepository.findById(transaction.getId());
        assertThat(deletedTransaction).isNotPresent();
    }
}