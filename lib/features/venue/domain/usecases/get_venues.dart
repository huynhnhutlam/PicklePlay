import 'package:dartz/dartz.dart';
import 'package:pickle_app/core/error/failures.dart';
import 'package:pickle_app/core/usecases/usecase.dart';
import 'package:pickle_app/features/venue/domain/entities/venue_entity.dart';
import 'package:pickle_app/features/venue/domain/repositories/venue_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class GetVenues implements UseCase<List<VenueEntity>, VenueParams> {
  final VenueRepository repository;

  const GetVenues(this.repository);

  @override
  Future<Either<Failure, List<VenueEntity>>> call(VenueParams params) async {
    return await repository.getVenues(
      searchQuery: params.searchQuery,
      latitude: params.latitude,
      longitude: params.longitude,
      radiusKm: params.radiusKm,
      limit: params.limit,
      offset: params.offset,
    );
  }
}

class VenueParams {
  final String? searchQuery;
  final double? latitude;
  final double? longitude;
  final double? radiusKm;
  final int? limit;
  final int? offset;

  const VenueParams({
    this.searchQuery,
    this.latitude,
    this.longitude,
    this.radiusKm,
    this.limit = 20,
    this.offset = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'searchQuery': searchQuery,
      'latitude': latitude,
      'longitude': longitude,
      'radiusKm': radiusKm,
      'limit': limit,
      'offset': offset,
    };
  }
}
