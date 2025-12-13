import 'package:flutter/material.dart';
import 'package:internet_application_project/core/resources/responsive_util.dart';
import 'package:internet_application_project/core/widgets/customAppBar.dart';
import 'package:open_filex/open_filex.dart';
import 'package:url_launcher/url_launcher.dart';

final GlobalKey<NavigatorState> navigatorKey1 = GlobalKey<NavigatorState>();

class ViewDocumentsPage extends StatelessWidget {
  const ViewDocumentsPage({super.key});

  Future<Map<String, List<String>>> fetchDocuments() async {
    // ضع هنا استدعاء API الحقيقي
    return {
      "photos": [
        "https://images.unsplash.com/photo-1519681393784-d120267933ba",
        "https://images.unsplash.com/photo-1506765515384-028b60a970df",
      ],
      "files": [
        "https://www.w3.org/TR/PNG/iso_8859-1.txt",
        // مثال على ملف محلي على الهاتف يجب أن يكون موجود
        // "/storage/emulated/0/Download/example.pdf",
      ],
      "videos": [
        "https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4",
      ],
    };
  }

  @override
  Widget build(BuildContext context) {
    final spacing = ResponsiveUtils.mediumSpacing(context);
    final subtitleFont = ResponsiveUtils.bodyTextSize(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'View Documents', icon: Icons.arrow_back),
      body: FutureBuilder<Map<String, List<String>>>(
        future: fetchDocuments(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Failed to load documents'));
          }

          final photos = snapshot.data?['photos'] ?? [];
          final files = snapshot.data?['files'] ?? [];
          final videos = snapshot.data?['videos'] ?? [];

          return SingleChildScrollView(
            padding: EdgeInsets.all(spacing),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Photos",
                  style: TextStyle(fontSize: subtitleFont, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: spacing),
                photos.isNotEmpty
                    ? _buildPhotoGrid(context, photos)
                    : const Text("No photos available", style: TextStyle(color: Colors.grey)),

                SizedBox(height: spacing * 2),
                Text(
                  "Videos",
                  style: TextStyle(fontSize: subtitleFont, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: spacing),
                videos.isNotEmpty
                    ? _buildVideoGrid(context, videos)
                    : const Text("No videos available", style: TextStyle(color: Colors.grey)),

                SizedBox(height: spacing * 2),
                const Divider(thickness: 1, color: Colors.brown),
                SizedBox(height: spacing),
                Text(
                  "Files",
                  style: TextStyle(fontSize: subtitleFont, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: spacing),
                files.isNotEmpty
                    ? _buildDocumentGrid(context, files)
                    : const Text("No documents available", style: TextStyle(color: Colors.grey)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPhotoGrid(BuildContext context, List<String> photos) {
    final size = ResponsiveUtils.isMobile(context)
        ? 90.0
        : ResponsiveUtils.isTablet(context)
            ? 120.0
            : 150.0;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: photos.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: ResponsiveUtils.isMobile(context) ? 2 : 4,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        final url = photos[index];
        return GestureDetector(
          onTap: () => _openPhoto(context, url),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              url,
              width: size,
              height: size,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: size,
                height: size,
                color: Colors.grey.shade200,
                child: const Icon(Icons.broken_image, color: Colors.grey),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildVideoGrid(BuildContext context, List<String> videos) {
    final size = ResponsiveUtils.isMobile(context) ? 90.0 : 120.0;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: videos.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: ResponsiveUtils.isMobile(context) ? 2 : 4,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        final url = videos[index];
        return GestureDetector(
          onTap: () => _launchURL(url),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
              child: Icon(Icons.play_circle_fill, color: Colors.red, size: 50),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDocumentGrid(BuildContext context, List<String> files) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: files.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: ResponsiveUtils.isMobile(context) ? 2 : 4,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        childAspectRatio: 0.9,
      ),
      itemBuilder: (context, index) {
        final path = files[index];
        final lower = path.toLowerCase();
        final isPdf = lower.endsWith(".pdf");
        final isDoc = lower.endsWith(".doc") || lower.endsWith(".docx");
        final isTxt = lower.endsWith(".txt");

        IconData icon;
        if (isPdf) {
          icon = Icons.picture_as_pdf;
        } else if (isDoc) {
          icon = Icons.insert_drive_file;
        } else if (isTxt) {
          icon = Icons.description;
        } else {
          icon = Icons.insert_drive_file;
        }

        return GestureDetector(
          onTap: () => _isUrl(path) ? _launchURL(path) : OpenFilex.open(path),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.brown.withOpacity(0.15)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: ResponsiveUtils.isMobile(context) ? 48 : 64, color: Colors.brown),
                const SizedBox(height: 8),
                Text(
                  path.split('/').last,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _openPhoto(BuildContext context, String imageUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: Center(
            child: Image.network(imageUrl, fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);

    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint('Cannot open link: $url. Error: $e');
      if (navigatorKey1.currentContext != null) {
        ScaffoldMessenger.of(navigatorKey1.currentContext!).showSnackBar(
          const SnackBar(content: Text('Cannot open this link')),
        );
      }
    }
  }

  bool _isUrl(String path) => path.startsWith("http://") || path.startsWith("https://");
}
