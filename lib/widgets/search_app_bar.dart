import 'package:contactsphere/providers/contact_provider.dart';
import 'package:contactsphere/providers/theme_provider.dart';
import 'package:contactsphere/widgets/custom_toast.dart';
import 'package:contactsphere/widgets/dialog_box.dart';
import 'package:contactsphere/widgets/dialog_dev.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchAppBar extends StatefulWidget {
  final TextEditingController textController;

  const SearchAppBar({
    super.key,
    required this.textController,
  });

  @override
  State<SearchAppBar> createState() => _SearchAppBarState();
}

class _SearchAppBarState extends State<SearchAppBar> {
  @override
  Widget build(BuildContext context) {
    var brightness = Theme.of(context).brightness;
    var themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 60.h),
      child: Row(
        children: [
          // Search Bar
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              child: Container(
                alignment: Alignment.center,
                height: 50.h,
                child: TextField(
                  controller: widget.textController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search,
                        size: 24, color: Theme.of(context).hintColor),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.clear,
                          size: 16, color: Theme.of(context).hintColor),
                      onPressed: widget.textController.clear,
                    ),
                    hintText: "Search...",
                    hintStyle: TextStyle(color: Theme.of(context).hintColor),
                    filled: true,
                    fillColor: Theme.of(context).cardColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
                  ),
                  style: TextStyle(color: Theme.of(context).hintColor, fontSize: 16.sp),
                ),
              ),
            ),
          ),
          SizedBox(width: 8.w),

          // Theme Toggle Button
          _buildCircleButton(
            icon: brightness == Brightness.dark
                ? Icons.dark_mode
                : Icons.light_mode,
            onPressed: themeProvider.toggleTheme,
          ),
          SizedBox(width: 5.w),

          //  Menu Button
          _buildCircleButton(
            icon: Icons.menu,
            onPressed: () => _showMainMenu(context),
          ),
        ],
      ),
    );
  }

  ///  Helper Function: Circle Icon Button
  Widget _buildCircleButton(
      {required IconData icon, required VoidCallback onPressed}) {
    return Ink(
      decoration: ShapeDecoration(
        color: Theme.of(context).cardColor,
        shape: const CircleBorder(),
      ),
      child: IconButton(
        icon: Icon(icon, size: 24),
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.white
            : Colors.black,
        onPressed: onPressed,
      ),
    );
  }

  //  Main Menu Popup
  void _showMainMenu(BuildContext context) async {
    final selectedValue = await showMenu<int>(
      context: context,
      position: RelativeRect.fromLTRB(
        MediaQuery.of(context).size.width - 150,
        kToolbarHeight + 40,
        0,
        0,
      ),
      items: [
        PopupMenuItem<int>(
            value: 1,
            child: _buildMenuItem("Sort By", Icons.arrow_forward_ios)),
        PopupMenuItem<int>(value: 2, child: Text("Delete All Contacts", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500))),
        PopupMenuItem<int>(value: 3, child: Text("About Developer", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500))),
      ],
    );

    switch (selectedValue) {
      case 1:
        // ignore: use_build_context_synchronously
        _showSortMenu(context);
        break;
      case 2:
        // ignore: use_build_context_synchronously
        showPopupDialog(context, "All Contacts Delected",
            "Are you sure all contacts has been deleted", () {
          Navigator.pop(context);
        }, () {
          Provider.of<ContactProvider>(context, listen: false).removeAllContacts();
          Navigator.pop(context);
          CustomToast.show(context, "All Deleted Successfully!");
        });
        break;
      case 3:
        // ignore: use_build_context_synchronously
        showAppAndDeveloperInfoDialog(context);
        break;
    }
  }

  // Sort Menu Popup
  void _showSortMenu(BuildContext context) async {
    var contactProvider = Provider.of<ContactProvider>(context, listen: false);

    final selectedValue = await showMenu<int>(
      context: context,
      position: RelativeRect.fromLTRB(
        MediaQuery.of(context).size.width - 150,
        kToolbarHeight + 40,
        0,
        0,
      ),
      items: [
        PopupMenuItem<int>(
          value: 1,
          child: _buildSortItem("A-Z", contactProvider.isSortedAZ),
        ),
        PopupMenuItem<int>(
          value: 2,
          child: _buildSortItem("Z-A", !contactProvider.isSortedAZ),
        ),
      ],
    );

    if (selectedValue == 1) {
      contactProvider.sortContacts(true); // Sort A to Z
    } else if (selectedValue == 2) {
      contactProvider.sortContacts(false); // Sort Z to A
    }
  }

  // Helper Function: Menu Item Row
  Widget _buildMenuItem(String text, IconData? icon) {
    return Row(
      children: [
        Text(text, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500)),
        if (icon != null) Icon(icon, size: 20),
      ],
    );
  }

  // Helper Function: Sort Item with Check Icon
  Widget _buildSortItem(String text, bool isSelected) {
    return Row(
      children: [
        isSelected ? Icon(Icons.check, size: 20) : SizedBox(width: 20.w),
        SizedBox(width: 8.w),
        Text(text, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500)),
      ],
    );
  }
}
