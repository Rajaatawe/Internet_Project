import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:internet_application_project/core/resources/colorfile.dart';
import 'package:internet_application_project/core/resources/responsive_util.dart';
import 'package:internet_application_project/core/widgets/customAppBar.dart';
import 'package:internet_application_project/features/my_complaints/widgets/complaint_card.dart';

class MyComplaintsPage extends StatelessWidget {
  const MyComplaintsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 4,
      child: Scaffold(
        appBar: CustomAppBar(title: 'My complaints', icon: Icons.arrow_back),
        body: Column(
          children: [
            Container(
              color: const Color(0xFFE7E1D6),
              padding: EdgeInsets.symmetric(
                vertical: ResponsiveUtils.smallSpacing(context),
              ),
              child: Center(child: _buildTabBar(context)),
            ),

            Expanded(
              child: TabBarView(
                children: [
                  _buildResponsiveComplaintList(context),
                   _buildPlaceholderTab('New'),
                  _buildPlaceholderTab('In process'),
                  _buildPlaceholderTab('Rejected'),
                  _buildPlaceholderTab('Done'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  //                 TAB BAR FIXED WITH BIGGER STYLE
  // ------------------------------------------------------------
  Widget _buildTabBar(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);
    final isTablet = ResponsiveUtils.isTablet(context);
    final isDesktop = ResponsiveUtils.isDesktop(context);

    double horizontalPadding =
        isMobile ? 20 : (isTablet ? 40 : 50);

    double fontSize =
        isMobile ? 14 : (isTablet ? 18 : 20);

    double radius = 15;

    return ButtonsTabBar(
      radius: radius,
      height: isMobile ? 45 : 55, // Bigger tabs
      buttonMargin: EdgeInsets.symmetric(horizontal: 8),
      contentPadding: EdgeInsets.symmetric(horizontal: horizontalPadding),

      labelStyle: TextStyle(
        color: Colors.white,
        fontSize: fontSize,
        fontWeight: FontWeight.w600,
      ),

      unselectedLabelStyle: TextStyle(
        color: Colors.white,
        fontSize: fontSize,
      ),

      decoration: BoxDecoration(
        color: darkBrown,
        borderRadius: BorderRadius.circular(radius),
      ),
      unselectedDecoration: BoxDecoration(
        color: whiteBrown2,
        borderRadius: BorderRadius.circular(radius),
      ),

      tabs: const [
        Tab(text: 'New'),
        Tab(text: 'In process'),
        Tab(text: 'Rejected'),
        Tab(text: 'Done'),
      ],
    );
  }

  // ------------------------------------------------------------
  //        RESPONSIVE LIST → GRID FOR TABLET & DESKTOP
  // ------------------------------------------------------------
  Widget _buildResponsiveComplaintList(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);
    final isTablet = ResponsiveUtils.isTablet(context);

    if (isMobile) {
      // ---------- Mobile: ListView ----------
      return ListView.builder(
        padding: EdgeInsets.all(ResponsiveUtils.mediumSpacing(context)),
        itemCount: 10,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: ComplaintCard(),
        ),
      );
    } else {
      // ---------- Tablet: 2 columns ----------
      // ---------- Desktop: 3 columns ----------
      int crossAxisCount = isTablet ? 2 : 3;

      return Padding(
        padding: EdgeInsets.all(ResponsiveUtils.mediumSpacing(context)),
        child: GridView.builder(
          itemCount: 10,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 3 / 2, // Adjust as needed
          ),
          itemBuilder: (context, index) => ComplaintCard(),
        ),
      );
    }
  }

  Widget _buildPlaceholderTab(String text) {
    return Center(
      child: Text(
        'Here the $text',
        style: const TextStyle(fontSize: 18, color: Colors.grey),
      ),
    );
  }
}
