import '../../domain/entities/booking_list_entity.dart';

class BookinglistModel extends BookinglistEntity {
  // TODO: Implement fields specific to the data layer model
  final String? id;
  final String? name;

  const BookinglistModel({this.id, this.name});

  // Example: fromJson factory constructor to convert JSON to model
  factory BookinglistModel.fromJson(Map<String, dynamic> json) {
    return BookinglistModel(
      // id: json['id'] as String,
      // name: json['name'] as String,
    );
  }

  // Example: toJson method to convert model to JSON
  Map<String, dynamic> toJson() {
    return {
      // 'id': id,
      // 'name': name,
    };
  }

  // Convert Model to Entity (or use as is if Model extends Entity directly)
  BookinglistEntity toEntity() {
    return BookinglistEntity(
      // id: id,
      // name: name,
    );
  }

  @override
  List<Object?> get props => [
    // id, name
  ];
}
