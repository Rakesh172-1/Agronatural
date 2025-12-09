import 'package:hive_flutter/hive_flutter.dart';
import 'package:vriddhiapps/features/auth/data/models/user_model.dart';

class AuthService {
  static const String userBoxName = 'users';
  static const String currentUserKey = 'current_user';

  /// Initialize Hive box for user data
  Future<void> initializeAuthBox() async {
    if (!Hive.isBoxOpen(userBoxName)) {
      await Hive.openBox(userBoxName);
    }
  }

  /// Sign up a new user
  Future<User> signUp({
    required String email,
    required String password,
    required String fullName,
    required String phoneNumber,
  }) async {
    try {
      // Validate inputs
      if (email.isEmpty || password.isEmpty || fullName.isEmpty || phoneNumber.isEmpty) {
        throw Exception('All fields are required');
      }

      if (!email.contains('@')) {
        throw Exception('Invalid email format');
      }

      if (password.length < 6) {
        throw Exception('Password must be at least 6 characters');
      }

      if (phoneNumber.length < 10) {
        throw Exception('Phone number must be at least 10 digits');
      }

      final box = Hive.box(userBoxName);
      
      // Check if user already exists
      final existingUsers = box.values.whereType<Map<dynamic, dynamic>>().toList();
      for (var user in existingUsers) {
        if (user['email'] == email) {
          throw Exception('User with this email already exists');
        }
      }

      // Create new user
      final newUser = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        email: email,
        fullName: fullName,
        phoneNumber: phoneNumber,
        isLoggedIn: true,
        createdAt: DateTime.now(),
      );

      // Store user data in Hive
      final userData = {
        'id': newUser.id,
        'email': newUser.email,
        'fullName': newUser.fullName,
        'phoneNumber': newUser.phoneNumber,
        'password': password, // In production, use proper hashing
        'isLoggedIn': newUser.isLoggedIn,
        'createdAt': newUser.createdAt?.toIso8601String(),
      };

      await box.put(newUser.id, userData);
      await box.put(currentUserKey, userData);

      return newUser;
    } catch (e) {
      rethrow;
    }
  }

  /// Sign in an existing user
  Future<User> signIn({
    required String email,
    required String password,
  }) async {
    try {
      if (email.isEmpty || password.isEmpty) {
        throw Exception('Email and password are required');
      }

      final box = Hive.box(userBoxName);
      final users = box.values.whereType<Map<dynamic, dynamic>>().toList();

      // Find user by email and password
      Map<dynamic, dynamic>? foundUser;
      for (var user in users) {
        if (user['email'] == email && user['password'] == password) {
          foundUser = user;
          break;
        }
      }

      if (foundUser == null) {
        throw Exception('Invalid email or password');
      }

      // Mark user as logged in
      foundUser['isLoggedIn'] = true;
      await box.put(foundUser['id'], foundUser);
      await box.put(currentUserKey, foundUser);

      return User(
        id: foundUser['id'],
        email: foundUser['email'],
        fullName: foundUser['fullName'],
        phoneNumber: foundUser['phoneNumber'],
        isLoggedIn: true,
        createdAt: foundUser['createdAt'] != null ? DateTime.parse(foundUser['createdAt']) : null,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Sign out current user
  Future<void> signOut() async {
    try {
      final box = Hive.box(userBoxName);
      final currentUser = box.get(currentUserKey) as Map<dynamic, dynamic>?;
      
      if (currentUser != null) {
        currentUser['isLoggedIn'] = false;
        await box.put(currentUser['id'], currentUser);
      }
      
      await box.delete(currentUserKey);
    } catch (e) {
      rethrow;
    }
  }

  /// Skip authentication and continue as guest
  Future<void> skipAuthentication() async {
    try {
      final box = Hive.box(userBoxName);
      final guestUser = {
        'id': 'guest_${DateTime.now().millisecondsSinceEpoch}',
        'email': 'guest@vriddhi.app',
        'fullName': 'Guest User',
        'phoneNumber': '0000000000',
        'isLoggedIn': true,
        'createdAt': DateTime.now().toIso8601String(),
      };
      
      await box.put('current_user', guestUser);
    } catch (e) {
      rethrow;
    }
  }

  /// Get current logged-in user
  Future<User?> getCurrentUser() async {
    try {
      final box = Hive.box(userBoxName);
      final userData = box.get(currentUserKey) as Map<dynamic, dynamic>?;
      
      if (userData == null) {
        return null;
      }

      return User(
        id: userData['id'],
        email: userData['email'],
        fullName: userData['fullName'],
        phoneNumber: userData['phoneNumber'],
        isLoggedIn: userData['isLoggedIn'] ?? false,
        createdAt: userData['createdAt'] != null ? DateTime.parse(userData['createdAt']) : null,
      );
    } catch (e) {
      return null;
    }
  }

  /// Check if user is authenticated
  Future<bool> isUserAuthenticated() async {
    try {
      final user = await getCurrentUser();
      return user != null && user.isLoggedIn;
    } catch (e) {
      return false;
    }
  }
}
