import 'dart:convert';

import 'package:merlin_foyer_app/resource/profile_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper {
  SharedPreferenceHelper._internal();
  static final SharedPreferenceHelper _singleton = SharedPreferenceHelper._internal();

  factory SharedPreferenceHelper() {
    return _singleton;
  }

  Future<List<ProfileModel>?> getUserProfiles() async {
    final jsonString = (await SharedPreferences.getInstance()).getString(
      UserPreferenceKey.userProfile.toString(),
    );
    var data = jsonDecode(jsonString.toString());
    return data != null
        ? (data as List).map((dynamic e) => ProfileModel.fromJson(e as Map<String, dynamic>)).toList()
        : null;
  }

  Future<bool> setUserProfiles(ProfileModel model) async {
    final list = await getUserProfiles() ?? [];
    final prefs = await SharedPreferences.getInstance();
    list.add(model);
    final addList = list.map((e) => e.toJson()).toList();
    return await prefs.setString(UserPreferenceKey.userProfile.toString(), jsonEncode(addList));
  }

  Future<bool> saveProfileList(List<ProfileModel> list) async {
    final prefs = await SharedPreferences.getInstance();
    final plist = list.map((e) => e.toJson()).toList();
    return await prefs.setString(UserPreferenceKey.userProfile.toString(), jsonEncode(plist));
  }

  //
  // Future<GetAllWalletsModel?> getPrimaryWalletModel() async {
  //   final jsonString = (await SharedPreferences.getInstance()).getString(
  //     UserPreferenceKey.primaryWallet.toString(),
  //   );
  //
  //   return jsonString != null ? GetAllWalletsModel.fromJson(json.decode(jsonString)) : null;
  // }
  //
  // Future<void> persistSession(Session session) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setString(UserPreferenceKey.supabaseSessionKey.toString(), session.persistSessionString);
  // }
  //
  // Future<void> removeSession() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   prefs.remove(UserPreferenceKey.supabaseSessionKey.toString());
  // }
  //
  // Future<String> getSessionKey() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   if (prefs.containsKey(UserPreferenceKey.supabaseSessionKey.toString())) {
  //     log('Found persisted session string, attempting to recover session');
  //     return prefs.getString(UserPreferenceKey.supabaseSessionKey.toString()) ?? '';
  //   } else {
  //     return '';
  //   }
  // }
  //
  // Future<String> getPrimaryWalletAddress() async {
  //   final user = await getUserProfile();
  //   final getWalletModel = await getPrimaryWalletModel();
  //   if (getWalletModel != null) {
  //     return getWalletModel.emailObjects?.first.externalEmail ?? "";
  //   }
  //   return user != null ? user.primaryWalletAddress : "";
  // }
  //
  // Future<bool> saveUserProfile(SharedPrefUserModel user) async {
  //   return (await SharedPreferences.getInstance()).setString(
  //     UserPreferenceKey.userProfile.toString(),
  //     json.encode(user.toJson()),
  //   );
  // }
  //
  // Future<bool> savePrimaryWalletModel(GetAllWalletsModel model) async {
  //   return (await SharedPreferences.getInstance()).setString(
  //     UserPreferenceKey.primaryWallet.toString(),
  //     json.encode(model.toJson()),
  //   );
  // }
  //
  // Future<void> saveUserInfoToLocalDatabase(UserModel userModel, GetAllWalletsModel? getAllWalletsModel) async {
  //   final sharedPreferenceModel = SharedPrefUserModel(
  //     uid: userModel.user?.id ?? '',
  //     accessToken: userModel.accessToken ?? '',
  //     refreshToken: userModel.refreshToken ?? '',
  //     hashId: userModel.user?.userMetadata?.hashId ?? '',
  //     hashImage: userModel.user?.userMetadata?.hashIdImage ?? '',
  //     theme: userModel.user?.userMetadata?.theme ?? '',
  //     userType: userModel.user?.userMetadata?.userType ?? '',
  //     externalEmail: getAllWalletsModel?.emailObjects?.first.externalEmail ??
  //         userModel.user?.userMetadata?.primaryWallet?.externalEmail ??
  //         '',
  //     phoneNumber: userModel.user?.phone ?? '',
  //     authenticatedStatus: userModel.user?.aud ?? '',
  //     walletOfficialVerifiedName: getAllWalletsModel?.emailObjects?.first.displayName ??
  //         userModel.user?.userMetadata?.primaryWallet?.displayName ??
  //         '',
  //     primaryWalletAddress: getAllWalletsModel?.emailObjects?.first.externalEmail ??
  //         userModel.user?.userMetadata?.primaryWallet?.address ??
  //         '',
  //     walletNickName: getAllWalletsModel?.nickName ?? userModel.user?.userMetadata?.primaryWallet?.nickName ?? '',
  //   );
  //   await SharedPrefrenceHelper().saveUserProfile(sharedPreferenceModel);
  //   await SharedPrefrenceHelper().setUID(userModel.user?.id ?? "");
  //   await SharedPrefrenceHelper().setSignature(userModel.user?.userMetadata?.signature ?? "");
  //   if (getAllWalletsModel != null) await SharedPrefrenceHelper().savePrimaryWalletModel(getAllWalletsModel);
  //   SharedPrefrenceHelper().setNotificationBool(true);
  // }

  Future<bool> setUID(String value) async {
    return (await SharedPreferences.getInstance()).setString(UserPreferenceKey.uid.toString(), value);
  }

  Future<String?> getUID() async {
    return (await SharedPreferences.getInstance()).getString(UserPreferenceKey.uid.toString());
  }

  Future<String?> getLanguageCode() async {
    return (await SharedPreferences.getInstance()).getString(UserPreferenceKey.languageCode.toString());
  }

  Future<bool> setLanguageCode(String value) async {
    return (await SharedPreferences.getInstance()).setString(UserPreferenceKey.languageCode.toString(), value);
  }

  Future<bool?> getOnboardingSeen() async {
    return (await SharedPreferences.getInstance()).getBool(UserPreferenceKey.seenOnboarding.toString());
  }

  Future<bool> setOnboardingSeen(bool value) async {
    return (await SharedPreferences.getInstance()).setBool(UserPreferenceKey.seenOnboarding.toString(), value);
  }

  Future<String> getDeviceId() async {
    return (await SharedPreferences.getInstance()).getString(UserPreferenceKey.deviceId.toString()) ?? '';
  }

  Future<bool> setDeviceId(String value) async {
    return (await SharedPreferences.getInstance()).setString(UserPreferenceKey.deviceId.toString(), value);
  }

  // Future<bool> checkIfUserIsAuthenticated() async {
  //   final user = await getUserProfile();
  //   return user?.authenticatedStatus == authenticated;
  // }

  Future<bool> clearAll() async {
    (await SharedPreferences.getInstance()).remove(UserPreferenceKey.userProfile.toString());
    // await clearAllInboxList();
    return true;
  }
}

