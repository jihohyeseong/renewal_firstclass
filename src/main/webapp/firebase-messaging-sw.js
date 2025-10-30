// SDK 임포트 (v9 compat 버전)
importScripts("https://www.gstatic.com/firebasejs/9.22.1/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/9.22.1/firebase-messaging-compat.js");

// Firebase 초기화 (JSP에서 사용한 것과 동일한 설정)
const firebaseConfig = {
    apiKey: "AIzaSyBb2vaosR63S_Knim9gbnGH5Rk7F87qkC4",
    authDomain: "firstclass-b26aa.firebaseapp.com",
    projectId: "firstclass-b26aa",
    storageBucket: "firstclass-b26aa.firebasestorage.app",
    messagingSenderId: "90572579455",
    appId: "1:90572579455:web:49c5070ba44f968649154a"
};
firebase.initializeApp(firebaseConfig);

const messaging = firebase.messaging();

// 백그라운드 메시지 핸들러
messaging.onBackgroundMessage((payload) => {
    console.log('[firebase-messaging-sw.js] Received background message ', payload);

    // Spring 백엔드에서 보낸 Notification 객체를 사용합니다.
    const notificationTitle = payload.notification.title;
    const notificationOptions = {
        body: payload.notification.body,
        //icon: '/images/your-push-icon.png' // 알림에 표시할 아이콘 (경로 확인)
    };

    // 사용자에게 알림을 표시합니다.
    self.registration.showNotification(notificationTitle, notificationOptions);
});