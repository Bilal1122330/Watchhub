import 'package:flutter/material.dart';
import 'package:watch_hub/widgets/user_cus_drawer.dart';
import 'package:watch_hub/widgets/video_template.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({Key? key}) : super(key: key);
  static const routeName = "/aboutus";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const UserCusDrawer(),
      appBar: AppBar(
        title: Text(
          'About Us',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        iconTheme:const IconThemeData(color: Colors.deepOrange),
      ),
      body: VideoTemplate(
        videoPath: 'assets/media/back_video/videoplayback.mp4',
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 🌟 Main Animated Heading
              TweenAnimationBuilder(
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeOut,
                tween: Tween<double>(begin: 0, end: 1),
                builder: (context, double opacity, child) {
                  return Opacity(
                    opacity: opacity,
                    child: child,
                  );
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.info_outline, color: Colors.white, size: 28),
                    SizedBox(width: 8),
                    Text(
                      "About Us",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              _buildUnifiedContainer(), // 🎨 Stylish Unified Section
            ],
          ),
        ),
      ),
    );
  }

  // 🎨 Unified Section with Modern Styling & Animated Opacity
  Widget _buildUnifiedContainer() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 700),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade700, width: 1.5),
        gradient: const LinearGradient(
          colors: [Colors.black87, Colors.black54],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.6),
            blurRadius: 10,
            spreadRadius: 3,
            offset: const Offset(5, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSection(
            icon: Icons.watch, 
            title: "Watch Hub",
            content: "Your premier destination for quality watches. Passionate about timepieces, "
                     "we deliver an exceptional shopping experience with the best products.",
          ),

          const SizedBox(height: 20),
          _glowingDivider(),

          _buildSection(
            icon: Icons.flag,
            title: "Our Mission",
            content: "To provide unparalleled quality, innovation, and service in watches, "
                     "ensuring each customer finds a timepiece that perfectly matches their style.",
          ),

          const SizedBox(height: 20),
          _glowingDivider(),

          _buildSection(
            icon: Icons.visibility,
            title: "Our Vision",
            content: "To be recognized globally as the leading watch provider, "
                     "setting standards in excellence and customer satisfaction.",
          ),
        ],
      ),
    );
  }

  // 🏆 Reusable Section with Animated Icons
  Widget _buildSection({required IconData icon, required String title, required String content}) {
    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOut,
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, double opacity, child) {
        return Opacity(
          opacity: opacity,
          child: child,
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Animated Icon with Glow Effect
              TweenAnimationBuilder(
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeInOut,
                tween: Tween<double>(begin: 0, end: 1),
                builder: (context, double scale, child) {
                  return Transform.scale(
                    scale: scale,
                    child: child,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.4),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Icon(icon, color: Colors.white, size: 26),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            content,
            style: const TextStyle(
              fontSize: 16,
              height: 1.5,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  // ✨ Glowing Divider for Sections
  Widget _glowingDivider() {
    return Container(
      height: 1.5,
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.5),
            Colors.white.withOpacity(0.1),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
    );
  }
}
