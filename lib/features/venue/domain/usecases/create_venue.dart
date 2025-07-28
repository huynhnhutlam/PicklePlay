import 'package:dartz/dartz.dart';
import 'package:pickle_app/core/error/failures.dart';
import 'package:pickle_app/core/usecases/usecase.dart';
import 'package:pickle_app/features/venue/domain/entities/venue_entity.dart';
import 'package:pickle_app/features/venue/domain/repositories/venue_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class CreateVenue implements UseCase<VenueEntity, VenueEntity> {
  final VenueRepository repository;

  const CreateVenue(this.repository);

  @override
  Future<Either<Failure, VenueEntity>> call(VenueEntity venue) async {
    return await repository.createVenue(venue);
  }
}
