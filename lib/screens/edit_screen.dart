import 'dart:typed_data';
import 'package:contactsphere/main.dart';
import 'package:contactsphere/providers/contact_provider.dart';
import 'package:contactsphere/widgets/custom_toast.dart';
import 'package:contactsphere/widgets/input_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:image/image.dart' as img;
import 'package:contactsphere/styles/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditContactScreen extends StatefulWidget {
  final Contact contact;

  const EditContactScreen({super.key, required this.contact});

  @override
  State<EditContactScreen> createState() => _EditContactScreenState();
}

class _EditContactScreenState extends State<EditContactScreen> {
  // Controllers for input fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController companyController = TextEditingController();
  final TextEditingController websiteController = TextEditingController();

  Uint8List? avatarPhoto;

  @override
  void initState() {
    super.initState();

    // Prepopulate the input fields with existing contact details
    nameController.text =
        widget.contact.name.first.isEmpty ? "" : widget.contact.displayName;

    // Safely access the first email
    if (widget.contact.emails.isNotEmpty &&
        widget.contact.emails.first.address.isNotEmpty) {
      emailController.text = widget.contact.emails.first.address;
    } else {
      emailController.text = '';
    }

    // Safely access the first phone
    if (widget.contact.phones.isNotEmpty &&
        widget.contact.phones.first.number.isNotEmpty) {
      phoneController.text = widget.contact.phones.first.number;
    } else {
      phoneController.text = '';
    }

    // Safely access the first postal address
    if (widget.contact.addresses.isNotEmpty &&
        widget.contact.addresses.first.address.isNotEmpty) {
      addressController.text = widget.contact.addresses.first.address;
    } else {
      addressController.text = '';
    }

    if (widget.contact.organizations.isNotEmpty &&
        widget.contact.organizations.first.company.isNotEmpty) {
      companyController.text = widget.contact.organizations.first.company;
    } else {
      companyController.text = "";
    }

    if (widget.contact.websites.isNotEmpty &&
        widget.contact.websites.first.url.isNotEmpty) {
      websiteController.text = widget.contact.websites.first.url;
    } else {
      websiteController.text = "";
    }

    if (widget.contact.photo != null && widget.contact.photo!.isNotEmpty) {
      avatarPhoto = widget.contact.photo;
    } else {
      avatarPhoto = null;
    }
  }

  // Method to pick an avatar photo from the gallery
  Future<void> pickAvatarPhoto() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final decodedImage = img.decodeImage(await image.readAsBytes());
      final compressedImage = img.encodeJpg(decodedImage!, quality: 50);
      setState(() {
        avatarPhoto = Uint8List.fromList(compressedImage);
      });
    } else {
      CustomToast.show(
          // ignore: use_build_context_synchronously
          context,
          "Can't get the image from the gallery, please try again!");
    }
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final contactProvider = Provider.of<ContactProvider>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Bar
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.arrow_back,
                        size: 30.sp,
                        color: brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                    Text(
                      "Edit Contact",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ],
                ),
                SizedBox(height: 20.h),

                // Profile Picture
                Center(
                  child: GestureDetector(
                    onTap: pickAvatarPhoto,
                    child: CircleAvatar(
                      radius: 50.r,
                      backgroundImage: avatarPhoto != null
                          ? MemoryImage(avatarPhoto!)
                          : const AssetImage("assets/img/user.jpg")
                              as ImageProvider,
                      backgroundColor: Theme.of(context).cardColor,
                      child: avatarPhoto == null
                          ? Icon(Icons.add_a_photo, size: 30.sp)
                          : null,
                    ),
                  ),
                ),
                SizedBox(height: 20.h),

                // Input Fields
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name Controller
                    InputBar(
                      controller: nameController,
                      labelStr: "Name",
                      inputType: TextInputType.name,
                    ),

                    // Email Controller
                    InputBar(
                      controller: emailController,
                      labelStr: "Email",
                      inputType: TextInputType.emailAddress,
                    ),

                    // Phone Controller
                    InputBar(
                      controller: phoneController,
                      labelStr: "Phone",
                      inputType: TextInputType.phone,
                    ),

                    // Address Controller
                    InputBar(
                      controller: addressController,
                      labelStr: "Address",
                      inputType: TextInputType.streetAddress,
                    ),

                    // Company Controller
                    InputBar(
                      controller: companyController,
                      labelStr: "Company",
                      inputType: TextInputType.text,
                    ),

                    // Website Controller
                    InputBar(
                      controller: websiteController,
                      labelStr: "Website",
                      inputType: TextInputType.text,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Create a new contact object with updated information
          var contact = await FlutterContacts.getContact(widget.contact.id,
              withAccounts: true, withPhoto: true);
          if (contact != null) {
            contact.displayName = nameController.text;
            contact.emails = [Email(emailController.text)];
            contact.phones = [Phone(phoneController.text)];
            contact.photo = avatarPhoto;
            contact.addresses = [Address(addressController.text)];
            contact.websites = [Website(websiteController.text)];
            contact.organizations = [
              Organization(company: companyController.text)
            ];

            var isUpdated = await contactProvider.updateContact(contact);
            if (isUpdated) {
              // ignore: use_build_context_synchronously
              CustomToast.show(context, "Updated Contact Successfully!");
              Future.delayed(const Duration(seconds: 3), () {
                // ignore: use_build_context_synchronously
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const MainScreen()),
                    (route) => false);
              });
            } else {
              // ignore: use_build_context_synchronously
              CustomToast.show(context, "Can't update contact");
            }
          } else {
            // ignore: use_build_context_synchronously
            CustomToast.show(context, "Can't update contact");
          }
        },
        backgroundColor: brightness == Brightness.dark
            ? AppColorsDark.iconBackgroundColorPhone
            : AppColorsLight.iconBackgroundColorPhone,
        child: Icon(
          Icons.save_as,
          size: 30.sp,
          color: brightness == Brightness.dark
              ? AppColorsDark.iconForegroundColorPhone
              : AppColorsLight.iconForegroundColorPhone,
        ),
      ),
    );
  }
}
