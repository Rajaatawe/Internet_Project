import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_application_project/core/config/app_configt.dart';
import 'package:internet_application_project/core/constants/app_assets.dart';
import 'package:internet_application_project/core/models/GovernmentAgency.dart';
import 'package:internet_application_project/core/models/enum/states_enum.dart';
import 'package:internet_application_project/core/resources/colorfile.dart';
import 'package:internet_application_project/core/resources/responsive_util.dart';
import 'package:internet_application_project/core/services/generalized_api.dart';
import 'package:internet_application_project/core/widgets/custom_button.dart';
import 'package:internet_application_project/features/Form/cubit/form_complaint_cubit.dart';
import 'package:internet_application_project/features/Form/presentation/complaints_types_page.dart';
import 'package:internet_application_project/features/Form/presentation/preview.dart';
import 'package:internet_application_project/features/home_page/cubit/home_page_cubit.dart';
import 'package:internet_application_project/features/home_page/cubit/home_page_state.dart';
import 'package:internet_application_project/features/my_complaints/presentation/my_complaints_page.dart';
import 'package:internet_application_project/features/notification/cubit/notification_cubit.dart';
import 'package:internet_application_project/features/notification/widget/NotificationService.dart';
import 'package:internet_application_project/features/settings/presentation/settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
// final token = NotificationService().token;

    // if (token != null && token.isNotEmpty) {
    //   final deviceType = getDeviceType(context);
    //     final platform = getPlatform();
    //   context.read<NotificationCubit>().saveToken(
    //     token,
    //     deviceType, 
    //     platform,
    //   );
    // }  
    }
    String getPlatform() {
  if (Platform.isAndroid) return 'android';
  if (Platform.isIOS) return 'ios';
  return 'unknown';
}

String getDeviceType(BuildContext context) {
  final shortestSide = MediaQuery.of(context).size.shortestSide;
  return shortestSide < 600 ? 'mobile' : 'tablet';
}

  @override
    
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: ResponsiveUtils.largeSpacing(context)),

                    _buildTitle(context),

                    SizedBox(height: ResponsiveUtils.largeSpacing(context)),

                    // Only the grid section uses Bloc
                    _buildAgencyGridWithBloc(),

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
      toolbarHeight: ResponsiveUtils.appBarHeight(context) + 10,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: ResponsiveUtils.titleTextSize(context) + 10,
        fontWeight: FontWeight.w600,
        color: darkBrown,
      ),
      title: const Text('HOME'),
      leadingWidth: ResponsiveUtils.isDesktop(context) ? 150 : 110,
      leading: Padding(
        padding: EdgeInsets.all(ResponsiveUtils.smallSpacing(context) * 0.75),
        child: Image.asset(logo, fit: BoxFit.contain),
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
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const SettingsPage()),
            );
          },
        ),
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

  Widget _buildAgencyGridWithBloc() {
    return BlocProvider(
      create: (context) =>
          HomePageCubit(remoteService: RemoteService.getInstance(AppConst()))
            ..loadHomePage(),
      child: _AgencyGridBlocWrapper(),
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
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const MyComplaintsPage()),
          );
        },
      ),
    );
  }
}

class _AgencyGridBlocWrapper extends StatefulWidget {
  @override
  State<_AgencyGridBlocWrapper> createState() => _AgencyGridBlocWrapperState();
}

