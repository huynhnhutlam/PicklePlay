part of 'venue_bloc.dart';

abstract class VenueEvent extends Equatable {
  const VenueEvent();

  @override
  List<Object?> get props => [];
}

class LoadVenuesEvent extends VenueEvent {
  final String? searchQuery;
  final int? limit;
  final int? offset;

  const LoadVenuesEvent({this.searchQuery, this.limit, this.offset});

  @override
  List<Object?> get props => [searchQuery, limit, offset];
}

class CreateVenueEvent extends VenueEvent {
  final VenueEntity venue;

  const CreateVenueEvent({required this.venue});

  @override
  List<Object?> get props => [venue];
}

class UpdateVenueEvent extends VenueEvent {
  final VenueEntity venue;

  const UpdateVenueEvent({required this.venue});

  @override
  List<Object?> get props => [venue];
}

class DeleteVenueEvent extends VenueEvent {
  final String id;

  const DeleteVenueEvent({required this.id});

  @override
  List<Object?> get props => [id];
}

class SearchVenuesEvent extends VenueEvent {
  final String query;

  const SearchVenuesEvent({required this.query});

  @override
  List<Object?> get props => [query];
}

class LoadVenuesByOwnerEvent extends VenueEvent {
  final String ownerId;

  const LoadVenuesByOwnerEvent({required this.ownerId});

  @override
  List<Object?> get props => [ownerId];
}

class LoadNearbyVenuesEvent extends VenueEvent {
  final double latitude;
  final double longitude;
  final double radiusKm;

  const LoadNearbyVenuesEvent({
    required this.latitude,
    required this.longitude,
    this.radiusKm = 10.0,
  });

  @override
  List<Object?> get props => [latitude, longitude, radiusKm];
}
