package com.example.renewal_firstclass.service;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.renewal_firstclass.dao.ConfirmApplyDAO;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class ApprovalBatchService {
    private final ConfirmApplyDAO confirmApplyDAO;
	
    @Transactional
    public int approveConfirmByBatch() {
        return confirmApplyDAO.approveConfirmByBatch();
    }

}