class _AgencyGridBlocWrapperState extends State<_AgencyGridBlocWrapper> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<HomePageCubit>(context).loadHomePage();
    print('//////////////////////////////////////////////////////////////');
    print(
      "home page perfectoooooooooooooooooooooooooooooooooooooooooooooooooooo",
    );
    print('//////////////////////////////////////////////////////////////');
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomePageCubit, HomePageState>(
      buildWhen: (previous, current) => current.state != previous.state,
      listenWhen: (previous, current) => current.state != previous.state,
      listener: (context, state) {
        if (state.state == StateValue.loaded) {
          print("print success Homepage");
        } else if (state.state == StateValue.error) {
          print(
            "///////////////////////////////////////////////Error Home page",
          );
        }
      },
      builder: (context, state) {
        if (state.state == StateValue.loading) {
          return SizedBox(
            height: ResponsiveUtils.heightPercentage(context, 0.56),
            child: const Center(
              child: CircularProgressIndicator(color: primaryColor),
            ),
          );
        }

        // Error state
        if (state.state == StateValue.error) {
          return SizedBox(
            height: ResponsiveUtils.heightPercentage(context, 0.56),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, color: Colors.red, size: 50),
                    SizedBox(height: 10),
                    Text(
                      'Failed to load agencies',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        // Loaded state
        return _buildAgencyGrid(context, state.governmentAgencies);
      },
    );
  }

  Widget _buildAgencyGrid(
    BuildContext context,
    List<GovernmentAgencyclass> agencies,
  ) {
    if (agencies.isEmpty) {
      return SizedBox(
        height: ResponsiveUtils.heightPercentage(context, 0.56),
        child: Center(
          child: Text(
            'No government agencies found',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ),
      );
    }

    return Padding(
      padding: ResponsiveUtils.contentPadding(context),
      child: SizedBox(
        height: ResponsiveUtils.heightPercentage(context, 0.56),
        child: GridView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: ResponsiveUtils.gridCrossAxisCount(context),
            childAspectRatio: ResponsiveUtils.gridChildAspectRatio(context),
            crossAxisSpacing: ResponsiveUtils.gridSpacing(context),
            mainAxisSpacing: ResponsiveUtils.gridSpacing(context),
          ),
          itemCount: agencies.length,
          itemBuilder: (BuildContext context, int index) {
            final agency = agencies[index];
            return GestureDetector(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => BlocProvider(
 create: (context) => FormComplaintCubit(
        remoteService:context.read<RemoteService>()),
            child: ComplaintsTypesPage(agencyId: agency.id),
                  ),
                ),
              ),

              child: GovernmentAgencyCardItem(governmentAgency: agency),
            );
          },
        ),
      ),
    );
  }
}

class GovernmentAgencyCardItem extends StatelessWidget {
  const GovernmentAgencyCardItem({super.key, required this.governmentAgency});

  final GovernmentAgencyclass governmentAgency;

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
              Icon(
                _getIconForAgency(governmentAgency),
                color: primaryColor,
                size: _getIconSize(context),
              ),
              SizedBox(height: ResponsiveUtils.smallSpacing(context)),
              Text(
                governmentAgency.agencyName,
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

  IconData _getIconForAgency(GovernmentAgencyclass governmentAgency) {
    final agencyname = governmentAgency.agencyName.toLowerCase();

    if (agencyname.contains('water')) return Icons.water_drop;
    if (agencyname.contains('electric') || agencyname.contains('power'))
      return Icons.electric_bolt;
    if (agencyname.contains('gas')) return Icons.gas_meter;
    if (agencyname.contains('health') ||
        agencyname.contains('hospital') ||
        agencyname.contains('medical'))
      return Icons.medical_services;
    if (agencyname.contains('education') ||
        agencyname.contains('school') ||
        agencyname.contains('university'))
      return Icons.school;
    if (agencyname.contains('transport') ||
        agencyname.contains('bus') ||
        agencyname.contains('traffic'))
      return Icons.directions_bus;
    if (agencyname.contains('police') || agencyname.contains('security'))
      return Icons.local_police;
    if (agencyname.contains('fire')) return Icons.local_fire_department;
    if (agencyname.contains('waste') || agencyname.contains('garbage'))
      return Icons.delete;
    if (agencyname.contains('telecom') ||
        agencyname.contains('phone') ||
        agencyname.contains('communication'))
      return Icons.phone;
    if (agencyname.contains('internet') ||
        agencyname.contains('wifi') ||
        agencyname.contains('broadband'))
      return Icons.wifi;
    if (agencyname.contains('road') ||
        agencyname.contains('highway') ||
        agencyname.contains('infrastructure'))
      return Icons.streetview;
    if (agencyname.contains('tax') || agencyname.contains('revenue'))
      return Icons.attach_money;
    if (agencyname.contains('immigration') || agencyname.contains('passport'))
      return Icons.airplanemode_active;

    return Icons.business; // Default icon for government agencies
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
