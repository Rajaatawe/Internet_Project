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
      final url = media.url.toLowerCase();

      if (_isImageFile(url)) {
        photos.add(media.url);
      } else if (_isVideoFile(url)) {
        videos.add(media.url);
      } else {
        files.add(media.url);
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
      url.contains('youtube');

  // ===================== UI =====================
  @override
  Widget build(BuildContext context) {
    final spacing = ResponsiveUtils.mediumSpacing(context);
    final fontSize = ResponsiveUtils.bodyTextSize(context);

    final categorized = _categorizeMedia();

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
            if (categorized['photos']!.isNotEmpty) ...[
              _sectionTitle('Photos', categorized['photos']!.length, fontSize),
              _photoGrid(context, categorized['photos']!),
              SizedBox(height: spacing * 2),
            ],
            if (categorized['videos']!.isNotEmpty) ...[
              _sectionTitle('Videos', categorized['videos']!.length, fontSize),
              _videoGrid(context, categorized['videos']!),
              SizedBox(height: spacing * 2),
            ],
            if (categorized['files']!.isNotEmpty) ...[
              const Divider(color: Colors.brown),
              _sectionTitle('Files', categorized['files']!.length, fontSize),
              _fileGrid(context, categorized['files']!),
            ],
            if (mediaList.isEmpty) _emptyState(),
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

  // ===================== Photos =====================
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

  // ===================== Videos =====================
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
        final fileUrl = files[i];
        final name = fileUrl.split('/').last.toLowerCase();

        IconData icon = Icons.insert_drive_file;
        Color color = Colors.brown;

        if (name.endsWith('.pdf')) {
          icon = Icons.picture_as_pdf;
          color = Colors.red;
        }

        return GestureDetector(
          onTap: () => _openAnyFile(fileUrl),
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

  Widget _emptyState() {
    return const Center(
      child: Column(
        children: [
          SizedBox(height: 120),
          Icon(Icons.folder_open, size: 64, color: Colors.grey),
          SizedBox(height: 10),
          Text('No documents available'),
        ],
      ),
    );
  }

  // ===================== Actions =====================

  Future<File?> _downloadFile(String url) async {
    try {
      final uri = Uri.parse(url);
      final dir = await getTemporaryDirectory();
      final filePath = '${dir.path}/${uri.pathSegments.last}';

      final request = await HttpClient().getUrl(uri);
      final response = await request.close();

      if (response.statusCode != 200) {
        throw Exception('Download failed');
      }

      final bytes = await consolidateHttpClientResponseBytes(response);
      final file = File(filePath);
      await file.writeAsBytes(bytes);

      return file;
    } catch (e) {
      debugPrint('Download error: $e');
      return null;
    }
  }

  Future<void> _openPhoto(BuildContext context, String url) async {
    final file = await _downloadFile(url);
    if (file == null) return;

    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.black,
        insetPadding: const EdgeInsets.all(20),
        child: InteractiveViewer(
          child: Image.file(file),
        ),
      ),
    );
  }

  Future<void> _openAnyFile(String url) async {
    final file = await _downloadFile(url);
    if (file == null) return;

    await OpenFilex.open(file.path);
  }

  Future<void> _launchURL(String url) async {
    try {
      await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      debugPrint('Open URL failed: $e');
    }
  }
}
