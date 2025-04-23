import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Import Bloc
import 'package:toropal_clone/bloc/increment_bloc.dart'; // Import Bloc files

// Change to StatefulWidget
class IncrementScreen extends StatefulWidget {
  const IncrementScreen({super.key});

  @override
  State<IncrementScreen> createState() => _IncrementScreenState();
}

// Change from ConsumerState to State
class _IncrementScreenState extends State<IncrementScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  // Removed _errorText, now handled by Bloc state
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _incrementCounter(BuildContext context) {
    // Pass context
    final input = _controller.text;
    final number = int.tryParse(input);

    // Dispatch event to Bloc, Bloc handles validation
    context.read<IncrementBloc>().add(
      IncrementRequested(number ?? -1), // Send -1 if parse fails
    );

    _focusNode.unfocus();
    // Animation and clearing text field will be handled by BlocListener/BlocBuilder
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Increment App',
          style: Theme.of(context).textTheme.displayMedium,
        ),
        actions: [
          BlocBuilder<IncrementBloc, IncrementState>(
            buildWhen:
                (previous, current) => previous.themeMode != current.themeMode,
            builder: (context, state) {
              return IconButton(
                icon: Icon(
                  state.themeMode == ThemeMode.dark
                      ? Icons.light_mode
                      : Icons.dark_mode,
                ),
                onPressed: () {
                  final newThemeMode =
                      state.themeMode == ThemeMode.dark
                          ? ThemeMode.light
                          : ThemeMode.dark;
                  context.read<IncrementBloc>().add(
                    ThemeModeChanged(newThemeMode),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<IncrementBloc, IncrementState>(
        listener: (context, state) {
          if (state.errorMessage == null) {
            _controller.clear();
            _animationController.forward().then(
              (_) => _animationController.reverse(),
            );
          }
        },
        builder: (context, state) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  Theme.of(context).colorScheme.surface,
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 24.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: _controller,
                        focusNode: _focusNode,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Enter a positive integer',
                          errorText: state.errorMessage,
                          // Using theme's input decoration
                        ),
                        onSubmitted: (_) => _incrementCounter(context),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () => _incrementCounter(context),
                            child: Text(
                              'Increment',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: Colors.white),
                            ),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            onPressed: () {
                              context.read<IncrementBloc>().add(
                                const SaveValueRequested(),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.secondary,
                            ),
                            child: Text(
                              'Save',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Center(
                        child: ScaleTransition(
                          scale: _scaleAnimation,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 16,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).colorScheme.primary.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.primary.withOpacity(0.2),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Text(
                              '${state.value}',
                              style: Theme.of(
                                context,
                              ).textTheme.displayMedium?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color:
                          Theme.of(context).brightness == Brightness.dark
                              ? Colors.grey[850] // Dark background in dark mode
                              : Colors.white, // White background in light mode
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).shadowColor.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Saved Values',
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Expanded(
                            child:
                                state.savedValues.isEmpty
                                    ? Center(
                                      child: Text(
                                        'No values saved yet.',
                                        style:
                                            Theme.of(
                                              context,
                                            ).textTheme.bodyMedium,
                                      ),
                                    )
                                    : ListView.separated(
                                      itemCount: state.savedValues.length,
                                      separatorBuilder:
                                          (context, index) =>
                                              const Divider(height: 16),
                                      itemBuilder: (context, index) {
                                        final value = state.savedValues[index];
                                        return Container(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 12,
                                            horizontal: 16,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary
                                                .withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            border: Border.all(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary
                                                  .withOpacity(0.3),
                                            ),
                                          ),
                                          child: Text(
                                            'Value: $value',
                                            style: Theme.of(
                                              context,
                                            ).textTheme.bodyLarge?.copyWith(
                                              color:
                                                  Theme.of(
                                                    context,
                                                  ).colorScheme.primary,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
