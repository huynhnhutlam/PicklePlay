part of 'venue_detail_bloc.dart';

abstract class VenueDetailEvent extends Equatable {
  const VenueDetailEvent();

  @override
  List<Object?> get props => [];
}

class LoadVenueDetailEvent extends VenueDetailEvent {
  final int? id;

  const LoadVenueDetailEvent({this.id});

  @override
  List<Object?> get props => [id];
}
