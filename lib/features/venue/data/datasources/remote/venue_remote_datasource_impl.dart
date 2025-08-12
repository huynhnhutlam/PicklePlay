import 'dart:developer' as developer;

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pickle_app/core/error/exceptions.dart';
import 'package:pickle_app/core/error/failures.dart';
import 'package:pickle_app/core/models/base_list_model.dart';
import 'package:pickle_app/core/network/network_client.dart';
import 'package:pickle_app/core/network/supabase_client.dart' as core;
import 'package:pickle_app/features/venue/data/datasources/remote/venue_remote_datasource.dart';
import 'package:pickle_app/features/venue/data/models/venue_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

@Injectable(as: VenueRemoteDataSource)
class VenueRemoteDataSourceImpl implements VenueRemoteDataSource {
  final supabase.SupabaseClient _supabaseClient;
  final NetworkClient _networkClient;

  VenueRemoteDataSourceImpl(this._networkClient)
    : _supabaseClient = core.SupabaseClient.client;

  @override
  Future<Either<Failure, List<VenueModel>>> getVenues({
    String? searchQuery,
    double? latitude,
    double? longitude,
    double? radiusKm,
    int? limit,
    int? offset,
  }) async {
    try {
      // Build the base query
      final query = _supabaseClient.from('venues').select('*');
      // Apply search filter if provided

      if (searchQuery != null && searchQuery.isNotEmpty) {
        query.or('name.ilike.%$searchQuery%,address.ilike.%$searchQuery%');
      }
      // Apply ordering
      query.order('created_at', ascending: false);

      // Apply pagination
      if (limit != null) {
        query.limit(limit);
      }

      if (offset != null) {
        query.range(offset, offset + (limit ?? 10) - 1);
      }

      // Execute the query
      final response = await query;

      // Parse the response
      final venues = (response as List)
          .map<VenueModel>(
            (json) => VenueModel.fromJson(json as Map<String, dynamic>),
          )
          .toList();

      return Right(venues);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e, stackTrace) {
      developer.log(
        'Error getting venues',
        error: e,
        stackTrace: stackTrace,
        name: 'VenueRemoteDataSource',
      );
      return Left(ServerFailure('Failed to load venues'));
    }
  }

  @override
  Future<Either<Failure, VenueModel>> getVenueById(String id) async {
    try {
      final response = await _supabaseClient
          .from('venues')
          .select('*')
          .eq('id', id)
          .single();

      final venue = VenueModel.fromJson(response);
      return Right(venue);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e, stackTrace) {
      developer.log(
        'Error getting venue by id: $id',
        error: e,
        stackTrace: stackTrace,
        name: 'VenueRemoteDataSource',
      );
      return Left(ServerFailure('Failed to load venue'));
    }
  }

  @override
  Future<Either<Failure, VenueModel>> createVenue(VenueModel venue) async {
    try {
      final response = await _supabaseClient
          .from('venues')
          .insert(venue.toJson())
          .select()
          .single();

      final createdVenue = VenueModel.fromJson(response);
      return Right(createdVenue);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e, stackTrace) {
      developer.log(
        'Error creating venue',
        error: e,
        stackTrace: stackTrace,
        name: 'VenueRemoteDataSource',
      );
      return Left(ServerFailure('Failed to create venue'));
    }
  }

  @override
  Future<Either<Failure, VenueModel>> updateVenue(VenueModel venue) async {
    try {
      final response = await _supabaseClient
          .from('venues')
          .update(venue.toJson())
          .eq('id', venue.id)
          .select()
          .single();

      final updatedVenue = VenueModel.fromJson(response);
      return Right(updatedVenue);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e, stackTrace) {
      developer.log(
        'Error updating venue: ${venue.id}',
        error: e,
        stackTrace: stackTrace,
        name: 'VenueRemoteDataSource',
      );
      return Left(ServerFailure('Failed to update venue'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteVenue(String id) async {
    try {
      await _supabaseClient.from('venues').delete().eq('id', id);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e, stackTrace) {
      developer.log(
        'Error deleting venue: $id',
        error: e,
        stackTrace: stackTrace,
        name: 'VenueRemoteDataSource',
      );
      return Left(ServerFailure('Failed to delete venue'));
    }
  }

  @override
  Future<Either<Failure, List<VenueModel>>> getVenuesByOwner(
    String ownerId,
  ) async {
    try {
      final response = await _supabaseClient
          .from('venues')
          .select()
          .eq('owner_id', ownerId)
          .order('created_at', ascending: false);

      final venues = (response as List)
          .map((json) => VenueModel.fromJson(json))
          .toList();

      return Right(venues);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e, stackTrace) {
      developer.log(
        'Error getting venues by owner: $ownerId',
        error: e,
        stackTrace: stackTrace,
        name: 'VenueRemoteDataSource',
      );
      return Left(ServerFailure('Failed to load venues'));
    }
  }

  @override
  Future<Either<Failure, List<VenueModel>>> searchVenues(String query) async {
    try {
      final response = await _supabaseClient
          .from('venues')
          .select()
          .or(
            'name.ilike.%$query%,address.ilike.%$query%,description.ilike.%$query%',
          )
          .order('created_at', ascending: false);

      final venues = (response as List)
          .map((json) => VenueModel.fromJson(json))
          .toList();

      return Right(venues);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e, stackTrace) {
      developer.log(
        'Error searching venues: $query',
        error: e,
        stackTrace: stackTrace,
        name: 'VenueRemoteDataSource',
      );
      return Left(ServerFailure('Failed to search venues'));
    }
  }

  @override
  Future<Either<Failure, List<VenueModel>>> getNearbyVenues({
    required double latitude,
    required double longitude,
    double radiusKm = 10.0,
  }) async {
    try {
      final response = await _supabaseClient.rpc(
        'get_nearby_venues',
        params: {'lat': latitude, 'lng': longitude, 'radius_km': radiusKm},
      );

      final venues = (response as List)
          .map((json) => VenueModel.fromJson(json))
          .toList();

      return Right(venues);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e, stackTrace) {
      developer.log(
        'Error getting nearby venues',
        error: e,
        stackTrace: stackTrace,
        name: 'VenueRemoteDataSource',
      );
      return Left(ServerFailure('Failed to load nearby venues'));
    }
  }

  @override
  Future<Either<Failure, List<VenueModel>>> getAllVenues() async {
    try {
      final response = await _networkClient.dio.get('/venues');
      final baseListModel = BaseListModel<VenueModel>.fromJson(
        response.data,
        (json) => VenueModel.fromJson(json as Map<String, dynamic>),
      );
      return Right(baseListModel.items ?? []);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e, stackTrace) {
      developer.log(
        'Error getting all venues',
        error: e,
        stackTrace: stackTrace,
        name: 'VenueRemoteDataSource',
      );
      return Left(ServerFailure('Failed to load venues'));
    }
  }
}
