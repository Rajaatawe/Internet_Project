import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_application_project/core/models/complaints_types.dart';
import 'package:internet_application_project/core/resources/colorfile.dart';
import 'package:internet_application_project/core/services/generalized_api.dart';
import 'package:internet_application_project/core/widgets/customAppBar.dart';
import 'package:internet_application_project/features/Form/cubit/form_complaint_cubit.dart';
import 'package:internet_application_project/features/Form/cubit/form_complaint_state.dart';
import 'package:internet_application_project/features/Form/presentation/preview.dart';
import 'package:internet_application_project/core/models/enum/states_enum.dart';

class ComplaintsTypesPage extends StatefulWidget {
  final int agencyId;

  const ComplaintsTypesPage({super.key, required this.agencyId});

  @override
  State<ComplaintsTypesPage> createState() => _ComplaintsTypesPageState();
}

class _ComplaintsTypesPageState extends State<ComplaintsTypesPage> {
  @override
  void initState() {
    super.initState();
    context.read<FormComplaintCubit>().fetchComplaintsTypes(widget.agencyId);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Complaint Types',
        icon: Icons.arrow_back,
      ),
      body: BlocBuilder<FormComplaintCubit, FormComplaintState>(
        builder: (context, state) {
          if (state.typesState == StateValue.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.typesState == StateValue.error) {
            return Center(
              child: Text(
                state.typesMessage,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          final List<ComplaintType> types = state.complaintTypes;

          if (types.isEmpty) {
            return const Center(child: Text("No complaint types found"));
          }

          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.05,
              vertical: size.height * 0.02,
            ),
            child: ListView.separated(
              itemCount: types.length,
              separatorBuilder: (_, __) => SizedBox(height: size.height * 0.02),
              itemBuilder: (context, index) {
                final item = types[index];

                return InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => BlocProvider(
                          create: (context) => FormComplaintCubit(remoteService: context.read<RemoteService>()),
                          child: Preview(
                            agencyId: widget.agencyId,
                            complaintType: item.name,
                          ),
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.04,
                      vertical: size.height * 0.011,
                    ),
                    decoration: BoxDecoration(
                      color: secondColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: primaryColor.withOpacity(0.15),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.more_horiz,
                            color: primaryColor,
                            size: isTablet ? 36 : 28,
                          ),
                        ),
                        SizedBox(width: size.width * 0.05),
                        Expanded(
                          child: Text(
                            item.name,
                            style: TextStyle(
                              fontSize: isTablet ? 22 : 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white70,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
