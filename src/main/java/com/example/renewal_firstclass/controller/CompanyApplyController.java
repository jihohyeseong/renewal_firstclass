package com.example.renewal_firstclass.controller;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.validation.Valid;

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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.example.renewal_firstclass.domain.ConfirmApplyDTO;
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
    
    /* 메인 */
    @GetMapping("/comp/main")
    public String main(Model model) {
        UserDTO user = currentUserOrNull();
        if (user != null && user.getId() != null) {
            model.addAttribute("confirmList", companyApplyService.getListByUser(user.getId()));
        }
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

    /* 작성 화면 — 로그인 필수 */
    @GetMapping("/comp/apply")
    public String compApply(Model model) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String username = auth.getName(); // principal이 CustomUserDetails든 아닐든 username
        UserDTO user = userService.findByUsername(username);

        if (!model.containsAttribute("form")) {
            ConfirmApplyDTO form = new ConfirmApplyDTO();
            form.setUserId(user.getId());
            model.addAttribute("form", form);
        }
        model.addAttribute("userDTO", user);
        return "company/compapply";
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

    /* 제출: ST_10 → ST_20 & apply_dt = SYSDATE — 로그인 필수 */
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
            return "redirect:/comp/detail?confirmNumber=" + confirmNumber;
        } catch (Exception e) {
            ra.addFlashAttribute("error", "제출 실패: " + e.getMessage());
            return "redirect:/comp/detail?confirmNumber=" + confirmNumber;
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

}
