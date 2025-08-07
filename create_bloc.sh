#!/bin/bash
# create_flutter_bloc_clean_feature.sh
#
# This script interactively prompts the user to create a new Flutter BLoC
# feature with a Clean Architecture folder and file structure.
# It handles conversion of feature names between snake_case and PascalCase
# for correct naming conventions in files, directories, and Dart classes.
#
# Usage:
#   bash create_flutter_bloc_clean_feature.sh
#
# Requirements:
#   - Feature name (snake_case or PascalCase) is mandatory.
#   - Checks for existing feature directory to prevent overwrites.
#   - Generates minimal boilerplate code for each Dart file.

# Function to convert snake_case or PascalCase to PascalCase
# For example: test -> Test, user_profile -> UserProfile, UserProfile -> UserProfile
to_pascal_case() {
  local input="$1"
  # Use awk for robust PascalCase conversion, compatible with macOS (BSD awk)
  echo "$input" | awk -F'_' '{
    for(i=1; i<=NF; i++) {
      # Handle empty parts in case of leading/trailing/double underscores
      if (length($i) > 0) {
        printf toupper(substr($i,1,1)) tolower(substr($i,2));
      }
    }
  }'
}

# Function to convert PascalCase or snake_case to snake_case (all lowercase with underscores)
# This version avoids non-portable features like \L and handles acronyms.
# For example: Test -> test, UserProfile -> user_profile, user_profile -> user_profile, HTTPClient -> http_client
to_snake_case() {
  local input="$1"
  local temp_snake

  # 1. Insert underscore between a lowercase letter/digit and an uppercase letter (e.g., userProfile -> user_Profile)
  # 2. Insert underscore between an uppercase letter followed by another uppercase letter
  #    and then a lowercase letter (e.g., HTTPClient -> HTTP_Client, ensuring acronyms like HTTP are not split H_T_T_P)
  temp_snake=$(echo "$input" | sed -E 's/([a-z0-9])([A-Z])/\1_\2/g; s/([A-Z]+)([A-Z][a-z])/\1_\2/g')

  # 3. Convert the entire string to lowercase
  local lower_snake=$(echo "$temp_snake" | tr '[:upper:]' '[:lower:]')

  # 4. Remove any leading underscores that might result from conversion (e.g., _test -> test)
  # 5. Collapse multiple underscores into a single one (e.g., a__b -> a_b)
  echo "$lower_snake" | sed 's/^_//' | tr -s '_'
}

# --- Input Prompts ---

# 1. Prompt for feature name (accepts snake_case or PascalCase)
read -p "Enter the feature name (e.g., user_profile or UserProfile): " RAW_FEATURE_NAME

# Validate feature name
if [ -z "$RAW_FEATURE_NAME" ]; then
  echo "Error: Feature name cannot be empty."
  echo "Usage: Please provide a valid feature name (e.g., product_detail or ProductDetail)."
  exit 1
fi

# Convert raw input to PascalCase for Dart class names
PASCAL_FEATURE_NAME=$(to_pascal_case "$RAW_FEATURE_NAME")

# Convert raw input to snake_case for file and directory names
SNAKE_FEATURE_NAME=$(to_snake_case "$RAW_FEATURE_NAME")

# 2. Prompt for feature directory name (optional, defaults to snake_case feature name)
read -p "Enter the feature directory name (optional, defaults to '$SNAKE_FEATURE_NAME'): " FEATURE_DIR_INPUT
FEATURE_DIR_NAME=${FEATURE_DIR_INPUT:-$SNAKE_FEATURE_NAME} # If input is empty, use SNAKE_FEATURE_NAME

# 3. Prompt for base directory (optional, defaults to lib/features)
read -p "Enter the base directory (optional, defaults to 'lib/features'): " BASE_DIR_INPUT
BASE_DIR=${BASE_DIR_INPUT:-lib/features} # If input is empty, use 'lib/features'

# Construct the full path for the new feature directory
FULL_FEATURE_PATH="$BASE_DIR/$FEATURE_DIR_NAME"

# --- Pre-creation Checks ---

# Check if the target feature directory already exists
if [ -d "$FULL_FEATURE_PATH" ]; then
  echo "Error: The feature directory '$FULL_FEATURE_PATH' already exists."
  echo "Please choose a different feature name or delete the existing directory if you wish to overwrite."
  exit 1
fi

