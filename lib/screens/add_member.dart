import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gym_kiosk_admin/main.dart';
import 'package:gym_kiosk_admin/models/model.dart';
import 'membership_duration.dart';
import 'package:intl/intl.dart';

enum AddressSelection { binan, other }

class MemberInput extends StatefulWidget {
  final String adminName;
  const MemberInput({Key? key, required this.adminName}) : super(key: key);

  @override
  State<MemberInput> createState() => _MemberInputState();
}

class _MemberInputState extends State<MemberInput> {
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController contactNumberController;
  late TextEditingController emailController;
  late TextEditingController addressController;
  late MembershipType? selectedMembershipType;
  List<MembershipType> membershipTypes = [];
  final _formKey = GlobalKey<FormState>();
  late TextEditingController dobController;

  AddressSelection? selectedAddress;
  String selectedBinanBarangay = 'Select Barangay';
  String otherCity = '';
  String otherBarangay = '';

  List<String> binanBarangays = [
    'Select Barangay',
    'Biñan (Poblacion)',
    'Bungahan',
    'Santo Tomas (Calabuso)',
    'Canlalay',
    'Casile',
    'De La Paz',
    'Ganado',
    'San Francisco (Halang)',
    'Langkiwa',
    'Loma',
    'Malaban',
    'Malamig',
    'Mampalasan',
    'Platero',
    'Poblacion',
    'Santo Niño',
    'San Antonio',
    'San Jose',
    'San Vicente',
    'Soro-soro',
    'Santo Domingo',
    'Timbao',
    'Tubigan',
    'Zapote',
  ];

  @override
  void initState() {
    super.initState();
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    contactNumberController = TextEditingController();
    emailController = TextEditingController();
    addressController = TextEditingController();
    _fetchMembershipTypes(); // Fetch membership types when the widget initializes
    selectedMembershipType = null;
    dobController = TextEditingController();
  }

