package com.example.renewal_firstclass.controller;

import org.springframework.security.core.Authentication;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

import com.example.renewal_firstclass.domain.AdminSuperCheckDTO;
import com.example.renewal_firstclass.domain.CustomUserDetails;
import com.example.renewal_firstclass.service.AdminSuperiorService;

import lombok.RequiredArgsConstructor;

@ControllerAdvice
@RequiredArgsConstructor
public class GlobalControllerAdvice {
    
    private final AdminSuperiorService adminSuperiorService;
    
    @ModelAttribute
    public void addAdminCheckToModel(Authentication authentication, Model model) {
        if (authentication != null && authentication.isAuthenticated() 
            && authentication.getPrincipal() instanceof CustomUserDetails) {
            
            String username = ((CustomUserDetails) authentication.getPrincipal()).getUsername();
            Long centerId = adminSuperiorService.getCenterIdByUsername(username);
            String centerPosition = adminSuperiorService.getCenterPositionByUsername(username);
            
            AdminSuperCheckDTO checkDto = new AdminSuperCheckDTO();
            checkDto.setCenterId(centerId);
            checkDto.setCenterPosition(centerPosition);
            
            model.addAttribute("adminCheck", checkDto);
        }
    }
}