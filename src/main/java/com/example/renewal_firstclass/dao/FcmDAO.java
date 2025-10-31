package com.example.renewal_firstclass.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface FcmDAO {

	void updateToken(@Param("userId")Long userId, @Param("fcmToken")String fcmToken);

	List<String> findTokenByUserId(Long userId);

	void removeToken(@Param("userId")Long userId, @Param("fcmToken")String fcmToken);

	Long checkFcmToken(@Param("userId")Long userId, @Param("fcmToken")String fcmToken);

}
