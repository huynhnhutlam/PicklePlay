import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pickle_app/core/base/blocs/loadmore/base_loadmore_state.dart';
import 'package:pickle_app/core/widget/loadmore/loadmore_base.dart';
import 'package:pickle_app/features/venue/domain/entities/venue_entity.dart';
import 'package:pickle_app/features/venue/presentation/bloc/venue_list/venue_cubit.dart';
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
    context.read<VenueListCubit>().fetchFirstPage();
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
      context.read<VenueListCubit>().fetchFirstPage();
    } else {
      context.read<VenueListCubit>().fetchFirstPage(
        filters: {'searchQuery': query},
      );
    }
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
        backgroundColor: Theme.of(context).primaryColor,
        titleTextStyle: const TextStyle(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            color: Colors.white,
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
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            color: Colors.white,
            onPressed: () {
              // TODO: Implement notifications
            },
          ),
        ],
      ),
      body: BlocConsumer<VenueListCubit, LoadMoreState<VenueEntity>>(
        listener: (context, state) {
          if (state is LoadMoreError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Error')));
          }
        },
        builder: (context, state) {
          return LoadMoreListView<VenueEntity>(
            state: state,
            onLoadMore: () {
              context.read<VenueListCubit>().fetchNextPage();
            },
            onRetry: () {
              context.read<VenueListCubit>().fetchFirstPage();
            },
            onRefresh: () async {
              context.read<VenueListCubit>().refresh();
            },
            itemBuilder: (context, item, index) {
              return VenueCard(venue: item, onTap: () {});
            },
          );
        },
      ),
    );
  }
}
