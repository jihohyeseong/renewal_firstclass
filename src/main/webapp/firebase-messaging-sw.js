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

