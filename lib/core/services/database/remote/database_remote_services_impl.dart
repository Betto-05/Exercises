import 'package:firebase_auth/firebase_auth.dart';
import 'package:football/core/models/user.dart';
import 'package:football/core/services/database/remote/database_remote_services.dart';

class DatabaseRemoteServicesImpl implements DatabaseRemoteServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<AppUser?> login(String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = result.user;
      if (user == null) throw "فشل تسجيل الدخول.";
      return AppUser.fromFirebase(user);
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseError(e);
    }
  }

  @override
  Future<AppUser?> register(
    String email,
    String password, {
    String? name,
  }) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = result.user;
      if (user == null) throw "فشل إنشاء الحساب.";

      if (name != null && name.isNotEmpty) {
        await user.updateDisplayName(name);
      }

      await user.sendEmailVerification();
      await user.reload();

      final updatedUser = _auth.currentUser!;
      return AppUser(
        uid: updatedUser.uid,
        email: updatedUser.email,
        name: updatedUser.displayName,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseError(e);
    }
  }

  @override
  Future<void> logOut() async {
    await _auth.signOut();
  }

  @override
  Future<AppUser?> getCurrentUser() async {
    final user = _auth.currentUser;
    if (user != null) {
      await user.reload();
      return AppUser.fromFirebase(user);
    }
    return null;
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      if (email.isEmpty) throw 'الرجاء إدخال البريد الإلكتروني';
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseError(e);
    } catch (e) {
      throw 'حدث خطأ أثناء إرسال رابط استعادة كلمة المرور';
    }
  }

  String _handleFirebaseError(FirebaseAuthException e) {
    print(e.code.toString());
    switch (e.code) {
      case 'invalid-credential':
        return 'البريد الإلكتروني أو كلمة المرور غير صحيحة';
      case 'user-not-found':
        return 'المستخدم غير موجود';
      case 'wrong-password':
        return 'كلمة المرور غير صحيحة';
      case 'email-already-in-use':
        return 'البريد الإلكتروني مستخدم بالفعل';
      case 'weak-password':
        return 'كلمة المرور ضعيفة';
      case 'invalid-email':
        return "يرجى كتابة البريد الإلكتروني بشكل صحيح";
      default:
        return 'حدث خطأ غير متوقع';
    }
  }
}
