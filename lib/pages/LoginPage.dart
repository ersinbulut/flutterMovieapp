import 'package:flutter/material.dart';
import 'package:movie_app/services/auth_service.dart';
import 'package:movie_app/pages/HomePage.dart';
import 'package:movie_app/models/user.dart' as app_user;
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();
  
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();
  
  bool _isLogin = true;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0F111D),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _isLogin ? 'Giriş Yap' : 'Kayıt Ol',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                if (!_isLogin)
                  TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'Kullanıcı Adı',
                      labelStyle: TextStyle(color: Colors.white70),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white30),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                    style: TextStyle(color: Colors.white),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Lütfen kullanıcı adınızı girin';
                      }
                      return null;
                    },
                  ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'E-posta',
                    labelStyle: TextStyle(color: Colors.white70),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white30),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                  ),
                  style: TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Lütfen e-posta adresinizi girin';
                    }
                    if (!value.contains('@')) {
                      return 'Geçerli bir e-posta adresi girin';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Şifre',
                    labelStyle: TextStyle(color: Colors.white70),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white30),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                  ),
                  style: TextStyle(color: Colors.white),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Lütfen şifrenizi girin';
                    }
                    if (value.length < 6) {
                      return 'Şifre en az 6 karakter olmalıdır';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24),
                if (_isLoading)
                  CircularProgressIndicator()
                else
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: _handleSubmit,
                        child: Text(_isLogin ? 'Giriş Yap' : 'Kayıt Ol'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 50),
                        ),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomePage(currentUser: app_user.User(
                                id: 'admin',
                                email: 'admin@admin.com',
                                username: 'Admin',
                              )),
                            ),
                          );
                        },
                        child: Text('Admin Girişi'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 50),
                          backgroundColor: Colors.green,
                        ),
                      ),
                    ],
                  ),
                SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isLogin = !_isLogin;
                    });
                  },
                  child: Text(
                    _isLogin ? 'Hesabınız yok mu? Kayıt olun' : 'Zaten hesabınız var mı? Giriş yapın',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        if (_isLogin) {
          print('Giriş işlemi başlatılıyor...');
          // Giriş işlemi
          final userCredential = await _authService.signInWithEmailAndPassword(
            _emailController.text,
            _passwordController.text,
          );
          
          if (userCredential.user != null) {
            print('Firebase Auth girişi başarılı, kullanıcı bilgileri getiriliyor...');
            final userData = await _authService.getUserData(userCredential.user!.uid);
            if (userData != null) {
              print('Kullanıcı bilgileri başarıyla alındı, ana sayfaya yönlendiriliyor...');
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => HomePage(currentUser: userData),
                ),
              );
            } else {
              throw Exception('Kullanıcı bilgileri alınamadı');
            }
          }
        } else {
          print('Kayıt işlemi başlatılıyor...');
          // Kayıt işlemi
          final userCredential = await _authService.registerWithEmailAndPassword(
            _emailController.text,
            _passwordController.text,
            _usernameController.text,
          );
          
          if (userCredential.user != null) {
            print('Firebase Auth kaydı başarılı, kullanıcı bilgileri getiriliyor...');
            final userData = await _authService.getUserData(userCredential.user!.uid);
            if (userData != null) {
              print('Kullanıcı bilgileri başarıyla alındı, ana sayfaya yönlendiriliyor...');
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => HomePage(currentUser: userData),
                ),
              );
            } else {
              throw Exception('Kullanıcı bilgileri alınamadı');
            }
          }
        }
      } catch (e) {
        print('İşlem sırasında hata oluştu: $e');
        String errorMessage = 'Bir hata oluştu';
        
        if (e is firebase_auth.FirebaseAuthException) {
          print('Firebase Auth Hatası: ${e.code} - ${e.message}');
          switch (e.code) {
            case 'user-not-found':
              errorMessage = 'Bu e-posta adresi ile kayıtlı kullanıcı bulunamadı';
              break;
            case 'wrong-password':
              errorMessage = 'Hatalı şifre';
              break;
            case 'email-already-in-use':
              errorMessage = 'Bu e-posta adresi zaten kullanımda';
              break;
            case 'weak-password':
              errorMessage = 'Şifre çok zayıf';
              break;
            case 'invalid-email':
              errorMessage = 'Geçersiz e-posta adresi';
              break;
            case 'operation-not-allowed':
              errorMessage = 'E-posta/şifre girişi etkin değil';
              break;
            case 'network-request-failed':
              errorMessage = 'İnternet bağlantınızı kontrol edin';
              break;
            default:
              errorMessage = 'Hata: ${e.message}';
          }
        } else if (e is firebase_auth.FirebaseException) {
          print('Firebase Hatası: ${e.code} - ${e.message}');
          errorMessage = 'Veritabanı hatası: ${e.message}';
        } else {
          print('Bilinmeyen hata: $e');
          errorMessage = 'Beklenmeyen bir hata oluştu: $e';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 5),
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }
} 