import 'package:equatable/equatable.dart';
// import '../../domain/entities/booking_list_entity.dart'; // Import entity if state holds it

abstract class BookinglistState extends Equatable {
  const BookinglistState();

  @override
  List<Object> get props => [];
}

class BookinglistInitial extends BookinglistState {
  const BookinglistInitial();
}

class BookinglistLoading extends BookinglistState {
  const BookinglistLoading();
}

class BookinglistLoaded extends BookinglistState {
  // TODO: Include actual data if the state represents loaded data
  // final BookinglistEntity data;
  const BookinglistLoaded(
      // {required this.data}
      );

  @override
  List<Object> get props => [
        // data
      ];
}

class BookinglistError extends BookinglistState {
  final String message;
  const BookinglistError(this.message);

  @override
  List<Object> get props => [message];
}
