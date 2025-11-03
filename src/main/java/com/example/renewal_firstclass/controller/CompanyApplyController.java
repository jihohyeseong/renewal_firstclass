package com.example.renewal_firstclass.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.validation.Valid;

import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.example.renewal_firstclass.domain.ConfirmApplyDTO;
import com.example.renewal_firstclass.domain.ConfirmListDTO;
import com.example.renewal_firstclass.domain.CustomUserDetails; // 프로젝트 경로 맞게
import com.example.renewal_firstclass.domain.UserDTO;
import com.example.renewal_firstclass.service.CompanyApplyService;
import com.example.renewal_firstclass.service.UserService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class CompanyApplyController {

    private final CompanyApplyService companyApplyService;
    private final UserService userService;

    
/*     메인 
    @GetMapping("/comp/main")
    public String main(@RequestParam(defaultValue = "1") int page,
                       @RequestParam(defaultValue = "10") int size,
                       Model model) {

        UserDTO user = currentUserOrNull();
        if (user == null || user.getId() == null) {
            return "redirect:/login";
        }

        // 전체 건수 & 목록
        int total = companyApplyService.countByUser(user.getId());
        int totalPages = (int) Math.ceil((double) total / Math.max(1, size));

        // 페이지 경계 보정
        if (page < 1) page = 1;
        if (totalPages > 0 && page > totalPages) page = totalPages;

        model.addAttribute("confirmList", companyApplyService.getListByUser(user.getId(), page, size));
        model.addAttribute("userDTO",user);
        model.addAttribute("page", page);
        model.addAttribute("size", size);
        model.addAttribute("total", total);
        model.addAttribute("totalPages", totalPages);

        return "company/compmain";
    }*/
    
    /* 메인 */
    @GetMapping("/comp/main")
    public String mainPage(@RequestParam(defaultValue = "1") int page,
                           @RequestParam(defaultValue = "10") int size,
                           Model model) {

        UserDTO user = currentUserOrNull();
        if (user == null || user.getId() == null) {
            return "redirect:/login";
        }

        // 기본 목록용 (검색조건 없음)
        int total = companyApplyService.countConfirmList(user.getId());
        int totalPages = (int) Math.ceil((double) total / Math.max(1, size));
        if (page < 1) page = 1;
        if (totalPages > 0 && page > totalPages) page = totalPages;

        List<ConfirmListDTO> list = companyApplyService.getConfirmList(user.getId(), page, size);

        model.addAttribute("confirmList", list);
        model.addAttribute("userDTO", user);
        model.addAttribute("status", "ALL");
        model.addAttribute("nameKeyword", null);
        model.addAttribute("regNoKeyword", null);
        model.addAttribute("page", page);
        model.addAttribute("size", size);
        model.addAttribute("total", total);
        model.addAttribute("totalPages", totalPages);

        return "company/compmain";
    }
    /*메인에서검색*/
    @PostMapping("/comp/search")
    public String search(@RequestParam(defaultValue = "ALL") String status,
                         @RequestParam(required = false) String nameKeyword,
                         @RequestParam(required = false) String regNoKeyword,
                         @RequestParam(defaultValue = "1") int page,
                         @RequestParam(defaultValue = "10") int size,
                         Model model) {

        UserDTO user = currentUserOrNull();
        if (user == null || user.getId() == null) {
            return "redirect:/login";
        }

        boolean hasKeyword = (nameKeyword != null) ||
                             (regNoKeyword != null);

        int total;
        List<ConfirmListDTO> list;

        if (hasKeyword) {
            total = companyApplyService.countConfirmList(user.getId(), status, nameKeyword, regNoKeyword);
            list = companyApplyService.getConfirmList(user.getId(), status, nameKeyword, regNoKeyword, page, size);
        } else {
            total = companyApplyService.countConfirmList(user.getId());
            list = companyApplyService.getConfirmList(user.getId(), page, size);
        }

        int totalPages = (int) Math.ceil((double) total / Math.max(1, size));
        if (page < 1) page = 1;
        if (totalPages > 0 && page > totalPages) page = totalPages;

        model.addAttribute("confirmList", list);
        model.addAttribute("userDTO", user);
        model.addAttribute("status", status);
        model.addAttribute("nameKeyword", nameKeyword);
        model.addAttribute("regNoKeyword", regNoKeyword);
        model.addAttribute("page", page);
        model.addAttribute("size", size);
        model.addAttribute("total", total);
        model.addAttribute("totalPages", totalPages);

        return "company/compmain";
    }




    

    private UserDTO currentUserOrNull() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth == null || !auth.isAuthenticated() || "anonymousUser".equals(auth.getPrincipal())) {
            return null;
        }
        CustomUserDetails ud = (CustomUserDetails) auth.getPrincipal();
        return userService.findByUsername(ud.getUsername());
    }
    
    
    /* 작성 화면  */
    @GetMapping("/comp/apply")
    public String compApply(Model model) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String username = auth.getName();
        UserDTO user = userService.findByUsername(username);

        if (!model.containsAttribute("form")) {
            ConfirmApplyDTO form = new ConfirmApplyDTO();
            form.setUserId(user.getId());
            model.addAttribute("form", form);
        }
        model.addAttribute("userDTO", user);
        return "company/compapply";
    }
    
    /*주민번호로이름찾기*/
    @PostMapping("/comp/apply/find-name")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> findName(@RequestParam String regNo) {
        String name = userService.findNameByRegistrationNumber(regNo);
        boolean found = (name != null);

        Map<String, Object> body = new HashMap<>();
        body.put("found", found);
        if (found) body.put("name", name);
        else body.put("name", null);

        return ResponseEntity.ok(body);
    }
    
    @PostMapping("/comp/apply/leave-period")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> leavePeriod(@RequestBody Map<String, String> body) {
        String name = (body != null) ? body.get("name") : null;
        String regNo = (body != null) ? body.get("regNo") : null;

        Map<String, Object> res = companyApplyService.findLatestPeriodByPerson(name, regNo);

        return ResponseEntity.ok(res == null || res.isEmpty() ? null : res);
    }


    /* 저장(임시저장) + 단위기간 생성 */
    @PostMapping("/comp/apply/save")
    public String compSave(@Valid @ModelAttribute("form") ConfirmApplyDTO form,
                            BindingResult binding,
                            java.security.Principal principal,
                            RedirectAttributes ra, 
                            @RequestParam(name="monthlyCompanyPay", required=false) List<String> monthlyCompanyPayRaw) {
        if (principal == null) {
            ra.addFlashAttribute("error", "로그인이 필요합니다.");
            return "redirect:/login";
        }

        // 로그인 사용자 -> userId 주입
        Long userId = userService.findByUsername(principal.getName()).getId();
        form.setUserId(userId);
        
        if (form.getChildBirthDate() != null && "".equals(form.getChildBirthDate().toString().trim())) {
            form.setChildBirthDate(null);
        }
        if (form.getCenterId() == null) form.setCenterId(1L);

        if (binding.hasErrors()) {
            Map<String, String> errors = new LinkedHashMap<>();
            for (FieldError fe : binding.getFieldErrors()) {
                errors.putIfAbsent(fe.getField(), fe.getDefaultMessage());
            }
            ra.addFlashAttribute("form", form);
            ra.addFlashAttribute("errors", errors);
            return "redirect:/comp/apply";
        }
        
        List<Long> monthlyCompanyPay = new ArrayList<>();
        if (monthlyCompanyPayRaw != null) {
            for (String s : monthlyCompanyPayRaw) {
                String digits = (s == null) ? "" : s.replaceAll("[^0-9]", "");
                monthlyCompanyPay.add(digits.isEmpty() ? 0L : Long.parseLong(digits));
            }
        }

        try {
            Long confirmNumber = companyApplyService.createConfirm(form,monthlyCompanyPay);
            ra.addFlashAttribute("message", "임시저장 완료 (확인서 ID: " + confirmNumber + ")");
            return "redirect:/comp/detail?confirmNumber=" + confirmNumber;
        } catch (Exception e) {
            ra.addFlashAttribute("form", form);
            ra.addFlashAttribute("error", "임시저장 중 오류: " + e.getMessage());
            return "redirect:/comp/apply";
        }
    }

    /* 제출*/
    @PostMapping("/comp/submit")
    public String submit(@RequestParam("confirmNumber") Long confirmNumber,
                         java.security.Principal principal,
                         RedirectAttributes ra) {
        if (principal == null) {
            ra.addFlashAttribute("error", "로그인이 필요합니다.");
            return "redirect:/login";
        }
        try {
            Long userId = userService.findByUsername(principal.getName()).getId();
            companyApplyService.submitConfirm(confirmNumber, userId);
            ra.addFlashAttribute("message", "제출이 완료되었습니다.");
            return "redirect:/comp/complete?confirmNumber=" + confirmNumber;
        } catch (Exception e) {
            ra.addFlashAttribute("error", "제출 실패: " + e.getMessage());
            return "redirect:/comp/detail?confirmNumber=" + confirmNumber;
        }
    }
    
    @GetMapping("/comp/complete")
    public String compComplete(@RequestParam("confirmNumber") Long confirmNumber,
                             @AuthenticationPrincipal CustomUserDetails me,
                             Model model,
                             RedirectAttributes ra) {
        if (me == null) {
            ra.addFlashAttribute("error", "로그인이 필요합니다.");
            return "redirect:/login";
        }

        try {
            ConfirmApplyDTO confirmDTO = companyApplyService.findByConfirmNumber(confirmNumber);

            if (confirmDTO == null) {
                ra.addFlashAttribute("error", "확인서를 찾을 수 없습니다.");
                return "redirect:/comp/main";
            }
            model.addAttribute("confirmDTO", confirmDTO);
            return "company/compcomplete";

        } catch (Exception e) {
            ra.addFlashAttribute("error", "상세 조회 중 오류 발생: " + e.getMessage());
            return "redirect:/comp/main";
        }
    }


    /* 상세 화면*/
    @GetMapping("/comp/detail")
    public String compDetail(@RequestParam("confirmNumber") Long confirmNumber,
                             @AuthenticationPrincipal CustomUserDetails me,
                             Model model,
                             RedirectAttributes ra) {
        if (me == null) {
            ra.addFlashAttribute("error", "로그인이 필요합니다.");
            return "redirect:/login";
        }

        try {
            ConfirmApplyDTO confirmDTO = companyApplyService.findByConfirmNumber(confirmNumber);
            ConfirmApplyDTO dto = companyApplyService.findByConfirmNumber(confirmNumber);
            if (confirmDTO == null) {
                ra.addFlashAttribute("error", "확인서를 찾을 수 없습니다.");
                return "redirect:/comp/main";
            }
            model.addAttribute("termList", dto.getTermAmounts()); 
            model.addAttribute("confirmDTO", confirmDTO);
            return "company/compdetail";

        } catch (Exception e) {
            ra.addFlashAttribute("error", "상세 조회 중 오류 발생: " + e.getMessage());
            return "redirect:/comp/main";
        }
    }
    
    @GetMapping("/comp/update")
    public String compUpdate(@RequestParam("confirmNumber") Long confirmNumber,
                             @AuthenticationPrincipal CustomUserDetails me,
                             Model model,
                             RedirectAttributes ra) {
        if (me == null) {
            ra.addFlashAttribute("error", "로그인이 필요합니다.");
            return "redirect:/login";
        }

        try {
            ConfirmApplyDTO confirmDTO = companyApplyService.findByConfirmNumber(confirmNumber);
            ConfirmApplyDTO dto = companyApplyService.findByConfirmNumber(confirmNumber);
            if (confirmDTO == null) {
                ra.addFlashAttribute("error", "확인서를 찾을 수 없습니다.");
                return "redirect:/comp/main";
            }
            model.addAttribute("termList", dto.getTermAmounts()); 
            model.addAttribute("confirmDTO", confirmDTO);
            return "company/compupdate";

        } catch (Exception e) {
            ra.addFlashAttribute("error", "내용 조회 중 오류 발생: " + e.getMessage());
            return "redirect:/comp/main";
        }
    }
    
    
    @PostMapping("/comp/update")
    public String compUpdateSave(@RequestParam("confirmNumber") Long confirmNumber,
                                 @ModelAttribute ConfirmApplyDTO dto,
                                 @RequestParam(value="monthlyCompanyPay", required=false) List<String> monthlyCompanyPayRaw,
                                 RedirectAttributes ra) {
        UserDTO me = currentUserOrNull();
        if (me == null) {
            ra.addFlashAttribute("error", "로그인이 필요합니다.");
            return "redirect:/login";
        }

        dto.setConfirmNumber(confirmNumber);
        dto.setUserId(me.getId());

        List<Long> monthlyCompanyPay = null;
        if (monthlyCompanyPayRaw != null) {
            monthlyCompanyPay = monthlyCompanyPayRaw.stream()
                .filter(s -> s != null && !s.trim().isEmpty())
                .map(s -> s.replaceAll("[^\\d]", ""))
                .filter(s -> !s.isEmpty())
                .map(Long::valueOf)
                .collect(java.util.stream.Collectors.toList());
        }

        try {
            companyApplyService.updateConfirm(dto, monthlyCompanyPay);
            ra.addFlashAttribute("success", "수정되었습니다.");
            return "redirect:/comp/detail?confirmNumber=" + confirmNumber;
        } catch (Exception e) {
            ra.addFlashAttribute("error", "수정 중 오류: " + e.getMessage());
            return "redirect:/comp/detail?confirmNumber=" + confirmNumber;
        }
    }
    
    @PostMapping("/comp/recall")
    public String recall(@RequestParam Long confirmNumber,
                         RedirectAttributes ra) {
    	
        UserDTO me = currentUserOrNull();
        if (me == null) {
            ra.addFlashAttribute("error", "로그인이 필요합니다.");
            return "redirect:/login";
        }

        try {
            companyApplyService.recallConfirm(confirmNumber, me.getId());
            ra.addFlashAttribute("success","회수되었습니다.");
        } catch (Exception e) {
            ra.addFlashAttribute("error","회수 실패: " + e.getMessage());
        }
        return "redirect:/comp/detail?confirmNumber=" + confirmNumber;
    }


}
