import 'dart:typed_data';
import 'package:contactsphere/providers/contact_provider.dart';
import 'package:contactsphere/screens/profile_screen.dart';
import 'package:contactsphere/styles/colors.dart';
import 'package:contactsphere/utils/redirect_phone.dart';
import 'package:contactsphere/widgets/custom_toast.dart';
import 'package:contactsphere/widgets/dialog_box.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ContactBar extends StatefulWidget {
  final Contact contacts;

  const ContactBar({
    super.key,
    required this.contacts,
  });

  @override
  State<ContactBar> createState() => _ContactBarState();
}

class _ContactBarState extends State<ContactBar> {
  Uint8List? avatarPhoto;

  @override
  void initState() {
    super.initState();
    if (widget.contacts.photo != null && widget.contacts.photo!.isNotEmpty) {
      setState(() {
        avatarPhoto = widget.contacts.photo;
      });
    } else {
      avatarPhoto = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Brightness brightness = Theme.of(context).brightness;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Dismissible(
        key: UniqueKey(), // Unique key for the dismissible widget
        direction: DismissDirection.endToStart, // Swipe left to right
        onDismissed: (direction) {
          showPopupDialog(context, "Delete Contact",
              "Are you sure you want to delete this contact", () {
            Navigator.pop(context);
          }, () {
            Provider.of<ContactProvider>(context, listen: false)
                .removeContact(widget.contacts);
            Navigator.pop(context);
            CustomToast.show(context,
                '${widget.contacts.name.first.isNotEmpty ? widget.contacts.displayName : "Unknown"} deleted!');
          });
        },
        background: Container(
          alignment: Alignment.centerRight,
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: const Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
        child: RawMaterialButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ContactProfile(
                    contact: widget.contacts), // Navigate to profile
              ),
            );
          },
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
          fillColor: Theme.of(context).cardColor,
          splashColor: brightness == Brightness.dark
              ? const Color.fromARGB(255, 92, 91, 94)
              : const Color.fromARGB(255, 197, 196, 198),
          child: Padding(
            padding: EdgeInsets.all(8.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30.r,
                      backgroundImage: avatarPhoto != null
                          ? MemoryImage(avatarPhoto!)
                          : const AssetImage("assets/img/user.jpg")
                              as ImageProvider,
                      backgroundColor: Theme.of(context).cardColor,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6.w),
                      child: widget.contacts.name.first.isNotEmpty
                          ? Text(
                              widget.contacts.displayName,
                              style: Theme.of(context).textTheme.bodyMedium,
                            )
                          : Text(
                              "Unknown",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    if (widget.contacts.phones.isNotEmpty)
                      _buildIcon(
                        brightness,
                        Icons.phone,
                        AppColorsDark.iconBackgroundColorPhone,
                        AppColorsLight.iconBackgroundColorPhone,
                        () {
                          if (widget.contacts.phones.isNotEmpty) {
                            callPhone(widget.contacts.phones.first.number);
                            CustomToast.show(context, "Opening Phone");
                          } else {
                            CustomToast.show(context, "Your number is empty");
                          }
                        },
                      ),
                    if (widget.contacts.phones.isNotEmpty)
                      _buildIcon(
                        brightness,
                        Icons.message,
                        AppColorsDark.iconBackgroundColorMessage,
                        AppColorsLight.iconBackgroundColorMessage,
                        () {
                          if (widget.contacts.phones.isNotEmpty) {
                            sendMessage(widget.contacts.phones.first.number);
                            CustomToast.show(context, "Opening Message");
                          } else {
                            CustomToast.show(context, "Your number is empty");
                          }
                        },
                      ),
                    if (widget.contacts.emails.isNotEmpty)
                      _buildIcon(
                        brightness,
                        Icons.mail,
                        AppColorsDark.iconBackgroundColorMail,
                        AppColorsLight.iconBackgroundColorMail,
                        () {
                          if (widget.contacts.emails.isNotEmpty) {
                            sendEmail(widget.contacts.emails.first.address);
                            CustomToast.show(context, "Mail is opening");
                          } else {
                            CustomToast.show(context, "Your emails is empty");
                          }
                        },
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

  Widget _buildIcon(Brightness brightness, IconData icon, Color darkColor,
      Color lightColor, VoidCallback callback) {
    return Padding(
      padding: EdgeInsets.all(2.h),
      child: RawMaterialButton(
        onPressed: callback,
        elevation: 2.0.sp,
        fillColor: brightness == Brightness.dark ? darkColor : lightColor,
        constraints: const BoxConstraints(minWidth: 0),
        padding: EdgeInsets.all(10.h),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: const CircleBorder(),
        child: Icon(
          icon,
          color: brightness == Brightness.dark ? Colors.white : Colors.black,
          size: 18.sp,
        ),
      ),
    );
  }
}
