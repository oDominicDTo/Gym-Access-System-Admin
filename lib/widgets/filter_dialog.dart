import 'package:flutter/material.dart';

import '../main.dart';
import '../models/model.dart';

class FilterDialog extends StatefulWidget {
  final Function(List<String>, String?) onApplyFilters;
  final List<String> appliedFilters;
  final String? appliedStatus;
  final Function(String?) onStatusSelected; // Add this callback

  const FilterDialog({
    Key? key,
    required this.onApplyFilters,
    required this.appliedFilters,
    this.appliedStatus,
    required this.onStatusSelected, // Pass the callback
  }) : super(key: key);
  @override
  State createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  late List<MembershipType> _membershipTypes = [];
  late List<bool> _isSelected = [];
  String? _selectedStatus; // Updated to handle the selected status

  @override
  void initState() {
    super.initState();
    _loadMembershipTypes();
    _selectedStatus = widget.appliedStatus;
  }

  String? getSelectedStatus() {
    return _selectedStatus;
  }

  Future<void> _loadMembershipTypes() async {
    _membershipTypes = await objectbox.getAllMembershipTypes();
    _isSelected = List.generate(_membershipTypes.length, (index) {
      // Initialize the selection based on the applied filters received
      return widget.appliedFilters.contains(_membershipTypes[index].typeName);
    });
    setState(() {});
  }

  void _applyStatusFilter(String selectedStatus) {
    setState(() {
      // Implement your logic here using selectedStatus
      // This method should update the displayed data based on status
      // For instance:
      if (selectedStatus == 'Active') {
        // Update displayed data based on 'Active' status
      } else if (selectedStatus == 'Inactive') {
        // Update displayed data based on 'Inactive' status
      } else if (selectedStatus == 'Expired') {
        // Update displayed data based on 'Expired' status
      } else {
        // Handle other cases or default behavior
      }
      _selectedStatus = selectedStatus;
      widget.onStatusSelected(_selectedStatus); // Update selected status
    });
  }
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Filter Options', style: TextStyle(color: Colors.black, fontFamily: 'Poppins')),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Membership Type:', style: TextStyle(color: Colors.black, fontFamily: 'Poppins')),
            if (_membershipTypes.isNotEmpty)
              ToggleButtons(
                isSelected: _isSelected,
                onPressed: (index) {
                  setState(() {
                    _isSelected[index] = !_isSelected[index];
                  });
                },
                children: _buildMembershipTypeButtons(),

              ),
            const SizedBox(height: 20),
            const Text('Status:', style: TextStyle(color: Colors.black, fontFamily: 'Poppins')),
            _buildStatusSegmentedControl(),
          ],
        ),
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            setState(() {
              _isSelected = List.generate(_isSelected.length, (_) => false);
              _selectedStatus = null; // Reset status to null
            });
          },
          style: TextButton.styleFrom(
            side: const BorderSide(color: Colors.black), // Set border color to black
          ),
          child: const Text('Reset', style: TextStyle(color: Colors.black, fontFamily: 'Poppins')),
        ),
        TextButton(
          onPressed: () {
            List<String> selectedMembershipTypes = _getSelectedMembershipTypes();
            widget.onApplyFilters(selectedMembershipTypes, _selectedStatus); // Pass status as the second argument
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black, // Set background color to black
          ),
          child: const Text('Apply', style: TextStyle(color: Colors.white, fontFamily: 'Poppins')),
        ),
      ],
    );
  }

  Widget _buildStatusSegmentedControl() {
    return Wrap(
      children: [
        _buildStatusButton('Active', 0),
        _buildStatusButton('Inactive', 1),
        _buildStatusButton('Expired', 2),
      ],
    );
  }

  Widget _buildStatusButton(String status, int index) {
      return Container(
        padding: const EdgeInsets.all(8.0), // Add padding inside the box
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
            width: 0.2,
          ),
        ),
      child: TextButton(
        onPressed: () {
          setState(() {
            _applyStatusFilter(status);
            _selectedStatus = status; // Update the selected status
          });
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
                (states) {
              return _selectedStatus == status ? Colors.black : Colors.white;
            },
          ),
          foregroundColor: MaterialStateProperty.resolveWith<Color>(
                (states) {
              return _selectedStatus == status ? Colors.white : Colors.black;
            },
          ),
        ),
        child: Text(status),
      ),
    );
  }

  List<Padding> _buildMembershipTypeButtons() {
    return _membershipTypes.map((type) {
      final index = _membershipTypes.indexOf(type);
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: TextButton(
          onPressed: () {
            setState(() {
              // Preserve the selected status

              // Toggle the selection
              _isSelected[index] = !_isSelected[index];

            });
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
              // If membership type is selected, keep the status color unchanged
              if (_isSelected[index]) {
                return Colors.black;
              }
              return Colors.white;
            }),
            foregroundColor: MaterialStateProperty.resolveWith<Color>((states) {
              // If membership type is selected, keep the status text color unchanged
              if (_isSelected[index]) {
                return Colors.white;
              }
              return Colors.black;
            }),
          ),
          child: Text(type.typeName),
        ),
      );
    }).toList();
  }


  List<String> _getSelectedMembershipTypes() {
    List<String> selectedTypes = [];
    for (int i = 0; i < _isSelected.length; i++) {
      if (_isSelected[i]) {
        selectedTypes.add(_membershipTypes[i].typeName);
      }
    }
    return selectedTypes;
  }
}
