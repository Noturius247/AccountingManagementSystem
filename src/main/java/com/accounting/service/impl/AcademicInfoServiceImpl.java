package com.accounting.service.impl;

import com.accounting.model.AcademicInfo;
import com.accounting.repository.AcademicInfoRepository;
import com.accounting.service.AcademicInfoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class AcademicInfoServiceImpl implements AcademicInfoService {

    @Autowired
    private AcademicInfoRepository academicInfoRepository;

    @Override
    @Transactional
    public AcademicInfo createAcademicInfo(AcademicInfo academicInfo, String username) {
        academicInfo.setCreatedBy(username);
        academicInfo.setActive(true);
        return academicInfoRepository.save(academicInfo);
    }

    @Override
    @Transactional
    public AcademicInfo updateAcademicInfo(Long id, AcademicInfo academicInfo, String username) {
        AcademicInfo existingInfo = academicInfoRepository.findById(id)
            .orElseThrow(() -> new RuntimeException("Academic Info not found"));
        
        existingInfo.setAcademicYear(academicInfo.getAcademicYear());
        existingInfo.setSemester(academicInfo.getSemester());
        existingInfo.setProgram(academicInfo.getProgram());
        existingInfo.setYearLevel(academicInfo.getYearLevel());
        existingInfo.setUpdatedBy(username);
        
        return academicInfoRepository.save(existingInfo);
    }

    @Override
    @Transactional
    public void deleteAcademicInfo(Long id) {
        AcademicInfo academicInfo = academicInfoRepository.findById(id)
            .orElseThrow(() -> new RuntimeException("Academic Info not found"));
        academicInfo.setActive(false);
        academicInfoRepository.save(academicInfo);
    }

    @Override
    public List<AcademicInfo> getAllActiveAcademicInfo() {
        return academicInfoRepository.findByIsActiveTrue();
    }

    @Override
    public AcademicInfo getAcademicInfoById(Long id) {
        return academicInfoRepository.findById(id)
            .orElseThrow(() -> new RuntimeException("Academic Info not found"));
    }

    @Override
    public List<AcademicInfo> getAcademicInfoByYearAndSemester(String academicYear, String semester) {
        return academicInfoRepository.findByAcademicYearAndSemester(academicYear, semester);
    }

    @Override
    public List<AcademicInfo> getAcademicInfoByProgram(String program) {
        return academicInfoRepository.findByProgram(program);
    }

    @Override
    public List<AcademicInfo> getAcademicInfoByYearLevel(int yearLevel) {
        return academicInfoRepository.findByYearLevel(yearLevel);
    }
} 