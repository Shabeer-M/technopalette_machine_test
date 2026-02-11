import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:technopalette_machine_test/presentation/widgets/auth_background.dart';
import '../../../../domain/entities/user_profile.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../auth/bloc/auth_event.dart';
import '../../auth/bloc/auth_state.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  void _loadProfile() {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      context.read<ProfileBloc>().add(LoadProfileRequested(authState.user.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        Widget? header;
        Widget child = const SizedBox();

        if (state is ProfileLoading) {
          child = const Center(child: CircularProgressIndicator());
        } else if (state is ProfileLoaded || state is ProfileUpdated) {
          final profile = (state is ProfileLoaded)
              ? state.profile
              : (state as ProfileUpdated).profile;
          header = _buildHeader(profile);
          child = _buildProfileContent(profile);
        } else if (state is ProfileError) {
          child = Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Error: ${state.message}'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _loadProfile,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        } else {
          child = const Center(child: Text('No profile data'));
        }

        return Scaffold(
          body: AuthBackground(
            withWhiteCard: true,
            headerContent: header,
            child: child,
          ),
          floatingActionButton:
              (state is ProfileLoaded || state is ProfileUpdated)
              ? FloatingActionButton.extended(
                  onPressed: () => context.pushNamed('search'),
                  icon: const Icon(Icons.search),
                  label: const Text('Find Match'),
                  backgroundColor: const Color(0xFF1E3A8A),
                  foregroundColor: Colors.white,
                )
              : null,
        );
      },
    );
  }

  Widget _buildHeader(UserProfile profile) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Placeholder for spacing or back button if needed
            const SizedBox(width: 48),
            Text(
              'Profile',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.white),
              onPressed: () {
                context.pushNamed('edit_profile', extra: profile);
              },
            ),
          ],
        ),
        const SizedBox(height: 20),
        Hero(
          tag: 'profile_${profile.id}',
          child: CircleAvatar(
            radius: 50,
            backgroundImage: profile.profileImageUrl != null
                ? NetworkImage(profile.profileImageUrl!)
                : null,
            backgroundColor: Colors.white.withValues(alpha: 0.2),
            child: profile.profileImageUrl == null
                ? const Icon(Icons.person, size: 50, color: Colors.white)
                : null,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          profile.name,
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          profile.email,
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.white.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileContent(UserProfile profile) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 24.0, bottom: 24.0),
      child: Column(
        children: [
          _buildInfoTile(Icons.wc, 'Gender', profile.gender),
          if (profile.address != null)
            _buildInfoTile(
              Icons.location_on,
              'Address',
              '${profile.address}, ${profile.city}, ${profile.state}',
            ),
          if (profile.height != null)
            _buildInfoTile(Icons.height, 'Height', '${profile.height} cm'),
          if (profile.weight != null)
            _buildInfoTile(Icons.line_weight, 'Weight', '${profile.weight} kg'),

          const SizedBox(height: 20),
          if (profile.familyInfo != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Family Information",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1E3A8A),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    profile.familyInfo!,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                context.read<AuthBloc>().add(LogoutRequested());
                // GoRouter refresh stream should handle redirect
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: const BorderSide(color: Colors.red),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Log Out',
                style: GoogleFonts.poppins(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50], // Very light grey
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF1E3A8A).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: const Color(0xFF1E3A8A), size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