echo "--- Creating new Flutter BLoC Clean Architecture feature ---"
echo "Raw Input Name:     $RAW_FEATURE_NAME"
echo "PascalCase Name:    $PASCAL_FEATURE_NAME"
echo "Snake_Case Name:    $SNAKE_FEATURE_NAME"
echo "Feature Directory:  $FEATURE_DIR_NAME"
echo "Base Directory:     $BASE_DIR"
echo "Full Path:          $FULL_FEATURE_PATH"
echo "---------------------------------------------------------"

# --- Create Directory Structure ---
echo "Creating directory structure..."
mkdir -p "$FULL_FEATURE_PATH/data/models"
mkdir -p "$FULL_FEATURE_PATH/data/repositories"
mkdir -p "$FULL_FEATURE_PATH/domain/entities"
mkdir -p "$FULL_FEATURE_PATH/domain/repositories"
mkdir -p "$FULL_FEATURE_PATH/domain/usecases"
mkdir -p "$FULL_FEATURE_PATH/presentation/bloc"
mkdir -p "$FULL_FEATURE_PATH/presentation/pages"
mkdir -p "$FULL_FEATURE_PATH/presentation/widgets"
echo "Directory structure created."

# --- Create Dart Files with Boilerplate Code ---
echo "Creating boilerplate Dart files..."

# data/models/<feature_snake_case>_model.dart
cat << EOF > "$FULL_FEATURE_PATH/data/models/${SNAKE_FEATURE_NAME}_model.dart"
import '../../domain/entities/${SNAKE_FEATURE_NAME}_entity.dart';

class ${PASCAL_FEATURE_NAME}Model extends ${PASCAL_FEATURE_NAME}Entity {
  // TODO: Implement fields specific to the data layer model
  // final String id;
  // final String name;

  const ${PASCAL_FEATURE_NAME}Model({
    // required this.id,
    // required this.name,
  });

  // Example: fromJson factory constructor to convert JSON to model
  factory ${PASCAL_FEATURE_NAME}Model.fromJson(Map<String, dynamic> json) {
    return ${PASCAL_FEATURE_NAME}Model(
      // id: json['id'] as String,
      // name: json['name'] as String,
    );
  }

  // Example: toJson method to convert model to JSON
  Map<String, dynamic> toJson() {
    return {
      // 'id': id,
      // 'name': name,
    };
  }

  // Convert Model to Entity (or use as is if Model extends Entity directly)
  ${PASCAL_FEATURE_NAME}Entity toEntity() {
    return ${PASCAL_FEATURE_NAME}Entity(
      // id: id,
      // name: name,
    );
  }

  @override
  List<Object?> get props => [
    // id, name
  ];
}
EOF

# data/repositories/<feature_snake_case>_repository_impl.dart
cat << EOF > "$FULL_FEATURE_PATH/data/repositories/${SNAKE_FEATURE_NAME}_repository_impl.dart"
import '../../domain/repositories/${SNAKE_FEATURE_NAME}_repository.dart';
// import '../datasources/${SNAKE_FEATURE_NAME}_remote_data_source.dart'; // Example remote data source
// import '../datasources/${SNAKE_FEATURE_NAME}_local_data_source.dart';  // Example local data source
// import '../models/${SNAKE_FEATURE_NAME}_model.dart'; // Import model if used

class ${PASCAL_FEATURE_NAME}RepositoryImpl implements ${PASCAL_FEATURE_NAME}Repository {
  // TODO: Declare data sources as dependencies
  // final ${PASCAL_FEATURE_NAME}RemoteDataSource remoteDataSource;
  // final ${PASCAL_FEATURE_NAME}LocalDataSource localDataSource;

  // ${PASCAL_FEATURE_NAME}RepositoryImpl({
  //   // required this.remoteDataSource,
  //   // required this.localDataSource,
  // });

  // Example: Implement methods defined in the domain repository
  // @override
  // Future<${PASCAL_FEATURE_NAME}Entity> get${PASCAL_FEATURE_NAME}ById(String id) async {
  //   // final model = await remoteDataSource.fetch${PASCAL_FEATURE_NAME}(id);
  //   // return model.toEntity(); // Convert model to entity before returning
  //   throw UnimplementedError('get${PASCAL_FEATURE_NAME}ById has not been implemented');
  // }
}
EOF

