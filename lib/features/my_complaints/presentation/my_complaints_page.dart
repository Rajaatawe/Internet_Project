// File: my_complaints_page.dart

import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_application_project/core/models/complaints_model.dart';
import 'package:internet_application_project/core/models/enum/states_enum.dart';
import 'package:internet_application_project/core/resources/colorfile.dart';
import 'package:internet_application_project/core/resources/responsive_util.dart';
import 'package:internet_application_project/core/services/generalized_api.dart';
import 'package:internet_application_project/core/widgets/customAppBar.dart';
import 'package:internet_application_project/features/my_complaints/cubit/my_complaints_cubit.dart';
import 'package:internet_application_project/features/my_complaints/cubit/my_complaints_state.dart';
import 'package:internet_application_project/features/my_complaints/widgets/complaint_card.dart';

class MyComplaintsPage extends StatelessWidget {
  const MyComplaintsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MyComplaintsCubit(
        remoteService: context.read<RemoteService>(),
      )..loadComplaints(),
      child: DefaultTabController(
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
                child: BlocBuilder<MyComplaintsCubit, MyComplaintsState>(
                  builder: (context, state) {
                    if (state.state == StateValue.loading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state.state == StateValue.error) {
                      return Center(child: Text(state.message));
                      print("//////////////////////");
                    }

                    return TabBarView(
                      children: [
                        _buildResponsiveComplaintList(
                          context,
                          filterByStatus(state.complaints, 'new'),
                        ),
                        _buildResponsiveComplaintList(
                          context,
                          filterByStatus(state.complaints, 'in_process'),
                        ),
                        _buildResponsiveComplaintList(
                          context,
                          filterByStatus(state.complaints, 'rejected'),
                        ),
                        _buildResponsiveComplaintList(
                          context,
                          filterByStatus(state.complaints, 'done'),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- TabBar ----------------
  Widget _buildTabBar(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);
    final isTablet = ResponsiveUtils.isTablet(context);

    double horizontalPadding = isMobile ? 20 : (isTablet ? 40 : 50);
    double fontSize = isMobile ? 14 : (isTablet ? 18 : 20);
    double radius = 15;

    return ButtonsTabBar(
      radius: radius,
      height: isMobile ? 45 : 55,
      buttonMargin: const EdgeInsets.symmetric(horizontal: 8),
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

  // ---------------- Filter by status ----------------
  List<Complaint> filterByStatus(List<Complaint> complaints, String status) {
    return complaints.where((c) => c.status == status).toList();
  }

  // ---------------- Responsive List/Grid ----------------
  Widget _buildResponsiveComplaintList(
      BuildContext context, List<Complaint> complaints) {
    final isMobile = ResponsiveUtils.isMobile(context);
    final isTablet = ResponsiveUtils.isTablet(context);

    if (complaints.isEmpty) {
      return const Center(
        child: Text(
          'No complaints here',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    if (isMobile) {
      // ListView for mobile
      return ListView.builder(
        padding: EdgeInsets.all(ResponsiveUtils.mediumSpacing(context)),
        itemCount: complaints.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: ComplaintCard(complaint: complaints[index]),
          );
        },
      );
    } else {
      // Grid for tablet/desktop
      int crossAxisCount = isTablet ? 2 : 3;
      return Padding(
        padding: EdgeInsets.all(ResponsiveUtils.mediumSpacing(context)),
        child: GridView.builder(
          itemCount: complaints.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 3 / 2,
          ),
          itemBuilder: (context, index) {
            return ComplaintCard(complaint: complaints[index]);
          },
        ),
      );
    }
  }
}
