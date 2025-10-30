package com.example.renewal_firstclass.controller;

import java.security.Principal;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import com.example.renewal_firstclass.domain.FcmTokenDTO;
import com.example.renewal_firstclass.service.FcmService;
import com.example.renewal_firstclass.service.UserService;

import lombok.RequiredArgsConstructor;

@RestController
@RequiredArgsConstructor
public class FcmTokenController {

	private final UserService userService;
	private final FcmService fcmService;
	
	// 로그인 시 토큰 저장
	@PostMapping("/save-fcm-token")
    public ResponseEntity<String> saveFcmToken(@RequestBody FcmTokenDTO tokenDTO, Principal principal) {

		if (principal == null) {
            return ResponseEntity.status(401).body("로그인이 필요합니다.");
        }

        try {
            String username = principal.getName();       
            userService.updateFcmToken(username, tokenDTO.getFcmToken());
            
            return ResponseEntity.ok("FCM 토큰이 성공적으로 저장되었습니다.");
            
        } catch (Exception e) {
            e.printStackTrace(); 
            
            return ResponseEntity.status(500).body("서버 오류가 발생했습니다.");
        }
    }
	
	@GetMapping("/push/{userId}")
    public ResponseEntity<String> sendTestPush(@PathVariable("userId") Long userId) {
        
        try {
            // 1. DB에서 해당 사용자의 FCM 토큰을 조회합니다.
            //    (이 메소드는 UserService 또는 Mapper에 직접 구현해야 합니다)
            String fcmToken = userService.getFcmTokenByUserId(userId);

            if (fcmToken == null || fcmToken.isEmpty()) {
                return ResponseEntity.status(404).body(userId + " 사용자의 FCM 토큰이 DB에 없습니다.");
            }

            // 2. FcmService를 호출하여 푸시 알림 전송
            fcmService.sendPushNotification(
                    fcmToken, 
                    "🔔 알림테스트", 
                    userId + "에게 푸시알림 전송"
            );

            return ResponseEntity.ok(userId + "님에게 푸시를 전송했습니다. (토큰: " + fcmToken + ")");

        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(500).body("푸시 전송 중 서버 오류 발생: " + e.getMessage());
        }
    }
}
