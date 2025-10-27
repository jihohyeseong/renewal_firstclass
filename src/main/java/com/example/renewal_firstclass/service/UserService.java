package com.example.renewal_firstclass.service;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.renewal_firstclass.dao.UserDAO;
import com.example.renewal_firstclass.domain.UserDTO;
import com.example.renewal_firstclass.util.AES256Util;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class UserService {
	
    private final UserDAO userDAO;
    private final AES256Util aes256Util;
    
    @Transactional(readOnly = true)
    public UserDTO findByUsername(String username) {
    	UserDTO user = userDAO.findUserInfo(username);
    	if(user.getRegistrationNumber() != null) {
	    	try {
				user.setRegistrationNumber(aes256Util.decrypt(user.getRegistrationNumber()));
			} catch (Exception e) {
				e.printStackTrace();
			}
    	}
        return user;
    }

	public UserDTO findById(Long userId) {
		
		UserDTO user = userDAO.findById(userId);
		if(user.getRegistrationNumber() != null) {
			try {
				user.setRegistrationNumber(aes256Util.decrypt(user.getRegistrationNumber()));
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
        return user;
	}
}