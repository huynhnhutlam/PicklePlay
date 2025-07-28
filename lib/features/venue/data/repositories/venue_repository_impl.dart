import 'package:dartz/dartz.dart';
import 'package:pickle_app/core/error/failures.dart';
import 'package:pickle_app/features/venue/data/datasources/remote/venue_remote_datasource.dart';
import 'package:pickle_app/features/venue/domain/entities/venue_entity.dart';
import 'package:pickle_app/features/venue/domain/repositories/venue_repository.dart';
import 'package:pickle_app/features/venue/data/models/venue_model.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: VenueRepository)
class VenueRepositoryImpl implements VenueRepository {
  final VenueRemoteDataSource remoteDataSource;

  VenueRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<VenueEntity>>> getVenues({
    String? searchQuery,
    double? latitude,
    double? longitude,
    double? radiusKm,
    int? limit,
    int? offset,
  }) async {
    try {
      final result = await remoteDataSource.getVenues(
        searchQuery: searchQuery,
        latitude: latitude,
        longitude: longitude,
        radiusKm: radiusKm,
        limit: limit,
        offset: offset,
      );

      return result.fold(
        (failure) => Left(failure),
        (models) => Right(models.map((model) => model.toEntity()).toList()),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, VenueEntity>> getVenueById(String id) async {
    try {
      final result = await remoteDataSource.getVenueById(id);
      return result.fold(
        (failure) => Left(failure),
        (model) => Right(model.toEntity()),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, VenueEntity>> createVenue(VenueEntity venue) async {
    try {
      final model = VenueModel.fromEntity(venue);
      final result = await remoteDataSource.createVenue(model);
      return result.fold(
        (failure) => Left(failure),
        (createdModel) => Right(createdModel.toEntity()),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, VenueEntity>> updateVenue(VenueEntity venue) async {
    try {
      final model = VenueModel.fromEntity(venue);
      final result = await remoteDataSource.updateVenue(model);
      return result.fold(
        (failure) => Left(failure),
        (updatedModel) => Right(updatedModel.toEntity()),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteVenue(String id) async {
    try {
      final result = await remoteDataSource.deleteVenue(id);
      return result.fold((failure) => Left(failure), (_) => const Right(null));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<VenueEntity>>> getVenuesByOwner(
    String ownerId,
  ) async {
    try {
      final result = await remoteDataSource.getVenuesByOwner(ownerId);
      return result.fold(
        (failure) => Left(failure),
        (models) => Right(models.map((model) => model.toEntity()).toList()),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<VenueEntity>>> searchVenues(String query) async {
    try {
      final result = await remoteDataSource.searchVenues(query);
      return result.fold(
        (failure) => Left(failure),
        (models) => Right(models.map((model) => model.toEntity()).toList()),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<VenueEntity>>> getNearbyVenues({
    required double latitude,
    required double longitude,
    double radiusKm = 10.0,
  }) async {
    try {
      final result = await remoteDataSource.getNearbyVenues(
        latitude: latitude,
        longitude: longitude,
        radiusKm: radiusKm,
      );
      return result.fold(
        (failure) => Left(failure),
        (models) => Right(models.map((model) => model.toEntity()).toList()),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
