import 'package:dartz/dartz.dart';
import 'package:pickle_app/core/error/failures.dart';
import 'package:pickle_app/core/usecases/usecase.dart';
import 'package:pickle_app/features/venue/domain/entities/venue_entity.dart';
import 'package:pickle_app/features/venue/domain/repositories/venue_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class GetVenue implements UseCase<VenueEntity, String> {
  final VenueRepository repository;

  const GetVenue(this.repository);

  @override
  Future<Either<Failure, VenueEntity>> call(String id) async {
    return await repository.getVenueById(id);
  }
}
