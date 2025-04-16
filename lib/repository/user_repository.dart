import 'package:tesis_airbnb_web/models/user.dart';

abstract class UserRepository {
  Future<User?> getUser(String userId);
  Future<void> add(User user);
}
