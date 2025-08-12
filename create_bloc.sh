#!/bin/bash
# create_flutter_bloc_only.sh
#
# This script creates a new BLoC (Bloc, Event, State) in an existing
# 'presentation/bloc' directory.
#
# Usage:
#   bash create_flutter_bloc_only.sh
#
# Requirements:
#   - Assumes a 'presentation/bloc' directory already exists in your project.
#   - Prompts for the BLoC name.
#   - Generates minimal boilerplate code for Bloc, Event, and State files.

# --- Helper Functions ---
# Function to convert snake_case or PascalCase to PascalCase
to_pascal_case() {
  local input="$1"
  echo "$input" | awk -F'_' '{
    for(i=1; i<=NF; i++) {
      if (length($i) > 0) {
        printf toupper(substr($i,1,1)) tolower(substr($i,2));
      }
    }
  }'
}

# Function to convert PascalCase or snake_case to snake_case
to_snake_case() {
  local input="$1"
  local temp_snake
  temp_snake=$(echo "$input" | sed -E 's/([a-z0-9])([A-Z])/\1_\2/g; s/([A-Z]+)([A-Z][a-z])/\1_\2/g')
  local lower_snake=$(echo "$temp_snake" | tr '[:upper:]' '[:lower:]')
  echo "$lower_snake" | sed 's/^_//' | tr -s '_'
}

# --- Input Prompts ---

# 1. Prompt for BLoC name (accepts snake_case or PascalCase)
read -p "Enter the BLoC name (e.g., product_bloc or ProductBloc): " RAW_BLOC_NAME

# Validate BLoC name
if [ -z "$RAW_BLOC_NAME" ]; then
  echo "Error: BLoC name cannot be empty."
  exit 1
fi

# Convert raw input to PascalCase for Dart class names
PASCAL_BLOC_NAME=$(to_pascal_case "$RAW_BLOC_NAME")

# Convert raw input to snake_case for file names
SNAKE_BLOC_NAME=$(to_snake_case "$RAW_BLOC_NAME")

# 2. Prompt for the target directory
read -p "Enter the target directory for the BLoC (e.g., lib/features/user_profile/presentation/bloc): " BLOC_DIR_INPUT
BLOC_DIR=${BLOC_DIR_INPUT:-./} # If input is empty, default to current directory

# Construct the full path for the new BLoC files
BLOC_FULL_PATH="$BLOC_DIR"

# Check if target directory exists
if [ ! -d "$BLOC_FULL_PATH" ]; then
  echo "Error: The directory '$BLOC_FULL_PATH' does not exist."
  echo "Please provide a valid path to an existing directory."
  exit 1
fi

echo "--- Creating new Flutter BLoC files ---"
echo "PascalCase Name:    $PASCAL_BLOC_NAME"
echo "Snake_Case Name:    $SNAKE_BLOC_NAME"
echo "Target Directory:   $BLOC_FULL_PATH"
echo "---------------------------------------"

# --- Create Dart Files with Boilerplate Code ---
echo "Creating boilerplate Dart files..."

# presentation/bloc/<feature_snake_case>_bloc.dart
cat << EOF > "$BLOC_FULL_PATH/${SNAKE_BLOC_NAME}_bloc.dart"
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part '${SNAKE_BLOC_NAME}_event.dart';
part '${SNAKE_BLOC_NAME}_state.dart';

class ${PASCAL_BLOC_NAME}Bloc extends Bloc<${PASCAL_BLOC_NAME}Event, ${PASCAL_BLOC_NAME}State> {
  ${PASCAL_BLOC_NAME}Bloc() : super(${PASCAL_BLOC_NAME}Initial()) {
    on<${PASCAL_BLOC_NAME}Event>((event, emit) {
      // TODO: implement event handler
    });
  }
}
EOF

# presentation/bloc/<feature_snake_case>_event.dart
cat << EOF > "$BLOC_FULL_PATH/${SNAKE_BLOC_NAME}_event.dart"
part of '${SNAKE_BLOC_NAME}_bloc.dart';

abstract class ${PASCAL_BLOC_NAME}Event extends Equatable {
  const ${PASCAL_BLOC_NAME}Event();

  @override
  List<Object> get props => [];
}
EOF

# presentation/bloc/<feature_snake_case>_state.dart
cat << EOF > "$BLOC_FULL_PATH/${SNAKE_BLOC_NAME}_state.dart"
part of '${SNAKE_BLOC_NAME}_bloc.dart';

abstract class ${PASCAL_BLOC_NAME}State extends Equatable {
  const ${PASCAL_BLOC_NAME}State();
  
  @override
  List<Object> get props => [];
}

class ${PASCAL_BLOC_NAME}Initial extends ${PASCAL_BLOC_NAME}State {}
EOF

echo "All boilerplate files created successfully."

echo "Success! BLoC '$RAW_BLOC_NAME' has been created at:"
echo "$BLOC_FULL_PATH"
echo ""