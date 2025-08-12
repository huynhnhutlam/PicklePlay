import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:pickle_app/core/error/failures.dart';
import 'package:get_it/get_it.dart';
import 'package:pickle_app/features/venue/domain/entities/venue_entity.dart';
import 'package:pickle_app/features/venue/domain/usecases/usecase.dart';

part 'venue_event.dart';
part 'venue_state.dart';

@injectable
class VenueBloc extends Bloc<VenueEvent, VenueState> {
  final GetVenues getVenues = GetIt.instance<GetVenues>();
  final GetAllVenues getAllVenues = GetIt.instance<GetAllVenues>();
  final CreateVenue createVenue = GetIt.instance<CreateVenue>();
  final UpdateVenue updateVenue = GetIt.instance<UpdateVenue>();
  final DeleteVenue deleteVenue = GetIt.instance<DeleteVenue>();
  final SearchVenues searchVenues = GetIt.instance<SearchVenues>();
  final GetVenuesByOwner getVenuesByOwner = GetIt.instance<GetVenuesByOwner>();
  final GetNearbyVenues getNearbyVenues = GetIt.instance<GetNearbyVenues>();

  VenueBloc() : super(VenueInitial()) {
    on<LoadVenuesEvent>(_onLoadVenues);
    on<CreateVenueEvent>(_onCreateVenue);
    on<UpdateVenueEvent>(_onUpdateVenue);
    on<DeleteVenueEvent>(_onDeleteVenue);
    on<SearchVenuesEvent>(_onSearchVenues);
    on<LoadVenuesByOwnerEvent>(_onLoadVenuesByOwner);
    on<LoadNearbyVenuesEvent>(_onLoadNearbyVenues);
  }

  Future<void> _onLoadVenues(
    LoadVenuesEvent event,
    Emitter<VenueState> emit,
  ) async {
    emit(VenueLoading());
    // final failureOrVenues = await getVenues(
    //   VenueParams(
    //     searchQuery: event.searchQuery,
    //     limit: event.limit,
    //     offset: event.offset,
    //     latitude: null,
    //     longitude: null,
    //     radiusKm: null,
    //   ),
    // );
    final failureOrVenues = await getAllVenues(null);
    emit(
      failureOrVenues.fold(
        (failure) => VenueFailureState(message: _mapFailureToMessage(failure)),
        (venues) => VenueLoadSuccess(venues: venues),
      ),
    );
  }

  Future<void> _onCreateVenue(
    CreateVenueEvent event,
    Emitter<VenueState> emit,
  ) async {
    emit(VenueOperationInProgress());

    final failureOrSuccess = await createVenue(event.venue);

    emit(
      failureOrSuccess.fold(
        (failure) =>
            VenueOperationFailure(message: _mapFailureToMessage(failure)),
        (venue) => VenueOperationSuccess(venue: venue),
      ),
    );
  }

  Future<void> _onUpdateVenue(
    UpdateVenueEvent event,
    Emitter<VenueState> emit,
  ) async {
    emit(VenueOperationInProgress());

    final failureOrSuccess = await updateVenue(event.venue);

    emit(
      failureOrSuccess.fold(
        (failure) =>
            VenueOperationFailure(message: _mapFailureToMessage(failure)),
        (venue) => VenueOperationSuccess(venue: venue),
      ),
    );
  }

  Future<void> _onDeleteVenue(
    DeleteVenueEvent event,
    Emitter<VenueState> emit,
  ) async {
    emit(VenueOperationInProgress());

    final failureOrSuccess = await deleteVenue(event.id);

    emit(
      failureOrSuccess.fold(
        (failure) =>
            VenueOperationFailure(message: _mapFailureToMessage(failure)),
        (_) => VenueOperationSuccess(isDeleted: true),
      ),
    );
  }

  Future<void> _onSearchVenues(
    SearchVenuesEvent event,
    Emitter<VenueState> emit,
  ) async {
    emit(VenueLoading());

    final failureOrVenues = await searchVenues(event.query);

    emit(
      failureOrVenues.fold(
        (failure) => VenueFailureState(message: _mapFailureToMessage(failure)),
        (venues) => VenueLoadSuccess(venues: venues),
      ),
    );
  }

  Future<void> _onLoadVenuesByOwner(
    LoadVenuesByOwnerEvent event,
    Emitter<VenueState> emit,
  ) async {
    emit(VenueLoading());

    final failureOrVenues = await getVenuesByOwner(event.ownerId);

    emit(
      failureOrVenues.fold(
        (failure) => VenueFailureState(message: _mapFailureToMessage(failure)),
        (venues) => VenueLoadSuccess(venues: venues),
      ),
    );
  }

  Future<void> _onLoadNearbyVenues(
    LoadNearbyVenuesEvent event,
    Emitter<VenueState> emit,
  ) async {
    emit(VenueLoading());

    final failureOrVenues = await getNearbyVenues(
      GetNearbyVenuesParams(
        latitude: event.latitude,
        longitude: event.longitude,
        radiusKm: event.radiusKm,
      ),
    );

    emit(
      failureOrVenues.fold(
        (failure) => VenueFailureState(message: _mapFailureToMessage(failure)),
        (venues) => VenueLoadSuccess(venues: venues),
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
