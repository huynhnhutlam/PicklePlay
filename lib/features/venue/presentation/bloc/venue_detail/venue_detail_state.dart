part of 'venue_detail_bloc.dart';

abstract class VenueDetailState extends Equatable {
  const VenueDetailState();

  @override
  List<Object?> get props => [];
}

class VenueDetailInitial extends VenueDetailState {}

class VenueDetailLoadding extends VenueDetailState {}

class VenueDetailFailed extends VenueDetailState {
  final String? message;
  const VenueDetailFailed({this.message});
}

class VenueDetailLoaded extends VenueDetailState {
  final VenueEntity venue;

  const VenueDetailLoaded({required this.venue});

  @override
  List<Object?> get props => [venue];
}