# domain/entities/<feature_snake_case>_entity.dart
cat << EOF > "$FULL_FEATURE_PATH/domain/entities/${SNAKE_FEATURE_NAME}_entity.dart"
import 'package:equatable/equatable.dart';

class ${PASCAL_FEATURE_NAME}Entity extends Equatable {
  // TODO: Define core properties of the entity (data-agnostic)
  // final String id;
  // final String name;

  const ${PASCAL_FEATURE_NAME}Entity({
    // required this.id,
    // required this.name,
  });

  @override
  List<Object?> get props => [
        // id, name
      ]; // For Equatable to compare objects

  // Example: copyWith method for immutability
  // ${PASCAL_FEATURE_NAME}Entity copyWith({
  //   String? id,
  //   String? name,
  // }) {
  //   return ${PASCAL_FEATURE_NAME}Entity(
  //     id: id ?? this.id,
  //     name: name ?? this.name,
  //   );
  // }
}
EOF

# domain/repositories/<feature_snake_case>_repository.dart
cat << EOF > "$FULL_FEATURE_PATH/domain/repositories/${SNAKE_FEATURE_NAME}_repository.dart"
import '../entities/${SNAKE_FEATURE_NAME}_entity.dart';

abstract class ${PASCAL_FEATURE_NAME}Repository {
  // TODO: Define abstract methods that the data layer will implement
  // These methods return domain entities or Futures of domain entities.
  // Future<${PASCAL_FEATURE_NAME}Entity> get${PASCAL_FEATURE_NAME}ById(String id);
  // Future<List<${PASCAL_FEATURE_NAME}Entity>> getAll${PASCAL_FEATURE_NAME}s();
}
EOF

# domain/usecases/get_<feature_snake_case>.dart
cat << EOF > "$FULL_FEATURE_PATH/domain/usecases/get_${SNAKE_FEATURE_NAME}.dart"
// import 'package:dartz/dartz.dart'; // For functional error handling (Either)
import 'package:equatable/equatable.dart'; // For NoParams if used

import '../repositories/${SNAKE_FEATURE_NAME}_repository.dart';
// import '../../../core/errors/failures.dart'; // Import your project's Failure class

class Get${PASCAL_FEATURE_NAME}UseCase {
  final ${PASCAL_FEATURE_NAME}Repository repository;

  Get${PASCAL_FEATURE_NAME}UseCase(this.repository);

  // TODO: Implement the callable method for the use case
  // The 'call' method makes the use case callable like a function.
  // Future<Either<Failure, ${PASCAL_FEATURE_NAME}Entity>> call(NoParams params) async {
  //   return await repository.get${PASCAL_FEATURE_NAME}ById(params.id);
  // }

  // A common practice for use cases that don't require parameters
  // Future<Either<Failure, ${PASCAL_FEATURE_NAME}Entity>> call(NoParams params) async {
  //   // return await repository.someMethod();
  //   throw UnimplementedError('call() has not been implemented in Get${PASCAL_FEATURE_NAME}UseCase');
  // }
}

// Example of a NoParams class for use cases without parameters
class NoParams extends Equatable {
  const NoParams();
  @override
  List<Object> get props => [];
}

// Example of a Param class for use cases with parameters
// class Get${PASCAL_FEATURE_NAME}Params extends Equatable {
//   final String id;
//   const Get${PASCAL_FEATURE_NAME}Params({required this.id});
//   @override
//   List<Object> get props => [id];
// }
EOF

# presentation/bloc/<feature_snake_case>_bloc.dart
cat << EOF > "$FULL_FEATURE_PATH/presentation/bloc/${SNAKE_FEATURE_NAME}_bloc.dart"
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart'; // For state comparison

import './${SNAKE_FEATURE_NAME}_event.dart';
import './${SNAKE_FEATURE_NAME}_state.dart';
// import '../../domain/usecases/get_${SNAKE_FEATURE_NAME}.dart'; // Example use case import
// import '../../domain/entities/${SNAKE_FEATURE_NAME}_entity.dart'; // Import entity if state holds it

// part '${SNAKE_FEATURE_NAME}_bloc.g.dart'; // Uncomment if using bloc_test or bloc_freezed for code generation

class ${PASCAL_FEATURE_NAME}Bloc extends Bloc<${PASCAL_FEATURE_NAME}Event, ${PASCAL_FEATURE_NAME}State> {
  // TODO: Declare use cases as dependencies
  // final Get${PASCAL_FEATURE_NAME}UseCase get${PASCAL_FEATURE_NAME}UseCase;

