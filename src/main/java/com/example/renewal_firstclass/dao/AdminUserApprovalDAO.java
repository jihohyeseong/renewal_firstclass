package com.example.renewal_firstclass.dao;

import java.util.Date;
import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.renewal_firstclass.domain.AdminUserApprovalDTO;
import com.example.renewal_firstclass.domain.ApplicationSearchDTO;
import com.example.renewal_firstclass.domain.TermAmountDTO;

@Mapper
public interface AdminUserApprovalDAO {
    
    //상세페이지
    AdminUserApprovalDTO selectAppDetailByAppNo(@Param("applicationNumber") long applicationNumber);
    List<TermAmountDTO> selectByConfirmId(@Param("confirmNumber") long confirmNumber);
    

    // 관리자 상세 진입 시 심사중상태로
    int whenOpenChangeState(@Param("applicationNumber") long applicationNumber);

    //1차 지급 확정(2차 심사로)
    int approveApplicationLevel1(@Param("applicationNumber") long applicationNumber,
                                 @Param("processorId") Long processorId);

    //부지급 확정
    int rejectApplication(@Param("applicationNumber") long applicationNumber,
                          @Param("rejectionReasonCode") String rejectionReasonCode,
                          @Param("rejectComment") String rejectComment,
                          @Param("processorId") Long processorId);
    
    int updateBankInfoByAppNo(
            @Param("applicationNumber") Long applicationNumber,
            @Param("updBankCode") String updBankCode,
            @Param("updAccountNumber") String updAccountNumber
        );

    int updateChildInfoByAppNo(
            @Param("applicationNumber") Long applicationNumber,
            @Param("updChildName") String updChildName,
            @Param("updChildBirthDate") Date updChildBirthDate,
            @Param("updChildResiRegiNumber") String updChildResiRegiNumber
        );

}