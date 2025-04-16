class Reservation {
  final String userId;
  final String houseId;
  final String initDate;
  final String endDate;
  final int persons;

  Reservation({
    required this.userId,
    required this.houseId,
    required this.initDate,
    required this.endDate,
    required this.persons,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      userId: json['userId'],
      houseId: json['houseId'],
      initDate: json['initDate'],
      endDate: json['endDate'],
      persons: json['persons'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'houseId': houseId,
      'initDate': initDate,
      'endDate': endDate,
      'persons': persons,
    };
  }
}
