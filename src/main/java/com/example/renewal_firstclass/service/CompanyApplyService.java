package com.example.renewal_firstclass.service;

import com.example.renewal_firstclass.dao.ConfirmApplyDAO;
import com.example.renewal_firstclass.domain.ConfirmApplyDTO;
import com.example.renewal_firstclass.util.AES256Util;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class CompanyApplyService {

    private final ConfirmApplyDAO confirmApplyDAO;
    private final AES256Util aes256Util; // 민감정보 암호화용 (없으면 제거)

    @Transactional
    public Long createConfirm(ConfirmApplyDTO dto) {
        // 1) 기본값 보정

        // 2) 민감정보 암호화
        //    - 근로자 주민등록번호: registration_number
        //    - 자녀 주민등록번호: child_resi_regi_number
        try {
            if (notBlank(dto.getRegistrationNumber())) {
                dto.setRegistrationNumber(aes256Util.encrypt(dto.getRegistrationNumber()));
            }
            if (notBlank(dto.getChildResiRegiNumber())) {
                dto.setChildResiRegiNumber(aes256Util.encrypt(dto.getChildResiRegiNumber()));
            }
        } catch (Exception e) {
            // 암호화 실패는 치명적이므로 트랜잭션 롤백
            throw new IllegalStateException("개인정보 암호화 중 오류가 발생했습니다.", e);
        }

        // 3) INSERT 실행
        int rows = confirmApplyDAO.insertConfirmApplication(dto);
        if (rows != 1 || dto.getConfirmId() == null) {
            throw new IllegalStateException("확인서 저장에 실패했습니다.");
        }

        // 4) 생성된 PK 반환
        return dto.getConfirmId();
    }

    private static boolean notBlank(String s) {
        return s != null && !s.trim().isEmpty();
    }
}
