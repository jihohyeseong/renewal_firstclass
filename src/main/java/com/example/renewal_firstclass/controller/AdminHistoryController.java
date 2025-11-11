package com.example.renewal_firstclass.controller;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.renewal_firstclass.domain.AdminHistoryDTO;
import com.example.renewal_firstclass.domain.CompSearchDTO;
import com.example.renewal_firstclass.domain.PageDTO;
import com.example.renewal_firstclass.service.AdminHistoryService;

import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/admin")
@RequiredArgsConstructor
public class AdminHistoryController {

    private final AdminHistoryService adminHistoryService;
    
    @InitBinder
    public void initBinder(WebDataBinder binder) {
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        dateFormat.setLenient(false);
        binder.registerCustomEditor(Date.class, new CustomDateEditor(dateFormat, true));
    }
    
    @GetMapping("/history")
    public String getHistoryList(
            @ModelAttribute("search") CompSearchDTO searchDTO, 
            @RequestParam(value = "pageNum", defaultValue = "1") int pageNum,
            @RequestParam(value = "listSize", defaultValue = "10") int listSize,
            Model model) {
        
        PageDTO pageDTO = new PageDTO(pageNum, listSize);
        searchDTO.setPageDTO(pageDTO);

        List<AdminHistoryDTO> historyList = adminHistoryService.getMergedHistoryList(searchDTO);

        model.addAttribute("list", historyList);
        model.addAttribute("pageDTO", pageDTO);

        return "admin/adminhistory";
    }
}