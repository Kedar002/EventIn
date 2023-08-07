///
/// AVANCED EXAMPLE:
/// Screen with map and search box on top. When the user selects a place through autocompletion,
/// the screen is moved to the selected location, a path that demonstrates the route is created, and a "start route"
/// box slides in to the screen.
///

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:io' show Platform;
import 'package:toast/toast.dart';

import '../constants/theme.dart';

class MapLocation extends StatefulWidget {
  MapLocation(
      {Key? key,
      // this.address,
      this.lat,
      this.lng})
      : super(key: key);
  // var address;
  var lat;
  var lng;

  @override
  State<MapLocation> createState() => MapLocationState();
}

class MapLocationState extends State<MapLocation>
    with SingleTickerProviderStateMixin {
  var lat;
  var lng;
  late PickResult selectedPlace;
  LatLng kInitialPosition = LatLng(0.0, 0.0);
  late GoogleMapController _controller;

  Future<void> _onMapCreated(GoogleMapController controller) async {
    _controller = controller;
    setState(() {});
  }

  Future<void> _getPinCodeFromDeviceLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      lat = position.latitude;
      lng = position.longitude;
      print(placemarks);
      setState(() {});
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  Future<void> _checkLocationPermission() async {
    final status = await Geolocator.checkPermission();
    if (status == LocationPermission.denied) {
      await Geolocator.requestPermission();
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.lat != null) {
      setfetchedLocation();
    } else {
      setInitialLocation();
    }
  }

  setInitialLocation() {
    kInitialPosition = LatLng(lat, lng);
    setState(() {});
  }

  setfetchedLocation() {
    kInitialPosition = LatLng(widget.lat, widget.lng);
    setState(() {});
  }

  onTapPickHere(selectedPlace) async {
    GetAddress data = GetAddress(selectedPlace.geometry.location.lat.toString(),
        selectedPlace.geometry.location.lng.toString());
    print(data);
    Navigator.pop(context, data);
  }

  @override
  Widget build(BuildContext context) {
    return PlacePicker(
      hintText: 'Pick Your Event Location',
      apiKey:
          'AIzaSyD2YOIzSCqU7hr4_npknS897AdN3Umajjc', //api key will come here
      initialPosition: kInitialPosition,
      useCurrentLocation: false,
      //selectInitialPosition: true,
      //onMapCreated: _onMapCreated, // this causes error , do not open this
      //initialMapType: MapType.terrain,

      //usePlaceDetailSearch: true,
      onPlacePicked: (result) {
        selectedPlace = result;

        print("onPlacePicked..." + result.toString());
        // Navigator.of(context).pop();
        setState(() {});
      },
      //forceSearchOnZoomChanged: true,
      //automaticallyImplyAppBarLeading: false,
      //autocompleteLanguage: "ko",
      //region: 'au',
      //selectInitialPosition: true,
      selectedPlaceWidgetBuilder:
          (_, selectedPlace, state, isSearchBarFocused) {
        //print("state: $state, isSearchBarFocused: $isSearch
        //print("-------------");
        /*
        if(!isSearchBarFocused && state != SearchingState.Searching){
          ToastComponent.showDialog("Hello", context,
              gravity: Toast.center, duration: Toast.lengthLong);
        }*/
        return isSearchBarFocused
            ? Container()
            : FloatingCard(
                height: 140,
                bottomPosition: 20.0,
                // MediaQuery.of(context) will cause rebuild. See MediaQuery document for the information.
                leftPosition: 0.0,
                rightPosition: 0.0,
                width: 500,
                borderRadius: const BorderRadius.only(
                  topLeft: const Radius.circular(8.0),
                  bottomLeft: const Radius.circular(8.0),
                  topRight: const Radius.circular(8.0),
                  bottomRight: const Radius.circular(8.0),
                ),
                child: state == SearchingState.Searching
                    ? Center(
                        child: Text(
                        'fetching . . .',
                        style: TextStyle(color: Colors.grey),
                      ))
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Container(
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 2.0, right: 2.0),
                                    child: Text(
                                      selectedPlace!.formattedAddress
                                          .toString(),
                                      maxLines: 2,
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Container(
                                  width: double.infinity,
                                  height: 45,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: MyTheme.secondaryColor,
                                    ),
                                    // color: MyTheme.accent_color,
                                    // shape: RoundedRectangleBorder(
                                    //     borderRadius: const BorderRadius.only(
                                    //   topLeft: const Radius.circular(4.0),
                                    //   bottomLeft: const Radius.circular(4.0),
                                    //   topRight: const Radius.circular(4.0),
                                    //   bottomRight: const Radius.circular(4.0),
                                    // )),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Save The Location',
                                          // AppLocalizations.of(context)
                                          //     .map_location_screen_pick_here,
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Icon(
                                          Icons.save_outlined,
                                          size: 18,
                                        )
                                      ],
                                    ),
                                    onPressed: () {
                                      // IMPORTANT: You MUST manage selectedPlace data yourself as using this build will not invoke onPlacePicker as
                                      //            this will override default 'Select here' Button.
                                      /*print("do something with [selectedPlace] data");
                                      print(selectedPlace.formattedAddress);
                                      print(selectedPlace.geometry.location.lat);
                                      print(selectedPlace.geometry.location.lng);*/

                                      onTapPickHere(selectedPlace);
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
              );
      },
      pinBuilder: (context, state) {
        if (state == PinState.Idle) {
          return Icon(
            Icons.location_on_outlined,
            color: MyTheme.secondaryColor,
            size: 26,
          );
        } else {
          return Icon(
            Icons.location_on_outlined,
            color: MyTheme.secondaryColor,
            size: 26,
          );
        }
      },
    );
  }
}

class GetAddress {
  final String lat;
  final String lng;
  // final String value3;
  // final String value4;
  // final String value5;
  // final String value6;
  // final String value7;
  // final String value8;

  GetAddress(
    this.lat,
    this.lng,
    //  this.value3,
    //     this.value4, this.value5, this.value6, this.value7, this.value8
  );
}
