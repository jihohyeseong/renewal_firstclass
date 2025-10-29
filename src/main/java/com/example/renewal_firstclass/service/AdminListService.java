package com.example.renewal_firstclass.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.example.renewal_firstclass.dao.AdminListDAO;
import com.example.renewal_firstclass.domain.AdminListDTO;


import lombok.RequiredArgsConstructor;


@Service
@RequiredArgsConstructor
public class AdminListService {

    private final AdminListDAO adminListDAO;

    public List<AdminListDTO> getApplyAndConfirmList(Map<String, Object> params) {
        return adminListDAO.selectApplyAndConfirm(params);
    }

    public int getApplyAndConfirmCount(Map<String, Object> params) {
        return adminListDAO.countApplyAndConfirm(params);
    }

}
