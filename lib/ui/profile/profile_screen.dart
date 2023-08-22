import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:merlin_foyer_app/resource/profile_model.dart';
import 'package:merlin_foyer_app/resource/states/map_state.dart';
import 'package:merlin_foyer_app/utility/colors.dart';
import 'package:merlin_foyer_app/utility/images.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _loader = ValueNotifier(false);
  List<ProfileModel> _profileList = [];
  final profileNameController = TextEditingController();
  final latController = TextEditingController();
  final langController = TextEditingController();

  @override
  void dispose() {
    profileNameController.dispose();
    latController.dispose();
    langController.dispose();
    _loader.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((timeStamp) async {
      await _getAllProfiles();
    });
  }

  bool isLatitudeValid(double latitude) {
    return (latitude >= -90.0 && latitude <= 90.0);
  }

  bool isLongitudeValid(double longitude) {
    return (longitude >= -180.0 && longitude <= 180.0);
  }

  bool areCoordinatesValid(double latitude, double longitude) {
    return isLatitudeValid(latitude) && isLongitudeValid(longitude);
  }

  Future<void> _getAllProfiles() async {
    final mapState = Provider.of<MapState>(context, listen: false);
    _loader.value = true;
    _profileList = await mapState.getProfiles();
    _loader.value = false;
  }

  Future<bool> _updateProfile(MapState mapState, String id) async {
    final indexOfUpdatingTodo = _profileList.indexWhere((element) => element.id == id);
    double lat = 0;
    double lang = 0;
    try {
      lat = double.parse(latController.text);
      lang = double.parse(langController.text);
    } catch (err) {
      debugPrint("unable to parse lat, lang double $err");
    }
    if (indexOfUpdatingTodo != -1) {
      _profileList[indexOfUpdatingTodo] = ProfileModel(
        id: id,
        title: profileNameController.text,
        lat: lat,
        lang: lang,
      );
      debugPrint("Item updated: ${_profileList[indexOfUpdatingTodo]}");
    } else {
      debugPrint("Item with id $indexOfUpdatingTodo not found.");
    }

    final updated = await mapState.updateListElement(_profileList);
    return updated;
  }

  Future<void> _updateAlert(MapState mapState, String id) async {
    await QuickAlert.show(
      context: context,
      type: QuickAlertType.custom,
      barrierDismissible: true,
      customAsset: MerlinImg.millerGif,
      backgroundColor: MerlinColors.darkColor.withOpacity(0.6),
      confirmBtnText: 'Update',
      widget: SizedBox(
        height: 250,
        child: ListView(
          children: [
            TextFormField(
              controller: profileNameController,
              style: TextStyle(color: MerlinColors.textGray400),
              decoration: InputDecoration(
                alignLabelWithHint: true,
                hintText: 'Update Profile Name',
                hintStyle: TextStyle(color: MerlinColors.textGray400),
                prefixIcon: const Icon(
                  Icons.person_2_outlined,
                  color: Colors.white,
                ),
              ),
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 2),
            TextFormField(
              controller: latController,
              style: TextStyle(color: MerlinColors.textGray400),
              decoration: InputDecoration(
                alignLabelWithHint: true,
                hintText: 'Update Latitude',
                hintStyle: TextStyle(color: MerlinColors.textGray400),
                prefixIcon: const Icon(
                  Icons.label,
                  color: Colors.white,
                ),
              ),
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 2),
            TextFormField(
              controller: langController,
              style: TextStyle(color: MerlinColors.textGray400),
              decoration: InputDecoration(
                alignLabelWithHint: true,
                hintText: 'Update Longitude',
                hintStyle: TextStyle(color: MerlinColors.textGray400),
                prefixIcon: const Icon(
                  Icons.label,
                  color: Colors.white,
                ),
              ),
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),
      confirmBtnColor: MerlinColors.primaryColor,
      onConfirmBtnTap: () async {
        if (profileNameController.text.isEmpty || latController.text.isEmpty || langController.text.isEmpty) {
          await QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            text: 'Empty fields not allowed',
            confirmBtnColor: MerlinColors.primaryColor,
            onConfirmBtnTap: () => Navigator.pop(context),
          );
          return;
        }
        //19.925444193725365
        //74.73340138792993
        double lat = 0;
        double lang = 0;
        try {
          lat = double.parse(latController.text);
          lang = double.parse(langController.text);
        } catch (err) {
          debugPrint("unable to parse lat, lang double $err");
        }
        if (!areCoordinatesValid(lat, lang)) {
          await QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            text: 'Invalid Latitude or Longitude',
            confirmBtnColor: MerlinColors.primaryColor,
            onConfirmBtnTap: () => Navigator.pop(context),
          );
          return;
        }

        //19.931545, 74.714726
        //19.908574, 74.712141
        //19.942011, 74.741981
        //19.922548, 74.733338 - yummy tummy
        final updated = await _updateProfile(mapState, id);
        if (updated && mounted) {
          Navigator.pop(context);
          await QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            text: "Profile has been updated!.",
            confirmBtnColor: MerlinColors.primaryColor,
          );
        } else {
          await QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            text: "Unable to update profile",
            confirmBtnColor: MerlinColors.primaryColor,
            onConfirmBtnTap: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
          );
        }
        profileNameController.clear();
        langController.clear();
        latController.clear();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MerlinColors.darkColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text("Profiles", style: TextStyle(color: MerlinColors.textGray400)),
      ),
      body: RefreshIndicator(
        onRefresh: () async => await _getAllProfiles(),
        child: ValueListenableBuilder<bool>(
          valueListenable: _loader,
          builder: (context, loading, _) {
            return Consumer<MapState>(
              builder: (context, mapState, _) {
                return loading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: _profileList.length,
                        itemBuilder: (context, index) {
                          if (_profileList.isEmpty) {
                            return Center(
                              child: Text(
                                "No Profile Found",
                                style: TextStyle(color: MerlinColors.textGray400),
                              ),
                            );
                          }
                          final model = _profileList[index];
                          double lat = model.lat;
                          double lang = model.lang;
                          return Card(
                            elevation: 6,
                            color: MerlinColors.primaryColor.withOpacity(0.3),
                            margin: const EdgeInsets.all(10),
                            child: ListTile(
                              leading: SvgPicture.asset(
                                MerlinImg.logo,
                                height: 30,
                                width: 30,
                              ),
                              title: Text(
                                model.title ?? "",
                                style: TextStyle(color: MerlinColors.textGray400),
                              ),
                              subtitle: Text(
                                "LatLang(${lat.toStringAsFixed(3)}, ${lang.toStringAsFixed(3)})",
                                style: TextStyle(color: MerlinColors.textGray400, fontSize: 12),
                              ),
                              trailing: InkWell(
                                onTap: () async {
                                  profileNameController.text = model.title ?? "";
                                  latController.text = lat.toString();
                                  langController.text = lang.toString();
                                  await _updateAlert(mapState, model.id ?? "");
                                },
                                child: const Icon(Icons.edit),
                              ),
                            ),
                          );
                        },
                      );
              },
            );
          },
        ),
      ),
    );
  }
}
