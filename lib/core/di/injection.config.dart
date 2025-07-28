// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:pickle_app/features/auth/data/datasources/remote/auth_remote_datasource.dart'
    as _i692;
import 'package:pickle_app/features/auth/data/datasources/remote/supabase_auth_remote_datasource.dart'
    as _i821;
import 'package:pickle_app/features/auth/data/repositories/auth_repository_impl.dart'
    as _i708;
import 'package:pickle_app/features/auth/domain/repositories/auth_repository.dart'
    as _i785;
import 'package:pickle_app/features/auth/domain/usecases/sign_in_usecase.dart'
    as _i597;
import 'package:pickle_app/features/auth/domain/usecases/sign_up_usecase.dart'
    as _i529;
import 'package:pickle_app/features/auth/presentation/bloc/auth_bloc.dart'
    as _i932;
import 'package:pickle_app/features/venue/data/datasources/remote/venue_remote_datasource.dart'
    as _i83;
import 'package:pickle_app/features/venue/data/datasources/remote/venue_remote_datasource_impl.dart'
    as _i729;
import 'package:pickle_app/features/venue/data/repositories/venue_repository_impl.dart'
    as _i941;
import 'package:pickle_app/features/venue/domain/repositories/venue_repository.dart'
    as _i529;
import 'package:pickle_app/features/venue/domain/usecases/create_venue.dart'
    as _i908;
import 'package:pickle_app/features/venue/domain/usecases/delete_venue.dart'
    as _i574;
import 'package:pickle_app/features/venue/domain/usecases/get_nearby_venues.dart'
    as _i1028;
import 'package:pickle_app/features/venue/domain/usecases/get_venue.dart'
    as _i661;
import 'package:pickle_app/features/venue/domain/usecases/get_venues.dart'
    as _i450;
import 'package:pickle_app/features/venue/domain/usecases/get_venues_by_owner.dart'
    as _i74;
import 'package:pickle_app/features/venue/domain/usecases/search_venues.dart'
    as _i306;
import 'package:pickle_app/features/venue/domain/usecases/update_venue.dart'
    as _i636;
import 'package:pickle_app/features/venue/presentation/bloc/venue_bloc.dart'
    as _i1018;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.factory<_i932.AuthBloc>(() => _i932.AuthBloc());
    gh.factory<_i1018.VenueBloc>(() => _i1018.VenueBloc());
    gh.factory<_i692.AuthRemoteDataSource>(
      () => _i821.SupabaseAuthRemoteDataSource(),
    );
    gh.factory<_i83.VenueRemoteDataSource>(
      () => _i729.VenueRemoteDataSourceImpl(),
    );
    gh.lazySingleton<_i529.VenueRepository>(
      () => _i941.VenueRepositoryImpl(
        remoteDataSource: gh<_i83.VenueRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i785.AuthRepository>(
      () => _i708.AuthRepositoryImpl(
        remoteDataSource: gh<_i692.AuthRemoteDataSource>(),
      ),
    );
    gh.factory<_i574.DeleteVenue>(
      () => _i574.DeleteVenue(gh<_i529.VenueRepository>()),
    );
    gh.factory<_i908.CreateVenue>(
      () => _i908.CreateVenue(gh<_i529.VenueRepository>()),
    );
    gh.factory<_i450.GetVenues>(
      () => _i450.GetVenues(gh<_i529.VenueRepository>()),
    );
    gh.factory<_i74.GetVenuesByOwner>(
      () => _i74.GetVenuesByOwner(gh<_i529.VenueRepository>()),
    );
    gh.factory<_i636.UpdateVenue>(
      () => _i636.UpdateVenue(gh<_i529.VenueRepository>()),
    );
    gh.factory<_i1028.GetNearbyVenues>(
      () => _i1028.GetNearbyVenues(gh<_i529.VenueRepository>()),
    );
    gh.factory<_i306.SearchVenues>(
      () => _i306.SearchVenues(gh<_i529.VenueRepository>()),
    );
    gh.factory<_i661.GetVenue>(
      () => _i661.GetVenue(gh<_i529.VenueRepository>()),
    );
    gh.factory<_i1028.GetNearbyVenuesParams>(
      () => _i1028.GetNearbyVenuesParams(
        latitude: gh<double>(),
        longitude: gh<double>(),
        radiusKm: gh<double>(),
      ),
    );
    gh.factory<_i597.SignInWithEmailAndPasswordUseCase>(
      () => _i597.SignInWithEmailAndPasswordUseCase(gh<_i785.AuthRepository>()),
    );
    gh.factory<_i529.SignUpWithEmailAndPasswordUseCase>(
      () => _i529.SignUpWithEmailAndPasswordUseCase(gh<_i785.AuthRepository>()),
    );
    return this;
  }
}
