import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContactProvider extends ChangeNotifier {
  List<Contact> _contactsList = [];
  List<Contact> _favoritesList = [];
  bool _isLoading = false;
  bool _isSortedAZ = true;

  ContactProvider() {
    debugPrint("ContactProvider initialized");
    initializeApp();
  }

  Future<void> initializeApp() async {
    await _loadFavoritesFromPrefs();
    await _loadContactsFromService();
    sortContacts(true);
  }

  List<Contact> get contactsList => _contactsList;
  List<Contact> get favoritesList => _favoritesList;
  bool get isLoading => _isLoading;
  bool get isSortedAZ => _isSortedAZ;

  void sortContacts(bool ascending) {
    _contactsList.sort((a, b) => ascending
        ? a.displayName.compareTo(b.displayName)
        : b.displayName.compareTo(a.displayName));
    _favoritesList.sort((a, b) => ascending
        ? a.displayName.compareTo(b.displayName)
        : b.displayName.compareTo(a.displayName));
    _isSortedAZ = ascending;
    notifyListeners();
  }

  Future<void> _loadFavoritesFromPrefs() async {
    try {
      _isLoading = true;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? jsonString = prefs.getString('favoritesContactSaved');
      if (jsonString != null) {
        List<dynamic> decodedJson = jsonDecode(jsonString);
        _favoritesList = decodedJson.map((contactJson) {
          var contactMap = Map<String, dynamic>.from(contactJson);
          if (contactMap['photo'] is String) {
            contactMap['photo'] = base64Decode(contactMap['photo']);
          }
          if (contactMap['thumbnail'] is String) {
            contactMap['thumbnail'] = base64Decode(contactMap['thumbnail']);
          }
          return Contact.fromJson(contactMap);
        }).toList();
      }
    } catch (e) {
      debugPrint("Error loading favorites: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadContactsFromService() async {
    try {
      _isLoading = true;
      if (await _checkContactPermission()) {
        _contactsList = await FlutterContacts.getContacts(
            withProperties: true, withPhoto: true);
      }
    } catch (e) {
      debugPrint("Error loading contacts: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> _checkContactPermission() async {
    PermissionStatus status = await Permission.contacts.request();
    if (status.isGranted) return true;
    if (status.isDenied || status.isPermanentlyDenied) {
      openAppSettings();
    }
    return false;
  }

  Future<bool> addContact(Contact contact) async {
    try {
      if (!_contactsList.any((c) => c.id == contact.id)) {
        await FlutterContacts.insertContact(contact);
        await _loadContactsFromService();
        return true;
      }
    } catch (e) {
      debugPrint("Error adding contact: $e");
    }
    return false;
  }

  Future<bool> updateContact(Contact contact) async {
    try {
      int index = _contactsList.indexWhere((c) => c.id == contact.id);
      if (index != -1) {
        await FlutterContacts.updateContact(contact);
        _contactsList[index] = contact;
        int favIndex = _favoritesList.indexWhere((c) => c.id == contact.id);
        if (favIndex != -1) {
          _favoritesList[favIndex] = contact;
          await _saveFavoritesToPrefs();
        }
        notifyListeners();
        return true;
      }
    } catch (e) {
      debugPrint("Error updating contact: $e");
    }
    return false;
  }

  Future<bool> removeContact(Contact contact) async {
    try {
      _contactsList.removeWhere((c) => c.id == contact.id);
      _favoritesList.removeWhere((c) => c.id == contact.id);
      await FlutterContacts.deleteContact(contact);
      await _saveFavoritesToPrefs();
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint("Error removing contact: $e");
    }
    return false;
  }

  Future<bool> removeAllContacts() async {
    try {
      _isLoading = true;
      List<Contact> allContacts = await FlutterContacts.getContacts();
      await FlutterContacts.deleteContacts(allContacts);
      _contactsList.clear();
      _favoritesList.clear();
      await _saveFavoritesToPrefs();
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint("Error removing all contacts: $e");
    }
    return false;
  }

  bool isFavorite(Contact contact) {
    return _favoritesList.any((c) => c.id == contact.id);
  }

  Future<void> toggleFavorite(Contact contact) async {
    try {
      if (isFavorite(contact)) {
        _favoritesList.removeWhere((c) => c.id == contact.id);
      } else {
        _favoritesList.add(contact);
      }
      await _saveFavoritesToPrefs();
      notifyListeners();
    } catch (e) {
      debugPrint("Error toggling favorite: $e");
    }
  }

  Future<void> _saveFavoritesToPrefs() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String jsonString = jsonEncode(
        _favoritesList.map((contact) {
          var jsonData = contact.toJson();
          if (jsonData['photo'] is Uint8List) {
            jsonData['photo'] = base64Encode(jsonData['photo']);
          }
          if (jsonData['thumbnail'] is Uint8List) {
            jsonData['thumbnail'] = base64Encode(jsonData['thumbnail']);
          }
          return jsonData;
        }).toList(),
      );
      await prefs.setString('favoritesContactSaved', jsonString);
    } catch (e) {
      debugPrint("Error saving favorites: $e");
    }
  }
}
