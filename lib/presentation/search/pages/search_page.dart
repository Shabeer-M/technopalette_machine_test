import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../domain/usecases/profile/search_profiles_usecase.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../auth/bloc/auth_state.dart';
import '../bloc/search_bloc.dart';
import '../bloc/search_event.dart';
import '../bloc/search_state.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SearchBloc>(),
      child: const SearchView(),
    );
  }
}

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();

  RangeValues _heightRange = const RangeValues(150, 180); // cm
  RangeValues _weightRange = const RangeValues(50, 80); // kg

  // Optional: Allow manual gender override
  String? _selectedGender;

  @override
  void dispose() {
    _nameController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      if (authState.user.gender == 'Groom') {
        _selectedGender = 'Bride';
      } else if (authState.user.gender == 'Bride') {
        _selectedGender = 'Groom';
      }
    }
  }

  void _onSearch() {
    if (_formKey.currentState!.validate()) {
      // Auto-detect gender from AuthBloc if not manually selected
      String? genderFilter = _selectedGender;
      if (genderFilter == null) {
        final authState = context.read<AuthBloc>().state;
        if (authState is AuthAuthenticated) {
          // Assuming we might have gender in user profile later, but for now
          // we can default to 'Bride' searching for 'Groom' or vice-versa if we knew.
          // Since we don't, we leave filter null unless selected.
        }
      }

      final filters = SearchProfilesParams(
        query: _nameController.text,
        minHeight: _heightRange.start,
        maxHeight: _heightRange.end,
        minWeight: _weightRange.start,
        maxWeight: _weightRange.end,
        city: _cityController.text.isEmpty ? null : _cityController.text,
        state: _stateController.text.isEmpty ? null : _stateController.text,
        myGender: genderFilter,
      );

      context.read<SearchBloc>().add(SearchRequested(filters));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Profiles'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {},
            tooltip: 'History',
          ),
        ],
      ),
      body: BlocListener<SearchBloc, SearchState>(
        listener: (context, state) {
          if (state is SearchLoaded) {
            context.pushNamed('search_results');
          } else if (state is SearchEmpty) {
            context.pushNamed('search_results');
          } else if (state is SearchError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildAnimatedSection(
                  child: TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name (Required)',
                      prefixIcon: Icon(Icons.search),
                      helperText: 'Enter name to start search',
                    ),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Please enter a name'
                        : null,
                  ),
                ),
                const SizedBox(height: 24),

                _buildSectionHeader('Physical Attributes'),
                _buildAnimatedSection(
                  child: Column(
                    children: [
                      _buildRangeSlider(
                        label: 'Height (cm)',
                        values: _heightRange,
                        min: 100,
                        max: 250,
                        onChanged: (values) =>
                            setState(() => _heightRange = values),
                      ),
                      const SizedBox(height: 16),
                      _buildRangeSlider(
                        label: 'Weight (kg)',
                        values: _weightRange,
                        min: 30,
                        max: 150,
                        onChanged: (values) =>
                            setState(() => _weightRange = values),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                _buildSectionHeader('Location'),
                _buildAnimatedSection(
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _cityController,
                          decoration: const InputDecoration(
                            labelText: 'City',
                            prefixIcon: Icon(Icons.location_city),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _stateController,
                          decoration: const InputDecoration(
                            labelText: 'State',
                            prefixIcon: Icon(Icons.map),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                BlocBuilder<SearchBloc, SearchState>(
                  builder: (context, state) {
                    return FilledButton.icon(
                      onPressed: state is SearchLoading ? null : _onSearch,
                      icon: state is SearchLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.search),
                      label: Text(
                        state is SearchLoading
                            ? 'Searching...'
                            : 'Search Matches',
                      ),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
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

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildRangeSlider({
    required String label,
    required RangeValues values,
    required double min,
    required double max,
    required ValueChanged<RangeValues> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: Theme.of(context).textTheme.bodyMedium),
            Text(
              '${values.start.round()} - ${values.end.round()}',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
        RangeSlider(
          values: values,
          min: min,
          max: max,
          divisions: (max - min).toInt(),
          labels: RangeLabels(
            values.start.round().toString(),
            values.end.round().toString(),
          ),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildAnimatedSection({required Widget child}) {
    // Simple animated wrapper could be added here for entry animations
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 500),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
