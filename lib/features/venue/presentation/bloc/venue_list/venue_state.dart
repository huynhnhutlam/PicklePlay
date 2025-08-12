part of 'venue_bloc.dart';

abstract class VenueState extends Equatable {
  const VenueState();

  @override
  List<Object?> get props => [];
}

class VenueInitial extends VenueState {}

class VenueLoading extends VenueState {}

class VenueLoadSuccess extends VenueState {
  final List<VenueEntity> venues;
  final bool hasReachedMax;

  const VenueLoadSuccess({required this.venues, this.hasReachedMax = false});

  @override
  List<Object?> get props => [venues, hasReachedMax];

  VenueLoadSuccess copyWith({List<VenueEntity>? venues, bool? hasReachedMax}) {
    return VenueLoadSuccess(
      venues: venues ?? this.venues,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}

class VenueOperationSuccess extends VenueState {
  final VenueEntity? venue;
  final bool isDeleted;

  const VenueOperationSuccess({this.venue, this.isDeleted = false});

  @override
  List<Object?> get props => [venue, isDeleted];
}

class VenueFailureState extends VenueState {
  final String message;

  const VenueFailureState({required this.message});

  @override
  List<Object?> get props => [message];
}

class VenueOperationInProgress extends VenueState {}

class VenueOperationFailure extends VenueState {
  final String message;

  const VenueOperationFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
