package com.accounting.repository;

import com.accounting.model.QueueInfo;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface QueueInfoRepository extends JpaRepository<QueueInfo, Long> {
    Optional<QueueInfo> findByQueueNumber(String queueNumber);
    Optional<QueueInfo> findByUsername(String username);
    List<QueueInfo> findByStatusOrderByEntryTimeAsc(String status);
    List<QueueInfo> findByStatus(String status);
    Optional<QueueInfo> findFirstByStatusOrderByEntryTimeAsc(String status);
} 