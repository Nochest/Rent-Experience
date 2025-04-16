import 'package:tesis_airbnb_web/data/appwrite_setting.dart';
import 'package:tesis_airbnb_web/models/reservation.dart';
import 'package:tesis_airbnb_web/repository/reservation_repository.dart';
import 'package:tesis_airbnb_web/utils/cons.dart';

class ReservationRepositryImpl implements ReservationRepository {
  @override
  Future<void> createReservation(Reservation reservation) async {
    await AppwriteApiClient.database.createDocument(
      databaseId: Constants.appwriteDatabase,
      collectionId: Constants.collectionReservationId,
      documentId: "unique()",
      data: {
        'userId': reservation.userId,
        'houseId': reservation.houseId,
        'initDate': reservation.initDate,
        'endDate': reservation.endDate,
        'persons': reservation.persons,
      },
    );
  }
}
