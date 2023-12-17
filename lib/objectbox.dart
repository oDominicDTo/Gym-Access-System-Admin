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
      discount: 0,
      isLifetime: true,
    );
    MembershipType type2 = MembershipType(
      typeName: 'Athlete',
      fee: 250.0,
      discount: 0,
      isLifetime: false,
    );

    MembershipType type3 = MembershipType(
      typeName: 'Standard',
      fee: 500.0,
      discount: 0,
      isLifetime: false,
    );

    // Add the MembershipType objects to the _membershipTypeBox
    _membershipTypeBox.putMany([type1, type2,type3]);

    Member member1 = Member(
      firstName: 'Dominic John',
      lastName: 'Tanas',
      contactNumber: '09178701138',
      nfcTagID: 'c3ff9310',
      dateOfBirth: DateTime(2001, 04, 29),
      address: 'Zapote',
      email: 'dominic@example.com',
      membershipStartDate: DateTime.now(),
      membershipEndDate: DateTime.now().add(const Duration(days: 365)),
      photoPath: 'dom.jpg',
    );
    member1.membershipType.target = type1;

    Member member2 = Member(
      firstName: 'Jay Ann',
      lastName: 'Garcia',
      contactNumber: '09672182672',
      nfcTagID: 'b385aafd',
      dateOfBirth: DateTime(2001, 7, 14),
      address: 'Bungahan',
      email: 'jay@example.com',
      membershipStartDate: DateTime.now(),
      membershipEndDate: DateTime.now().add(const Duration(days: 365)),
      photoPath: 'jayan.jpg',
    );
    member2.membershipType.target = type2;

    // When the Member is put, its MembershipType will automatically be put into the MembershipType Box.
    _memberBox.putMany([member1, member2]);
  }

  // CRUD methods for Member entity
  // Create a new Member
  Future<int> addMember(Member member) async {
    return _memberBox.put(member);
  }

  // Retrieve a Member by ID
  Member getMember(int id) {
    return _memberBox.get(id)!;
  }

  // Update an existing Member
  void updateMember(Member updatedMember) {
    _memberBox.put(updatedMember);
  }

  // Delete a Member by ID
  void deleteMember(int id) {
    _memberBox.remove(id);
  }

  // Retrieve all Members
  List<Member> getAllMembers() {
    return _memberBox.getAll();
  }

  // Retrieve all Members asynchronously
  Future<List<Member>> getAllMembersAsync() async {
    return _memberBox.getAllAsync();
  }

  // Example method to get Members with a specific name
  List<Member> getMembersByName(String name) {
    // Create a query to find members with a specific first name
    final query = _memberBox.query(Member_.firstName.equals(name)).build();

    // Find and return matching members
    return query.find();
  }

  Future<List<MembershipType>> getAllMembershipTypes() async {
    return _membershipTypeBox.getAll();
  }

  Future<int> addMembershipType(MembershipType membershipType) async {
    return _membershipTypeBox.put(membershipType);
  }

  MembershipType getMembershipType(int id) {
    return _membershipTypeBox.get(id)!;
  }

  void updateMembershipType(MembershipType updatedMembershipType) {
    _membershipTypeBox.put(updatedMembershipType);
  }

  void deleteMembershipType(int id) {
    _membershipTypeBox.remove(id);
  }

  Future<bool> checkTagIdExists(String tagId) async {
    // Create a query to find a member with the given NFC tag ID
    final query = _memberBox.query(Member_.nfcTagID.equals(tagId)).build();

    // Find members with the specified NFC tag ID
    final List<Member> members = query.find();

    // Return whether any member with the tag ID exists
    return members.isNotEmpty;
  }
}
