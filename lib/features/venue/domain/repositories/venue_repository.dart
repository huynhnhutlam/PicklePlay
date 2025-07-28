import 'package:dartz/dartz.dart';
import 'package:pickle_app/core/error/failures.dart';
import 'package:pickle_app/features/venue/domain/entities/venue_entity.dart';

abstract class VenueRepository {
  // Get all venues
  Future<Either<Failure, List<VenueEntity>>> getVenues({
    String? searchQuery,
    double? latitude,
    double? longitude,
    double? radiusKm,
    int? limit,
    int? offset,
  });

  // Get a single venue by ID
  Future<Either<Failure, VenueEntity>> getVenueById(String id);

  // Create a new venue
  Future<Either<Failure, VenueEntity>> createVenue(VenueEntity venue);

  // Update an existing venue
  Future<Either<Failure, VenueEntity>> updateVenue(VenueEntity venue);

  // Delete a venue
  Future<Either<Failure, void>> deleteVenue(String id);

  // Get venues by owner
  Future<Either<Failure, List<VenueEntity>>> getVenuesByOwner(String ownerId);

  // Search venues by name or address
  Future<Either<Failure, List<VenueEntity>>> searchVenues(String query);

  // Get nearby venues
  Future<Either<Failure, List<VenueEntity>>> getNearbyVenues({
    required double latitude,
    required double longitude,
    double radiusKm = 10.0,
  });
}
