// import 'package:dartz/dartz.dart'; // For functional error handling (Either)
import 'package:equatable/equatable.dart'; // For NoParams if used

import '../repositories/booking_list_repository.dart';
// import '../../../core/errors/failures.dart'; // Import your project's Failure class

class GetBookinglistUseCase {
  final BookinglistRepository repository;

  GetBookinglistUseCase(this.repository);

  // TODO: Implement the callable method for the use case
  // The 'call' method makes the use case callable like a function.
  // Future<Either<Failure, BookinglistEntity>> call(NoParams params) async {
  //   return await repository.getBookinglistById(params.id);
  // }

  // A common practice for use cases that don't require parameters
  // Future<Either<Failure, BookinglistEntity>> call(NoParams params) async {
  //   // return await repository.someMethod();
  //   throw UnimplementedError('call() has not been implemented in GetBookinglistUseCase');
  // }
}

// Example of a NoParams class for use cases without parameters
class NoParams extends Equatable {
  const NoParams();
  @override
  List<Object> get props => [];
}

// Example of a Param class for use cases with parameters
// class GetBookinglistParams extends Equatable {
//   final String id;
//   const GetBookinglistParams({required this.id});
//   @override
//   List<Object> get props => [id];
// }
