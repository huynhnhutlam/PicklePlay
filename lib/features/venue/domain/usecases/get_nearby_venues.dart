import 'package:dartz/dartz.dart';
import 'package:pickle_app/core/error/failures.dart';
import 'package:pickle_app/core/usecases/usecase.dart';
import 'package:pickle_app/features/venue/domain/entities/venue_entity.dart';
import 'package:pickle_app/features/venue/domain/repositories/venue_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class GetNearbyVenuesParams {
  final double latitude;
  final double longitude;
  final double radiusKm;

  const GetNearbyVenuesParams({
    required this.latitude,
    required this.longitude,
    this.radiusKm = 10.0,
  });

  Map<String, dynamic> toJson() {
    return {'latitude': latitude, 'longitude': longitude, 'radiusKm': radiusKm};
  }
}

@Injectable()
class GetNearbyVenues
    implements UseCase<List<VenueEntity>, GetNearbyVenuesParams> {
  final VenueRepository repository;

  const GetNearbyVenues(this.repository);

  @override
  Future<Either<Failure, List<VenueEntity>>> call(
    GetNearbyVenuesParams params,
  ) async {
    return await repository.getNearbyVenues(
      latitude: params.latitude,
      longitude: params.longitude,
      radiusKm: params.radiusKm,
    );
  }
}
