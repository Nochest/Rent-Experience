import 'package:tesis_airbnb_web/models/reservation.dart';

abstract class ReservationRepository {
  Future<void> createReservation(Reservation reservation);
}
