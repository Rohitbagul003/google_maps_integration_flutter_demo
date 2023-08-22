import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:merlin_foyer_app/resource/states/map_state.dart';
import 'package:merlin_foyer_app/utility/colors.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

import '../../utility/images.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  String _darkMapStyle = "";
  final _isGranted = ValueNotifier(false);
  final _latLang = ValueNotifier(const LatLng(12.972442, 77.580643));
  final _refreshing = ValueNotifier(false);
  double lat = 12.972442;
  double long = 77.580643;
  final LatLng _center = const LatLng(12.972442, 77.580643);
  final Completer<GoogleMapController> _controller = Completer();
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
  final _profileController = TextEditingController();

  @override
  void dispose() {
    _profileController.dispose();
    _isGranted.dispose();
    _refreshing.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((timeStamp) async {
      // _pid = await SharedPreferenceHelper().getPID();
      await _loadMapStyles();
      await _checkPermissionAndAddMarkers();
    });
  }

  Future _loadMapStyles() async {
    _darkMapStyle = await rootBundle.loadString('assets/dark_map_theme.json');
  }

  Future<void> _checkPermissionAndAddMarkers() async {
    if (!_isGranted.value) {
      var status = await Permission.location.status;
      _isGranted.value = status == PermissionStatus.granted;
      if (_isGranted.value) {
        await _determinePositionAndUpdateUserLocation();
      } else {
        await Permission.location.request();
      }
    }
  }

  Future<void> _determinePositionAndUpdateUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    _isGranted.value = serviceEnabled;
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _isGranted.value = false;
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _isGranted.value = false;
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }

    final position = await Geolocator.getCurrentPosition();
    await _navigateToUserLocation(position);
  }

  Future<void> setMarkersToMapIfExist() async {
    final mapState = Provider.of<MapState>(context, listen: false);
    mapState.setMarkersFromDB();
  }

  Future<void> _navigateToUserLocation(Position position) async {
    final mapState = Provider.of<MapState>(context, listen: false);
    if (mounted) {
      mapState.setCenterLatLang = LatLng(position.latitude, position.longitude);

      // specified current users location
      CameraPosition cameraPosition = CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 30,
      );

      final GoogleMapController controller = await _controller.future;
      setMarkersToMapIfExist();
      controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

      debugPrint("Current location Lat ${position.latitude} and Long ${position.longitude} and _center :$_center");
    }
  }

  void _onMapCreated(GoogleMapController controller) async {
    final mapState = Provider.of<MapState>(context, listen: false);
    _controller.complete(controller);
    final position = await Geolocator.getCurrentPosition();
    mapState.setCenterLatLang = LatLng(position.latitude, position.longitude);
    CameraPosition cameraPosition = CameraPosition(
      target: mapState.centerLatLang,
      zoom: 30,
    );
    setMarkersToMapIfExist();
    controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    controller.setMapStyle(_darkMapStyle);
  }

  void _onCameraMove(CameraPosition position) {
    debugPrint("this is google Lat ${position.target.longitude}");
    if (mounted) {
      _latLang.value = LatLng(position.target.latitude, position.target.longitude);
    }
    debugPrint("this is google lat: ${_latLang.value.latitude} and long: ${_latLang.value.longitude}");
  }

  Future<bool> addMarkerFunction(MapState mapState, LatLng latLng) async {
    String id = Random().nextInt(50).toString();
    if (mapState.addMarkersToggle) {
      return await mapState.addMarker(id: id, position: latLng, title: _profileController.text);
    }
    return false;
  }

  void _alertForAddingProfile(MapState mapState, LatLng latLng) async {
    if (!mapState.addMarkersToggle) return;
    await QuickAlert.show(
      context: context,
      type: QuickAlertType.custom,
      customAsset: MerlinImg.millerGif,
      barrierDismissible: true,
      backgroundColor: MerlinColors.darkColor.withOpacity(0.6),
      confirmBtnText: 'Add',
      widget: TextFormField(
        controller: _profileController,
        style: TextStyle(color: MerlinColors.textGray400),
        decoration: InputDecoration(
          alignLabelWithHint: true,
          hintText: 'Add Profile Name',
          hintStyle: TextStyle(color: MerlinColors.textGray400),
          prefixIcon: const Icon(
            Icons.person_2_outlined,
            color: Colors.white,
          ),
        ),
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.text,
      ),
      confirmBtnColor: MerlinColors.primaryColor,
      onConfirmBtnTap: () async {
        if (_profileController.text.isEmpty) {
          Navigator.pop(context);
          await QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            text: 'Please input something',
            confirmBtnColor: MerlinColors.primaryColor,
          );
          return;
        }
        Navigator.pop(context);
        final added = await addMarkerFunction(mapState, latLng);
        if (added && mounted) {
          await QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            text: "Profile has been saved!.",
            confirmBtnColor: MerlinColors.primaryColor,
          );
        } else {
          await QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            text: "Unable to save profile",
            confirmBtnColor: MerlinColors.primaryColor,
          );
        }
        _profileController.text = "";
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MapState>(
      builder: (context, mapState, _) {
        return ValueListenableBuilder<bool>(
          valueListenable: _isGranted,
          builder: (context, bool isGranted, _) {
            return ValueListenableBuilder(
              valueListenable: _latLang,
              builder: (context, latLang, _) {
                return Scaffold(
                  backgroundColor: MerlinColors.darkColor,
                  floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
                  floatingActionButton: FloatingActionButton(
                    onPressed: () => mapState.toggleAddMarkers = !mapState.addMarkersToggle,
                    child: Icon(mapState.addMarkersToggle ? Icons.close : Icons.add),
                  ),
                  body: GoogleMap(
                    markers: mapState.getMarkers,
                    compassEnabled: true,
                    myLocationEnabled: true,
                    onMapCreated: _onMapCreated,
                    onTap: (LatLng latLng) async {
                      _alertForAddingProfile(mapState, latLng);
                    },
                    initialCameraPosition: CameraPosition(
                      target: mapState.centerLatLang,
                      zoom: 30,
                    ),
                    onCameraMove: _onCameraMove,
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