enum UserPreferenceKey {
  uid,
  userProfile,
  languageCode,
  seenOnboarding,
  deviceId,
  supabaseSessionKey,
  signature,
  primaryWallet,
  notification,
}

extension InboxSaveExtension on SharedPreferenceHelper {
  // Future<void> saveInboxList(Folder folderName, List<Messages> list) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setString(folderName.asString()!, jsonEncode(list));
  // }
  //
  // Future<List<Messages>> getInboxList(Folder folderName) async {
  //   final listString = (await SharedPreferences.getInstance()).getString(folderName.asString()!);
  //   List list = [];
  //   try {
  //     list = jsonDecode(listString.toString()) ?? [];
  //   } catch (err, stackTrace) {
  //     log("Get Inbox List Error --> $err, \n $stackTrace");
  //     list = [];
  //   }
  //   final listToModel = list.map((e) => Messages.fromJson(e as Map<String, dynamic>)).toList();
  //   return listToModel;
  // }
  //
  // Future<void> removeSelectedFolderList(Folder folder) async {
  //   final listString = (await SharedPreferences.getInstance()).getString(folder.asString()!);
  //   if (listString != null && listString.isNotEmpty) {
  //     (await SharedPreferences.getInstance()).remove(folder.asString()!);
  //   }
  // }
  //
  // Future<void> clearAllInboxList() async {
  //   final listString = (await SharedPreferences.getInstance()).getString(Folder.inbox.asString()!);
  //   final archiveListString = (await SharedPreferences.getInstance()).getString(Folder.archive.asString()!);
  //   final trashListString = (await SharedPreferences.getInstance()).getString(Folder.trash.asString()!);
  //   final spamListString = (await SharedPreferences.getInstance()).getString(Folder.spam.asString()!);
  //   final sentListString = (await SharedPreferences.getInstance()).getString(Folder.sent.asString()!);
  //   final draftListString = (await SharedPreferences.getInstance()).getString(Folder.drafts.asString()!);
  //   if (listString != null && listString.isNotEmpty) {
  //     (await SharedPreferences.getInstance()).remove(Folder.inbox.asString()!);
  //   }
  //   if (archiveListString != null && archiveListString.isNotEmpty) {
  //     (await SharedPreferences.getInstance()).remove(Folder.archive.asString()!);
  //   }
  //   if (trashListString != null && trashListString.isNotEmpty) {
  //     (await SharedPreferences.getInstance()).remove(Folder.trash.asString()!);
  //   }
  //   if (spamListString != null && spamListString.isNotEmpty) {
  //     (await SharedPreferences.getInstance()).remove(Folder.spam.asString()!);
  //   }
  //   if (sentListString != null && sentListString.isNotEmpty) {
  //     (await SharedPreferences.getInstance()).remove(Folder.sent.asString()!);
  //   }
  //   if (draftListString != null && draftListString.isNotEmpty) {
  //     (await SharedPreferences.getInstance()).remove(Folder.drafts.asString()!);
  //   }
  // }
  //
  // Future<void> saveDraftList(List<DraftMessages> list) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setString(Folder.drafts.asString()!, jsonEncode(list));
  // }
  //
  // Future<List<DraftMessages>> getDraftList() async {
  //   final listString = (await SharedPreferences.getInstance()).getString(Folder.drafts.asString()!);
  //   List list = [];
  //   try {
  //     list = jsonDecode(listString.toString()) ?? [];
  //   } catch (err, stackTrace) {
  //     log("Get Inbox List Error --> $err, \n $stackTrace");
  //     list = [];
  //   }
  //   final listToModel = list.map((e) => DraftMessages.fromJson(e as Map<String, dynamic>)).toList();
  //   return listToModel;
  // }
}
