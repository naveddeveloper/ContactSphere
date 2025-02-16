import 'dart:typed_data';
import 'package:contactsphere/screens/profile_screen.dart';
import 'package:contactsphere/styles/colors.dart';
import 'package:contactsphere/providers/contact_provider.dart';
import 'package:contactsphere/utils/redirect_phone.dart';
import 'package:contactsphere/widgets/custom_toast.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CardTile extends StatefulWidget {
  final Contact contacts;

  const CardTile({Key? key, required this.contacts}) : super(key: key);

  @override
  State<CardTile> createState() => _CardTileState();
}

class _CardTileState extends State<CardTile> {
  Uint8List? avatarPhoto;

  @override
  void initState() {
    super.initState();
    avatarPhoto = (widget.contacts.photo != null && widget.contacts.photo!.isNotEmpty)
        ? widget.contacts.photo
        : null;
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final cardColor = Theme.of(context).cardColor;

    return Padding(
      padding: EdgeInsets.all(2.0.h),
      child: Material(
        color: cardColor,
        borderRadius: BorderRadius.circular(20.r),
        child: InkWell(
          borderRadius: BorderRadius.circular(20.r),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ContactProfile(contact: widget.contacts),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(12.0.h),
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  right: 0,
                  child: _buildFavoriteButton(brightness),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Contact avatar
                    CircleAvatar(
                      radius: 30.r,
                      backgroundImage: avatarPhoto != null
                          ? MemoryImage(avatarPhoto!)
                          : const AssetImage("assets/img/user.jpg"),
                      backgroundColor: cardColor,
                    ),
                    SizedBox(height: 4.h),
                    // Contact name
                    Text(
                      widget.contacts.name.first.isNotEmpty
                          ? widget.contacts.displayName
                          : "Unknown",
                      style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        if (widget.contacts.phones.isNotEmpty)
                          _buildActionIcon(
                            icon: Icons.phone,
                            darkColor: AppColorsDark.iconBackgroundColorPhone,
                            lightColor: AppColorsLight.iconBackgroundColorPhone,
                            onPressed: () {
                              callPhone(widget.contacts.phones.first.number);
                              CustomToast.show(context, "Opening Phone");
                            },
                            brightness: brightness,
                          ),
                        if (widget.contacts.phones.isNotEmpty)
                          _buildActionIcon(
                            icon: Icons.message,
                            darkColor: AppColorsDark.iconBackgroundColorMessage,
                            lightColor: AppColorsLight.iconBackgroundColorMessage,
                            onPressed: () {
                              sendMessage(widget.contacts.phones.first.number);
                              CustomToast.show(context, "Opening Message");
                            },
                            brightness: brightness,
                          ),
                        if (widget.contacts.emails.isNotEmpty)
                          _buildActionIcon(
                            icon: Icons.mail,
                            darkColor: AppColorsDark.iconBackgroundColorMail,
                            lightColor: AppColorsLight.iconBackgroundColorMail,
                            onPressed: () {
                              sendEmail(widget.contacts.emails.first.address);
                              CustomToast.show(context, "Mail is opening");
                            },
                            brightness: brightness,
                          ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Builds the favorite button widget.
  Widget _buildFavoriteButton(Brightness brightness) {
    return Material(
      color: brightness == Brightness.dark
          ? Colors.grey
          : Colors.grey.withOpacity(0.4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20.r),
        onTap: () {
          Provider.of<ContactProvider>(context, listen: false)
              .toggleFavorite(widget.contacts);
        },
        child: Padding(
          padding: EdgeInsets.all(8.0.h),
          child: Icon(
            Icons.star,
            size: 16.sp,
            color:
                brightness == Brightness.dark ? Colors.white : Colors.white24,
          ),
        ),
      ),
    );
  }

  // Builds a generic action icon widget.
  Widget _buildActionIcon({
    required IconData icon,
    required Color darkColor,
    required Color lightColor,
    required VoidCallback onPressed,
    required Brightness brightness,
  }) {
    return Padding(
      padding: EdgeInsets.all(2.h),
      child: Material(
        shape: const CircleBorder(),
        elevation: 2.0.sp,
        color: brightness == Brightness.dark ? darkColor : lightColor,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onPressed,
          child: Padding(
            padding: EdgeInsets.all(10.h),
            child: Icon(
              icon,
              size: 18.sp,
              color: brightness == Brightness.dark ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
