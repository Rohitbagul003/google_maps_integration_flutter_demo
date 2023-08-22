import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:merlin_foyer_app/resource/profile_model.dart';
import 'package:merlin_foyer_app/resource/shared_preference_helper.dart';

class MapState extends ChangeNotifier {
  LatLng _center = const LatLng(12.972442, 77.580643);
  final _markers = <Marker>{};
  final prefs = SharedPreferenceHelper();

  bool _addMarkersToggle = false;

  bool get addMarkersToggle => _addMarkersToggle;

  set toggleAddMarkers(bool value) {
    _addMarkersToggle = value;
    notifyListeners();
  }

  LatLng get centerLatLang => _center;
  Set<Marker> get getMarkers => _markers;

  set setCenterLatLang(LatLng latLng) {
    _center = latLng;
    notifyListeners();
  }

  Future<bool> addMarker({
    required String id,
    required LatLng position,
    required String title,
  }) async {
    _markers.add(
      Marker(
        markerId: MarkerId(id),
        position: LatLng(position.latitude, position.longitude),
        infoWindow: InfoWindow(
          title: title,
        ),
      ),
    );
    final model = ProfileModel(id: id, title: title, lang: position.longitude, lat: position.latitude);
    notifyListeners();
    return await prefs.setUserProfiles(model);
  }

  Future<List<ProfileModel>> getProfiles() async {
    final list = await prefs.getUserProfiles() ?? [];
    log("this is print $list");
    return list;
  }

  Future<void> setMarkersFromDB() async {
    final profileList = await SharedPreferenceHelper().getUserProfiles() ?? [];
    if (profileList.isNotEmpty) {
      _markers.clear();
      for (final profile in profileList) {
        if (profile.id != null) {
          _markers.add(
            Marker(
              markerId: MarkerId(profile.id!),
              position: LatLng(profile.lat, profile.lang),
              infoWindow: InfoWindow(
                title: profile.title!,
              ),
            ),
          );
        }
      }
    }
  }

  Future<bool> updateListElement(List<ProfileModel> list) async {
    return await prefs.saveProfileList(list);
  }
}
