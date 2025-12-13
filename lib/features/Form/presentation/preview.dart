import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:internet_application_project/core/models/enum/states_enum.dart';
import 'package:internet_application_project/core/resources/colorfile.dart';
import 'package:internet_application_project/core/widgets/customAppBar.dart';
import 'package:internet_application_project/core/widgets/custom_button.dart';
import 'package:internet_application_project/features/Form/cubit/form_complaint_cubit.dart';
import 'package:internet_application_project/features/Form/cubit/form_complaint_state.dart';
import 'package:internet_application_project/features/Form/presentation/maps_screen.dart';
import 'package:internet_application_project/features/Form/widgets/place_picker_widget.dart';
import 'package:latlong2/latlong.dart';

class Preview extends StatefulWidget {
  final int agencyId;
  final String complaintType;
  final int? complaintTypeId; // Add this if available

  const Preview({
    super.key,
    required this.agencyId,
    required this.complaintType,
    this.complaintTypeId,
  });

  @override
  State<Preview> createState() => _PreviewState();
}

class _PreviewState extends State<Preview> {
  int _currentStep = 0;
  PickedData? pickedData;
  MapController mapController = MapController();
  UniqueKey _mapKey = UniqueKey();

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  List<PlatformFile> documents = [];
  bool _isSubmitting = false;

