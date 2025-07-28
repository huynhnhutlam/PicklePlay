import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pickle_app/features/venue/domain/entities/venue_entity.dart';

part 'venue_model.freezed.dart';
part 'venue_model.g.dart';

@freezed
@JsonSerializable(createToJson: true)
abstract class VenueModel with _$VenueModel {
  const factory VenueModel({
    required String id,
    required String name,
    required String address,
    String? imageUrl,
    double? rating,
    int? totalReviews,
    String? fullAddress,
    String? description,
    String? createdAt,
    String? updatedAt,
    String? ownerId,
  }) = _VenueModel;

  const VenueModel._();

  factory VenueModel.fromJson(Map<String, dynamic> json) =>
      _$VenueModelFromJson(json);

  factory VenueModel.fromEntity(VenueEntity entity) {
    return VenueModel(
      id: entity.id,
      name: entity.name,
      address: entity.address,
      imageUrl: entity.imageUrl,
      rating: entity.rating,
      totalReviews: entity.totalReviews,
      fullAddress: entity.fullAddress,
      description: entity.description,
      ownerId: entity.ownerId,
    );
  }

  Map<String, dynamic> toJson() => _$VenueModelToJson(this);
}

extension VenueModelX on VenueModel {
  VenueEntity toEntity() {
    return VenueEntity(
      id: id,
      name: name,
      address: address,
      imageUrl: imageUrl,
      rating: rating,
      totalReviews: totalReviews,
      fullAddress: fullAddress,
      description: description,
      ownerId: ownerId,
    );
  }
}
