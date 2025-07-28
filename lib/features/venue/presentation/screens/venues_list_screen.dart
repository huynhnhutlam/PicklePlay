import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pickle_app/features/venue/presentation/bloc/venue_bloc.dart';
import 'package:pickle_app/features/venue/presentation/bloc/venue_event.dart';
import 'package:pickle_app/features/venue/presentation/bloc/venue_state.dart';
import 'package:pickle_app/features/venue/presentation/widgets/venue_card.dart';

class VenuesListScreen extends StatefulWidget {
  static const routeName = '/venues';

  const VenuesListScreen({super.key});

  @override
  State<VenuesListScreen> createState() => _VenuesListScreenState();
}

class _VenuesListScreenState extends State<VenuesListScreen> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<VenueBloc>().add(const LoadVenues());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });

    if (query.isEmpty) {
      context.read<VenueBloc>().add(const LoadVenues());
    } else {
      context.read<VenueBloc>().add(SearchVenues(query: query));
    }
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<VenueBloc>().add(
        LoadVenues(searchQuery: _searchQuery.isNotEmpty ? _searchQuery : null),
      );
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Search venues...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.white70),
                ),
                style: const TextStyle(color: Colors.white),
                onChanged: _onSearchChanged,
              )
            : const Text('Venues'),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                if (_isSearching) {
                  _searchController.clear();
                  _onSearchChanged('');
                }
                _isSearching = !_isSearching;
              });
            },
          ),
          IconButton(icon: const Icon(Icons.add), onPressed: () async {}),
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

          if (state is VenueLoadSuccess) {
            if (state.venues.isEmpty) {
              return const Center(child: Text('No venues found'));
            }

            return ListView.builder(
              controller: _scrollController,
              itemCount: state.hasReachedMax
                  ? state.venues.length
                  : state.venues.length + 1,
              itemBuilder: (context, index) {
                if (index >= state.venues.length) {
                  return const Center(child: CircularProgressIndicator());
                }
                return VenueCard(venue: state.venues[index], onTap: () {});
              },
            );
          }

          return const Center(child: Text('Something went wrong'));
        },
      ),
    );
  }
}
