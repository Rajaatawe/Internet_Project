import 'package:flutter/material.dart';
import 'package:internet_application_project/core/models/complaints_model.dart';
import 'package:internet_application_project/core/resources/responsive_util.dart';
import 'package:internet_application_project/core/widgets/customAppBar.dart';
import 'package:open_filex/open_filex.dart';
import 'package:url_launcher/url_launcher.dart';

final GlobalKey<NavigatorState> navigatorKey1 = GlobalKey<NavigatorState>();

class ViewDocumentsPage extends StatelessWidget {
  final List<Media> mediaList;
  
  const ViewDocumentsPage({
    super.key,
    required this.mediaList,
  });

  Map<String, List<String>> _categorizeMedia() {
    List<String> photos = [];
    List<String> videos = [];
    List<String> files = [];

    for (var media in mediaList) {
      final url = media.url;
      final lowerUrl = url.toLowerCase();
      
      // تصنيف حسب الامتداد
      if (_isImageFile(lowerUrl)) {
        photos.add(url);
      } else if (_isVideoFile(lowerUrl)) {
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

  bool _isImageFile(String url) {
    return url.endsWith('.jpg') ||
           url.endsWith('.jpeg') ||
           url.endsWith('.png') ||
           url.endsWith('.gif') ||
           url.endsWith('.bmp') ||
           url.endsWith('.webp') ||
           url.contains('unsplash.com') ||
           url.contains('image') ||
           url.contains('photo') ||
           url.contains('img');
  }

  bool _isVideoFile(String url) {
    return url.endsWith('.mp4') ||
           url.endsWith('.mov') ||
           url.endsWith('.avi') ||
           url.endsWith('.wmv') ||
           url.endsWith('.flv') ||
           url.endsWith('.mkv') ||
           url.endsWith('.webm') ||
           url.contains('video') ||
           url.contains('mp4');
  }

  @override
  Widget build(BuildContext context) {
    final spacing = ResponsiveUtils.mediumSpacing(context);
    final subtitleFont = ResponsiveUtils.bodyTextSize(context);
    
    final categorizedMedia = _categorizeMedia();
    final photos = categorizedMedia['photos'] ?? [];
    final videos = categorizedMedia['videos'] ?? [];
    final files = categorizedMedia['files'] ?? [];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'View Documents', icon: Icons.arrow_back),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(spacing),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Photos Section
            if (photos.isNotEmpty) ...[
              Text(
                "Photos (${photos.length})",
                style: TextStyle(fontSize: subtitleFont, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: spacing),
              _buildPhotoGrid(context, photos),
              SizedBox(height: spacing * 2),
            ],

            // Videos Section
            if (videos.isNotEmpty) ...[
              Text(
                "Videos (${videos.length})",
                style: TextStyle(fontSize: subtitleFont, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: spacing),
              _buildVideoGrid(context, videos),
              SizedBox(height: spacing * 2),
            ],

            // Files Section
            if (files.isNotEmpty) ...[
              const Divider(thickness: 1, color: Colors.brown),
              SizedBox(height: spacing),
              Text(
                "Files (${files.length})",
                style: TextStyle(fontSize: subtitleFont, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: spacing),
              _buildDocumentGrid(context, files),
            ],

            // Empty State
            if (mediaList.isEmpty) ...[
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                    Icon(Icons.folder_open, size: 64, color: Colors.grey.shade400),
                    SizedBox(height: spacing),
                    Text(
                      "No documents available",
                      style: TextStyle(
                        fontSize: subtitleFont,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
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
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                );
              },
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
            child: Stack(
              children: [
                if (_isUrl(url))
                  Image.network(
                    _getVideoThumbnailUrl(url),
                    width: size,
                    height: size,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(),
                  ),
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.play_circle_fill, color: Colors.red, size: 40),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _getVideoThumbnailUrl(String videoUrl) {
    // محاولة إنشاء رابط ثامبنيل للفيديو
    if (videoUrl.contains('youtube.com') || videoUrl.contains('youtu.be')) {
      final videoId = videoUrl.contains('youtube.com')
          ? videoUrl.split('v=')[1].split('&')[0]
          : videoUrl.split('youtu.be/')[1].split('?')[0];
      return 'https://img.youtube.com/vi/$videoId/0.jpg';
    }
    
    if (videoUrl.contains('vimeo.com')) {
      final videoId = videoUrl.split('vimeo.com/')[1].split('/').last;
      return 'https://i.vimeocdn.com/video/$videoId.webp';
    }
    
    return videoUrl; // لغير ذلك، نرجع نفس الرابط
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
        final fileName = path.split('/').last;
        final lower = fileName.toLowerCase();
        
        IconData icon;
        Color iconColor = Colors.brown;
        
        if (lower.endsWith('.pdf')) {
          icon = Icons.picture_as_pdf;
          iconColor = Colors.red;
        } else if (lower.endsWith('.doc') || lower.endsWith('.docx')) {
          icon = Icons.insert_drive_file;
          iconColor = Colors.blue;
        } else if (lower.endsWith('.txt')) {
          icon = Icons.description;
          iconColor = Colors.black;
        } else if (lower.endsWith('.xls') || lower.endsWith('.xlsx')) {
          icon = Icons.table_chart;
          iconColor = Colors.green;
        } else if (lower.endsWith('.zip') || lower.endsWith('.rar')) {
          icon = Icons.folder_zip;
          iconColor = Colors.orange;
        } else {
          icon = Icons.insert_drive_file;
        }

        return GestureDetector(
          onTap: () => _openFile(path),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
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
                Icon(
                  icon,
                  size: ResponsiveUtils.isMobile(context) ? 48 : 64,
                  color: iconColor,
                ),
                const SizedBox(height: 8),
                Text(
                  fileName,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: ResponsiveUtils.isMobile(context) ? 11 : 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _getFileSize(path),
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _getFileSize(String path) {
    // هذه دالة افتراضية، يمكنك تعديلها بناءً على بياناتك الفعلية
    if (path.contains('unsplash')) return '~2 MB';
    if (path.contains('sample-videos')) return '~1 MB';
    return 'Unknown size';
  }

  void _openPhoto(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(20),
        child: Stack(
          children: [
            Center(
              child: Image.network(
                imageUrl,
                fit: BoxFit.contain,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey.shade200,
                  child: const Center(
                    child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, color: Colors.white, size: 24),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      debugPrint('Cannot open link: $url. Error: $e');
      if (navigatorKey1.currentContext != null) {
        ScaffoldMessenger.of(navigatorKey1.currentContext!).showSnackBar(
          SnackBar(
            content: Text('Cannot open this link: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _openFile(String path) async {
    if (_isUrl(path)) {
      await _launchURL(path);
    } else {
      try {
        await OpenFilex.open(path);
      } catch (e) {
        debugPrint('Cannot open file: $path. Error: $e');
        if (navigatorKey1.currentContext != null) {
          ScaffoldMessenger.of(navigatorKey1.currentContext!).showSnackBar(
            SnackBar(
              content: Text('Cannot open file: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  bool _isUrl(String path) => path.startsWith("http://") || path.startsWith("https://") || path.startsWith("www.");
}