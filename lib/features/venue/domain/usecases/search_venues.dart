import 'package:dartz/dartz.dart';
import 'package:pickle_app/core/error/failures.dart';
import 'package:pickle_app/core/usecases/usecase.dart';
import 'package:pickle_app/features/venue/domain/entities/venue_entity.dart';
import 'package:pickle_app/features/venue/domain/repositories/venue_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class SearchVenues implements UseCase<List<VenueEntity>, String> {
  final VenueRepository repository;

  const SearchVenues(this.repository);

  @override
  Future<Either<Failure, List<VenueEntity>>> call(String query) async {
    return await repository.searchVenues(query);
  }
}
