import 'package:equatable/equatable.dart';

class BookinglistEntity extends Equatable {
  final String? id;
  final String? name;

  const BookinglistEntity({this.id, this.name});

  @override
  List<Object?> get props => [
    // id, name
  ]; // For Equatable to compare objects

  BookinglistEntity copyWith({String? id, String? name}) {
    return BookinglistEntity(id: id ?? this.id, name: name ?? this.name);
  }
}
