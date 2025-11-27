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

        //로그인 사용자
        UserDTO me = currentUserOrNull();
        if (me == null || me.getId() == null) {
            return ResponseEntity.status(401).build();
        }

        AttachedFileDTO meta = fileService.getMeta(fileId, seq);
        if (meta == null) {
            return ResponseEntity.notFound().build();
        }

        var auth = SecurityContextHolder.getContext().getAuthentication();
        boolean isAdmin = auth != null && auth.getAuthorities() != null &&
                auth.getAuthorities().stream().anyMatch(a -> "ROLE_ADMIN".equals(a.getAuthority()));

        // 권한 검증 
        boolean allowed = fileService.canDownload(fileId, me.getId(), isAdmin);
        if (!allowed) {
            return ResponseEntity.status(403).build();
        }

        ResponseEntity<org.springframework.core.io.Resource> resp = fileService.buildDownloadResponse(meta);
        return (resp != null) ? resp : ResponseEntity.internalServerError().build();
    }

    
    /** 수정시 새 첨부파일 추가*/
    @PostMapping("/file/append")
    @ResponseBody
    public Map<String, Object> append(@RequestParam("fileId") Long fileId,
                                      @RequestParam("files") MultipartFile[] files,
                                      @RequestParam(value="fileTypes", required=false) List<String> fileTypes) {
        try {
            fileService.append(fileId, files, fileTypes);
            java.util.Map<String, Object> res = new java.util.HashMap<>();
            res.put("ok", true);
            res.put("fileId", fileId);
            return res;
        } catch (IOException e) {
            throw new RuntimeException("파일 추가 실패: " + e.getMessage(), e);
        }
    }

    /** 수정시 특정 시퀀스 하나 삭제 */
    @PostMapping("/file/delete-one")
    @ResponseBody
    public Map<String, Object> deleteOne(@RequestParam("fileId") Long fileId,
                                         @RequestParam("sequence") Integer sequence,
                                         @RequestParam(value="removePhysical", defaultValue="true") boolean removePhysical) {
        int affected = fileService.deleteOne(fileId, sequence, removePhysical);
        java.util.Map<String, Object> res = new java.util.HashMap<>();
        res.put("deleted", affected);
        return res;
    }
    
    private UserDTO currentUserOrNull() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth == null || !auth.isAuthenticated() || "anonymousUser".equals(auth.getPrincipal())) {
            return null;
        }
        CustomUserDetails ud = (CustomUserDetails) auth.getPrincipal();
        return userService.findByUsername(ud.getUsername());
    }
    
}

