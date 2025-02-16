import 'package:contactsphere/screens/add_screen.dart';
import 'package:contactsphere/styles/colors.dart';
import 'package:contactsphere/providers/contact_provider.dart';
import 'package:contactsphere/widgets/contact_bar.dart';
import 'package:contactsphere/widgets/search_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  List<Contact> filteredItems = [];
  bool searchActive = false;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      _filterContacts(searchController.text);
    });
  }

  // Filter contacts based on search query
  void _filterContacts(String query) {
    var contactList =
        Provider.of<ContactProvider>(context, listen: false).contactsList;

    if (query.isEmpty) {
      setState(() {
        searchActive = false;
        filteredItems = contactList;
      });
    } else {
      setState(() {
        searchActive = true;
      });
      List<Contact> filtered = contactList.where((contact) {
        String name = contact.displayName.toLowerCase();
        return name.contains(query.toLowerCase());
      }).toList();

      setState(() {
        filteredItems = filtered;
      });
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return Consumer<ContactProvider>(builder: (context, value, child) {
      if (value.isLoading) {
        return Scaffold(
            body: Center(
          child: CircularProgressIndicator(),
        ));
      }
      return Scaffold(
        appBar: AppBar(title: SearchAppBar(textController: searchController)),
        body: searchActive
            ? ListView.builder(
                key: Key(filteredItems.length.toString()),
                itemCount: filteredItems.length,
                itemBuilder: (context, index) {
                  Contact contact = filteredItems[index];
                  return ContactBar(
                    contacts: contact,
                  );
                },
              )
            : SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: Column(
                    children: [
                      Expanded(child: _buildContactList(value.contactsList)),
                    ],
                  ),
                ),
              ),
        floatingActionButton: _buildFloatingActionButton(brightness),
      );
    });
  }

  Widget _buildContactList(List<Contact> contactList) {
    return contactList.isEmpty
        ? Center(
            child: Text(
              "No contacts available",
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500),
            ),
          )
        : SizedBox(
            child: ListView.builder(
              itemCount: contactList.length,
              itemBuilder: (context, index) {
                final contact = contactList[index];
                return ContactBar(
                  contacts: contact,
                );
              },
            ),
          );
  }

  Widget _buildFloatingActionButton(Brightness brightness) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const AddContactScreen()),
        );
      },
      child: Icon(
        Icons.add,
        size: 30.sp,
        color: brightness == Brightness.dark
            ? AppColorsDark.iconForegroundColorPhone
            : AppColorsLight.iconForegroundColorPhone,
      ),
    );
  }
}
