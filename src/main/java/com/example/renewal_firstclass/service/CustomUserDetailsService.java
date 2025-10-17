package com.example.renewal_firstclass.service;

import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import com.example.renewal_firstclass.dao.UserDAO;
import com.example.renewal_firstclass.domain.CustomUserDetails;
import com.example.renewal_firstclass.domain.UserVO;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class CustomUserDetailsService implements UserDetailsService {

    private final UserDAO userDAO;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
    	
    	System.out.println("=============== 로그인 시도: " + username + " ===============");
        UserVO userData = userDAO.findByUsername(username);
        
        if (userData == null) {
            throw new UsernameNotFoundException("사용자를 찾을 수 없습니다: " + username);
        }

        return new CustomUserDetails(userData);
    }
    
    
}
