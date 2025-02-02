import 'package:contactsphere/screens/add_screen.dart';
import 'package:contactsphere/widgets/contact_bar.dart';
import 'package:contactsphere/widgets/contact_tile.dart';
import 'package:contactsphere/widgets/search_app_bar.dart';
import 'package:contactsphere/providers/contact_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:provider/provider.dart';
import 'package:contactsphere/styles/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  List<Contact> filteredItems = [];
  bool searchActive = false;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    debugPrint("State Initialization FavoriteScreen");

    searchController.addListener(() {
      _filterContacts(searchController.text);
    });
  }

  // Filter contacts based on search query
  void _filterContacts(String query) {
    var favList =
        Provider.of<ContactProvider>(context, listen: false).favoritesList;

    if (query.isEmpty) {
      setState(() {
        searchActive = false;
        filteredItems = favList;
      });
    } else {
      setState(() {
        searchActive = true;
      });
      List<Contact> filtered = favList.where((contact) {
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

    return Consumer<ContactProvider>(
        builder: (context, contactProvider, child) {
      if (contactProvider.isLoading) {
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }

      return Scaffold(
        appBar: AppBar(
            title: SearchAppBar(
          textController: searchController,
        )),

        // If the searchActive then show the items and did not searchactive then show my contact list
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
                  padding: EdgeInsets.symmetric(horizontal: 12.0.w),
                  child: Column(
                    children: [
                      _buildInformationContact(
                          contactProvider.favoritesList, brightness),
                      Expanded(
                        child: _showFavContact(contactProvider.favoritesList),
                      ),
                    ],
                  ),
                ),
              ),
        floatingActionButton: _buildFloatingActionButton(brightness),
      );
    });
  }

  // Show the length of the favorites contact list
  Widget _buildInformationContact(
      List<Contact> favoritesList, Brightness brightness) {
    return Padding(
      padding: EdgeInsets.all(8.0.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              Text("Favorites Contacts",
                  style: Theme.of(context).textTheme.headlineMedium),
              Text(
                '${favoritesList.length} Contacts',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ],
          )
        ],
      ),
    );
  }

  // Show the favorites contact list
  Widget _showFavContact(List<Contact> favoritesList) {
    return favoritesList.isEmpty
        ? Center(
            child: Text("No contacts available",
                style: Theme.of(context).textTheme.bodyLarge),
          )
        : SizedBox(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                  childAspectRatio: 1),
              itemCount: favoritesList.length,
              itemBuilder: (context, index) {
                final contact = favoritesList[index];
                return CardTile(
                  contacts: contact,
                );
              },
            ),
          );
  }

  // FloatingActionBar
  Widget _buildFloatingActionButton(Brightness brightness) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const AddContactScreen()),
        );
      },
      child: Icon(
        Icons.add,
        size: 30,
        color: brightness == Brightness.dark
            ? AppColorsDark.iconForegroundColorPhone
            : AppColorsLight.iconForegroundColorPhone,
      ),
    );
  }
}
