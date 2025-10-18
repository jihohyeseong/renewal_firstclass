package com.example.renewal_firstclass.service;

import org.springframework.stereotype.Service;

import com.example.renewal_firstclass.dao.PhoneNumberDAO;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class PhoneNumberService {

	private final PhoneNumberDAO phoneNumberDAO;
}
