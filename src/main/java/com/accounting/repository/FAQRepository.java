package com.accounting.repository;

import com.accounting.model.FAQ;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface FAQRepository extends JpaRepository<FAQ, Long> {
    List<FAQ> findByQuestionContaining(String query);
    List<FAQ> findByAnswerContaining(String query);
    List<FAQ> findByCategory(String category);
    
    @Query("SELECT f FROM FAQ f WHERE f.question LIKE %:query% OR f.answer LIKE %:query%")
    List<FAQ> findByQuestionContainingOrAnswerContaining(@Param("query") String query);
} 