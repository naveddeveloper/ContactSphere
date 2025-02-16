import 'package:contactsphere/providers/contact_provider.dart';
import 'package:contactsphere/screens/edit_screen.dart';
import 'package:contactsphere/widgets/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:provider/provider.dart';
import 'package:contactsphere/styles/colors.dart';
import 'package:contactsphere/utils/redirect_phone.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ContactProfile extends StatefulWidget {
  final Contact contact;
  const ContactProfile({super.key, required this.contact});

  @override
  State<ContactProfile> createState() => _ContactProfileState();
}

class _ContactProfileState extends State<ContactProfile> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Brightness brightness = Theme.of(context).brightness;

    return Consumer<ContactProvider>(
      builder: (context, contactProvider, child) {
        bool isFav = contactProvider.isFavorite(widget.contact);

        return Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          appBar: AppBar(
            title: Text(
              widget.contact.name.first.isEmpty
                  ? "Unknown"
                  : widget.contact.displayName,
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
            ),
            centerTitle: true,
            backgroundColor: Theme.of(context).cardColor,
            foregroundColor:
                brightness == Brightness.dark ? Colors.white : Colors.black,
            elevation: 1,
            actions: [
              GestureDetector(
                onTap: () {
                  contactProvider.toggleFavorite(widget.contact);
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20.w),
                  decoration: BoxDecoration(
                    color: isFav
                        ? (brightness == Brightness.dark
                            ? Colors.grey
                            : Colors.grey[800]!.withValues(alpha: 0.4))
                        : null,
                    shape: BoxShape.circle, // Make the button circular
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(8.h),
                    child: Icon(
                      Icons.star,
                      color: isFav
                          ? (brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black)
                          : brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                      size: 20.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(16.0.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Profile Picture
                CircleAvatar(
                  radius: 70.r,
                  backgroundImage: widget.contact.photo != null
                      ? MemoryImage(widget.contact.photo!)
                      : const AssetImage("assets/img/user.jpg")
                          as ImageProvider,
                  backgroundColor: Theme.of(context).cardColor,
                ),
                SizedBox(height: 16.h),

                // Name
                if (widget.contact.name.first.isNotEmpty)
                  Text(
                    widget.contact.name.first.isEmpty
                        ? "Unknown"
                        : widget.contact.displayName,
                    style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w500),
                  ),
                SizedBox(height: 3.h),

                // Company
                widget.contact.organizations.isNotEmpty
                    ? Text(
                        widget.contact.organizations.first.company.isNotEmpty
                            ? widget.contact.organizations.first.company
                            : "",
                        style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500, color: AppColorsLight.notfocusedBar),
                      )
                    : SizedBox(),
                SizedBox(height: 6.h),

                // Phone
                widget.contact.phones.isNotEmpty
                    ? Text(
                        widget.contact.phones.first.number,
                        style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500, color: AppColorsLight.notfocusedBar),
                      )
                    : SizedBox(),
                SizedBox(height: 8.h),

                // Row with icons
                Padding(
                  padding: EdgeInsets.all(12.0.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Call Icon
                      widget.contact.phones.isNotEmpty
                          ? _buildIcon(
                              brightness,
                              Icons.phone,
                              AppColorsDark.iconBackgroundColorPhone,
                              AppColorsLight.iconBackgroundColorPhone,
                              () {
                                if (widget.contact.phones.isNotEmpty) {
                                  callPhone(widget.contact.phones.first.number);
                                  CustomToast.show(context, "Opening Phone");
                                } else {
                                  CustomToast.show(
                                      context, "Your number is empty");
                                }
                              },
                            )
                          : SizedBox(),

                      // Message Icon
                      widget.contact.phones.isNotEmpty
                          ? Padding(
                              padding: EdgeInsets.only(left: 18.0.w),
                              child: _buildIcon(
                                brightness,
                                Icons.message,
                                AppColorsDark.iconBackgroundColorMessage,
                                AppColorsLight.iconBackgroundColorMessage,
                                () {
                                  if (widget.contact.phones.isNotEmpty) {
                                    sendMessage(
                                        widget.contact.phones.first.number);
                                    CustomToast.show(
                                        context, "Opening Message");
                                  } else {
                                    CustomToast.show(
                                        context, "Your number is empty");
                                  }
                                },
                              ),
                            )
                          : SizedBox(),

                      widget.contact.emails.isNotEmpty
                          ? Padding(
                              padding: EdgeInsets.only(left: 18.0.w),
                              child: _buildIcon(
                                brightness,
                                Icons.mail,
                                AppColorsDark.iconBackgroundColorMail,
                                AppColorsLight.iconBackgroundColorMail,
                                () {
                                  if (widget.contact.emails.isNotEmpty) {
                                    sendEmail(
                                        widget.contact.emails.first.address);
                                    CustomToast.show(
                                        context, "Mail is opening");
                                  } else {
                                    CustomToast.show(
                                        context, "Your emails is empty");
                                  }
                                },
                              ),
                            )
                          : SizedBox(),
                    ],
                  ),
                ),

                // Contact Column Bar
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(12.0.r),
                  ),
                  padding: EdgeInsets.all(16.0.h),
                  child: Column(
                    children: [
                      // Emails
                      widget.contact.emails.isNotEmpty
                          ? Container(
                              margin: EdgeInsets.symmetric(vertical: 1.0.h),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.r)),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(10.r),
                                  onTap: () {
                                    if (widget.contact.emails.isNotEmpty) {
                                      sendEmail(
                                          widget.contact.emails.first.address);
                                      CustomToast.show(
                                          context, "Email is opening!");
                                    } else {
                                      CustomToast.show(
                                          context, "Your emails is empty");
                                    }
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0.h),
                                    child: Column(
                                      children: [
                                        _contactInfoRow(
                                            Icons.email,
                                            widget.contact.emails.first.address
                                                    .isEmpty
                                                ? "No Email"
                                                : widget.contact.emails.first
                                                    .address,
                                            "Email"),
                                         const Divider(color: AppColorsLight.notfocusedBar,),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : SizedBox(),

                      // Phones
                      widget.contact.phones.isNotEmpty
                          ? Container(
                              margin: EdgeInsets.symmetric(vertical: 1.0.h),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.r)),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(10.r),
                                  onTap: () {
                                    if (widget.contact.phones.isNotEmpty) {
                                      callPhone(
                                          widget.contact.phones.first.number);
                                      CustomToast.show(
                                          context, "Opening Phone");
                                    } else {
                                      CustomToast.show(context,
                                          "Your phone number is empty");
                                    }
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0.h),
                                    child: Column(
                                      children: [
                                        _contactInfoRow(
                                            Icons.phone,
                                            widget.contact.phones.first.number
                                                    .isEmpty
                                                ? "No Phone"
                                                : widget
                                                        .contact
                                                        .phones
                                                        .first
                                                        .normalizedNumber
                                                        .isNotEmpty
                                                    ? widget.contact.phones
                                                        .first.normalizedNumber
                                                    : widget.contact.phones
                                                        .first.number,
                                            "Phone Number"),
                                        const Divider(color: AppColorsLight.notfocusedBar,),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : SizedBox(),

                      // Company
                      widget.contact.organizations.isNotEmpty
                          ? Container(
                              margin: EdgeInsets.symmetric(vertical: 1.0.h),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.r)),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(10.r),
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0.h),
                                    child: Column(
                                      children: [
                                        _contactInfoRow(
                                            Icons.business,
                                            widget.contact.organizations.first
                                                    .company.isEmpty
                                                ? "No Company"
                                                : widget.contact.organizations
                                                    .first.company,
                                            "Company"),
                                         const Divider(color: AppColorsLight.notfocusedBar,),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : SizedBox(),

                      // Address
                      widget.contact.addresses.isNotEmpty
                          ? Container(
                              margin: EdgeInsets.symmetric(vertical: 1.0.h),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.r)),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(10.r),
                                  onTap: () {
                                    if (widget.contact.addresses.isNotEmpty) {
                                      openInGoogleMaps(widget
                                          .contact.addresses.first.address);
                                      CustomToast.show(context, "Opening Maps");
                                    } else {
                                      CustomToast.show(
                                          context, "Your address is empty");
                                    }
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0.h),
                                    child: Column(
                                      children: [
                                        _contactInfoRow(
                                            Icons.location_on,
                                            widget.contact.addresses.first
                                                    .address.isEmpty
                                                ? "No Address"
                                                : widget.contact.addresses.first
                                                    .address,
                                            "Address"),
                                         const Divider(color: AppColorsLight.notfocusedBar,)
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : SizedBox(),

                      // Websites
                      widget.contact.websites.isNotEmpty
                          ? Container(
                              margin: EdgeInsets.symmetric(vertical: 1.0.h),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.r)),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(10.r),
                                  onTap: () {
                                    if (widget.contact.websites.isNotEmpty) {
                                      openUrlInBrowser(
                                          widget.contact.websites.first.url);
                                      CustomToast.show(
                                          context, "Opening browser...");
                                    } else {
                                      CustomToast.show(
                                          context, "Url is empty.");
                                    }
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0.h),
                                    child: Column(
                                      children: [
                                        _contactInfoRow(
                                            Icons.web,
                                            widget.contact.websites.first.url
                                                    .isEmpty
                                                ? "No Website"
                                                : widget
                                                    .contact.websites.first.url,
                                            "Website"),
                                         const Divider(color: AppColorsLight.notfocusedBar,),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : SizedBox(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => EditContactScreen(
                    contact: widget.contact,
                  ),
                ),
              );
            },
            backgroundColor: brightness == Brightness.dark
                ? AppColorsDark.iconBackgroundColorPhone
                : AppColorsLight.iconBackgroundColorPhone,
            child: Icon(
              Icons.edit,
              size: 35,
              color: brightness == Brightness.dark
                  ? AppColorsDark.iconForegroundColorPhone
                  : AppColorsLight.iconForegroundColorPhone,
            ),
          ),
        );
      },
    );
  }

  Widget _contactInfoRow(IconData icon, String text, String title) {
    return Container(
      alignment: Alignment.bottomLeft,
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Theme.of(context).hintColor, size: 20,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.0.w),
                child: Text(
                  title,
                  style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w300,
                      color: Theme.of(context).hintColor),
                ),
              ),
            ],
          ),
          SizedBox(width: 12.w),
          Text(
            text,
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
          // ),
        ],
      ),
    );
  }

  Widget _buildIcon(Brightness brightness, IconData icon, Color darkColor,
      Color lightColor, VoidCallback callback) {
    return Padding(
      padding: EdgeInsets.all(2.0.h),
      child: RawMaterialButton(
        onPressed: callback,
        elevation: 2.0,
        fillColor: brightness == Brightness.dark ? darkColor : lightColor,
        constraints: const BoxConstraints(minWidth: 0),
        padding: EdgeInsets.all(10.0.h),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: const CircleBorder(),
        child: Icon(
          icon,
          color: brightness == Brightness.dark ? Colors.white : Colors.black,
          size: 24,
        ),
      ),
    );
  }
}
