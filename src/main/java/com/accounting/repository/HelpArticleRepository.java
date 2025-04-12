package com.accounting.repository;

import com.accounting.model.HelpArticle;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface HelpArticleRepository extends JpaRepository<HelpArticle, Long> {
    @Query("SELECT h FROM HelpArticle h WHERE h.title LIKE %?1% OR h.content LIKE %?1%")
    List<HelpArticle> findByTitleContainingOrContentContaining(String query);
    
    List<HelpArticle> findByCategory(String category);
    
    @Query("SELECT h FROM HelpArticle h WHERE h.tags LIKE %?1%")
    List<HelpArticle> findByTagsContaining(String tag);

    List<HelpArticle> findByTitleContaining(String query);
    List<HelpArticle> findByContentContaining(String query);
} 