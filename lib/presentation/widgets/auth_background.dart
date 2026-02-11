import 'package:flutter/material.dart';

class AuthBackground extends StatelessWidget {
  final Widget child;
  final bool withWhiteCard;
  final Widget? headerContent;
  final bool showBackButton;

  const AuthBackground({
    super.key,
    required this.child,
    this.withWhiteCard = false,
    this.headerContent,
    this.showBackButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Gradient Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF1E3A8A), // Dark Blue
                  Color(0xFF3B82F6), // Light Blue
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // Abstract Bubbles (Positioned circles)
          Positioned(top: -50, left: -50, child: _buildBubble(150)),
          Positioned(top: 100, right: -30, child: _buildBubble(100)),
          Positioned(bottom: 250, left: 20, child: _buildBubble(80)),
          Positioned(bottom: -50, right: -20, child: _buildBubble(200)),

          // Content
          SafeArea(child: withWhiteCard ? _buildCardLayout(context) : child),

          // Back Button
          if (showBackButton)
            Positioned(
              top: MediaQuery.of(context).padding.top + 10,
              left: 16,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBubble(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }

  Widget _buildCardLayout(BuildContext context) {
    return Column(
      children: [
        // Header Area (transparent, shows gradient)
        Expanded(
          flex: 2,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            alignment: Alignment.center,
            child: headerContent ?? const SizedBox(),
          ),
        ),

        // White Card Area
        Expanded(
          flex: 6,
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: child,
          ),
        ),
      ],
    );
  }
}
