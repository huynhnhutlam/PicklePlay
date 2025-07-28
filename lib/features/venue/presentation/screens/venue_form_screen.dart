import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pickle_app/features/venue/domain/entities/venue_entity.dart';
import 'package:pickle_app/features/venue/presentation/bloc/venue_bloc.dart';
import 'package:pickle_app/features/venue/presentation/bloc/venue_event.dart';
import 'package:pickle_app/features/venue/presentation/bloc/venue_state.dart';

class VenueFormScreen extends StatefulWidget {
  static const routeName = '/venue-form';

  final VenueEntity? venue;

  const VenueFormScreen({super.key, this.venue});

  @override
  State<VenueFormScreen> createState() => _VenueFormScreenState();
}

class _VenueFormScreenState extends State<VenueFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _fullAddressController;
  late TextEditingController _descriptionController;
  late TextEditingController _imageUrlController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.venue?.name ?? '');
    _addressController = TextEditingController(
      text: widget.venue?.address ?? '',
    );
    _fullAddressController = TextEditingController(
      text: widget.venue?.fullAddress ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.venue?.description ?? '',
    );
    _imageUrlController = TextEditingController(
      text: widget.venue?.imageUrl ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _fullAddressController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() == true) {
      final venue = VenueEntity(
        id: widget.venue?.id ?? '',
        name: _nameController.text,
        address: _addressController.text,
        fullAddress: _fullAddressController.text,
        description: _descriptionController.text.isEmpty
            ? null
            : _descriptionController.text,
        imageUrl: _imageUrlController.text.isEmpty
            ? null
            : _imageUrlController.text,
        rating: widget.venue?.rating,
        totalReviews: widget.venue?.totalReviews,
        ownerId: widget.venue?.ownerId ?? '', // TODO: Get current user ID
        createdAt: widget.venue?.createdAt,
        updatedAt: widget.venue?.updatedAt,
      );

      if (widget.venue == null) {
        context.read<VenueBloc>().add(CreateVenue(venue: venue));
      } else {
        context.read<VenueBloc>().add(UpdateVenue(venue: venue));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.venue == null ? 'Add Venue' : 'Edit Venue'),
      ),
      body: BlocListener<VenueBloc, VenueState>(
        listener: (context, state) {
          if (state is VenueOperationSuccess) {
            Navigator.of(context).pop(state.venue);
          } else if (state is VenueOperationFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Venue Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a venue name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(
                    labelText: 'Address',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _fullAddressController,
                  decoration: const InputDecoration(
                    labelText: 'Full Address',
                    hintText: 'Street, City, Country',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description (Optional)',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                  maxLines: 4,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _imageUrlController,
                  decoration: const InputDecoration(
                    labelText: 'Image URL (Optional)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.url,
                ),
                const SizedBox(height: 24),
                BlocBuilder<VenueBloc, VenueState>(
                  builder: (context, state) {
                    return ElevatedButton(
                      onPressed: state is VenueOperationInProgress
                          ? null
                          : _submitForm,
                      child: state is VenueOperationInProgress
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : Text(
                              widget.venue == null
                                  ? 'Add Venue'
                                  : 'Update Venue',
                            ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
