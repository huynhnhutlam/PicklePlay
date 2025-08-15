import 'package:equatable/equatable.dart';

abstract class BookinglistEvent extends Equatable {
  const BookinglistEvent();

  @override
  List<Object> get props => [];
}

class BookinglistStarted extends BookinglistEvent {
  const BookinglistStarted();
}

// TODO: Add other events as needed for user interactions or data updates
// Example:
// class BookinglistLoadData extends BookinglistEvent {
//   final String query;
//   const BookinglistLoadData(this.query);

//   @override
//   List<Object> get props => [query];
// }
