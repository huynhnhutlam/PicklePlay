import 'package:equatable/equatable.dart';
import 'package:pickle_app/features/venue/domain/entities/venue_entity.dart';

abstract class VenueEvent extends Equatable {
  const VenueEvent();

  @override
  List<Object?> get props => [];
}

class LoadVenues extends VenueEvent {
  final String? searchQuery;
  final int? limit;
  final int? offset;

  const LoadVenues({
    this.searchQuery,
    this.limit,
    this.offset,
  });

  @override
  List<Object?> get props => [searchQuery, limit, offset];
}

class LoadVenueDetail extends VenueEvent {
  final String id;

  const LoadVenueDetail({required this.id});

  @override
  List<Object?> get props => [id];
}

class CreateVenue extends VenueEvent {
  final VenueEntity venue;

  const CreateVenue({required this.venue});

  @override
  List<Object?> get props => [venue];
}

class UpdateVenue extends VenueEvent {
  final VenueEntity venue;

  const UpdateVenue({required this.venue});

  @override
  List<Object?> get props => [venue];
}

class DeleteVenue extends VenueEvent {
  final String id;

  const DeleteVenue({required this.id});

  @override
  List<Object?> get props => [id];
}

class SearchVenues extends VenueEvent {
  final String query;

  const SearchVenues({required this.query});

  @override
  List<Object?> get props => [query];
}

class LoadVenuesByOwner extends VenueEvent {
  final String ownerId;

  const LoadVenuesByOwner({required this.ownerId});

  @override
  List<Object?> get props => [ownerId];
}

class LoadNearbyVenues extends VenueEvent {
  final double latitude;
  final double longitude;
  final double radiusKm;

  const LoadNearbyVenues({
    required this.latitude,
    required this.longitude,
    this.radiusKm = 10.0,
  });

  @override
  List<Object?> get props => [latitude, longitude, radiusKm];
}
