import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'increment_event.dart';
part 'increment_state.dart';

class IncrementBloc extends Bloc<IncrementEvent, IncrementState> {
  IncrementBloc() : super(const IncrementState()) {
    on<IncrementRequested>(_onIncrementRequested);
    on<SaveValueRequested>(_onSaveValueRequested);
  }

  void _onIncrementRequested(
    IncrementRequested event,
    Emitter<IncrementState> emit,
  ) {
    if (event.value > 0) {
      emit(state.copyWith(value: state.value + event.value, clearError: true));
    } else {
      emit(state.copyWith(errorMessage: 'Please enter a positive integer'));
    }
  }

  void _onSaveValueRequested(
    SaveValueRequested event,
    Emitter<IncrementState> emit,
  ) {
    if (state.savedValues.contains(state.value)) {
      emit(state.copyWith(errorMessage: 'Value already saved.'));
      return;
    }
    final updatedList = List<int>.from(state.savedValues)..add(state.value);
    emit(state.copyWith(savedValues: updatedList, clearError: true));
  }

  void _onThemeModeChanged(
    ThemeModeChanged event,
    Emitter<IncrementState> emit,
  ) {
    emit(state.copyWith(themeMode: event.themeMode));
  }
}
