import 'package:flutter/material.dart';
// import '../../domain/entities/booking_list_entity.dart'; // Import entity if widget displays it

class BookinglistWidget extends StatelessWidget {
  // TODO: Add properties to receive data if this is a stateless widget
  // final BookinglistEntity? data;

  const BookinglistWidget({
    super.key,
    // this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bookinglist Widget Content',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'This is a reusable UI component for the Bookinglist feature.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            // TODO: Display data passed to the widget
            // if (data != null) Text('Data ID: ${data!.id}, Name: ${data!.name}'),
          ],
        ),
      ),
    );
  }
}
