package com.accounting.service;

import com.accounting.model.AcademicInfo;
import java.util.List;

public interface AcademicInfoService {
    AcademicInfo createAcademicInfo(AcademicInfo academicInfo, String username);
    AcademicInfo updateAcademicInfo(Long id, AcademicInfo academicInfo, String username);
    void deleteAcademicInfo(Long id);
    List<AcademicInfo> getAllActiveAcademicInfo();
    AcademicInfo getAcademicInfoById(Long id);
    List<AcademicInfo> getAcademicInfoByYearAndSemester(String academicYear, String semester);
    List<AcademicInfo> getAcademicInfoByProgram(String program);
    List<AcademicInfo> getAcademicInfoByYearLevel(int yearLevel);
} 