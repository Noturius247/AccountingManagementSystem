package com.accounting.repository;

import com.accounting.model.AcademicInfo;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface AcademicInfoRepository extends JpaRepository<AcademicInfo, Long> {
    List<AcademicInfo> findByIsActiveTrue();
    List<AcademicInfo> findByAcademicYearAndSemester(String academicYear, String semester);
    List<AcademicInfo> findByProgram(String program);
    List<AcademicInfo> findByYearLevel(int yearLevel);
} 