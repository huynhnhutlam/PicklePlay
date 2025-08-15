import 'package:injectable/injectable.dart';
import 'package:pickle_app/core/base/blocs/loadmore/base_loadmore_bloc.dart';
import 'package:pickle_app/core/base/blocs/loadmore/loadmore_params.dart';
import 'package:pickle_app/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:pickle_app/features/venue/domain/entities/venue_entity.dart';
import 'package:pickle_app/features/venue/domain/usecases/get_venues.dart';

@injectable
class VenueListCubit extends LoadMoreCubit<VenueEntity> {
  final GetVenues getVenues;

  VenueListCubit({required this.getVenues, super.pageSize});

  @override
  Future<Either<Failure, List<VenueEntity>>> fetchPage(
    LoadMoreParams params,
  ) async {
    final result = await getVenues(
      VenueParams(
        searchQuery: params.filters['searchQuery'] as String?,
        latitude: params.filters['latitude'] as double?,
        longitude: params.filters['longitude'] as double?,
        radiusKm: params.filters['radiusKm'] as double?,
        limit: params.perPage,
        offset: (params.page - 1) * params.perPage,
      ),
    );
    return result;
  }
}
