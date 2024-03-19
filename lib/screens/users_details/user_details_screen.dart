import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:online_college/consts/subjects.dart';
import 'package:online_college/consts/utils.dart';
import 'package:online_college/model/student_user_model.dart';
import 'package:online_college/model/teacher_user_model.dart';
import 'package:online_college/providers/all_user_provider.dart';
import 'package:online_college/providers/student_data_firestore_provider.dart';
import 'package:online_college/providers/teacher_data_firestore_provider.dart';
import 'package:online_college/widgets/dialog_for_delete.dart';
import 'package:provider/provider.dart';

class UserDetailsScreen extends StatefulWidget {
  final String id;

  const UserDetailsScreen({Key? key, required this.id}) : super(key: key);

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  late AllUserProvider provider;
  late TeacherUserModel teacherUserModel;
  StudentUserModel studentUserModel = StudentUserModel(
    name: 'name',
    phoneNumber: 'phoneNumber',
    email: 'email',
    adhar: 'adhar',
    dateOfBirth: 'dateOfBirth',
    address: 'address',
    photoUrl: 'photoUrl',
    uid: 'uid',
    motherName: 'motherName',
    fatherName: 'fatherName',
    year: 'year',
    rollNo: 'rollNo',
    role: 'role',
    id: 'id',
    loginTime: 'loginTime',
    notificationToken: 'notificationToken',
    div: 'div',
  );
  bool isStudent = true;

  List<bool> subs = List.generate(subjects.length, (index) => false);
  List<bool> subjes = List.generate(subjects.length, (index) => false);

  final nameController = TextEditingController();
  final adharNoController = TextEditingController();
  final dateOfBirthController = TextEditingController();
  final addressController = TextEditingController();
  final qualificationController = TextEditingController();
  final emailController = TextEditingController();
  final motherNameController = TextEditingController();
  final fatherNameController = TextEditingController();

  String name = '';
  String adharNo = '';
  String dateOfBirth = '';
  String address = '';
  String qualification = '';
  String email = '';
  String motherName = '';
  String fatherName = '';
  String url = '';
  List<String> subjs = [];

  DateTime dateTime = DateTime.now();
  String userUrl = '';