  ${PASCAL_FEATURE_NAME}Bloc(
      // required this.get${PASCAL_FEATURE_NAME}UseCase, // Initialize use case
      ) : super(const ${PASCAL_FEATURE_NAME}Initial()) {
    on<${PASCAL_FEATURE_NAME}Started>(_on${PASCAL_FEATURE_NAME}Started);
    // TODO: Register other event handlers (e.g., on<${PASCAL_FEATURE_NAME}LoadData>(_onLoadData);)
  }

  Future<void> _on${PASCAL_FEATURE_NAME}Started(
    ${PASCAL_FEATURE_NAME}Started event,
    Emitter<${PASCAL_FEATURE_NAME}State> emit,
  ) async {
    emit(const ${PASCAL_FEATURE_NAME}Loading());
    try {
      // TODO: Call use case and handle success/failure
      // final result = await get${PASCAL_FEATURE_NAME}UseCase(const NoParams());
      // result.fold(
      //   (failure) => emit(const ${PASCAL_FEATURE_NAME}Error('Failed to load data')),
      //   (data) => emit(${PASCAL_FEATURE_NAME}Loaded(data: data)),
      // );
      await Future.delayed(const Duration(seconds: 1)); // Simulate loading
      emit(const ${PASCAL_FEATURE_NAME}Loaded()); // Example without actual data
    } catch (e) {
      emit(${PASCAL_FEATURE_NAME}Error('An unexpected error occurred: \${e.toString()}'));
    }
  }
}
EOF

# presentation/bloc/<feature_snake_case>_event.dart
cat << EOF > "$FULL_FEATURE_PATH/presentation/bloc/${SNAKE_FEATURE_NAME}_event.dart"
import 'package:equatable/equatable.dart';

abstract class ${PASCAL_FEATURE_NAME}Event extends Equatable {
  const ${PASCAL_FEATURE_NAME}Event();

  @override
  List<Object> get props => [];
}

class ${PASCAL_FEATURE_NAME}Started extends ${PASCAL_FEATURE_NAME}Event {
  const ${PASCAL_FEATURE_NAME}Started();
}

// TODO: Add other events as needed for user interactions or data updates
// Example:
// class ${PASCAL_FEATURE_NAME}LoadData extends ${PASCAL_FEATURE_NAME}Event {
//   final String query;
//   const ${PASCAL_FEATURE_NAME}LoadData(this.query);

//   @override
//   List<Object> get props => [query];
// }
EOF

# presentation/bloc/<feature_snake_case>_state.dart
cat << EOF > "$FULL_FEATURE_PATH/presentation/bloc/${SNAKE_FEATURE_NAME}_state.dart"
import 'package:equatable/equatable.dart';
// import '../../domain/entities/${SNAKE_FEATURE_NAME}_entity.dart'; // Import entity if state holds it

abstract class ${PASCAL_FEATURE_NAME}State extends Equatable {
  const ${PASCAL_FEATURE_NAME}State();

  @override
  List<Object> get props => [];
}

class ${PASCAL_FEATURE_NAME}Initial extends ${PASCAL_FEATURE_NAME}State {
  const ${PASCAL_FEATURE_NAME}Initial();
}

class ${PASCAL_FEATURE_NAME}Loading extends ${PASCAL_FEATURE_NAME}State {
  const ${PASCAL_FEATURE_NAME}Loading();
}

class ${PASCAL_FEATURE_NAME}Loaded extends ${PASCAL_FEATURE_NAME}State {
  // TODO: Include actual data if the state represents loaded data
  // final ${PASCAL_FEATURE_NAME}Entity data;
  const ${PASCAL_FEATURE_NAME}Loaded(
      // {required this.data}
      );

  @override
  List<Object> get props => [
        // data
      ];
}

class ${PASCAL_FEATURE_NAME}Error extends ${PASCAL_FEATURE_NAME}State {
  final String message;
  const ${PASCAL_FEATURE_NAME}Error(this.message);

  @override
  List<Object> get props => [message];
}
EOF

