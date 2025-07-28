import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pickle_app/features/venue/presentation/bloc/venue_event.dart';
import 'package:pickle_app/core/error/failures.dart';
import 'package:pickle_app/features/venue/domain/usecases/create_venue.dart'
    as create_venue_uc;
import 'package:pickle_app/features/venue/domain/usecases/delete_venue.dart'
    as delete_venue_uc;
import 'package:pickle_app/features/venue/domain/usecases/get_nearby_venues.dart'
    as get_nearby_venues_uc;
import 'package:pickle_app/features/venue/domain/usecases/get_venue.dart'
    as get_venue_uc;
import 'package:pickle_app/features/venue/domain/usecases/get_venues.dart'
    as get_venues_uc;
import 'package:pickle_app/features/venue/domain/usecases/get_venues_by_owner.dart'
    as get_venues_by_owner_uc;
import 'package:pickle_app/features/venue/domain/usecases/search_venues.dart'
    as search_venues_uc;
import 'package:pickle_app/features/venue/domain/usecases/update_venue.dart'
    as update_venue_uc;
import 'package:pickle_app/features/venue/presentation/bloc/venue_state.dart';
import 'package:get_it/get_it.dart';

@injectable
class VenueBloc extends Bloc<VenueEvent, VenueState> {
  final get_venues_uc.GetVenues getVenues =
      GetIt.instance<get_venues_uc.GetVenues>();
  final get_venue_uc.GetVenue getVenue =
      GetIt.instance<get_venue_uc.GetVenue>();
  final create_venue_uc.CreateVenue createVenue =
      GetIt.instance<create_venue_uc.CreateVenue>();
  final update_venue_uc.UpdateVenue updateVenue =
      GetIt.instance<update_venue_uc.UpdateVenue>();
  final delete_venue_uc.DeleteVenue deleteVenue =
      GetIt.instance<delete_venue_uc.DeleteVenue>();
  final search_venues_uc.SearchVenues searchVenues =
      GetIt.instance<search_venues_uc.SearchVenues>();
  final get_venues_by_owner_uc.GetVenuesByOwner getVenuesByOwner =
      GetIt.instance<get_venues_by_owner_uc.GetVenuesByOwner>();
  final get_nearby_venues_uc.GetNearbyVenues getNearbyVenues =
      GetIt.instance<get_nearby_venues_uc.GetNearbyVenues>();

  VenueBloc() : super(VenueInitial()) {
    on<LoadVenues>(_onLoadVenues);
    on<LoadVenueDetail>(_onLoadVenueDetail);
    on<CreateVenue>(_onCreateVenue);
    on<UpdateVenue>(_onUpdateVenue);
    on<DeleteVenue>(_onDeleteVenue);
    on<SearchVenues>(_onSearchVenues);
    on<LoadVenuesByOwner>(_onLoadVenuesByOwner);
    on<LoadNearbyVenues>(_onLoadNearbyVenues);
  }

  Future<void> _onLoadVenues(LoadVenues event, Emitter<VenueState> emit) async {
    emit(VenueLoading());
    final failureOrVenues = await getVenues(
      get_venues_uc.VenueParams(
        searchQuery: event.searchQuery,
        limit: event.limit,
        offset: event.offset,
        latitude: null,
        longitude: null,
        radiusKm: null,
      ),
    );
    emit(
      failureOrVenues.fold(
        (failure) => VenueFailureState(message: _mapFailureToMessage(failure)),
        (venues) => VenueLoadSuccess(venues: venues),
      ),
    );
  }

  Future<void> _onLoadVenueDetail(
    LoadVenueDetail event,
    Emitter<VenueState> emit,
  ) async {
    emit(VenueLoading());
    final failureOrVenue = await getVenue(event.id);
    emit(
      failureOrVenue.fold(
        (failure) => VenueFailureState(message: _mapFailureToMessage(failure)),
        (venue) => VenueDetailLoadSuccess(venue: venue),
      ),
    );
  }

  Future<void> _onCreateVenue(
    CreateVenue event,
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
    UpdateVenue event,
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
    DeleteVenue event,
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
    SearchVenues event,
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
    LoadVenuesByOwner event,
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
    LoadNearbyVenues event,
    Emitter<VenueState> emit,
  ) async {
    emit(VenueLoading());

    final failureOrVenues = await getNearbyVenues(
      get_nearby_venues_uc.GetNearbyVenuesParams(
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
