package com.example.renewal_firstclass.controller;

import java.io.IOException;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.example.renewal_firstclass.domain.AttachedFileDTO;
import com.example.renewal_firstclass.domain.CustomUserDetails;
import com.example.renewal_firstclass.domain.UserDTO;
import com.example.renewal_firstclass.service.AttachedFileService;
import com.example.renewal_firstclass.service.UserService;

import lombok.RequiredArgsConstructor;
import lombok.var;

@Controller
@RequiredArgsConstructor
public class AttachedFileController {
	
    private final AttachedFileService fileService;
    private final UserService userService;
    
    @PostMapping("/file/upload")
    @ResponseBody
    public Map<String, Object> uploadFiles(
            @RequestParam("files") MultipartFile[] files,
            @RequestParam("fileTypes") List<String> fileTypes) {

        try {
            Long fileId = fileService.uploadFilesWithTypes(files, fileTypes);
            return java.util.Collections.singletonMap("fileId", fileId);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }
    
    @GetMapping("/file/download")
    public ResponseEntity<org.springframework.core.io.Resource> download(
            @RequestParam("fileId") Long fileId,
            @RequestParam("seq") Integer seq) {

        UserDTO me = currentUserOrNull();
        if (me == null || me.getId() == null) {
            return ResponseEntity.status(401).build();
        }

        AttachedFileDTO meta = fileService.getMeta(fileId, seq);
        if (meta == null) {
            return ResponseEntity.notFound().build();
        }

        var auth = org.springframework.security.core.context.SecurityContextHolder
                .getContext().getAuthentication();
        boolean isAdmin = auth != null && auth.getAuthorities() != null &&
                auth.getAuthorities().stream().anyMatch(a -> "ROLE_ADMIN".equals(a.getAuthority()));

        if (!fileService.canDownload(fileId, me.getId(), isAdmin)) {
            return ResponseEntity.status(403).build();
        }

        ResponseEntity<org.springframework.core.io.Resource> resp = fileService.buildDownloadResponse(meta);
        return (resp != null) ? resp : ResponseEntity.internalServerError().build();
    }
    
    private UserDTO currentUserOrNull() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth == null || !auth.isAuthenticated() || "anonymousUser".equals(auth.getPrincipal())) {
            return null;
        }
        CustomUserDetails ud = (CustomUserDetails) auth.getPrincipal();
        return userService.findByUsername(ud.getUsername());
    }
    


/*
        @GetMapping("/file/download")
        public ResponseEntity<org.springframework.core.io.Resource> download(
                @RequestParam(required = true) Long fileId,
                @RequestParam(required = true) Integer seq,
                @AuthenticationPrincipal CustomUserDetails me) {

            // 0) 인증 체크
            if (me == null) return ResponseEntity.status(401).build();

            // 1) 메타 조회
            var meta = fileService.getMeta(fileId, seq);
            if (meta == null) return ResponseEntity.status(404).build();

            // 2) 요청자 userId 안전 조회
            Long requesterUserId = null;
            UserDTO.us
            try {
                var user = userService.findId(me.getId());
                if (user != null) requesterUserId = user.getId();
            } catch (Exception ignore) {}
            if (requesterUserId == null) {
                // 사용자 정보 없음 → 권한 없음 처리
                return ResponseEntity.status(403).build();
            }

            // 3) 관리자 여부 (authorities null 가드)
            boolean isAdmin = false;
            var auths = me.getAuthorities();
            if (auths != null) {
                isAdmin = auths.stream().anyMatch(a -> "ROLE_ADMIN".equals(a.getAuthority()));
            }

            // 4) 소유자 또는 관리자만 허용
            if (!fileService.canDownload(fileId, requesterUserId, isAdmin)) {
                return ResponseEntity.status(403).build();
            }

            // 5) 실제 파일 응답 (서비스에서 헤더/파일명/MIME 처리)
            return fileService.buildDownloadResponse(meta);
        }*/


}

