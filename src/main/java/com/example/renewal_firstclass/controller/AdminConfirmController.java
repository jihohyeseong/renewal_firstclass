package com.example.renewal_firstclass.controller;

import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.renewal_firstclass.domain.PageDTO;
import com.example.renewal_firstclass.service.AdminListService;

import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/admin")
@RequiredArgsConstructor
public class AdminConfirmController {

    @GetMapping("/confirm")
    public String confirm() {
    	return "adminconfirm";
    }
}