// File: complaint_card_details.dart
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:internet_application_project/features/Form/presentation/maps_screen.dart';
import 'package:internet_application_project/features/Form/widgets/place_picker_widget.dart';
import 'package:latlong2/latlong.dart';
import 'package:internet_application_project/core/resources/colorfile.dart';
import 'package:internet_application_project/core/resources/responsive_util.dart';

class ComplaintCardDetails extends StatefulWidget {
  final String description;
  final LatLng location;
  final String address; // Add address parameter

   ComplaintCardDetails({
    super.key,
    required this.description,
    required this.location,
    required this.address, // Add address parameter
  });

  @override
  State<ComplaintCardDetails> createState() => _ComplaintCardDetailsState();
}

class _ComplaintCardDetailsState extends State<ComplaintCardDetails> {
 PickedData? pickedData;

  MapController mapController = MapController();

  var addressController = TextEditingController();

  UniqueKey _mapKey = UniqueKey();

  @override
  Widget build(BuildContext context) {
    final spacing = ResponsiveUtils.smallSpacing(context);
    final font = ResponsiveUtils.bodyTextSize(context);
    final isMobile = ResponsiveUtils.isMobile(context);
    final isTablet = ResponsiveUtils.isTablet(context);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(
        isMobile ? spacing * 0.4 : spacing * 2,
      ),
      child: Container(
        padding: EdgeInsets.all(
          isMobile ? spacing * 0.4 : spacing * 2,
        ),
        decoration: BoxDecoration(
          color: whiteBrown,
          borderRadius: BorderRadius.circular(
            ResponsiveUtils.largeBorderRadius(context),
          ),
          boxShadow: [
            BoxShadow(
              color: darkBrown.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with title and close button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Complaint Details",
                  style: TextStyle(
                    fontSize: ResponsiveUtils.headlineTextSize(context) * 0.9,
                    fontWeight: FontWeight.bold,
                    color: darkBrown,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(
                    Icons.close,
                    color: darkBrown,
                    size: ResponsiveUtils.mediumIconSize(context),
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),

            SizedBox(height: spacing * 1.5),

            // ---------------- DESCRIPTION SECTION ----------------
            _buildSectionHeader(
              context: context,
              icon: Icons.description,
              label: "Description",
            ),

            SizedBox(height: spacing),

            _dashedBox(
              context: context,
              height: isMobile ? font * 6 : font * 5,
              text: widget.description,
            ),

            SizedBox(height: spacing * 2),

            // ---------------- LOCATION SECTION ----------------
            _buildSectionHeader(
              context: context,
              icon: Icons.location_on,
              label: "Location in Map",
            ),

            SizedBox(height: spacing),

            // Address display
          Column(
  children: [
    Container(
      clipBehavior: Clip.hardEdge,
      height: MediaQuery.of(context).size.height * 0.3,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.blueGrey,
          width: MediaQuery.of(context).size.height * 0.001,
        ),
      ),
      child: Stack(
        children: [
          FlutterMap(
            key: _mapKey,
            mapController: mapController,
            options: MapOptions(
              interactiveFlags: InteractiveFlag.none, // يمنع السحب والتكبير والضغط
              center: LatLng(
                widget.location.latitude,
                widget.location.longitude,
              ),
              zoom: 17,
              maxZoom: 19,
              maxBounds: LatLngBounds(
                LatLng(24.29200, 46.22700),
                LatLng(25.09800, 47.20200),
              ),
            ),
            children: [
              TileLayer(
                urlTemplate:
                    "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                userAgentPackageName:
                    'dev.fleaflet.flutter_map.example',
              ),
            ],
          ),

          const Positioned.fill(
            child: IgnorePointer(
              child: Center(
                child: Icon(
                  Icons.location_pin,
                  size: 50,
                  color: primaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
    ),

    SizedBox(height: spacing * 1.5),

    // إظهار الإحداثيات فقط
    Padding(
      padding: EdgeInsets.only(top: spacing),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: spacing,
          vertical: spacing * 0.8,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(
            ResponsiveUtils.smallBorderRadius(context),
          ),
          border: Border.all(
            color: darkBrown.withOpacity(0.1),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.gps_fixed,
              size: font * 0.8,
              color: darkBrown.withOpacity(0.6),
            ),
            SizedBox(width: spacing * 0.5),
            Text(
              "Lat: ${widget.location.latitude.toStringAsFixed(6)}, "
              "Lng: ${widget.location.longitude.toStringAsFixed(6)}",
              style: TextStyle(
                fontSize: font * 0.75,
                color: darkBrown.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    ),
  ],
)

     ] ),
    ));
  }

  // -------------------- Helper for section headers --------------------
  Widget _buildSectionHeader({
    required BuildContext context,
    required IconData icon,
    required String label,
  }) {
    final spacing = ResponsiveUtils.smallSpacing(context);
    final font = ResponsiveUtils.bodyTextSize(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: font * 0.7,
          height: font * 0.7,
          decoration: BoxDecoration(
            color: darkBrown,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: spacing),
        Icon(
          icon,
          size: font * 1.1,
          color: primaryColor,
        ),
        SizedBox(width: spacing * 0.8),
        Text(
          "$label:",
          style: TextStyle(
            fontSize: font,
            fontWeight: FontWeight.w600,
            color: darkBrown,
          ),
        ),
      ],
    );
  }

  // -------------------- Dashed Description Box --------------------
  Widget _dashedBox({
    required BuildContext context,
    required double height,
    required String text,
  }) {
    final spacing = ResponsiveUtils.smallSpacing(context);
    final font = ResponsiveUtils.bodyTextSize(context);

    return Container(
      width: double.infinity,
      height: height,
      padding: EdgeInsets.all(spacing * 1.2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          ResponsiveUtils.smallBorderRadius(context),
        ),
        border: Border.all(
          color: darkBrown.withOpacity(0.3),
          width: 1.5,
          style: BorderStyle.solid,
        ),
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Text(
          text,
          style: TextStyle(
            fontSize: font * 0.9,
            height: 1.4,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }

  // -------------------- MAP SECTION --------------------
  Widget _mapBox(BuildContext context) {
    final spacing = ResponsiveUtils.smallSpacing(context);
    final double mapHeight = ResponsiveUtils.isMobile(context)
        ? MediaQuery.of(context).size.height * 0.25
        : MediaQuery.of(context).size.height * 0.3;

    return Container(
      height: mapHeight,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          ResponsiveUtils.mediumBorderRadius(context),
        ),
        border: Border.all(
          color: darkBrown.withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: darkBrown.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
          ResponsiveUtils.mediumBorderRadius(context),
        ),
        child: Stack(
          children: [
            // Map
            FlutterMap(
              options: MapOptions(
                center: widget.location,
                zoom: 14.0, // Slightly higher zoom for better view
                interactiveFlags: InteractiveFlag.none, // Read-only
              ),
              children: [
                TileLayer(
                  urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: const ['a', 'b', 'c'],
                  userAgentPackageName: 'com.example.app',
                ),
                // Location marker
                MarkerLayer(
                  markers: [
                    Marker(
                      point: widget.location,
                      width: 60,
                      height: 60,
                      builder: (context) => Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: primaryColor.withOpacity(0.9),
                          boxShadow: [
                            BoxShadow(
                              color: darkBrown.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                          border: Border.all(
                            color: Colors.white,
                            width: 3,
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.location_pin,
                            color: Colors.white,
                            size: 30,
                            shadows: [
                              Shadow(
                                color: darkBrown.withOpacity(0.5),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // Attribution
            Positioned(
              bottom: 4,
              left: 4,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: spacing * 0.8,
                  vertical: spacing * 0.4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: darkBrown.withOpacity(0.1),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: darkBrown,
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: Text(
                        "OSM",
                        style: TextStyle(
                          fontSize: ResponsiveUtils.bodyTextSize(context) * 0.5,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(width: spacing * 0.5),
                    Text(
                      "© OpenStreetMap",
                      style: TextStyle(
                        fontSize: ResponsiveUtils.bodyTextSize(context) * 0.5,
                        color: darkBrown.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Read-only overlay
            Positioned.fill(
              child: Container(
                color: Colors.transparent,
                child: Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: spacing * 1.5,
                      vertical: spacing * 0.8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: darkBrown.withOpacity(0.2),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.visibility,
                          size: ResponsiveUtils.bodyTextSize(context) * 0.8,
                          color: darkBrown.withOpacity(0.6),
                        ),
                        SizedBox(width: spacing * 0.5),
                        Text(
                          "View Only",
                          style: TextStyle(
                            fontSize: ResponsiveUtils.bodyTextSize(context) * 0.7,
                            color: darkBrown.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}