package com.example.renewal_firstclass.service;

import java.io.File;
import java.io.IOException;
import java.net.URLEncoder;
import java.util.Arrays;
import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.example.renewal_firstclass.dao.AttachedFileDAO;
import com.example.renewal_firstclass.domain.AttachedFileDTO;

import lombok.RequiredArgsConstructor;
import lombok.var;

@Service
@RequiredArgsConstructor
public class AttachedFileService {

    private final AttachedFileDAO fileDAO;
    
    private static final String BASE_DIR = "C:/uploadtest";

    // 새 file_id 발급
    public Long selectNextFileId() {
        return fileDAO.selectNextFileId();
    }

    public Long uploadFilesWithTypes(MultipartFile[] files, List<String> fileTypes) throws IOException {
        Long newFileId = fileDAO.selectNextFileId();
        int seq = 1;

        if (files == null || files.length == 0) return newFileId;

        // fileId 전용 디렉터리 생성
        java.nio.file.Path dir = java.nio.file.Paths.get(BASE_DIR, String.valueOf(newFileId));
        java.nio.file.Files.createDirectories(dir);

        for (int i = 0; i < files.length; i++) {
            MultipartFile f = files[i];
            if (f == null || f.isEmpty()) continue;

            // 1) 원본 파일명 확보 
            String originalName = f.getOriginalFilename();
            if (originalName == null) originalName = "file";

            // 2) 확장자 분리 
            int dot = originalName.lastIndexOf('.');
            String base = (dot > 0) ? originalName.substring(0, dot) : originalName;
            String ext  = (dot > 0 && dot < originalName.length() - 1) ? originalName.substring(dot) : "";

            // 3) 중복시(n)
            java.nio.file.Path target = dir.resolve(originalName);
            int n = 2;
            while (java.nio.file.Files.exists(target)) {
                String candidate = base + " (" + n + ")" + ext;
                target = dir.resolve(candidate);
                n++;
            }

            //저장
            f.transferTo(target.toFile());

            String type = (fileTypes != null && fileTypes.size() > i && fileTypes.get(i) != null)
                    ? fileTypes.get(i) : "ETC";

            AttachedFileDTO dto = new AttachedFileDTO();
            dto.setFileId(newFileId);
            dto.setFileType(type);
            dto.setFileUrl(target.toString());
            dto.setSequence(seq++);


            fileDAO.insertFile(dto);
        }
        return newFileId;
    }

    public List<AttachedFileDTO> getFiles(Long fileId) {
        if (fileId == null) return java.util.Collections.emptyList();
        return fileDAO.selectFilesByFileId(fileId);
    }
    
    
    /*다운로드 기능*/
    public AttachedFileDTO getMeta(Long fileId, Integer seq) {
        return fileDAO.selectOneByFileIdAndSeq(fileId, seq);
    }


/*    public boolean canDownload(Long fileId, Long requesterUserId, boolean isAdmin) {
        if (isAdmin) return true;
        Long owner = fileDAO.findOwnerUserIdByFileId(fileId);
        return owner != null && owner.equals(requesterUserId);
    }*/

    public ResponseEntity<org.springframework.core.io.Resource> buildDownloadResponse(AttachedFileDTO meta) {
        try {
            if (meta == null) return ResponseEntity.status(HttpStatus.NOT_FOUND).build();

            // 절대경로
            java.nio.file.Path path = java.nio.file.Paths.get(meta.getFileUrl()).toAbsolutePath().normalize();

            if (!java.nio.file.Files.exists(path) || !java.nio.file.Files.isReadable(path)) {
                return ResponseEntity.status(HttpStatus.GONE).build();
            }

            var resource = new org.springframework.core.io.UrlResource(path.toUri());

            String mime = java.nio.file.Files.probeContentType(path);
            if (mime == null) mime = org.springframework.http.MediaType.APPLICATION_OCTET_STREAM_VALUE;

            String filename = path.getFileName().toString();
            String encoded = URLEncoder.encode(filename, java.nio.charset.StandardCharsets.UTF_8.name())
                    .replaceAll("\\+", "%20");
            String cd = "attachment; filename=\"" + encoded + "\"; filename*=UTF-8''" + encoded;

            var headers = new org.springframework.http.HttpHeaders();
            headers.setContentType(org.springframework.http.MediaType.parseMediaType(mime));
            headers.set(org.springframework.http.HttpHeaders.CONTENT_DISPOSITION, cd);
            headers.setCacheControl(org.springframework.http.CacheControl.noCache().getHeaderValue());
            headers.setPragma("no-cache");

            return new ResponseEntity<>(resource, headers, HttpStatus.OK);

        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
    
    /** 파일 묶음 전체 삭제 */
    @Transactional
    public int deleteByFileId(Long fileId, boolean removePhysical) {
        if (fileId == null) return 0;

        List<AttachedFileDTO> metas = fileDAO.selectFilesByFileId(fileId);
        // DB 삭제
        int deleted = fileDAO.deleteByFileId(fileId);
        // 물리파일 삭제
        if (removePhysical && metas != null) {
            for (AttachedFileDTO m : metas) {
                if (m == null) continue;
                String pathStr = m.getFileUrl();
                if (pathStr == null) continue;
                try {
                    java.nio.file.Files.deleteIfExists(java.nio.file.Paths.get(pathStr));
                } catch (Exception ignore) {
                }
            }
        }
        return deleted;
    }

    /** 특정 시퀀스 한 건 삭제 */
    @Transactional
    public int deleteOne(Long fileId, Integer sequence, boolean removePhysical) {
        if (fileId == null || sequence == null) return 0;

        AttachedFileDTO meta = fileDAO.selectOneByFileIdAndSeq(fileId, sequence);
        int deleted = fileDAO.deleteOne(fileId, sequence);

        // 물리파일 삭제
        if (removePhysical && meta != null) {
            String pathStr = meta.getFileUrl();
            if (pathStr != null) {
                try {
                    java.nio.file.Files.deleteIfExists(java.nio.file.Paths.get(pathStr));
                } catch (Exception ignore) {
                }
            }
        }
        return deleted;
    }

}
