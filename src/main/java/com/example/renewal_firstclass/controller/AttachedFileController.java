package com.example.renewal_firstclass.controller;

import java.io.IOException;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.example.renewal_firstclass.service.AttachedFileService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class AttachedFileController {
	
    private final AttachedFileService fileService;

/*    @PostMapping("/file/upload")
    public ResponseEntity<?> upload(@RequestParam("files") MultipartFile[] files,
                               @RequestParam("fileTypes") List<String> fileTypes) {

   Long fileId = fileService.selectNextFileId();
   fileService.uploadFilesWithTypes(fileId, files, fileTypes);
   Map<String, Object> result = new HashMap<>();
   result.put("fileId", fileId);
   result.put("count", files.length);
   return ResponseEntity.ok(result);
}*/
    
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
}

