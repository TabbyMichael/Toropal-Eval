part of 'increment_bloc.dart';

abstract class IncrementEvent extends Equatable {
  const IncrementEvent();

  @override
  List<Object> get props => [];
}

class IncrementRequested extends IncrementEvent {
  final int value;

  const IncrementRequested(this.value);

  @override
  List<Object> get props => [value];
}

class SaveValueRequested extends IncrementEvent {
  const SaveValueRequested();

  @override
  List<Object> get props => [];
}

class ThemeModeChanged extends IncrementEvent {
  final ThemeMode themeMode;

  const ThemeModeChanged(this.themeMode);

  @override
  List<Object> get props => [themeMode];
}
