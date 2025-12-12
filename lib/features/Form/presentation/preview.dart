import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:internet_application_project/core/resources/colorfile.dart';
import 'package:internet_application_project/core/widgets/customAppBar.dart';
import 'package:internet_application_project/core/widgets/custom_button.dart';
import 'package:internet_application_project/features/Form/presentation/maps_screen.dart';
import 'package:internet_application_project/features/Form/widgets/place_picker_widget.dart';
import 'package:internet_application_project/features/home_page/presentation/home_page.dart';
import 'package:latlong2/latlong.dart';

class Preview extends StatefulWidget {
  const   Preview({super.key});

  @override
  State<Preview> createState() => _PreviewState();
}

class _PreviewState extends State<Preview> {
  int _currentStep = 0;

  PickedData? pickedData;
  MapController mapController = MapController();
  var addressController = TextEditingController();
  UniqueKey _mapKey = UniqueKey();

  String? complaintType;
  TextEditingController otherTypeController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  List<String> documents = [];

  @override
  void dispose() {
    addressController.dispose();
    otherTypeController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

      final ThemeData stepperTheme = Theme.of(context).copyWith(
      colorScheme: Theme.of(context).colorScheme.copyWith(
            primary: secondColor,
          ),
      textTheme: Theme.of(context).textTheme.copyWith(
            bodyMedium: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Colors.white),
          ),
    );

    return Scaffold(
      appBar: CustomAppBar(title: 'Complaint Form', icon: Icons.arrow_back),
      body: Column(
        children: [
          Expanded(
            
            child:  Theme(data: stepperTheme, child:
            Stepper(
              
              type: StepperType.vertical,
              currentStep: _currentStep,
              onStepContinue: () {
                if (_currentStep < 3) {
                  setState(() {
                    _currentStep++;
                  });
                }
              },
              onStepCancel: () {
                if (_currentStep > 0) {
                  setState(() {
                    _currentStep--;
                  });
                }
              },
              steps: [
                Step(
                  title: const Text("Choose Location"),
                  isActive: _currentStep >= 0,
                  content: Column(
                    children: [
                      if (pickedData != null)
                        Container(
                          clipBehavior: Clip.hardEdge,
                          height: MediaQuery.of(context).size.height * 0.3,
                          foregroundDecoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: Colors.blueGrey,
                                  width: MediaQuery.of(context).size.height * 0.001)),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: Colors.blueGrey,
                                  width: MediaQuery.of(context).size.height * 0.001)),
                          child: Stack(
                            children: [
                              FlutterMap(
                                  key: _mapKey,
                                  mapController: mapController,
                                  options: MapOptions(
                                      interactiveFlags: InteractiveFlag.none,
                                      center: LatLng(
                                          pickedData!.latLong.latitude,
                                          pickedData!.latLong.longitude),
                                      zoom: 17,
                                      maxZoom: 19,
                                      maxBounds: LatLngBounds(
                                          LatLng(24.29200, 46.22700),
                                          LatLng(25.09800, 47.20200))),
                                  children: [
                                    TileLayer(
                                      urlTemplate:
                                          "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                                      userAgentPackageName:
                                          'dev.fleaflet.flutter_map.example',
                                    ),
                                  ]),
                              const Positioned.fill(
                                  child: IgnorePointer(
                                child: Center(
                                  child: Icon(
                                    Icons.location_pin,
                                    size: 50,
                                    color: primaryColor,
                                  ),
                                ),
                              )),
                            ],
                          ),
                        ),
            
                      if (pickedData == null)
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => PlacePicker(
                                      limitLocation: "دمشق",
                                      onPicked: (result) {
                                        if (!mounted) return;
                                        setState(() {
                                          this.pickedData = result;
                                        });
                                      },
                                    )));
                          },
                          child: Container(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            height: MediaQuery.of(context).size.height * 0.3,
                            decoration: BoxDecoration(
                                image: const DecorationImage(
                                    image: NetworkImage(
                                        "https://th-i.thgim.com/public/migration_catalog/article12284026.ece/alternates/FREE_320/Aleppo.jpg"),
                                    fit: BoxFit.cover),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: Colors.blueGrey,
                                    width:
                                        MediaQuery.of(context).size.height * 0.001)),
                          ),
                        )
                    ],
                  ),
                ),
            
                Step(
                  title: const Text("Choose Type"),
                  isActive: _currentStep >= 1,
                  content: Column(
                    children: [
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(labelText:  "type"),
                        value: complaintType,
                        items: const [
                          DropdownMenuItem(
                              value: "Road Damage", child: Text("Road Damage")),
                          DropdownMenuItem(
                              value: "Electricity Outage",
                              child: Text("Electricity Outage")),
                          DropdownMenuItem(
                              value: "Water Leakage", child: Text("Water Leakage")),
                          DropdownMenuItem(value: "Other", child: Text("Other")),
                        ],
                        onChanged: (value) {
                          setState(() {
                            complaintType = value;
                          });
                        },
                      ),
            
                      if (complaintType == "Other")
                        TextField(
                          controller: otherTypeController,
                          decoration:
                              const InputDecoration(labelText: "Write type here"),
                        ),
                    ],
                  ),
                ),
            
                Step(
                  title: const Text("Description"),
                  isActive: _currentStep >= 2,
                  content: TextField(
                    controller: descriptionController,
                    maxLines: 5,
                    decoration:
                        const InputDecoration(labelText: "Write the Description"),
                  ),
                ),
            
                Step(
                  title: const Text("Upload Document"),
                  isActive: _currentStep >= 3,
                  content: Column(
                    children: [
                      ElevatedButton(
              onPressed: () async {
                final result = await FilePicker.platform.pickFiles();
            
                if (result != null && result.files.isNotEmpty) {
            setState(() {
              documents.add(result.files.single.name);
            });
                }
              },
              child: const Text("Upload Document"),
            ),
            ...documents.map((e) => ListTile(
            title: Text(e),
            leading: const Icon(Icons.file_present),
                ))
            
                    ],
                  ),
                ),
              ],
            ),
          ),),
          CustomButton(
        width: MediaQuery.of(context).size.width * 0.45,
height: MediaQuery.of(context).size.height * 0.065,


       
        title: 'Confirm',
        titleColor: Colors.white,
        backgroundColor: primaryColor,
        onTap: () {
          Navigator.of(
            context,
          ).pop(MaterialPageRoute(builder: (context) => HomePage()));
        },
      ),
      SizedBox(height: 50,)
        ],
      ),
 
    );
  }
}
