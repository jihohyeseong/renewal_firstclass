package com.example.renewal_firstclass.dao;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.renewal_firstclass.domain.CorpJoinDTO;
import com.example.renewal_firstclass.domain.JoinDTO;
import com.example.renewal_firstclass.domain.UserDTO;
import com.example.renewal_firstclass.domain.UserVO;


@Mapper
public interface UserDAO {

	void save(JoinDTO joinDTO);
	
	void saveCorp(CorpJoinDTO joinDTO);

	UserVO findByUsername(String username);
	
	UserDTO findUserInfo(String username);

	boolean existsByUsername(String username);
	
	UserDTO findById(Long id);

	boolean existsByUsernameAndPhoneNumber(@Param("username")String username, @Param("phoneNumber")String phoneNumber);

	int updatePasswordByUsername(@Param("username")String username, @Param("password")String password);

	String findUsernameByNameAndPhoneNumber(@Param("name")String name, @Param("phoneNumber")String phoneNumber);

	Long findByRegistrationNumber(String registrationNumber);

	void updateToken(@Param("username")String username, @Param("fcmToken")String fcmToken);

	String findTokenByUserId(Long userId);

}
