import 'package:flutter/material.dart';
import 'package:internet_application_project/core/resources/colorfile.dart';
import 'package:internet_application_project/features/Form/presentation/maps_screen.dart';

class PlacePicker extends StatefulWidget {


  final void Function(PickedData pickedData) onPicked;  // لارجاع الاحداثيات المخنارة (خط الطول و خط العرض)

  final String limitLocation; //مشان تحصروا نتائج البحث بمحافظة او بلد معين

  const PlacePicker({super.key, required this.onPicked, required this.limitLocation});

  @override
  State<PlacePicker> createState() => _PlacePickerState();
}

class _PlacePickerState extends State<PlacePicker> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
            color: darkBrown,
            size: MediaQuery.of(context).size.height * 0.03),
      ),
      extendBodyBehindAppBar: true,
      body: Center(
        child: Column(
          children: [
            Flexible(
              child:
              MapScreenChooseLocation(
                  hintText: "Search Location" ,
                  limitLocation: widget.limitLocation,
                  locationPinIconColor: primaryColor,
                  center:LatLong(33.5138,36.2922),
                  buttonColor: primaryColor,

                  buttonText: "Pick Location",
                  onPicked: (pickedData) {
                    debugPrint(pickedData.latLong.latitude.toString());
                    debugPrint(pickedData.latLong.longitude.toString());
                    debugPrint(pickedData.address);
                    widget.onPicked(pickedData);

                    //تصرفوا بالموقع هون متل ما بدكم
                  }),

            ),
          ],
        ),
      )
      ,

    );
  }
}
