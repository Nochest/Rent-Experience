import 'package:appwrite/appwrite.dart';
import 'package:tesis_airbnb_web/data/appwrite_setting.dart';
import 'package:tesis_airbnb_web/models/house.dart';
import 'package:tesis_airbnb_web/repository/house_repository.dart';
import 'package:tesis_airbnb_web/utils/cons.dart';

class HouseRepositoryImpl implements HouseRepository {
  @override
  Future<void> add(House house) async {
    await AppwriteApiClient.database.createDocument(
      databaseId: Constants.appwriteDatabase,
      collectionId: Constants.collectionHouseId,
      documentId: "unique()",
      data: {
        "userId": house.userId,
        "name": house.name,
        "type": house.type,
        "place": house.place,
        //"status": house.status,
        "imagesIds": house.imagesIds,
        "price": house.price,
        "description": house.description,
      },
    );
  }

  @override
  Future<List<House>> getHouses(String userId) async {
    final documents = await AppwriteApiClient.database.listDocuments(
      databaseId: Constants.appwriteDatabase,
      collectionId: Constants.collectionHouseId,
      queries: [
        Query.equal('userId', userId),
      ],
    );
    return documents.documents.map((e) => House.fromMap(e.data)).toList();
  }

  @override
  Future<List<House>> getAllHouses() async {
    final documents = await AppwriteApiClient.database.listDocuments(
      databaseId: Constants.appwriteDatabase,
      collectionId: Constants.collectionHouseId,
      queries: [
        Query.limit(5000),
      ],
    );
    return documents.documents.map((e) => House.fromMap(e.data)).toList();
  }

  @override
  Future<void> approveHouse(String houseId) async {
    await AppwriteApiClient.database.updateDocument(
      databaseId: Constants.appwriteDatabase,
      collectionId: Constants.collectionHouseId,
      documentId: houseId,
      data: {
        "status": 'aproved',
      },
    );
  }

  @override
  Future<List<House>> getApprovedHouses() async {
    final documents = await AppwriteApiClient.database.listDocuments(
      databaseId: Constants.appwriteDatabase,
      collectionId: Constants.collectionHouseId,
      queries: [
        Query.equal('status', 'aproved'),
        Query.limit(5000),
      ],
    );
    return documents.documents.map((e) => House.fromMap(e.data)).toList();
  }
}
