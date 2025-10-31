package com.example.renewal_firstclass.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.example.renewal_firstclass.dao.FcmDAO;
import com.google.firebase.messaging.FirebaseMessaging;
import com.google.firebase.messaging.FirebaseMessagingException;
import com.google.firebase.messaging.Message;
import com.google.firebase.messaging.Notification;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class FcmService {
	
	private final FcmDAO fcmDAO;
	
	public void updateFcmToken(Long userId, String fcmToken) {
		
		fcmDAO.updateToken(userId, fcmToken);
		System.out.println("DB 업데이트 시도 -> 사용자: " + userId + ", 토큰: " + fcmToken);
	}

	public List<String> getFcmTokenByUserId(Long userId) {
		
		return fcmDAO.findTokenByUserId(userId);
	}

	public void sendPushNotification(String deviceToken, String title, String body) {
        
        // deviceToken이 유효하지 않은 경우(예: DB에서 가져오지 못한 경우)
        if (deviceToken == null || deviceToken.isEmpty()) {
            System.err.println("Device token is missing. Cannot send notification.");
            return; 
        }

        Notification notification = Notification.builder()
                .setTitle(title)
                .setBody(body)
                .setImage("https://g-cbox.pstatic.net/MjAyNTEwMzFfMyAg/MDAxNzYxODc2MjY5MTg2.aERTMykhu5fuKOn27yIA6LXHsyfuIkc2ufWXm4D5cSkg.RonAX9Q67_uaduDXANzUEjsXe78OoGNcn0HF-zlLQjog.PNG/logo.png?type=m250_375")
                .build();

        Message message = Message.builder()
                .setNotification(notification)
                .setToken(deviceToken) // 이 토큰으로 특정 디바이스에 메시지 전송
                .build();

        try {
            String response = FirebaseMessaging.getInstance().send(message);
            System.out.println("Successfully sent message: " + response);
        } catch (FirebaseMessagingException e) {
            System.err.println("Error sending message: " + e.getMessage());
            // TODO: 토큰이 만료되었거나 앱이 삭제된 경우 등의 예외 처리 (e.g., DB에서 토큰 삭제)
        }
    }

	public void removeFcmToken(Long userId, String fcmToken) {
		
		fcmDAO.removeToken(userId, fcmToken);
		System.out.println("DB 업데이트 시도 -> 사용자: " + userId + ", 토큰: " + fcmToken);
	}

	public boolean checkFcmToken(Long userId, String fcmToken) {
		
		return fcmDAO.checkFcmToken(userId, fcmToken) > 0 ? true : false;
	}
}
