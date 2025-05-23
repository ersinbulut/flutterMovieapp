import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart' as app_user;

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Kullanıcı durumunu dinle
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Giriş yapmış kullanıcıyı al
  User? get currentUser => _auth.currentUser;

  // Kullanıcı kaydı
  Future<UserCredential> registerWithEmailAndPassword(
      String email, String password, String username) async {
    try {
      print('Kayıt işlemi başlatılıyor...');
      print('Email: $email');
      print('Username: $username');

      // Firebase Authentication'da kullanıcı oluştur
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      print('Firebase Auth kaydı başarılı. UID: ${result.user?.uid}');

      // Firestore'da kullanıcı dokümanı oluştur
      await _firestore.collection('users').doc(result.user!.uid).set({
        'id': result.user!.uid,
        'username': username,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });

      print('Firestore kaydı başarılı');

      return result;
    } catch (e) {
      print('Kayıt işleminde hata: $e');
      if (e is FirebaseAuthException) {
        print('Firebase Auth Hatası: ${e.code} - ${e.message}');
      }
      rethrow;
    }
  }

  // Kullanıcı girişi
  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      print('Giriş işlemi başlatılıyor...');
      print('Email: $email');

      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      print('Giriş başarılı. UID: ${result.user?.uid}');
      return result;
    } catch (e) {
      print('Giriş işleminde hata: $e');
      if (e is FirebaseAuthException) {
        print('Firebase Auth Hatası: ${e.code} - ${e.message}');
      }
      rethrow;
    }
  }

  // Çıkış yap
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      print('Çıkış başarılı');
    } catch (e) {
      print('Çıkış işleminde hata: $e');
      rethrow;
    }
  }

  // Kullanıcı bilgilerini getir
  Future<app_user.User?> getUserData(String uid) async {
    try {
      print('Kullanıcı bilgileri getiriliyor... UID: $uid');

      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();

      if (doc.exists) {
        print('Kullanıcı dokümanı bulundu');
        final data = doc.data();

        if (data != null && data is Map<String, dynamic>) {
          print('Kullanıcı verileri: $data');

          // Verileri daha güvenli bir şekilde oku ve dönüştür
          final id = data['id'] as String?;
          final username = data['username'] as String?;
          final email = data['email'] as String?;
          final profileImage = data['profileImage'] as String?;
          final fullName = data['fullName'] as String?;
          final phoneNumber = data['phoneNumber'] as String?;
          final bio = data['bio'] as String?;

          // Gerekli alanların (id, username, email) null olmadığını kontrol et
          if (id != null && username != null && email != null) {
             return app_user.User(
              id: id,
              username: username,
              email: email,
              profileImage: profileImage,
              fullName: fullName,
              phoneNumber: phoneNumber,
              bio: bio,
            );
          } else {
             print('Firestore dokümanında gerekli alanlar (id, username, email) eksik veya null.');
             // Eksik alan varsa null dönebilir veya hata fırlatılabilir
             return null; 
          }
         
        } else {
          print('Kullanıcı dokümanı verisi null veya Map<String, dynamic> değil');
          return null;
        }
      } else {
        print('Kullanıcı dokümanı bulunamadı');
        return null;
      }
    } catch (e) {
      print('Kullanıcı bilgileri getirilirken hata: $e');
      return null;
    }
  }
} 