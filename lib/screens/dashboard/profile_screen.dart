import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:online_college/consts/user_shared_preferences.dart';
import 'package:online_college/consts/utils.dart';
import 'package:online_college/providers/student_data_firestore_provider.dart';
import 'package:online_college/providers/teacher_data_firestore_provider.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final adharNoController = TextEditingController();
  final dateOfBirthController = TextEditingController();
  final addressController = TextEditingController();
  final qualificationController = TextEditingController();
  final emailController = TextEditingController();
  final motherNameController = TextEditingController();
  final fatherNameController = TextEditingController();

  String adharNo = '';
  String dateOfBirth = '';
  String address = '';
  String qualification = '';
  String email = '';
  String motherName = '';
  String fatherName = '';
  String url = '';

  DateTime dateTime = DateTime.now();
  String userUrl = '';

  @override
  void initState() {
    adharNoController.text = UserSharedPreferences.adhar;
    dateOfBirthController.text = UserSharedPreferences.dateOfBirth;
    addressController.text = UserSharedPreferences.address;
    qualificationController.text = UserSharedPreferences.qualification;
    emailController.text = UserSharedPreferences.email;
    motherNameController.text = UserSharedPreferences.motherName;
    fatherNameController.text = UserSharedPreferences.fatherName;
    userUrl = UserSharedPreferences.photoUrl;

    adharNo = adharNoController.text;
    dateOfBirth = dateOfBirthController.text;
    address = addressController.text;
    qualification = qualificationController.text;
    email = emailController.text;
    motherName = motherNameController.text;
    fatherName = fatherNameController.text;
    url = userUrl;

    dateTime = dateOfBirthController.text.isEmpty
        ? DateTime.now()
        : DateFormat('dd MMM yyyy').parse(dateOfBirthController.text);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer2<TeacherDataFireStoreProvider, StudentDataFireStoreProvider>(
        builder: (context, fireStoreTeacher, fireStoreStudent, _) => CustomScrollView(
          slivers: [
            SliverAppBar(
              foregroundColor: Colors.white,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerRight,
                      end: Alignment.centerLeft,
                      colors: [Color(0xFF2855AE), Color(0xFF7292CF)],
                    ),
                  ),
                  child: Image.asset('assets/images/background.png'),
                ),
              ),
              bottom: PreferredSize(
                preferredSize: Size(MediaQuery.of(context).size.width, 40),
                child: Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(40), topLeft: Radius.circular(40)),
                    color: Colors.white,
                  ),
                ),
              ),
              title: Text(
                'My Profile',
                style: GoogleFonts.rubik(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                ),
              ),
              actions: [
                GestureDetector(
                  onTap: () {
                    if (UserSharedPreferences.role == 'student') {
                      if (adharNoController.text != '' && adharNoController.text != adharNo) {
                        UserSharedPreferences.setString(
                            title: 'adhar', data: adharNoController.text);
                        fireStoreStudent.updateStudentAdhar(
                            context: context,
                            adhar: adharNoController.text.trim(),
                            id: UserSharedPreferences.id);
                      }

                      if (emailController.text != '' && emailController.text != email) {
                        UserSharedPreferences.setString(title: 'email', data: emailController.text);
                        fireStoreStudent.updateStudentEmail(
                            context: context,
                            email: emailController.text.trim(),
                            id: UserSharedPreferences.id);
                      }

                      if (dateOfBirthController.text != '' &&
                          dateOfBirthController.text != dateOfBirth) {
                        UserSharedPreferences.setString(
                            title: 'dateOfBirth', data: dateOfBirthController.text);
                        fireStoreStudent.updateStudentDateOfBirth(
                            context: context,
                            dateOfBirth: dateOfBirthController.text.trim(),
                            id: UserSharedPreferences.id);
                      }

                      if (addressController.text != '' && addressController.text != address) {
                        UserSharedPreferences.setString(
                            title: 'address', data: addressController.text);
                        fireStoreStudent.updateStudentAddress(
                            context: context,
                            address: addressController.text,
                            id: UserSharedPreferences.id);
                      }

                      if (userUrl != '' && userUrl != url) {
                        UserSharedPreferences.setString(
                            title: 'photoUrl', data: userUrl.toString());
                        fireStoreStudent.updateStudentPhotoUrl(
                            context: context,
                            photoUrl: userUrl.trim(),
                            id: UserSharedPreferences.id);
                      }

                      if (motherNameController.text != '' &&
                          motherNameController.text != motherName) {
                        UserSharedPreferences.setString(
                            title: 'motherName', data: motherNameController.text);
                        fireStoreStudent.updateStudentMotherName(
                            context: context,
                            motherName: motherNameController.text.trim(),
                            id: UserSharedPreferences.id);
                      }

                      if (fatherNameController.text != '' &&
                          fatherNameController.text != fatherName) {
                        UserSharedPreferences.setString(
                            title: 'fatherName', data: fatherNameController.text);
                        fireStoreStudent.updateStudentFatherName(
                            context: context,
                            fatherName: fatherNameController.text.trim(),
                            id: UserSharedPreferences.id);
                      }
                    } else if (UserSharedPreferences.role == 'teacher') {
                      if (adharNoController.text != '' && adharNoController.text != adharNo) {
                        UserSharedPreferences.setString(
                            title: 'adhar', data: adharNoController.text);
                        fireStoreTeacher.updateTeacherAdhar(
                            context: context,
                            adhar: adharNoController.text.trim(),
                            id: UserSharedPreferences.id);
                      }

                      if (emailController.text != '' && emailController.text != email) {
                        UserSharedPreferences.setString(title: 'email', data: emailController.text);
                        fireStoreTeacher.updateTeacherEmail(
                            context: context,
                            email: emailController.text.trim(),
                            id: UserSharedPreferences.id);
                      }

                      if (dateOfBirthController.text != '' &&
                          dateOfBirthController.text != dateOfBirth) {
                        UserSharedPreferences.setString(
                            title: 'dateOfBirth', data: dateOfBirthController.text);
                        fireStoreTeacher.updateTeacherDateOfBirth(
                            context: context,
                            dateOfBirth: dateOfBirthController.text.trim(),
                            id: UserSharedPreferences.id);
                      }

                      if (qualificationController.text != '' &&
                          qualificationController.text != qualification) {
                        UserSharedPreferences.setString(
                            title: 'qualification', data: qualificationController.text);
                        fireStoreTeacher.updateTeacherQualification(
                            context: context,
                            qualification: qualificationController.text,
                            id: UserSharedPreferences.id);
                      }

                      if (addressController.text != '' && addressController.text != address) {
                        UserSharedPreferences.setString(
                            title: 'address', data: addressController.text);
                        fireStoreTeacher.updateTeacherAddress(
                            context: context,
                            address: addressController.text,
                            id: UserSharedPreferences.id);
                      }

                      if (userUrl != '' && userUrl != url) {
                        UserSharedPreferences.setString(
                            title: 'photoUrl', data: userUrl.toString());
                        fireStoreTeacher.updateTeacherPhotoUrl(
                            context: context,
                            photoUrl: userUrl.trim(),
                            id: UserSharedPreferences.id);
                      }
                    }
                  },
                  child: Container(
                    height: 30,
                    width: 90,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(
                          Icons.check_outlined,
                          color: Color(0xFF6688CA),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          'Done',
                          style: GoogleFonts.rubik(
                            color: const Color(0xFF6688CA),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Container(
                      height: 100,
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFF6688CA),
                          width: 2,
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 75,
                            width: 75,
                            decoration: BoxDecoration(
                              color: const Color(0xFF6688CA).withOpacity(0.7),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: const Color(0xFF6688CA), width: 2),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Hero(
                                tag: 'profilePhoto',
                                child: Image.network(
                                  userUrl,
                                  fit: BoxFit.fitHeight,
                                  errorBuilder:
                                      (BuildContext context, Object error, StackTrace? stackTrace) {
                                    return Image.asset('assets/images/student.png');
                                  },
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  UserSharedPreferences.name,
                                  style: GoogleFonts.rubik(
                                    color: Colors.black87,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  UserSharedPreferences.role == 'student'
                                      ? '${UserSharedPreferences.year} | Roll no: ${UserSharedPreferences.rollNo}'
                                      : '',
                                  style: GoogleFonts.rubik(
                                    color: Colors.black54,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                            onTap: () async {
                              final result = await FilePicker.platform.pickFiles();

                              if (result != null) {
                                PlatformFile pickedFile = result.files.first;

                                if (!context.mounted) return;
                                await fireStoreTeacher.uploadProfilePhoto(
                                    context: context, pickedFile: pickedFile);

                                setState(() {
                                  userUrl = fireStoreTeacher.photoUrl ?? '';
                                });
                              }
                            },
                            child: const Icon(
                              Icons.camera_alt_outlined,
                              color: Colors.black54,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 160,
                          child: TextFormField(
                            controller: adharNoController,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(12),
                            ],
                            validator: (value) {
                              if (value?.length != 12) {
                                return 'Adhar no must have 12 digits';
                              }

                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: 'Adhar No',
                              labelStyle: GoogleFonts.rubik(
                                color: Colors.black54,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                              hintText: 'xxxx xxxx xxxx',
                              hintStyle: GoogleFonts.rubik(
                                color: Colors.black54,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            style: GoogleFonts.rubik(
                              color: const Color(0xFF323643),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 160,
                          child: TextFormField(
                            controller: dateOfBirthController,
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: 'Date of Birth',
                              labelStyle: GoogleFonts.rubik(
                                color: Colors.black54,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            style: GoogleFonts.rubik(
                              color: const Color(0xFF323643),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: dateTime,
                                firstDate: DateTime(1950),
                                lastDate: DateTime.now(),
                                helpText: 'Select the date: ',
                                builder: (BuildContext context, Widget? child) {
                                  return Theme(
                                    data: ThemeData.light().copyWith(
                                        colorScheme: const ColorScheme(
                                          brightness: Brightness.light,
                                          primary: Color(0xFF6688CA),
                                          onPrimary: Colors.white,
                                          secondary: Color(0xFF6688CA),
                                          onSecondary: Colors.white,
                                          error: Color(0xFF6688CA),
                                          onError: Colors.white,
                                          background: Colors.white,
                                          onBackground: Color(0xFF6688CA),
                                          surface: Colors.white,
                                          onSurface: Color(0xFF6688CA),
                                        ),
                                        textTheme: GoogleFonts.rubikTextTheme().copyWith(
                                          bodyMedium: GoogleFonts.rubik(
                                            fontSize: 16,
                                            color: const Color(0xFF6688CA),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        )),
                                    child: child!,
                                  );
                                },
                              );

                              if (pickedDate != null) {
                                setState(() {
                                  dateTime = dateTime.copyWith(
                                    day: pickedDate.day,
                                    month: pickedDate.month,
                                    year: pickedDate.year,
                                  );

                                  dateOfBirthController.text =
                                      DateFormat('dd MMM yyyy').format(dateTime).toString();
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: emailController,
                      validator: (value) {
                        if (!Utils().isValidEmail(value.toString().trim())) {
                          return 'Enter valid email';
                        }

                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: GoogleFonts.rubik(
                          color: Colors.black54,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                        hintText: 'Email',
                        hintStyle: GoogleFonts.rubik(
                          color: Colors.black54,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      style: GoogleFonts.rubik(
                        color: const Color(0xFF323643),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    UserSharedPreferences.role == 'teacher'
                        ? TextFormField(
                            controller: qualificationController,
                            validator: (value) {
                              if (value != '') {
                                return 'Enter your qualification';
                              }

                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: 'Qualification',
                              labelStyle: GoogleFonts.rubik(
                                color: Colors.black54,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                              hintText: 'B. E.',
                              hintStyle: GoogleFonts.rubik(
                                color: Colors.black54,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            style: GoogleFonts.rubik(
                              color: const Color(0xFF323643),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        : Column(
                            children: [
                              TextFormField(
                                controller: motherNameController,
                                validator: (value) {
                                  if (value != '') {
                                    return 'Enter your mother name';
                                  }

                                  return null;
                                },
                                decoration: InputDecoration(
                                  labelText: 'Mother Name',
                                  labelStyle: GoogleFonts.rubik(
                                    color: Colors.black54,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  hintText: 'Mother Name',
                                  hintStyle: GoogleFonts.rubik(
                                    color: Colors.black54,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                style: GoogleFonts.rubik(
                                  color: const Color(0xFF323643),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                controller: fatherNameController,
                                validator: (value) {
                                  if (value != '') {
                                    return 'Enter your father name';
                                  }

                                  return null;
                                },
                                decoration: InputDecoration(
                                  labelText: 'Father Name',
                                  labelStyle: GoogleFonts.rubik(
                                    color: Colors.black54,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  hintText: 'Father Name',
                                  hintStyle: GoogleFonts.rubik(
                                    color: Colors.black54,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                style: GoogleFonts.rubik(
                                  color: const Color(0xFF323643),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: addressController,
                      maxLines: 2,
                      validator: (value) {
                        if (value != '') {
                          return 'Enter your address';
                        }

                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Address',
                        labelStyle: GoogleFonts.rubik(
                          color: Colors.black54,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                        hintText: 'Address',
                        hintStyle: GoogleFonts.rubik(
                          color: Colors.black54,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      style: GoogleFonts.rubik(
                        color: const Color(0xFF323643),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
