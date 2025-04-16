import 'package:tesis_airbnb_web/models/house.dart';

abstract class HouseRepository {
  Future<void> add(House house);
  Future<List<House>> getHouses(String userId);
  Future<List<House>> getAllHouses();
  Future<List<House>> getApprovedHouses();
  Future<void> approveHouse(String houseId);
}
