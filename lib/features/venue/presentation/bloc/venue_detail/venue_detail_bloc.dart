import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:pickle_app/core/error/failures.dart';
import 'package:pickle_app/features/venue/domain/entities/venue_entity.dart';
import 'package:pickle_app/features/venue/domain/usecases/usecase.dart';

part 'venue_detail_event.dart';
part 'venue_detail_state.dart';

class VenueDetailBloc extends Bloc<VenueDetailEvent, VenueDetailState> {
  final GetVenue getVenue = GetIt.instance<GetVenue>();
  VenueDetailBloc() : super(VenueDetailInitial()) {
    on<VenueDetailEvent>((event, emit) {
      on<LoadVenueDetailEvent>(_onLoadVenueDetail);
    });
  }

  Future<void> _onLoadVenueDetail(
    LoadVenueDetailEvent event,
    Emitter<VenueDetailState> emit,
  ) async {
    emit(VenueDetailLoadding());
    final failureOrVenue = await getVenue(event.id.toString());
    emit(
      failureOrVenue.fold(
        (failure) => VenueDetailFailed(message: _mapFailureToMessage(failure)),
        (venue) => VenueDetailLoaded(venue: venue),
      ),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) {
      return 'Server error. Please try again later.';
    } else if (failure is NetworkFailure) {
      return 'No internet connection. Please check your connection and try again.';
      // } else if (failure is NotFoundFailure) {
      //   return 'The requested venue was not found.';
      // } else if (failure is UnauthorizedFailure) {
      //   return 'You are not authorized to perform this action.';
    } else if (failure is ValidationFailure) {
      return 'Validation failed. Please check your input.';
    } else {
      return 'An unexpected error occurred. Please try again.';
    }
  }
}
