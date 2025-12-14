import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:internet_application_project/core/models/complaints_model.dart';
import 'package:internet_application_project/core/resources/responsive_util.dart';
import 'package:internet_application_project/core/widgets/customAppBar.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

final GlobalKey<NavigatorState> navigatorKey1 = GlobalKey<NavigatorState>();

class ViewDocumentsPage extends StatelessWidget {
  final List<Media> mediaList;

  const ViewDocumentsPage({
    super.key,
    required this.mediaList,
  });

  // ===================== Categorization =====================
  Map<String, List<String>> _categorizeMedia() {
    final photos = <String>[];
    final videos = <String>[];
    final files = <String>[];

    for (final media in mediaList) {
      final url = media.url;
      final lower = url.toLowerCase();

      if (_isImageFile(lower)) {
        photos.add(url);
      } else if (_isVideoFile(lower)) {
        videos.add(url);
      } else {
        files.add(url);
      }
    }

    return {
      'photos': photos,
      'videos': videos,
      'files': files,
    };
  }

  bool _isImageFile(String url) =>
      url.endsWith('.jpg') ||
      url.endsWith('.jpeg') ||
      url.endsWith('.png') ||
      url.endsWith('.gif') ||
      url.endsWith('.webp');

  bool _isVideoFile(String url) =>
      url.endsWith('.mp4') ||
      url.endsWith('.mov') ||
      url.endsWith('.avi') ||
      url.endsWith('.mkv') ||
      url.contains('youtube') ||
      url.contains('video');

  bool _isUrl(String path) =>
      path.startsWith('http://') || path.startsWith('https://');

  // ===================== UI =====================
  @override
  Widget build(BuildContext context) {
    final spacing = ResponsiveUtils.mediumSpacing(context);
    final fontSize = ResponsiveUtils.bodyTextSize(context);

    final categorized = _categorizeMedia();
    final photos = categorized['photos']!;
    final videos = categorized['videos']!;
    final files = categorized['files']!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
        title: 'View Documents',
        icon: Icons.arrow_back,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(spacing),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (photos.isNotEmpty) ...[
              _sectionTitle('Photos', photos.length, fontSize),
              _photoGrid(context, photos),
              SizedBox(height: spacing * 2),
            ],
            if (videos.isNotEmpty) ...[
              _sectionTitle('Videos', videos.length, fontSize),
              _videoGrid(context, videos),
              SizedBox(height: spacing * 2),
            ],
            if (files.isNotEmpty) ...[
              const Divider(color: Colors.brown),
              _sectionTitle('Files', files.length, fontSize),
              _fileGrid(context, files),
            ],
            if (mediaList.isEmpty) _emptyState(context),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title, int count, double size) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        '$title ($count)',
        style: TextStyle(fontSize: size, fontWeight: FontWeight.w600),
      ),
    );
  }

  // ===================== Photo =====================
  Widget _photoGrid(BuildContext context, List<String> photos) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: photos.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: ResponsiveUtils.isMobile(context) ? 2 : 4,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (_, i) => GestureDetector(
        onTap: () => _openPhoto(context, photos[i]),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            photos[i],
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) =>
                const Icon(Icons.broken_image),
          ),
        ),
      ),
    );
  }

  // ===================== Video =====================
  Widget _videoGrid(BuildContext context, List<String> videos) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: videos.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: ResponsiveUtils.isMobile(context) ? 2 : 4,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (_, i) => GestureDetector(
        onTap: () => _launchURL(videos[i]),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black12,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Center(
            child: Icon(Icons.play_circle_fill,
                color: Colors.red, size: 42),
          ),
        ),
      ),
    );
  }

  // ===================== Files =====================
  Widget _fileGrid(BuildContext context, List<String> files) {
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
      itemBuilder: (_, i) {
        final file = files[i];
        final name = file.split('/').last.toLowerCase();

        IconData icon = Icons.insert_drive_file;
        Color color = Colors.brown;

        if (name.endsWith('.pdf')) {
          icon = Icons.picture_as_pdf;
          color = Colors.red;
        }

        return GestureDetector(
          onTap: () => openPdfFromHttp(file),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.brown.withOpacity(.2)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 50, color: color),
                const SizedBox(height: 8),
                Text(
                  name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ===================== Empty =====================
  Widget _emptyState(BuildContext context) {
    return Center(
      child: Column(
        children: const [
          SizedBox(height: 120),
          Icon(Icons.folder_open, size: 64, color: Colors.grey),
          SizedBox(height: 10),
          Text('No documents available'),
        ],
      ),
    );
  }

  // ===================== Actions =====================
  void _openPhoto(BuildContext context, String url) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.black,
        child: Image.network(url, fit: BoxFit.contain),
      ),
    );
  }

Future<void> _launchURL(String url) async {
  try {
    final uri = Uri.parse(url);

    await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
  } catch (e) {
    debugPrint('Open URL failed: $e');

    if (navigatorKey1.currentContext != null) {
      ScaffoldMessenger.of(navigatorKey1.currentContext!).showSnackBar(
        const SnackBar(
          content: Text('لا يمكن فتح الرابط'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

Future<void> openPdfFromHttp(String url) async {
  try {
    final dir = await getTemporaryDirectory();
    final filePath = '${dir.path}/${url.split('/').last}';

    final request = await HttpClient().getUrl(Uri.parse(url));
    final response = await request.close();
    final bytes = await consolidateHttpClientResponseBytes(response);

    final file = File(filePath);
    await file.writeAsBytes(bytes);

    await OpenFilex.open(filePath);
  } catch (e) {
    debugPrint('Failed to open PDF: $e');
  }
}

  Future<void> _openFile(String path) async {
    if (_isUrl(path)) {
      await _launchURL(path);
    } else {
      await OpenFilex.open(path);
    }
  }

  void _showError(String msg) {
    if (navigatorKey1.currentContext != null) {
      ScaffoldMessenger.of(navigatorKey1.currentContext!).showSnackBar(
        SnackBar(content: Text(msg), backgroundColor: Colors.red),
      );
    }
  }
}
