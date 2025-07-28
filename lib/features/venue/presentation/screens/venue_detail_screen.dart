import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pickle_app/features/venue/domain/entities/venue_entity.dart';
import 'package:pickle_app/features/venue/presentation/bloc/venue_bloc.dart';
import 'package:pickle_app/features/venue/presentation/bloc/venue_event.dart';
import 'package:pickle_app/features/venue/presentation/bloc/venue_state.dart';

class VenueDetailScreen extends StatelessWidget {
  static const routeName = '/venue-detail';

  final String venueId;

  const VenueDetailScreen({super.key, required this.venueId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Venue Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // TODO: Navigate to edit venue screen
            },
          ),
        ],
      ),
      body: BlocConsumer<VenueBloc, VenueState>(
        listener: (context, state) {
          if (state is VenueFailureState) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is VenueLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is VenueDetailLoadSuccess) {
            return _VenueDetailView(venue: state.venue);
          }

          if (state is VenueFailureState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<VenueBloc>().add(
                        LoadVenueDetail(id: venueId),
                      );
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return const Center(child: Text('Something went wrong'));
        },
      ),
    );
  }
}

class _VenueDetailView extends StatelessWidget {
  final VenueEntity venue;

  const _VenueDetailView({required this.venue});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (venue.imageUrl != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                venue.imageUrl!,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 200,
                  color: Colors.grey[200],
                  child: const Icon(Icons.broken_image, size: 50),
                ),
              ),
            )
          else
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.place, size: 50),
            ),
          const SizedBox(height: 16),
          Text(venue.name, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          if (venue.fullAddress != null)
            Row(
              children: [
                const Icon(Icons.location_on, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    venue.fullAddress!,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          const SizedBox(height: 16),
          if (venue.rating != null || venue.totalReviews != null)
            Row(
              children: [
                if (venue.rating != null) ...[
                  const Icon(Icons.star, color: Colors.amber, size: 20),
                  const SizedBox(width: 4),
                  Text(
                    '${venue.rating!.toStringAsFixed(1)}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(width: 16),
                ],
                if (venue.totalReviews != null)
                  Text(
                    '${venue.totalReviews} reviews',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
              ],
            ),
          const SizedBox(height: 16),
          if (venue.description != null) ...[
            Text('About', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              venue.description!,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ],
      ),
    );
  }
}