  @override
  void initState() {
    provider = Provider.of<AllUserProvider>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      onSetState();
    });

    super.initState();
  }

  onSetState() async {
    await provider.getAllUser(context: context);

    for (var element in provider.studentsList) {
      if (element.id == widget.id) {
        isStudent = true;
        studentUserModel = element;
      }
    }

    for (var element in provider.teachersList) {
      if (element.id == widget.id) {
        isStudent = false;
        teacherUserModel = element;
      }
    }

    if (isStudent) {
      nameController.text = studentUserModel.name;
      adharNoController.text = studentUserModel.adhar;
      dateOfBirthController.text = studentUserModel.dateOfBirth;
      addressController.text = studentUserModel.address;
      emailController.text = studentUserModel.email;
      motherNameController.text = studentUserModel.motherName;
      fatherNameController.text = studentUserModel.fatherName;
      userUrl = studentUserModel.photoUrl;

      name = nameController.text;
      adharNo = adharNoController.text;
      dateOfBirth = dateOfBirthController.text;
      address = addressController.text;
      email = emailController.text;
      motherName = motherNameController.text;
      fatherName = fatherNameController.text;
      url = userUrl;
    } else {
      nameController.text = teacherUserModel.name;
      adharNoController.text = teacherUserModel.adhar;
      dateOfBirthController.text = teacherUserModel.dateOfBirth;
      addressController.text = teacherUserModel.address;
      qualificationController.text = teacherUserModel.qualification;
      emailController.text = teacherUserModel.email;
      userUrl = teacherUserModel.photoUrl;
      subjs = teacherUserModel.subjects;

      for (var element in subjects) {
        subs[subjects.indexOf(element)] = subjs.contains(element);
        subjes[subjects.indexOf(element)] = subjs.contains(element);
      }

      subjs.clear();
      subjs = [];

      name = nameController.text;
      adharNo = adharNoController.text;
      dateOfBirth = dateOfBirthController.text;
      address = addressController.text;
      qualification = qualificationController.text;
      email = emailController.text;
      url = userUrl;
    }

    dateTime = dateOfBirthController.text.isEmpty
        ? DateTime.now()
        : DateFormat('dd MMM yyyy').parse(dateOfBirthController.text);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => onSetState(),
      backgroundColor: const Color(0xFF2855AE),
      color: Colors.white,
      child: Scaffold(
        backgroundColor: Colors.white,
        body:
            Consumer3<AllUserProvider, TeacherDataFireStoreProvider, StudentDataFireStoreProvider>(
          builder: (context, users, fireStoreTeacher, fireStoreStudent, _) => CustomScrollView(
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
                  '${isStudent ? studentUserModel.name : teacherUserModel.name}\'s Profile',
                  style: GoogleFonts.rubik(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                actions: [
                  GestureDetector(
                    onTap: () => showDialogForDelete(
                      context: context,
                      text:
                          'Are you sure you want to delete ${isStudent ? '${studentUserModel.name} student' : '${teacherUserModel.name} teacher'}?',
                      onDelete: () async {
                        await users.deleteUser(
                            context: context,
                            id: isStudent ? studentUserModel.id : teacherUserModel.id);

                        if (!context.mounted) return;
                        Navigator.pop(context);

                        if (!context.mounted) return;
                        Navigator.pop(context);
                      },
                      onOk: () => Navigator.pop(context),
                    ),
                    child: Container(
                      height: 30,
                      width: 40,
                      margin: const EdgeInsets.only(right: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Icon(
                        Icons.delete_outlined,
                        color: Colors.red,
                        size: 25,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      if (isStudent) {
                        if (nameController.text != '' && nameController.text != name) {
                          if (!context.mounted) return;
                          await fireStoreStudent.updateStudentName(
                              context: context,
                              name: nameController.text.trim(),
                              id: studentUserModel.id);
                        }

                        if (adharNoController.text != '' && adharNoController.text != adharNo) {
                          if (!context.mounted) return;
                          await fireStoreStudent.updateStudentAdhar(
                              context: context,
                              adhar: adharNoController.text.trim(),
                              id: studentUserModel.id);
                        }

                        if (emailController.text != '' && emailController.text != email) {
                          if (!context.mounted) return;
                          await fireStoreStudent.updateStudentEmail(
                              context: context,
                              email: emailController.text.trim(),
                              id: studentUserModel.id);
                        }

                        if (dateOfBirthController.text != '' &&
                            dateOfBirthController.text != dateOfBirth) {
                          if (!context.mounted) return;
                          await fireStoreStudent.updateStudentDateOfBirth(
                              context: context,
                              dateOfBirth: dateOfBirthController.text.trim(),
                              id: studentUserModel.id);
                        }

                        if (addressController.text != '' && addressController.text != address) {
                          if (!context.mounted) return;
                          await fireStoreStudent.updateStudentAddress(
                              context: context,
                              address: addressController.text,
                              id: studentUserModel.id);
                        }

                        if (userUrl != '' && userUrl != url) {
                          if (!context.mounted) return;
                          await fireStoreStudent.updateStudentPhotoUrl(
                              context: context, photoUrl: userUrl.trim(), id: studentUserModel.id);
                        }

                        if (motherNameController.text != '' &&
                            motherNameController.text != motherName) {
                          if (!context.mounted) return;
                          await fireStoreStudent.updateStudentMotherName(
                              context: context,
                              motherName: motherNameController.text.trim(),
                              id: studentUserModel.id);
                        }

                        if (fatherNameController.text != '' &&
                            fatherNameController.text != fatherName) {
                          if (!context.mounted) return;
                          await fireStoreStudent.updateStudentFatherName(
                              context: context,
                              fatherName: fatherNameController.text.trim(),
                              id: studentUserModel.id);
                        }
                      } else {
                        if (nameController.text != '' && nameController.text != name) {
                          if (!context.mounted) return;
                          await fireStoreTeacher.updateTeacherName(
                              context: context,
                              name: nameController.text.trim(),
                              id: teacherUserModel.id);
                        }

                        if (adharNoController.text != '' && adharNoController.text != adharNo) {
                          if (!context.mounted) return;
                          await fireStoreTeacher.updateTeacherAdhar(
                              context: context,
                              adhar: adharNoController.text.trim(),
                              id: teacherUserModel.id);
                        }

                        if (emailController.text != '' && emailController.text != email) {
                          if (!context.mounted) return;
                          await fireStoreTeacher.updateTeacherEmail(
                              context: context,
                              email: emailController.text.trim(),
                              id: teacherUserModel.id);
                        }

                        if (dateOfBirthController.text != '' &&
                            dateOfBirthController.text != dateOfBirth) {
                          if (!context.mounted) return;
                          await fireStoreTeacher.updateTeacherDateOfBirth(
                              context: context,
                              dateOfBirth: dateOfBirthController.text.trim(),
                              id: teacherUserModel.id);
                        }

                        if (qualificationController.text != '' &&
                            qualificationController.text != qualification) {
                          if (!context.mounted) return;
                          await fireStoreTeacher.updateTeacherQualification(
                              context: context,
                              qualification: qualificationController.text,
                              id: teacherUserModel.id);
                        }

                        if (addressController.text != '' && addressController.text != address) {
                          if (!context.mounted) return;
                          await fireStoreTeacher.updateTeacherAddress(
                              context: context,
                              address: addressController.text,
                              id: teacherUserModel.id);
                        }

                        if (userUrl != '' && userUrl != url) {
                          if (!context.mounted) return;
                          await fireStoreTeacher.updateTeacherPhotoUrl(
                              context: context, photoUrl: userUrl.trim(), id: teacherUserModel.id);
                        }

                        if (subs.contains(true) && subs != subjes) {
                          if (!context.mounted) return;
                          await fireStoreTeacher.updateTeacherSubjects(
                              context: context, subjects: subjs, id: teacherUserModel.id);
                        }
                      }

                      await onSetState();
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
                              child: users.isLoading
                                  ? const SizedBox(
                                      height: 30,
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          color: Color(0xFF2855AE),
                                        ),
                                      ),
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Hero(
                                        tag: 'profilePhoto',
                                        child: Image.network(
                                          userUrl,
                                          fit: BoxFit.fitHeight,
                                          errorBuilder: (BuildContext context, Object error,
                                              StackTrace? stackTrace) {
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
                              child: users.isLoading
                                  ? const Center(
                                      child: SizedBox(
                                        height: 30,
                                        width: 30,
                                        child: CircularProgressIndicator(
                                          color: Color(0xFF2855AE),
                                        ),
                                      ),
                                    )
                                  : Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          nameController.text,
                                          style: GoogleFonts.rubik(
                                            color: Colors.black87,
                                            fontSize: 22,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          isStudent
                                              ? '${studentUserModel.year} | ${studentUserModel.div} - ${studentUserModel.rollNo}'
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
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      users.isLoading
                          ? SizedBox(
                              height: MediaQuery.of(context).size.height - 350,
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: Color(0xFF2855AE),
                                ),
                              ),
                            )
                          : Column(
                              children: [
                                TextFormField(
                                  controller: nameController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Enter valid name';
                                    }

                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'Name',
                                    labelStyle: GoogleFonts.rubik(
                                      color: Colors.black54,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    hintText: 'Name',
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
                                                    textTheme:
                                                        GoogleFonts.rubikTextTheme().copyWith(
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

                                              dateOfBirthController.text = DateFormat('dd MMM yyyy')
                                                  .format(dateTime)
                                                  .toString();
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
                                !isStudent
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
                                if (!isStudent)
                                  const SizedBox(
                                    height: 10,
                                  ),
                                if (!isStudent)
                                  StatefulBuilder(
                                    builder: (context, set) => MasonryGridView.count(
                                      crossAxisCount: 4,
                                      crossAxisSpacing: 10,
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      padding: EdgeInsets.zero,
                                      itemCount: subjects.length,
                                      itemBuilder: (context, index) {
                                        return FilterChip(
                                          label: Text(subjects[index]),
                                          labelStyle: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: subs[index] ? Colors.white : Colors.black54,
                                          ),
                                          selected: subs[index],
                                          selectedColor: const Color(0xFF2855AE),
                                          checkmarkColor: Colors.white,
                                          onSelected: (bool value) {
                                            if (value) {
                                              subjs.add(subjects[index]);
                                            } else {
                                              subjs.remove(subjects[index]);
                                            }

                                            subs[index] = value;
                                            set(() {});
                                          },
                                        );
                                      },
                                    ),
                                  ),
                              ],
                            ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
