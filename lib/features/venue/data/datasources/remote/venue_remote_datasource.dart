import 'package:dartz/dartz.dart';
import 'package:pickle_app/core/error/failures.dart';
import 'package:pickle_app/features/venue/data/models/venue_model.dart';

abstract class VenueRemoteDataSource {
  // Get all venues with optional filters
  Future<Either<Failure, List<VenueModel>>> getVenues({
    String? searchQuery,
    double? latitude,
    double? longitude,
    double? radiusKm,
    int? limit,
    int? offset,
  });

  // Get a single venue by ID
  Future<Either<Failure, VenueModel>> getVenueById(String id);

  // Create a new venue
  Future<Either<Failure, VenueModel>> createVenue(VenueModel venue);

  // Update an existing venue
  Future<Either<Failure, VenueModel>> updateVenue(VenueModel venue);

  // Delete a venue
  Future<Either<Failure, void>> deleteVenue(String id);

  // Get venues by owner
  Future<Either<Failure, List<VenueModel>>> getVenuesByOwner(String ownerId);

  // Search venues by query
  Future<Either<Failure, List<VenueModel>>> searchVenues(String query);

  // Get nearby venues
  Future<Either<Failure, List<VenueModel>>> getNearbyVenues({
    required double latitude,
    required double longitude,
    double radiusKm = 10.0,
  });
}
