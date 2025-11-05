package com.example.renewal_firstclass.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.renewal_firstclass.domain.AdminChildListDTO;
import com.example.renewal_firstclass.domain.PageDTO;
import com.example.renewal_firstclass.service.AdminChildSearchService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class AdminChildSearchController {
	
	private final AdminChildSearchService adminChildSearchService;
	
	@GetMapping("/admin/childsearch") 
    public String showChildList(
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int size,
            Model model) {
        
        PageDTO pageDTO = new PageDTO(page, size);
        List<AdminChildListDTO> list = adminChildSearchService.getPagedChildList(
                "ALL", null, null, pageDTO); 

        model.addAttribute("childList", list);
        model.addAttribute("pageDTO", pageDTO);
        model.addAttribute("status", "ALL"); 
        
        return "admin/adminchildsearch";
    }

    @PostMapping("/admin/childsearch") 
    public String searchChildList( 
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(defaultValue = "ALL") String status,
            @RequestParam(required = false) String nameKeyword,
            @RequestParam(required = false) String regNoKeyword,
            Model model) {

        PageDTO pageDTO = new PageDTO(page, size);

        List<AdminChildListDTO> list = adminChildSearchService.getPagedChildList(
                status, nameKeyword, regNoKeyword, pageDTO);

        model.addAttribute("childList", list);
        model.addAttribute("pageDTO", pageDTO);
        model.addAttribute("status", status);
        model.addAttribute("nameKeyword", nameKeyword);
        model.addAttribute("regNoKeyword", regNoKeyword);

        return "admin/adminchildsearch";
    }

}
