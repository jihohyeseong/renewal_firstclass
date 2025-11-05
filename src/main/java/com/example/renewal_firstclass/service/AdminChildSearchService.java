package com.example.renewal_firstclass.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.renewal_firstclass.dao.AdminChildSearchDAO;
import com.example.renewal_firstclass.domain.AdminChildListDTO;
import com.example.renewal_firstclass.domain.CompSearchDTO;
import com.example.renewal_firstclass.domain.PageDTO;
import com.example.renewal_firstclass.domain.TermAmountDTO;
import com.example.renewal_firstclass.util.AES256Util;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class AdminChildSearchService {

    private final AdminChildSearchDAO adminChildSearchDAO;
    private final AES256Util aes256Util;
    
    @Transactional
    public List<AdminChildListDTO> getPagedChildList(String statusCode,String nameKeyword, 
    		String regNoKeyword, PageDTO pageDTO) {
    	
		String regNoEnc = null;
		
		if (regNoKeyword != null && !regNoKeyword.isEmpty()) {
		try {
			regNoEnc = aes256Util.encrypt(regNoKeyword); 
		} catch (Exception e) {
			throw new IllegalStateException("주민번호 암호화 실패", e);
			}
		}
        
        // DTO로 묶어서 전달
        CompSearchDTO search = new CompSearchDTO();
        search.setStatus(statusCode);
        search.setNameKeyword(nameKeyword);
        search.setRegNoKeyword(regNoEnc);
        search.setPageDTO(pageDTO);
        
        // 검색 조건에 맞는 게시물 조회
        int totalCnt = adminChildSearchDAO.countChildSearch(search);
        pageDTO.setTotalCnt(totalCnt); // PageDTO에 총 개수 설정 -> 페이징 계산 완료
        
        List<AdminChildListDTO> childList = adminChildSearchDAO.selectChildSearch(search);
        
        // 각 신청서에 대한 단위 기간 조회
        /*for (AdminChildListDTO dto : childList) {
            if (dto.getChildResiRegiNumber() != null && !dto.getChildResiRegiNumber().isEmpty()) {
                try {
                    String decryptedRrn = aes256Util.decrypt(dto.getChildResiRegiNumber());
                    dto.setChildResiRegiNumber(decryptedRrn); // DTO의 값을 복호화된 값으로 교체
                } catch (Exception e) {
                    // e.printStackTrace(); // 복호화 실패 시 로그
                    dto.setChildResiRegiNumber("복호화 오류");
                }
            }

            
            if (dto.getConfirmNumber() != null) {
                // 수정된 단위기간(update_at='Y') 있는지 확인
                List<TermAmountDTO> terms = adminChildSearchDAO.selectUpdatedTermAmounts(dto.getConfirmNumber());

                if (terms == null || terms.isEmpty()) {
                    terms = adminChildSearchDAO.selectOriginalTermAmounts(dto.getConfirmNumber());
                }
                dto.setList(terms);
            }
        }*/
        for (AdminChildListDTO dto : childList) {
            if (dto.getChildResiRegiNumber() != null && !dto.getChildResiRegiNumber().isEmpty()) {
                try {
                    String decryptedRrn = aes256Util.decrypt(dto.getChildResiRegiNumber());
                    dto.setChildResiRegiNumber(decryptedRrn); // DTO의 값을 복호화된 값으로 교체
                } catch (Exception e) {
                    // e.printStackTrace(); // 복호화 실패 시 로그
                    dto.setChildResiRegiNumber("복호화 오류");
                }
            }
        }
        return childList;
    }
}
