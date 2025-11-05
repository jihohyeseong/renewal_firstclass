package com.example.renewal_firstclass.service;

import java.io.File;
import java.io.IOException;
import java.util.Arrays;
import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.example.renewal_firstclass.dao.AttachedFileDAO;
import com.example.renewal_firstclass.domain.AttachedFileDTO;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class AttachedFileService {

    private final AttachedFileDAO fileDAO;

    // 새 file_id 발급
    public Long selectNextFileId() {
        return fileDAO.selectNextFileId();
    }

    // 파일마다 타입 다르게 업로드
    public Long uploadFilesWithTypes(MultipartFile[] files, List<String> fileTypes) throws IOException {
        Long newFileId = fileDAO.selectNextFileId();
        int seq = 1;

        if (files == null) return newFileId;
        for (int i = 0; i < files.length; i++) {
            MultipartFile f = files[i];
            if (f == null || f.isEmpty()) continue;

            String savePath = "C:/uploadtest/" + f.getOriginalFilename();
            f.transferTo(new java.io.File(savePath));

            String type = (fileTypes != null && fileTypes.size() > i && fileTypes.get(i) != null)
                    ? fileTypes.get(i) : "ETC";

            AttachedFileDTO dto = new AttachedFileDTO();
            dto.setFileId(newFileId);
            dto.setFileType(type);
            dto.setFileUrl(savePath);
            dto.setSequence(seq++);
            fileDAO.insertFile(dto);
        }
        return newFileId;
    }


/*    // 단일 타입 업로드 (기존 버전)
    public Long uploadFiles(MultipartFile[] files, String fileType) {
        Long newFileId = fileDAO.selectNextFileId();
        uploadFilesWithTypes(newFileId, files, Arrays.asList(fileType));
        return newFileId;
    }*/
}
