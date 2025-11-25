import 'package:flutter/material.dart';
import 'package:internet_application_project/core/constants/app_assets.dart';
import 'package:internet_application_project/core/resources/colorfile.dart';
import 'package:internet_application_project/core/resources/responsive_util.dart';
import 'package:internet_application_project/core/widgets/custom_button.dart';
import 'package:internet_application_project/features/my_complaints/presentation/my_complaints_page.dart';
import 'package:internet_application_project/features/settings/presentation/settings_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              // Remove IntrinsicHeight and use proper constraints
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: ResponsiveUtils.largeSpacing(context),
                    ),

                    _buildTitle(context),

                    SizedBox(height: ResponsiveUtils.largeSpacing(context)),

                    _buildAgencyGrid(context),

                    SizedBox(
                      height: ResponsiveUtils.extraLargeSpacing(context),
                    ),

                    _buildComplaintButton(context),

                    SizedBox(height: ResponsiveUtils.largeSpacing(context)),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      toolbarHeight: ResponsiveUtils.appBarHeight(context)+10,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: ResponsiveUtils.titleTextSize(context) + 10,
        fontWeight: FontWeight.w600,
        color: darkBrown,
      ),
      title: const Text('HOME'),
      leadingWidth: ResponsiveUtils.isDesktop(context) ? 150 : 110,
      leading: Padding(
        padding: EdgeInsets.all(ResponsiveUtils.smallSpacing(context)*0.75),
        child: Image.asset(logo, fit: BoxFit.contain, ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.notifications, color: darkBrown),
          iconSize: ResponsiveUtils.mediumIconSize(context),
          onPressed: () {},
        ),
        if (!ResponsiveUtils.isMobile(context))
          SizedBox(width: ResponsiveUtils.smallSpacing(context)),
        IconButton(
          icon: Icon(Icons.settings, color: darkBrown),
          iconSize: ResponsiveUtils.mediumIconSize(context),
          onPressed: () {  Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => SettingsPage()));
   } ),
        SizedBox(width: ResponsiveUtils.mediumSpacing(context)),
      ],
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Padding(
      padding: ResponsiveUtils.screenPadding(context),
      child: Text(
        'Select a government agency',
        textAlign: TextAlign.center,
        style: ResponsiveUtils.adaptiveTitleStyle(context).copyWith(
          color: primaryColor,
          fontSize: ResponsiveUtils.headlineTextSize(context),
        ),
      ),
    );
  }

  Widget _buildAgencyGrid(BuildContext context) {
    return Padding(
      padding: ResponsiveUtils.contentPadding(context),
      child: SizedBox(
        // Use fixed height based on screen size instead of constrained box
        height: ResponsiveUtils.heightPercentage(context, 0.56),
        child: GridView.builder(
          // Remove shrinkWrap and use AlwaysScrollableScrollPhysics
          physics: const AlwaysScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: ResponsiveUtils.gridCrossAxisCount(context),
            childAspectRatio: ResponsiveUtils.gridChildAspectRatio(context),
            crossAxisSpacing: ResponsiveUtils.gridSpacing(context),
            mainAxisSpacing: ResponsiveUtils.gridSpacing(context),
          ),
          itemCount: 20,
          itemBuilder: (BuildContext context, int index) {
            return GovernmentAgencyCardItem();
          },
        ),
      ),
    );
  }

  Widget _buildComplaintButton(BuildContext context) {
    return Padding(
      padding: ResponsiveUtils.contentPadding(context),
      child: CustomButton(
        width: ResponsiveUtils.buttonWidth(
          context,
          mobileRatio: 0.7,
          tabletRatio: 0.5,
          desktopRatio: 0.3,
        ),
        height: ResponsiveUtils.buttonHeight(context),
        title: 'My complaint',
        titleColor: Colors.white,
        backgroundColor: primaryColor,
        onTap: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => MyComplaintsPage()));
        },
      ),
    );
  }
}

class GovernmentAgencyCardItem extends StatelessWidget {
  const GovernmentAgencyCardItem({
    super.key,
    this.name = 'water',
    this.icon = Icons.water_drop,
  });

  final String name;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: ResponsiveUtils.smallElevation(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          ResponsiveUtils.mediumBorderRadius(context),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            ResponsiveUtils.mediumBorderRadius(context),
          ),
          color: whiteBrown,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: primaryColor, size: _getIconSize(context)),
              SizedBox(height: ResponsiveUtils.smallSpacing(context)),
              Text(
                name,
                textAlign: TextAlign.center,
                style: ResponsiveUtils.adaptiveBodyStyle(context).copyWith(
                  color: primaryColor,
                  fontWeight: FontWeight.w500,
                  fontSize: _getTextSize(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double _getIconSize(BuildContext context) {
    if (ResponsiveUtils.isDesktop(context)) return 48;
    if (ResponsiveUtils.isTablet(context)) return 40;
    return 32;
  }

  double _getTextSize(BuildContext context) {
    if (ResponsiveUtils.isDesktop(context)) return 20;
    if (ResponsiveUtils.isTablet(context)) return 18;
    return 16;
  }
}