# presentation/pages/<feature_snake_case>_page.dart
cat << EOF > "$FULL_FEATURE_PATH/presentation/pages/${SNAKE_FEATURE_NAME}_page.dart"
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/${SNAKE_FEATURE_NAME}_bloc.dart';
import '../bloc/${SNAKE_FEATURE_NAME}_event.dart';
import '../bloc/${SNAKE_FEATURE_NAME}_state.dart';
import '../widgets/${SNAKE_FEATURE_NAME}_widget.dart'; // Example: using a sub-widget
// import '../../domain/usecases/get_${SNAKE_FEATURE_NAME}.dart'; // Import use case if BLoC is created here
// import '../../data/repositories/${SNAKE_FEATURE_NAME}_repository_impl.dart'; // Import repository if BLoC is created here

class ${PASCAL_FEATURE_NAME}Page extends StatelessWidget {
  const ${PASCAL_FEATURE_NAME}Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('${PASCAL_FEATURE_NAME} Feature'),
      ),
      // Use BlocProvider to provide the BLoC to the widget tree
      body: BlocProvider(
        create: (context) {
          // TODO: Provide necessary dependencies for the BLoC
          // For simplicity, directly instantiate if no complex dependencies
          // For real apps, use RepositoryProvider/ServiceLocator
          // final repository = ${PASCAL_FEATURE_NAME}RepositoryImpl(); // Example
          // final useCase = Get${PASCAL_FEATURE_NAME}UseCase(repository); // Example
          return ${PASCAL_FEATURE_NAME}Bloc(
              // get${PASCAL_FEATURE_NAME}UseCase: useCase,
              )..add(const ${PASCAL_FEATURE_NAME}Started()); // Dispatch initial event
        },
        child: BlocBuilder<${PASCAL_FEATURE_NAME}Bloc, ${PASCAL_FEATURE_NAME}State>(
          builder: (context, state) {
            if (state is ${PASCAL_FEATURE_NAME}Initial) {
              return const Center(child: Text('Feature Initialized.'));
            } else if (state is ${PASCAL_FEATURE_NAME}Loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ${PASCAL_FEATURE_NAME}Loaded) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        '${PASCAL_FEATURE_NAME} Data Loaded!',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      // TODO: Display data using state.data
                      const ${PASCAL_FEATURE_NAME}Widget(), // Example: Integrate a sub-widget
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          // Example: Trigger another event to refresh or interact
                          BlocProvider.of<${PASCAL_FEATURE_NAME}Bloc>(context).add(const ${PASCAL_FEATURE_NAME}Started());
                        },
                        child: const Text('Refresh Data'),
                      ),
                    ],
                  ),
                ),
              );
            } else if (state is ${PASCAL_FEATURE_NAME}Error) {
              return Center(
                child: Text(
                  'Error: \${state.message}',
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
          // You can also use context.read<${PASCAL_FEATURE_NAME}Bloc>().add(...)
          BlocProvider.of<${PASCAL_FEATURE_NAME}Bloc>(context).add(const ${PASCAL_FEATURE_NAME}Started());
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
EOF

# presentation/widgets/<feature_snake_case>_widget.dart
cat << EOF > "$FULL_FEATURE_PATH/presentation/widgets/${SNAKE_FEATURE_NAME}_widget.dart"
import 'package:flutter/material.dart';
// import '../../domain/entities/${SNAKE_FEATURE_NAME}_entity.dart'; // Import entity if widget displays it

class ${PASCAL_FEATURE_NAME}Widget extends StatelessWidget {
  // TODO: Add properties to receive data if this is a stateless widget
  // final ${PASCAL_FEATURE_NAME}Entity? data;

  const ${PASCAL_FEATURE_NAME}Widget({
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
              '${PASCAL_FEATURE_NAME} Widget Content',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'This is a reusable UI component for the ${PASCAL_FEATURE_NAME} feature.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            // TODO: Display data passed to the widget
            // if (data != null) Text('Data ID: \${data!.id}, Name: \${data!.name}'),
          ],
        ),
      ),
    );
  }
}
EOF

echo "All boilerplate files created successfully."

# --- Success Message ---
echo "Success! Flutter BLoC Clean Architecture feature '$RAW_FEATURE_NAME' has been created at:"
echo "$FULL_FEATURE_PATH"
echo ""
echo "Next steps:"
echo "1. Navigate to the directory: cd $FULL_FEATURE_PATH"
echo "2. Implement the logic for your feature in the respective files."
echo "3. Remember to add necessary dependencies like 'flutter_bloc' and 'equatable' to your pubspec.yaml."
