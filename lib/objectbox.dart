import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'models/model.dart';
import 'objectbox.g.dart'; // Assuming Member entity is defined in model.dart

class ObjectBox {
  late final Store _store;

  late final Admin _admin;

  late final Box<Member> _memberBox;
  late final Box<Attendance> _attendanceBox;
  late final Box<MembershipType> _membershipTypeBox;

  ObjectBox._create(this._store) {
    // Optional: enable ObjectBox Admin on debug builds.
    // https://docs.objectbox.io/data-browser
    if (Admin.isAvailable()) {
      // Keep a reference until no longer needed or manually closed.
      _admin = Admin(_store);
    }

    _memberBox = Box<Member>(_store);
    _attendanceBox = Box<Attendance>(_store);
    _membershipTypeBox = Box<MembershipType>(_store);

    // Add some demo data if the box is empty.
    if (_memberBox.isEmpty()) {
      _putDemoData();
    }
  }

  static Future<ObjectBox> create() async {
    // Set a unique directory within the documents directory
    final directoryPath =
    p.join((await getApplicationDocumentsDirectory()).path, "Kiosk");

    // Create the directory if it doesn't exist
    await Directory(directoryPath).create(recursive: true);

    // Open the ObjectBox store using the specified directory
    final store = await openStore(directory: directoryPath);

    return ObjectBox._create(store);
  }

  void _putDemoData() async {
    MembershipType type1 = MembershipType(
      typeName: 'VIP',
      fee: 100.0,
      discount: 10.0,
      isLifetime: true,
    );
    MembershipType type2 = MembershipType(
      typeName: 'Athlete',
      fee: 50.0,
      discount: 5.0,
      isLifetime: false,
    );

    // Add the MembershipType objects to the _membershipTypeBox
    _membershipTypeBox.putMany([type1, type2]);

    Member member1 = Member(
      firstName: 'Dominic John',
      lastName: 'Tanas',
      contactNumber: '09178701138',
      nfcTagID: 'c3ff9310',
      dateOfBirth: DateTime(1990, 5, 15),
      address: '123 Main St',
      email: 'dominic@example.com',
    );
    member1.membershipType.target = type1;
    Member member2 = Member(
      firstName: 'Jay Ann',
      lastName: 'Garcia',
      contactNumber: '09672182672',
      nfcTagID: 'b385aafd',
      dateOfBirth: DateTime(1985, 9, 22),
      address: '456 Elm St',
      email: 'jay@example.com',
    );
    member2.membershipType.target = type2;
    // When the Member is put, its MembershipType will automatically be put into the MembershipType Box.
    await _memberBox.putMany([member1, member2]);
  }

  // CRUD methods for Member entity
  Future<void> addMember(
      String firstName,
      String lastName,
      String contactNumber,
      String email,
      String nfcTagID,
      DateTime dateOfBirth,
      ) async {
    final newMember = Member(
      // Initialize a Member object with the provided details
      firstName: firstName,
      lastName: lastName,
      contactNumber: contactNumber,
      email: email,
      nfcTagID: nfcTagID,
      dateOfBirth: dateOfBirth,
    );

    // Add the new member using ObjectBox methods
    await _memberBox.put(newMember);
  }
  Member? getMemberById(int memberId) {
    return _memberBox.get(memberId);
  }

  void removeMember(int memberId) {
    _memberBox.remove(memberId);
  }

  Box<Member> getMemberBox() {
    return _memberBox;
// Similar CRUD methods for Attendance and MembershipType entities can be added here.
  }
  Stream<List<Member>> getMemberStream() {
    // Assuming _memberBox is a Box<Member> in your ObjectBox class
    return _memberBox.watchAll().map((query) => query.find());
  }
}