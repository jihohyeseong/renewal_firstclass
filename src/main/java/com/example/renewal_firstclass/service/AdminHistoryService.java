package com.example.renewal_firstclass.service;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;

import org.springframework.stereotype.Service;

import com.example.renewal_firstclass.dao.AdminAppHistoryDAO;
import com.example.renewal_firstclass.dao.AdminCnfHistoryDAO;
import com.example.renewal_firstclass.domain.AdminAppHistoryDTO;
import com.example.renewal_firstclass.domain.AdminCnfHistoryDTO;
import com.example.renewal_firstclass.domain.AdminHistoryDTO;
import com.example.renewal_firstclass.domain.CompSearchDTO;
import com.example.renewal_firstclass.domain.PageDTO;
import com.example.renewal_firstclass.util.AES256Util;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class AdminHistoryService {

    private final AdminAppHistoryDAO appDAO;
    private final AdminCnfHistoryDAO cnfDAO;
    private final AES256Util aes256Util;

    public List<AdminHistoryDTO> getMergedHistoryList(CompSearchDTO searchDTO) {

        List<AdminAppHistoryDTO> appList = new ArrayList<>();
        List<AdminCnfHistoryDTO> cnfList = new ArrayList<>();
        
        String formType = searchDTO.getFormType();
        String originalRegNo = searchDTO.getRegNoKeyword();
        
        if (originalRegNo != null && !originalRegNo.isEmpty()) {
            try {
                String encRegNo = aes256Util.encrypt(originalRegNo); // 암호화
                searchDTO.setRegNoKeyword(encRegNo); // 암호화된 값으로 덮기
            } catch (Exception e) {
                throw new IllegalStateException("주민번호 암호화 실패", e);
            }
        }
        
        if (formType == null || formType.isEmpty() || formType.equals("신청서")) {
            appList = appDAO.selectAppHistoryList(searchDTO); 
        }
        if (formType == null || formType.isEmpty() || formType.equals("확인서")) {
            cnfList = cnfDAO.selectCnfHistoryList(searchDTO);
        }

        List<AdminHistoryDTO> mergedList = new ArrayList<>();
        
        try {
            for (AdminAppHistoryDTO app : appList) {
                String decryptedUserRegNo = (app.getUserRegiNumber() == null || app.getUserRegiNumber().isEmpty())
                                            ? null
                                            : aes256Util.decrypt(app.getUserRegiNumber());

                mergedList.add(AdminHistoryDTO.builder()
                        .formType("신청서")
                        .actionType(app.getActionType())
                        .actionTime(app.getActionTime())
                        .userName(app.getUserName())
                        .userRegiNumber(decryptedUserRegNo)
                        
                        // (App 전용 필드)
                        .historyId_App(app.getHistoryId())
                        .applicationNumber(app.getApplicationNumber())
                        .bankCode(app.getBankCode())
                        .accountNumber(app.getAccountNumber())
                        .statusCode_App(app.getStatusCode())
                        .paymentResult(app.getPaymentResult())
                        .rejectionReasonCode_App(app.getRejectionReasonCode())
                        .rejectComment_App(app.getRejectComment())
                        .payment(app.getPayment())
                        .submittedDt(app.getSubmittedDt())
                        .examineDt(app.getExamineDt())
                        .deltAt_App(app.getDeltAt())
                        .confirmNumber_App(app.getConfirmNumber())
                        .userId_App(app.getUserId())
                        .govInfoAgree(app.getGovInfoAgree()) 
                        .centerId_App(app.getCenterId()) 
                        .updBankCode(app.getUpdBankCode()) 
                        .updAccountNumber(app.getUpdAccountNumber()) 
                        .fileId_App(app.getFileId())
                        .build());
            }

            for (AdminCnfHistoryDTO cnf : cnfList) {
                String decUserRegNo = (cnf.getRegistrationNumber() == null || cnf.getRegistrationNumber().isEmpty())
                                            ? null
                                            : aes256Util.decrypt(cnf.getRegistrationNumber());
                                            
                String decChildRegNo = (cnf.getChildResiRegiNumber() == null || cnf.getChildResiRegiNumber().isEmpty())
                                             ? null
                                             : aes256Util.decrypt(cnf.getChildResiRegiNumber());
                String decUpdUserRegNo = (cnf.getUpdRegistrationNumber() == null || cnf.getUpdRegistrationNumber().isEmpty())
					                        ? null
					                        : aes256Util.decrypt(cnf.getUpdRegistrationNumber());
                String decUpdChildRegNo = (cnf.getUpdChildResiRegiNumber() == null || cnf.getUpdChildResiRegiNumber().isEmpty())
					                        ? null
					                        : aes256Util.decrypt(cnf.getUpdChildResiRegiNumber());

                mergedList.add(AdminHistoryDTO.builder()
                        .formType("확인서")
                        .actionType(cnf.getActionType())
                        .actionTime(cnf.getActionTime())
                        .userName(cnf.getName())
                        .userRegiNumber(decUserRegNo) 
                        
                        // (Cnf 전용 필드)
                        .historyId_Cnf(cnf.getHistoryId())
                        .confirmNumber_Cnf(cnf.getConfirmNumber())
                        .applyDt(cnf.getApplyDt())
                        .startDate(cnf.getStartDate())
                        .endDate(cnf.getEndDate())
                        .weeklyHours(cnf.getWeeklyHours())
                        .regularWage(cnf.getRegularWage())
                        .childName(cnf.getChildName())
                        .childResiRegiNumber(decChildRegNo)
                        .childBirthDate(cnf.getChildBirthDate()) 
                        .name_Cnf(cnf.getName())
                        .registrationNumber_Cnf(decUserRegNo)
                        .deltAt(cnf.getDeltAt()) 
                        .responseName(cnf.getResponseName()) 
                        .responsePhoneNumber(cnf.getResponsePhoneNumber()) 
                        .statusCode_Cnf(cnf.getStatusCode())
                        .rejectionReasonCode_Cnf(cnf.getRejectionReasonCode())
                        .rejectComment_Cnf(cnf.getRejectComment())
                        .processorId(cnf.getProcessorId()) 
                        .centerId(cnf.getCenterId()) 
                        .userId_Cnf(cnf.getUserId())
                        .fileId_Cnf(cnf.getFileId())
                        
                        // (Cnf 수정 필드)
                        .updWeeklyHours(cnf.getUpdWeeklyHours()) 
                        .updRegularWage(cnf.getUpdRegularWage()) 
                        .updChildName(cnf.getUpdChildName()) 
                        .updChildResiRegiNumber(decUpdChildRegNo) 
                        .updEndDate(cnf.getUpdEndDate()) 
                        .updStartDate(cnf.getUpdStartDate()) 
                        .updChildBirthDate(cnf.getUpdChildBirthDate()) 
                        .updRegistrationNumber(decUpdUserRegNo) 
                        .updName(cnf.getUpdName())
                        .build());
            }
        } catch (Exception e) {
            throw new IllegalStateException("주민번호 결과 복호화 실패", e);
        }
        
        mergedList.sort(Comparator.comparing(AdminHistoryDTO::getActionTime, 
                                             Comparator.nullsLast(Comparator.reverseOrder())));

        int totalCnt = mergedList.size(); 
        PageDTO pageDTO = searchDTO.getPageDTO();
        
        if (pageDTO == null) {
            pageDTO = new PageDTO(1, 10);
            searchDTO.setPageDTO(pageDTO);
        }
        pageDTO.setTotalCnt(totalCnt);

        int start = pageDTO.getStartList(); // (pageNum - 1) * listSize
        int end = Math.min(start + pageDTO.getListSize(), totalCnt);
        
        if (start >= totalCnt) {
            return new ArrayList<>();
        }
        
        searchDTO.setRegNoKeyword(originalRegNo);
        
        return mergedList.subList(start, end);
    }
}