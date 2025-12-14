import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_application_project/core/models/enum/states_enum.dart';
import 'package:internet_application_project/core/resources/colorfile.dart';
import 'package:internet_application_project/core/resources/responsive_util.dart';
import 'package:internet_application_project/core/widgets/customAppBar.dart';
import 'package:internet_application_project/core/widgets/custom_button.dart';
import 'package:internet_application_project/features/auth/cubit/auth_cubit.dart';
import 'package:internet_application_project/features/auth/cubit/auth_state.dart';
import 'package:internet_application_project/features/auth/presentation/login_page.dart';
import 'package:internet_application_project/features/settings/widgets/item_settings_row.dart';
import 'package:internet_application_project/features/settings/widgets/title_settings_rows.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String? selectedLanguage;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.logoutState == StateValue.success) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const LoginPage()),
            (route) => false,
          );
        }

        if (state.logoutState == StateValue.error) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.logoutMessage)));
        }
      },
      child: Scaffold(
        appBar: CustomAppBar(title: 'Settings', icon: Icons.arrow_back),
        body: SingleChildScrollView(
          child: Padding(
            padding: ResponsiveUtils.contentPadding(context) * 0.00001,
            child: Column(
              children: [
                // SizedBox(height: ResponsiveUtils.mediumSpacing(context)),
                _buildGeneralSection(),
                SizedBox(height: ResponsiveUtils.largeSpacing(context)),

                _buildAccountSection(),
                SizedBox(height: ResponsiveUtils.largeSpacing(context)),

                _buildInfoSection(),
                SizedBox(height: ResponsiveUtils.extraLargeSpacing(context)),

                _buildLogoutButton(context),
                SizedBox(height: ResponsiveUtils.largeSpacing(context)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGeneralSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleSettingsRows(title: 'General'),
        SizedBox(height: ResponsiveUtils.smallSpacing(context)),

        ItemSettingsRow(
          title: 'Theme',
          icon: Icons.brightness_6,
          prefixWidget: Switch(
            value: true,
            onChanged: (value) {},
            thumbColor: WidgetStatePropertyAll(primaryColor.withOpacity(0.4)),
            activeTrackColor: primaryColor,
            inactiveTrackColor: Colors.grey.withOpacity(0.3),
          ),
        ),

        SizedBox(height: ResponsiveUtils.smallSpacing(context) * 0.7),

        ItemSettingsRow(
          title: 'Language',
          icon: Icons.language,
          prefixWidget: Container(
            width: ResponsiveUtils.isDesktop(context) ? 225 : 175,
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveUtils.smallSpacing(context),
              vertical: ResponsiveUtils.smallSpacing(context) * 0.3,
            ),
            decoration: BoxDecoration(
              color: const Color(0xffd6c1b5),
              borderRadius: BorderRadius.circular(
                ResponsiveUtils.smallBorderRadius(context),
              ),
              border: Border.all(color: const Color(0xffa68e7b), width: 1.2),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedLanguage,
                hint: Row(
                  children: [
                    Icon(
                      Icons.arrow_drop_down,
                      color: const Color(0xff6a4d38),
                      size: ResponsiveUtils.smallIconSize(context),
                    ),
                    SizedBox(
                      width: ResponsiveUtils.smallSpacing(context) * 0.5,
                    ),
                    Text(
                      "change language",
                      style: TextStyle(
                        fontSize: ResponsiveUtils.captionTextSize(context),
                        fontWeight: FontWeight.w700,
                        color: const Color(0xff6a4d38),
                      ),
                    ),
                  ],
                ),
                icon: const SizedBox.shrink(),
                selectedItemBuilder: (context) {
                  return ["English", "Arabic"].map((lang) {
                    return Row(
                      children: [
                        Icon(
                          Icons.arrow_drop_down,
                          color: const Color(0xff6a4d38),
                          size: ResponsiveUtils.smallIconSize(context),
                        ),
                        SizedBox(
                          width: ResponsiveUtils.smallSpacing(context) * 0.5,
                        ),
                        Text(
                          lang,
                          style: TextStyle(
                            fontSize: ResponsiveUtils.captionTextSize(context),
                            fontWeight: FontWeight.w700,
                            color: const Color(0xff6a4d38),
                          ),
                        ),
                      ],
                    );
                  }).toList();
                },
                dropdownColor: const Color(0xfff3e8e2),
                borderRadius: BorderRadius.circular(
                  ResponsiveUtils.smallBorderRadius(context),
                ),
                items: const [
                  DropdownMenuItem(
                    value: "English",
                    child: Row(
                      children: [
                        Icon(Icons.language, size: 18, color: primaryColor),
                        SizedBox(width: 8),
                        Text("English", style: TextStyle(fontSize: 14)),
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: "Arabic",
                    child: Row(
                      children: [
                        Icon(Icons.flag, size: 18, color: primaryColor),
                        SizedBox(width: 8),
                        Text("Arabic", style: TextStyle(fontSize: 14)),
                      ],
                    ),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedLanguage = value;
                  });
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAccountSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleSettingsRows(title: 'Account'),
        SizedBox(height: ResponsiveUtils.smallSpacing(context)),

        ItemSettingsRow(
          title: 'Full Name',
          icon: Icons.person_2_outlined,
          prefixWidget: Text(
            'Tomi Mark Hernandez',
            style: TextStyle(
              fontSize: ResponsiveUtils.bodyTextSize(context),
              color: primaryColor,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),

        SizedBox(height: ResponsiveUtils.smallSpacing(context) * 0.7),

        ItemSettingsRow(
          title: 'Email',
          icon: Icons.email,
          prefixWidget: Text(
            'Tomi@gmail.com',
            style: TextStyle(
              fontSize: ResponsiveUtils.bodyTextSize(context),
              color: primaryColor,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleSettingsRows(title: 'Info'),
        SizedBox(height: ResponsiveUtils.smallSpacing(context)),

        ItemSettingsRow(
          title: 'About',
          icon: Icons.info_outline,
          prefixWidget: Icon(
            Icons.arrow_forward_ios,
            color: primaryColor,
            size: ResponsiveUtils.smallIconSize(context),
          ),
        ),

        SizedBox(height: ResponsiveUtils.smallSpacing(context) * 0.7),

        ItemSettingsRow(
          title: 'Policy',
          icon: Icons.policy,
          prefixWidget: Icon(
            Icons.arrow_forward_ios,
            color: primaryColor,
            size: ResponsiveUtils.smallIconSize(context),
          ),
        ),
      ],
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Column(
      children: [
        CustomButton(
          height: ResponsiveUtils.buttonHeight(context),
          width: ResponsiveUtils.buttonWidth(
            context,
            mobileRatio: 0.6,
            tabletRatio: 0.4,
            desktopRatio: 0.3,
          ),
          title: 'Logout',
          titleColor: whiteBrown,
          backgroundColor: primaryColor,
          onTap: () => _showLogoutDialog(context),
        ),
      ],
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => BlocProvider.value(
        value: BlocProvider.of<AuthCubit>(context),
        child: Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: ResponsiveUtils.screenPadding(context),
          child: Container(
            padding: EdgeInsets.all(ResponsiveUtils.largeSpacing(context)),
            decoration: BoxDecoration(
              color: const Color(0xfffdf6f4),
              borderRadius: BorderRadius.circular(
                ResponsiveUtils.largeBorderRadius(context),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 15,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Are you sure?",
                  style: TextStyle(
                    fontSize: ResponsiveUtils.headlineTextSize(context),
                    fontWeight: FontWeight.w700,
                    color: const Color(0xff5a4638),
                  ),
                ),
                SizedBox(height: ResponsiveUtils.smallSpacing(context)),
                Text(
                  "you want to log out",
                  style: TextStyle(
                    fontSize: ResponsiveUtils.bodyTextSize(context),
                    color: const Color(0xff8b6f5a),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: ResponsiveUtils.largeSpacing(context)),
                _buildDialogButtons(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDialogButtons(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);

    if (isMobile) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomButton(
            height: ResponsiveUtils.buttonHeight(context) * 0.8,
            width: ResponsiveUtils.buttonWidth(context, mobileRatio: 0.5) * 0.6,
            title: 'confirm',
            titleColor: Colors.white,
            backgroundColor: Colors.red,
            onTap: () {
              context.read<AuthCubit>().logout();
            },
          ),
          SizedBox(height: ResponsiveUtils.smallSpacing(context)),
          CustomButton(
            height: ResponsiveUtils.buttonHeight(context) * 0.8,
            width: ResponsiveUtils.buttonWidth(context, mobileRatio: 0.5) * 0.6,
            title: 'cancel',
            titleColor: const Color(0xff5a4638),
            backgroundColor: const Color(0xffe9e4df),
            onTap: () => Navigator.pop(context),
          ),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CustomButton(
            height: ResponsiveUtils.buttonHeight(context),
            width: ResponsiveUtils.buttonWidth(
              context,
              tabletRatio: 0.25,
              desktopRatio: 0.2,
            ),
            title: 'confirm',
            titleColor: Colors.white,
            backgroundColor: Colors.red,
            onTap: () {
              context.read<AuthCubit>().logout();
            },
          ),
          CustomButton(
            height: ResponsiveUtils.buttonHeight(context),
            width: ResponsiveUtils.buttonWidth(
              context,
              tabletRatio: 0.25,
              desktopRatio: 0.2,
            ),
            title: 'cancel',
            titleColor: const Color(0xff5a4638),
            backgroundColor: const Color(0xffe9e4df),
            onTap: () => Navigator.pop(context),
          ),
        ],
      );
    }
  }
}
