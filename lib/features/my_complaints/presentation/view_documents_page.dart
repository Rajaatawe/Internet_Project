// view_documents_page.dart

import 'package:flutter/material.dart';
import 'package:internet_application_project/core/resources/responsive_util.dart';
import 'package:internet_application_project/core/widgets/customAppBar.dart';
import 'package:photo_view/photo_view.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:open_filex/open_filex.dart';

class ViewDocumentsPage extends StatelessWidget {
  final List<String>? photos;
  final List<String>? videos;
  final List<String>? files;

  const ViewDocumentsPage({
    super.key,
    required this.photos,
    required this.videos,
    required this.files,
  });

  @override
  Widget build(BuildContext context) {
    final spacing = ResponsiveUtils.mediumSpacing(context);
    final titleFont = ResponsiveUtils.titleTextSize(context);
    final subtitleFont = ResponsiveUtils.bodyTextSize(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar:  CustomAppBar(title: 'View documents', icon: Icons.arrow_back),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(spacing),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // -------------------------- SECTION TITLE --------------------------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "The photos and documents",
                  style: TextStyle(
                    fontSize: subtitleFont,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Row(
                  children: const [
                    Icon(Icons.filter_list),
                    SizedBox(width: 10),
                    Icon(Icons.grid_view),
                  ],
                ),
              ],
            ),

            SizedBox(height: spacing),

            // -------------------------- PHOTO GRID --------------------------
            if (photos!.isNotEmpty) _buildPhotoGrid(context),

            SizedBox(height: spacing * 2),
            const Divider(thickness: 1, color: Colors.brown),

            SizedBox(height: spacing),

            // -------------------------- FILE GRID --------------------------
            if (files!.isNotEmpty || videos!.isNotEmpty)
              _buildDocumentGrid(context),
          ],
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  // PHOTO GRID
  // ----------------------------------------------------------
  Widget _buildPhotoGrid(BuildContext context) {
    final size = ResponsiveUtils.isMobile(context)
        ? 90.0
        : ResponsiveUtils.isTablet(context)
            ? 120.0
            : 150.0;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: photos!.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: ResponsiveUtils.isMobile(context) ? 2 : 4,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => _openPhoto(context, photos![index]),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              photos![index],
              width: size,
              height: size,
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }

  // ----------------------------------------------------------
  // DOCUMENT + VIDEO ICON GRID
  // ----------------------------------------------------------
  Widget _buildDocumentGrid(BuildContext context) {
    final allDocs = [...videos!, ...files!];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: allDocs.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: ResponsiveUtils.isMobile(context) ? 2 : 4,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
      ),
      itemBuilder: (context, index) {
        final path = allDocs[index];
        final isVideo = path.endsWith(".mp4") || path.endsWith(".mov");

        return GestureDetector(
          onTap: () => isVideo ? _openVideo(context, path) : _openFile(path),
          child: Column(
            children: [
              Icon(
                isVideo ? Icons.video_file : Icons.insert_drive_file,
                size: ResponsiveUtils.isMobile(context) ? 50 : 70,
                color: Colors.brown,
              ),
            ],
          ),
        );
      },
    );
  }

  // ----------------------------------------------------------
  // OPEN FULL SCREEN PHOTO
  // ----------------------------------------------------------
  void _openPhoto(BuildContext context, String imageUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          backgroundColor: Colors.black,
          body: PhotoView(
            imageProvider: NetworkImage(imageUrl),
            backgroundDecoration: const BoxDecoration(color: Colors.black),
          ),
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  // OPEN VIDEO PLAYER
  // ----------------------------------------------------------
  void _openVideo(BuildContext context, String videoPath) {
    final videoPlayerController = VideoPlayerController.network(videoPath);
    final chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoPlay: true,
      looping: false,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Chewie(controller: chewieController),
      ),
    );
  }

  // ----------------------------------------------------------
  // OPEN ANY FILE (PDF, doc, txt)
  // ----------------------------------------------------------
  void _openFile(String filePath) {
    OpenFilex.open(filePath);
  }
}
