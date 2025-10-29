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
@RequestMapping("/admin/list")
@RequiredArgsConstructor
public class AdminListController {

    private final AdminListService adminListService;
    private final UserService userService;

    /** 현재 로그인 사용자 조회(캐스팅 없이 안전하게) */
    private UserDTO currentUserOrNull(Authentication auth) {
        if (auth == null || !auth.isAuthenticated()) return null;
        Object principal = auth.getPrincipal();
        if (principal instanceof String && "anonymousUser".equals(principal)) return null;
        String username = auth.getName();                 // 표준 접근
        return userService.findByUsername(username);      // 프로젝트에 맞게 구현된 서비스
    }

    @ResponseBody
    @GetMapping("/fetch")
    public Map<String, Object> fetchAdminList(
            @RequestParam(required = false) String docType,     // null|"APPLICATION"|"CONFIRM"
            @RequestParam(required = false) String keyword,     // 이름/번호 공통 검색
            @RequestParam(required = false) String date,        // YYYY-MM-DD
            @RequestParam(required = false) String statusName,  // 상태명(등록/제출/…)
            @RequestParam(required = false) String statusCode,  // ST_20 등 코드 직접 필터
            @RequestParam(defaultValue = "0") int startList,    // OFFSET
            @RequestParam(defaultValue = "10") int listSize,    // FETCH NEXT
            Authentication authentication                       // ★ 여기서 유저 정보 가져옴
    ) {
        // 1) 로그인 확인 + 유저 조회
        UserDTO me = currentUserOrNull(authentication);
        if (me == null || me.getId() == null) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "로그인이 필요합니다.");
        }

        // 2) 유저의 센터 ID 추출(필드명은 프로젝트에 맞춰 사용)
        Long centerId = me.getCenterId();   // UserDTO에 getCenterId()가 있다고 가정
        if (centerId == null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "센터 정보가 없습니다.");
        }

        // 3) 파라미터 구성(뷰에서 centerId는 보내지 않아도 됨)
        Map<String, Object> params = new HashMap<>();
        params.put("docType", docType);
        params.put("keyword", keyword);
        params.put("date", date);
        params.put("statusName", statusName);
        params.put("statusCode", statusCode);
        params.put("startList", startList);
        params.put("listSize", listSize);
        params.put("centerId", centerId);  // ★ 서버가 주입

        // 4) 조회
        List<AdminListDTO> list = adminListService.getApplyAndConfirmList(params);
        int totalCount = adminListService.getApplyAndConfirmCount(params);

        // 5) 응답
        Map<String, Object> result = new HashMap<>();
        result.put("list", list);
        result.put("totalCount", totalCount);
        return result;
    }
    
    @GetMapping("")
    public String adminListPage() {
        return "admin/adminlist";
    }
    


}
