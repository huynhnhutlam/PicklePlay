import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import './booking_list_event.dart';
import './booking_list_state.dart';
// import '../../domain/usecases/get_booking_list.dart'; // Example use case import
// import '../../domain/entities/booking_list_entity.dart'; // Import entity if state holds it

// part 'booking_list_bloc.g.dart'; // Uncomment if using bloc_test or bloc_freezed for code generation
@injectable
class BookinglistBloc extends Bloc<BookinglistEvent, BookinglistState> {
  // TODO: Declare use cases as dependencies
  // final GetBookinglistUseCase getBookinglistUseCase;

  BookinglistBloc(
    // required this.getBookinglistUseCase, // Initialize use case
  ) : super(const BookinglistInitial()) {
    on<BookinglistStarted>(_onBookinglistStarted);
    // TODO: Register other event handlers (e.g., on<BookinglistLoadData>(_onLoadData);)
  }

  Future<void> _onBookinglistStarted(
    BookinglistStarted event,
    Emitter<BookinglistState> emit,
  ) async {
    emit(const BookinglistLoading());
    try {
      // TODO: Call use case and handle success/failure
      // final result = await getBookinglistUseCase(const NoParams());
      // result.fold(
      //   (failure) => emit(const BookinglistError('Failed to load data')),
      //   (data) => emit(BookinglistLoaded(data: data)),
      // );
      await Future.delayed(const Duration(seconds: 1)); // Simulate loading
      emit(const BookinglistLoaded()); // Example without actual data
    } catch (e) {
      emit(BookinglistError('An unexpected error occurred: ${e.toString()}'));
    }
  }
}
