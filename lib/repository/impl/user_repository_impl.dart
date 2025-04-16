import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:tesis_airbnb_web/data/appwrite_setting.dart';
import 'package:tesis_airbnb_web/models/user.dart';
import 'package:tesis_airbnb_web/repository/user_repository.dart';
import 'package:tesis_airbnb_web/utils/cons.dart';

class UserRepositoryImpl implements UserRepository {
  @override
  Future<void> add(User user) async {
    await AppwriteApiClient.database.createDocument(
      databaseId: Constants.appwriteDatabase,
      collectionId: Constants.collectionUserId,
      documentId: "unique()",
      data: {
        "email": user.email,
        "userId": user.userId,
        "role": user.role,
        "name": user.name,
      },
    );
  }

  @override
  Future<User?> getUser(String userId) async {
    try {
      final document = await AppwriteApiClient.database.listDocuments(
          databaseId: Constants.appwriteDatabase,
          collectionId: Constants.collectionUserId,
          queries: [
            Query.equal('userId', userId),
          ]);

      return User.fromJson(document.documents.first.data);
    } on AppwriteException catch (e) {
      log(e.toString());
      return null;
    }
  }
}
