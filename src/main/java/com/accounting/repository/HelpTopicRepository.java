package com.accounting.repository;

import com.accounting.model.HelpTopic;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface HelpTopicRepository extends JpaRepository<HelpTopic, Long> {
    List<HelpTopic> findByTitleContaining(String query);
    List<HelpTopic> findByContentContaining(String query);
    List<HelpTopic> findByCategory(String category);
    List<HelpTopic> findByRelatedTopicsContaining(String tag);
} 