  // Form validation
  bool get _isFormValid {
    return titleController.text.trim().isNotEmpty &&
        descriptionController.text.trim().isNotEmpty &&
        pickedData != null;
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void _handleFilePick() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.any,
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        documents.addAll(result.files);
      });
    }
  }

  void _submitComplaint(BuildContext context) {
    if (!_isFormValid || _isSubmitting) return;

    if (pickedData == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a location'),
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    context.read<FormComplaintCubit>().submitComplaint(
          title: titleController.text.trim(),
          description: descriptionController.text.trim(),
          customComplaintType: widget.complaintType,
          complaintTypeId: widget.complaintTypeId,
          agencyId: widget.agencyId,
          latitude: pickedData!.latLong.latitude,
          longitude: pickedData!.latLong.longitude,
          documents: documents,
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FormComplaintCubit, FormComplaintState>(
      listener: (context, state) {
        if (state.formState == StateValue.loading) {
          setState(() => _isSubmitting = true);
        } else if (state.formState == StateValue.success) {
          setState(() => _isSubmitting = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.formMessage),
              backgroundColor: Colors.green,
            ),
          );
          // Navigate back or reset form
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.pop(context, true); // Pass success result
          });
        } else if (state.formState == StateValue.error) {
          setState(() => _isSubmitting = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.formMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: const CustomAppBar(
          title: 'Complaint Form',
          icon: Icons.arrow_back,
        ),
        body: Column(
          children: [
            Expanded(
              child: Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: Theme.of(context).colorScheme.copyWith(
                        primary: secondColor,
                      ),
                ),
                child: Stepper(
                  type: StepperType.vertical,
                  currentStep: _currentStep,
                  onStepContinue: () {
                    if (_currentStep < 3) {
                      setState(() => _currentStep++);
                    }
                  },
                  onStepCancel: () {
                    if (_currentStep > 0) {
                      setState(() => _currentStep--);
                    }
                  },
                  steps: [
                    /// STEP 0 — TITLE
                    Step(
                      title: const Text("Complaint Title"),
                      subtitle: Text("Type: ${widget.complaintType}"),
                      isActive: _currentStep >= 0,
                      state: titleController.text.isEmpty
                          ? StepState.indexed
                          : StepState.complete,
                      content: TextField(
                        controller: titleController,
                        decoration: InputDecoration(
                          labelText: "Title*",
                          hintText: "e.g. Broken street light",
                          errorText: titleController.text.isEmpty &&
                                  _currentStep >= 0
                              ? 'Title is required'
                              : null,
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                    ),

                    /// STEP 1 — LOCATION
                    Step(
                      title: const Text("Choose Location*"),
                      subtitle: const Text("Pick the exact location on the map"),
                      isActive: _currentStep >= 1,
                      state: pickedData == null
                          ? StepState.indexed
                          : StepState.complete,
                      content: Column(
                        children: [
                          if (pickedData != null)
                            Container(
                              clipBehavior: Clip.hardEdge,
                              height: MediaQuery.of(context).size.height * 0.3,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.blueGrey,
                                  width:
                                      MediaQuery.of(context).size.height * 0.001,
                                ),
                              ),
                              child: Stack(
                                children: [
                                  FlutterMap(
                                    key: _mapKey,
                                    mapController: mapController,
                                    options: MapOptions(
                                      interactiveFlags: InteractiveFlag.none,
                                      center: LatLng(
                                        pickedData!.latLong.latitude,
                                        pickedData!.latLong.longitude,
                                      ),
                                      zoom: 17,
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
                          if (pickedData == null)
                            GestureDetector(
                              onTap: () async {
                                final result = await Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => PlacePicker(
                                      limitLocation: "دمشق",
                                      onPicked: (result) {
                                        if (!mounted) return;
                                        setState(() {
                                          pickedData = result;
                                        });
                                      },
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                height: MediaQuery.of(context).size.height * 0.3,
                                decoration: BoxDecoration(
                                  image: const DecorationImage(
                                    image: NetworkImage(
                                      "https://th-i.thgim.com/public/migration_catalog/article12284026.ece/alternates/FREE_320/Aleppo.jpg",
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.blueGrey,
                                    width:
                                        MediaQuery.of(context).size.height *
                                            0.001,
                                  ),
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.location_on,
                                        size: 50,
                                        color: Colors.white.withOpacity(0.8),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        'Tap to pick location',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          if (pickedData == null && _currentStep >= 1)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                'Location is required',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),

                    /// STEP 2 — DESCRIPTION
                    Step(
                      title: const Text("Description*"),
                      subtitle: const Text("Explain the issue in detail"),
                      isActive: _currentStep >= 2,
                      state: descriptionController.text.isEmpty
                          ? StepState.indexed
                          : StepState.complete,
                      content: TextField(
                        controller: descriptionController,
                        maxLines: 5,
                        decoration: InputDecoration(
                          labelText: "Write the Description",
                          errorText: descriptionController.text.isEmpty &&
                                  _currentStep >= 2
                              ? 'Description is required'
                              : null,
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                    ),

                    /// STEP 3 — DOCUMENTS
                    Step(
                      title: const Text("Upload Documents"),
                      subtitle: const Text("Attach photos or documents (optional)"),
                      isActive: _currentStep >= 3,
                      state: documents.isEmpty
                          ? StepState.indexed
                          : StepState.complete,
                      content: Column(
                        children: [
                          ElevatedButton.icon(
                            onPressed: _handleFilePick,
                            icon: const Icon(Icons.upload_file),
                            label: const Text("Upload Documents"),
                          ),
                          const SizedBox(height: 8),
                          ...documents.map(
                            (file) => ListTile(
                              title: Text(file.name),
                              subtitle: Text(
                                '${(file.size / 1024).toStringAsFixed(2)} KB',
                              ),
                              leading: const Icon(Icons.attach_file),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  setState(() {
                                    documents.remove(file);
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            /// CONFIRM BUTTON
            BlocBuilder<FormComplaintCubit, FormComplaintState>(
              builder: (context, state) {
                final bool isSubmitting = state.formState == StateValue.loading;
                final bool isEnabled = _isFormValid && !isSubmitting;

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: Row(
                    children: [
                      if (_currentStep > 0)
                        Expanded(
                          child: CustomButton(
                            width: double.infinity,
                            height: 50,
                            title: 'Back',
                            titleColor: Colors.grey.shade700,
                            backgroundColor: Colors.grey.shade200,
                            onTap: () {
                              if (_currentStep > 0) {
                                setState(() => _currentStep--);
                              }
                            },
                          ),
                        ),
                      if (_currentStep > 0) const SizedBox(width: 10),
                      Expanded(
                        child: _currentStep < 3
                            ? CustomButton(
                                width: double.infinity,
                                height: 50,
                                title: 'Continue',
                                titleColor: Colors.white,
                                backgroundColor: primaryColor,
                                onTap: () {
                                  // Validate current step
                                  if (_currentStep == 0 &&
                                      titleController.text.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Please enter a title'),
                                      ),
                                    );
                                    return;
                                  }
                                  if (_currentStep == 1 && pickedData == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Please select a location'),
                                      ),
                                    );
                                    return;
                                  }
                                  if (_currentStep == 2 &&
                                      descriptionController.text.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Please enter a description'),
                                      ),
                                    );
                                    return;
                                  }

                                  setState(() => _currentStep++);
                                },
                              )
                            : CustomButton(
                                width: double.infinity,
                                height: 50,
                                title: isSubmitting
                                    ? 'Submitting...'
                                    : 'Submit Complaint',
                                titleColor: Colors.white,
                                backgroundColor:
                                    isEnabled ? primaryColor : Colors.grey,
                                onTap: isEnabled
                                    ? () => _submitComplaint(context)
                                    : null,
                              ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}