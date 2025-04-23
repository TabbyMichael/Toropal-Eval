part of 'increment_bloc.dart';

class IncrementState extends Equatable {
  final int value;
  final String? errorMessage;
  final List<int> savedValues;
  final ThemeMode themeMode;

  const IncrementState({
    this.value = 0,
    this.errorMessage,
    this.savedValues = const [],
    this.themeMode = ThemeMode.system,
  });

  IncrementState copyWith({
    int? value,
    String? errorMessage,
    List<int>? savedValues,
    ThemeMode? themeMode,
    bool clearError = false, // Helper to explicitly clear the error
  }) {
    return IncrementState(
      value: value ?? this.value,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      savedValues: savedValues ?? this.savedValues,
      themeMode: themeMode ?? this.themeMode,
    );
  }

  @override
  List<Object?> get props => [value, errorMessage, savedValues, themeMode];
}
