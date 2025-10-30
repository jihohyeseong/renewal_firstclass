package com.example.renewal_firstclass.service;

import org.springframework.stereotype.Service;

import com.google.firebase.messaging.FirebaseMessaging;
import com.google.firebase.messaging.FirebaseMessagingException;
import com.google.firebase.messaging.Message;
import com.google.firebase.messaging.Notification;

@Service
public class FcmService {

	public void sendPushNotification(String deviceToken, String title, String body) {
        
        // deviceToken이 유효하지 않은 경우(예: DB에서 가져오지 못한 경우)
        if (deviceToken == null || deviceToken.isEmpty()) {
            System.err.println("Device token is missing. Cannot send notification.");
            return; 
        }

        Notification notification = Notification.builder()
                .setTitle(title)
                .setBody(body)
                // .setImage("url-to-image.png") // 필요시 이미지 추가
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
}
