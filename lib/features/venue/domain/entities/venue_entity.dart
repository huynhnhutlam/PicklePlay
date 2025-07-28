import 'package:equatable/equatable.dart';

class VenueEntity extends Equatable {
  final String id;
  final String name;
  final String address;
  final String? imageUrl;
  final double? rating;
  final int? totalReviews;
  final String? fullAddress;
  final String? description;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? ownerId;

  const VenueEntity({
    required this.id,
    required this.name,
    required this.address,
    this.imageUrl,
    this.rating,
    this.totalReviews,
    this.fullAddress,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.ownerId,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    address,
    imageUrl,
    rating,
    totalReviews,
    fullAddress,
    description,
    createdAt,
    updatedAt,
    ownerId,
  ];

  VenueEntity copyWith({
    String? id,
    String? name,
    String? address,
    String? imageUrl,
    double? rating,
    int? totalReviews,
    // final List<CourtEntity> courts,
    // final List<ProductEntity> products,
    // final List<CommentEntity> comments,
    String? fullAddress,
    String? description,
    String? ownerId,
  }) {
    return VenueEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      address: address ?? this.address,
      rating: rating ?? this.rating,
      totalReviews: totalReviews ?? this.totalReviews,
      fullAddress: fullAddress ?? this.fullAddress,
      imageUrl: imageUrl ?? this.imageUrl,
      ownerId: ownerId ?? this.ownerId,
      // courts: courts ?? this.courts,
      // products: products ?? this.products,
      // comments: comments ?? this.comments,
    );
  }
}
