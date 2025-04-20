package com.accounting.controller;

import com.accounting.model.AcademicInfo;
import com.accounting.service.AcademicInfoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import java.security.Principal;
import java.util.List;

@Controller
@RequestMapping("/admin/academic-info")
@PreAuthorize("hasRole('ADMIN')")
public class AdminAcademicInfoController {

    @Autowired
    private AcademicInfoService academicInfoService;

    @GetMapping
    public String listAcademicInfo(Model model) {
        List<AcademicInfo> academicInfoList = academicInfoService.getAllActiveAcademicInfo();
        model.addAttribute("academicInfoList", academicInfoList);
        return "admin/academic-info/list";
    }

    @GetMapping("/new")
    public String showCreateForm(Model model) {
        model.addAttribute("academicInfo", new AcademicInfo());
        return "admin/academic-info/form";
    }

    @PostMapping
    public String createAcademicInfo(@ModelAttribute AcademicInfo academicInfo, Principal principal) {
        academicInfoService.createAcademicInfo(academicInfo, principal.getName());
        return "redirect:/admin/academic-info";
    }

    @GetMapping("/{id}/edit")
    public String showEditForm(@PathVariable Long id, Model model) {
        AcademicInfo academicInfo = academicInfoService.getAcademicInfoById(id);
        model.addAttribute("academicInfo", academicInfo);
        return "admin/academic-info/form";
    }

    @PostMapping("/{id}")
    public String updateAcademicInfo(@PathVariable Long id, @ModelAttribute AcademicInfo academicInfo, Principal principal) {
        academicInfoService.updateAcademicInfo(id, academicInfo, principal.getName());
        return "redirect:/admin/academic-info";
    }

    @PostMapping("/{id}/delete")
    public String deleteAcademicInfo(@PathVariable Long id) {
        academicInfoService.deleteAcademicInfo(id);
        return "redirect:/admin/academic-info";
    }
} 