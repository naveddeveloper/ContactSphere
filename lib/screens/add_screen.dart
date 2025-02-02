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

class AddContactScreen extends StatefulWidget {
  const AddContactScreen({super.key});

  @override
  State<AddContactScreen> createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  // Controllers for input fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController companyController = TextEditingController();
  final TextEditingController websiteController = TextEditingController();

  // Controller for photos
  Uint8List? avatarPhoto;

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
    final contactProvider =
        Provider.of<ContactProvider>(context, listen: false);

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
                      "Add Contact",
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
                    InputBar(
                        controller: nameController,
                        labelStr: "Name",
                        inputType: TextInputType.name),
                    InputBar(
                        controller: emailController,
                        labelStr: "Email",
                        inputType: TextInputType.emailAddress),
                    InputBar(
                        controller: phoneController,
                        labelStr: "Phone",
                        inputType: TextInputType.phone),
                    InputBar(
                        controller: addressController,
                        labelStr: "Address",
                        inputType: TextInputType.streetAddress),
                    InputBar(
                        controller: companyController,
                        labelStr: "Company",
                        inputType: TextInputType.text),
                    InputBar(
                        controller: websiteController,
                        labelStr: "Website",
                        inputType: TextInputType.url),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (nameController.text.isEmpty) {
            CustomToast.show(context, "Please enter a name");
            return;
          }

          if (phoneController.text.isEmpty) {
            CustomToast.show(context, "Please enter a phone number");
            return;
          }
          var myContact = Contact(
            name: Name(first: nameController.text),
            emails: [Email(emailController.text)],
            phones: [Phone(phoneController.text)],
            photo: avatarPhoto,
            addresses: [Address(addressController.text)],
            websites: [Website(websiteController.text)],
            organizations: [Organization(company: companyController.text)],
          );

          // Create a new contact
          var isAdded = await contactProvider.addContact(myContact);

          if (isAdded) {
            // ignore: use_build_context_synchronously
            CustomToast.show(context, "Add new contact saved successfully");
            Future.delayed(const Duration(seconds: 2), () {
              Navigator.pushAndRemoveUntil(
                // ignore: use_build_context_synchronously
                context,
                MaterialPageRoute(builder: (context) => const MainScreen()),
                (route) => false,
              );
            });
          } else {
            // ignore: use_build_context_synchronously
            CustomToast.show(context, "Can't add new contact");
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
