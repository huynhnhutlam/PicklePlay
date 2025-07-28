import 'package:dartz/dartz.dart';
import 'package:pickle_app/core/error/failures.dart';
import 'package:pickle_app/core/usecases/usecase.dart';
import 'package:pickle_app/features/venue/domain/repositories/venue_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class DeleteVenue implements UseCase<void, String> {
  final VenueRepository repository;

  const DeleteVenue(this.repository);

  @override
  Future<Either<Failure, void>> call(String id) async {
    return await repository.deleteVenue(id);
  }
}