  Future<void> _fetchMembershipTypes() async {
    membershipTypes = await objectbox.getAllMembershipTypes();
    if (membershipTypes.isNotEmpty) {
      setState(() {
        selectedMembershipType = membershipTypes.first;
      });
    }
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    contactNumberController.dispose();
    emailController.dispose();
    addressController.dispose();
    dobController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(1.0),
            child: Text(
              'Add New Member',
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
          ),
          const SizedBox(height: 50),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          _buildTextFormField(

                            labelText: 'First Name',
                            controller: firstNameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'First Name cannot be empty';
                              }
                              if (value.length < 2) {
                                return 'First Name should be at least 2 characters';
                              }
                              if (!RegExp(r"^[a-zA-ZñÑ\s']+$").hasMatch(value)) {
                                return 'First Name should not contain special characters or numbers';
                              }
                              return null;
                            },
                            isNameField:
                                true, // Set the flag for the First Name field
                          ),
                          const SizedBox(width: 15),
                          _buildTextFormField(
                            labelText: 'Last Name',
                            controller: lastNameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Last Name cannot be empty';
                              }
                              if (value.length < 2) {
                                return 'Last Name should be at least 2 characters';
                              }
                              if (!RegExp(r"^[a-zA-ZñÑ\s']+$").hasMatch(value)) {
                                return 'Last Name should not contain special characters or numbers';
                              }

                              return null;
                            },
                            isNameField:
                                true, // Set the flag for the Last Name field
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildTextFormField(
                            labelText: 'Contact Number',
                            controller: contactNumberController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a valid contact number';
                              }
                              if (!RegExp(r'^(\+63|0)9\d{9}$')
                                  .hasMatch(value)) {
                                return 'Please enter a valid Philippine contact number';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.phone,
                          ),
                          const SizedBox(width: 15),
                          _buildTextFormField(
                            labelText: 'Email',
                            controller: emailController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a valid email';
                              }
                              if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$')
                                  .hasMatch(value)) {
                                return 'Please enter a valid email address';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.emailAddress,
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildDOBFormField(),
                          const SizedBox(width: 10),
                          _buildAddressDropdown(),
                          const SizedBox(width: 10),
                          if (selectedAddress == AddressSelection.binan)
                            _buildBinanBarangayDropdown(),
                          if (selectedAddress == AddressSelection.other)
                            _buildOtherAddressFields(),
                        ],
                      ),
                      const SizedBox(height: 5),
                      _buildDropdownMembershipType(),
                      const SizedBox(height: 5),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            if (selectedAddress == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Please select an Address',
                                    textAlign: TextAlign.center,
                                    // Center align the text
                                    style: TextStyle(
                                        // Add additional styling if needed
                                        ),
                                  ),
                                ),
                              );
                              return;
                            }
                            if (selectedMembershipType != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MembershipDurationPage(
                                    selectedMembershipType:
                                        selectedMembershipType,
                                    firstName: firstNameController.text,
                                    lastName: lastNameController.text,
                                    contactNumber: contactNumberController.text,
                                    email: emailController.text,
                                    dateOfBirth: dobController.text,
                                    address: selectedAddress ==
                                            AddressSelection.other
                                        ? '$otherCity, $otherBarangay'
                                        : 'Biñan, $selectedBinanBarangay',
                                    onSaveMember: (Member newMember) {},
                                    adminName: widget.adminName,
                                  ),
                                ),
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black, // Set background color to black
                        ),
                        child: const Text('Next', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextFormField({
    required String labelText,
    required TextEditingController controller,
    required FormFieldValidator<String>? validator,
    TextInputType? keyboardType,
    bool isNameField = false, // Add a flag to identify name fields
  }) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.3,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: controller,
            decoration: InputDecoration(
              labelText: labelText,
              hintText: 'Enter $labelText',
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.blue, width: 2.0),
                borderRadius: BorderRadius.circular(8),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                borderRadius: BorderRadius.circular(8),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.red, width: 1.0),
                borderRadius: BorderRadius.circular(8),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.red, width: 2.0),
                borderRadius: BorderRadius.circular(8),
              ),
              errorStyle: const TextStyle(fontSize: 12),
              errorMaxLines: 2,
            ),
            validator: validator,
            keyboardType: keyboardType,
            inputFormatters: isNameField
                ? [
                    TextInputFormatter.withFunction((oldValue, newValue) {
                      if (newValue.text.isNotEmpty) {
                        final correctedText =
                            newValue.text.toLowerCase().split(' ').map((word) {
                          if (word.isNotEmpty) {
                            return '${word[0].toUpperCase()}${word.substring(1)}';
                          } else {
                            return '';
                          }
                        }).join(' ');
                        return TextEditingValue(
                          text: correctedText,
                          selection: newValue.selection,
                        );
                      }
                      return newValue;
                    }),
                  ]
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildDOBFormField() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.2,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            readOnly: true,
            controller: dobController,
            decoration: InputDecoration(
              labelText: 'Date of Birth',
              hintText: 'Select Date of Birth',
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.blue, width: 2.0),
                borderRadius: BorderRadius.circular(8),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                borderRadius: BorderRadius.circular(8),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.red, width: 1.0),
                borderRadius: BorderRadius.circular(8),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.red, width: 2.0),
                borderRadius: BorderRadius.circular(8),
              ),
              errorStyle: const TextStyle(fontSize: 12),
              errorMaxLines: 2,
            ),
            onTap: () async {
              final DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );
              if (pickedDate != null) {
                final formattedDate = DateFormat.yMMMMd('en_US').format(pickedDate);
                setState(() {
                  dobController.text = formattedDate;
                });
              }
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select a date of birth';
              }
              // Additional validation logic can be added here
              return null; // Return null if the date is valid
            },
          ),
        ],
      ),
    );
  }


  Widget _buildAddressDropdown() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.2,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButtonFormField<AddressSelection>(
            value: selectedAddress,
            items: const [
              DropdownMenuItem(
                value: AddressSelection.binan,
                child: Text('Biñan'),
              ),
              DropdownMenuItem(
                value: AddressSelection.other,
                child: Text('Other/Specify'),
              ),
            ],
            onChanged: (value) {
              setState(() {
                selectedAddress = value!;
              });
            },
            decoration: InputDecoration(
              labelText: 'Address',
              hintText: 'Select Address',
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.blue, width: 2.0),
                borderRadius: BorderRadius.circular(8),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                borderRadius: BorderRadius.circular(8),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.red, width: 1.0),
                borderRadius: BorderRadius.circular(8),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.red, width: 2.0),
                borderRadius: BorderRadius.circular(8),
              ),
              errorStyle: const TextStyle(fontSize: 12),
              errorMaxLines: 2,
            ),
            validator: (value) {
              if (value == null) {
                return 'Please select an address';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }


  Widget _buildBinanBarangayDropdown() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.2,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: DropdownButtonFormField<String>(
        value: selectedBinanBarangay,
        items: binanBarangays.map((barangay) {
          return DropdownMenuItem<String>(
            value: barangay,
            child: Text(barangay),
          );
        }).toList(),
        onChanged: (newValue) {
          setState(() {
            selectedBinanBarangay = newValue!;
          });
        },
        decoration: InputDecoration(
          labelText: 'Barangay',
          hintText: 'Select Barangay',
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.blue, width: 2.0),
            borderRadius: BorderRadius.circular(8),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey, width: 1.0),
            borderRadius: BorderRadius.circular(8),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red, width: 1.0),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red, width: 2.0),
            borderRadius: BorderRadius.circular(8),
          ),
          errorStyle: const TextStyle(fontSize: 12),
          errorMaxLines: 2,
        ),
        validator: (value) {
          if (value == 'Select Barangay') {
            return 'Please select a barangay';
          }
          return null;
        },
      ),
    );
  }


  Widget _buildOtherAddressFields() {
    return Column(
      children: [
        _buildAddressTextField(
          labelText: 'City',
          onChanged: (value) {
            setState(() {
              otherCity = value;
            });
          },
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please enter a city';
            }
            return null;
          },
        ),
        _buildAddressTextField(
          labelText: 'Barangay',
          onChanged: (value) {
            setState(() {
              otherBarangay = value;
            });
          },
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please enter a barangay';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildAddressTextField({
    required String labelText,
    required ValueChanged<String> onChanged,
    required FormFieldValidator<String> validator,
  }) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.2,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: labelText,
          hintText: 'Enter $labelText',
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.blue, width: 2.0),
            borderRadius: BorderRadius.circular(8),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey, width: 1.0),
            borderRadius: BorderRadius.circular(8),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red, width: 1.0),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red, width: 2.0),
            borderRadius: BorderRadius.circular(8),
          ),
          errorStyle: const TextStyle(fontSize: 12),
          errorMaxLines: 2,
        ),
        onChanged: onChanged,
        validator: validator,
      ),
    );
  }


  Widget _buildDropdownMembershipType() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.2,
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey),
      ),
      child: DropdownButtonHideUnderline(
        child: InputDecorator(
          decoration: const InputDecoration(
            border: InputBorder.none,
            labelText: 'Membership Type', // Initial label inside the box
          ),
          isEmpty: selectedMembershipType == null,
          child: DropdownButton<MembershipType>(
            value: selectedMembershipType,
            onChanged: (MembershipType? newValue) {
              setState(() {
                selectedMembershipType = newValue!;
              });
            },
            items: membershipTypes.map((MembershipType type) {
              return DropdownMenuItem<MembershipType>(
                value: type,
                child: Text(
                  type.typeName,
                  style: const TextStyle(color: Colors.black),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
