package com.example.renewal_firstclass.controller;

import com.example.renewal_firstclass.domain.AdminListDTO;
import com.example.renewal_firstclass.domain.UserDTO;
import com.example.renewal_firstclass.service.AdminListService;
import com.example.renewal_firstclass.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequiredArgsConstructor
public class AdminListController {

    private final AdminListService adminListService;
    private final UserService userService;

    private UserDTO currentUserOrNull(Authentication auth) {
        if (auth == null || !auth.isAuthenticated()) return null;
        Object principal = auth.getPrincipal();
        if (principal instanceof String && "anonymousUser".equals(principal)) return null;
        String username = auth.getName();
        return userService.findByUsername(username);
    }

    @ResponseBody
    @GetMapping("/admin/list/fetch")
    public Map<String, Object> fetchAdminList(
            @RequestParam(required = false) String docType,
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) String date,
            @RequestParam(required = false) String statusName,
            @RequestParam(required = false) String statusCode,
            @RequestParam(defaultValue = "0") int startList,
            @RequestParam(defaultValue = "10") int listSize,
            Authentication authentication
    ) {
        UserDTO me = currentUserOrNull(authentication);
        if (me == null || me.getId() == null) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "로그인이 필요합니다.");
        }

        Long centerId = me.getCenterId(); 
        if (centerId == null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "센터 정보가 없습니다.");
        }
        Map<String, Object> params = new HashMap<>();
        params.put("docType", docType);
        params.put("keyword", keyword);
        params.put("date", date);
        params.put("statusName", statusName);
        params.put("statusCode", statusCode);
        params.put("startList", startList);
        params.put("listSize", listSize);
        params.put("centerId", centerId);

        List<AdminListDTO> list = adminListService.getApplyAndConfirmList(params);
        int totalCount = adminListService.getApplyAndConfirmCount(params);

        Map<String, Object> result = new HashMap<>();
        result.put("list", list);
        result.put("totalCount", totalCount);
        return result;
    }
    
    @GetMapping("/admin/list")
    public String adminListPage() {
        return "admin/adminlist";
    }
    


}
