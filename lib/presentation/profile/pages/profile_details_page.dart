import 'package:flutter/material.dart';
import '../../../../domain/entities/user_profile.dart';

class ProfileDetailsPage extends StatelessWidget {
  final UserProfile profile;

  const ProfileDetailsPage({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(profile.name)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 250,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: 'profile_details_${profile.id}',
                    child: profile.profileImageUrl != null
                        ? Image.network(
                            profile.profileImageUrl!,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            color: Theme.of(
                              context,
                            ).colorScheme.primaryContainer,
                            child: Icon(
                              Icons.person,
                              size: 100,
                              color: Theme.of(
                                context,
                              ).colorScheme.onPrimaryContainer,
                            ),
                          ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Colors.black54],
                        ),
                      ),
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        profile.name,
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildSection(context, 'About', [
                    _buildDetailRow(
                      context,
                      Icons.email,
                      'Email',
                      profile.email,
                    ),
                    _buildDetailRow(
                      context,
                      Icons.wc,
                      'Gender',
                      profile.gender,
                    ),
                    if (profile.height != null)
                      _buildDetailRow(
                        context,
                        Icons.height,
                        'Height',
                        '${profile.height} cm',
                      ),
                    if (profile.weight != null)
                      _buildDetailRow(
                        context,
                        Icons.line_weight,
                        'Weight',
                        '${profile.weight} kg',
                      ),
                  ]),

                  const SizedBox(height: 20),

                  if (profile.address != null ||
                      profile.city != null ||
                      profile.state != null)
                    _buildSection(context, 'Location', [
                      if (profile.address != null)
                        _buildDetailRow(
                          context,
                          Icons.home,
                          'Address',
                          profile.address!,
                        ),
                      if (profile.city != null)
                        _buildDetailRow(
                          context,
                          Icons.location_city,
                          'City',
                          profile.city!,
                        ),
                      if (profile.state != null)
                        _buildDetailRow(
                          context,
                          Icons.map,
                          'State',
                          profile.state!,
                        ),
                    ]),

                  const SizedBox(height: 20),

                  if (profile.familyInfo != null &&
                      profile.familyInfo!.isNotEmpty)
                    _buildSection(context, 'Family Information', [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          profile.familyInfo!,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    List<Widget> children,
  ) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const Divider(),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.secondary),
          const SizedBox(width: 12),
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.labelLarge?.copyWith(color: Colors.grey[600]),
            ),
          ),
          Expanded(
            child: Text(value, style: Theme.of(context).textTheme.bodyLarge),
          ),
        ],
      ),
    );
  }
}
