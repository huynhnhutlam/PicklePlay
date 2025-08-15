import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/booking_list_bloc.dart';
import '../bloc/booking_list_event.dart';
import '../bloc/booking_list_state.dart';
import '../widgets/booking_list_widget.dart'; // Example: using a sub-widget
// import '../../domain/usecases/get_booking_list.dart'; // Import use case if BLoC is created here
// import '../../data/repositories/booking_list_repository_impl.dart'; // Import repository if BLoC is created here

class BookinglistPage extends StatelessWidget {
  const BookinglistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookinglist Feature'),
      ),
      // Use BlocProvider to provide the BLoC to the widget tree
      body: BlocProvider(
        create: (context) {
          // TODO: Provide necessary dependencies for the BLoC
          // For simplicity, directly instantiate if no complex dependencies
          // For real apps, use RepositoryProvider/ServiceLocator
          // final repository = BookinglistRepositoryImpl(); // Example
          // final useCase = GetBookinglistUseCase(repository); // Example
          return BookinglistBloc(
              // getBookinglistUseCase: useCase,
              )..add(const BookinglistStarted()); // Dispatch initial event
        },
        child: BlocBuilder<BookinglistBloc, BookinglistState>(
          builder: (context, state) {
            if (state is BookinglistInitial) {
              return const Center(child: Text('Feature Initialized.'));
            } else if (state is BookinglistLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is BookinglistLoaded) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Bookinglist Data Loaded!',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      // TODO: Display data using state.data
                      const BookinglistWidget(), // Example: Integrate a sub-widget
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          // Example: Trigger another event to refresh or interact
                          BlocProvider.of<BookinglistBloc>(context).add(const BookinglistStarted());
                        },
                        child: const Text('Refresh Data'),
                      ),
                    ],
                  ),
                ),
              );
            } else if (state is BookinglistError) {
              return Center(
                child: Text(
                  'Error: ${state.message}',
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              );
            }
            return const Center(child: Text('Unknown state'));
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // You can also use context.read<BookinglistBloc>().add(...)
          BlocProvider.of<BookinglistBloc>(context).add(const BookinglistStarted());
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
