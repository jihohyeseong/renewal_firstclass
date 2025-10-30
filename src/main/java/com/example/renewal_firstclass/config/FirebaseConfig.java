package com.example.renewal_firstclass.config;

import java.io.FileInputStream;
import java.io.IOException;

import javax.annotation.PostConstruct;

import org.springframework.context.annotation.Configuration;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;

@Configuration
public class FirebaseConfig {

	@PostConstruct
    public void initialize() {
        try {
            FileInputStream serviceAccount = new FileInputStream(getClass().getClassLoader().getResource("firstclass-b26aa-firebase-adminsdk-fbsvc-61f90a0113.json").getFile());

            FirebaseOptions options = FirebaseOptions.builder() 
                    .setCredentials(GoogleCredentials.fromStream(serviceAccount))
                    .build();

            // FirebaseApp이 이미 초기화되었는지 확인
            if (FirebaseApp.getApps().isEmpty()) {
                FirebaseApp.initializeApp(options);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
