import 'dart:io';
import 'package:faker/faker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'models/model.dart';
import 'objectbox.g.dart'; // Assuming Member entity is defined in model.dart
import 'package:gym_kiosk_admin/services/nfc_service.dart';

class ObjectBox {
  late final Store _store;

  late final Admin _admin;
  late final Box<Administrator> _administratorBox;
  late final Box<Member> _memberBox;
  late final Box<Attendance> _attendanceBox;
  late final Box<MembershipType> _membershipTypeBox;
  late final NFCService _nfcService;

  ObjectBox._create(this._store) {
    // Optional: enable ObjectBox Admin on debug builds.
    // https://docs.objectbox.io/data-browser
    if (Admin.isAvailable()) {
      // Keep a reference until no longer needed or manually closed.
      _admin = Admin(_store);
    }
    _administratorBox = Box<Administrator>(_store);
    _memberBox = Box<Member>(_store);
    _attendanceBox = Box<Attendance>(_store);
    _membershipTypeBox = Box<MembershipType>(_store);
    _nfcService = NFCService();
    // Start NFC event listener
    _startNFCListener();
    // Add some demo data if the box is empty.
    if (_memberBox.isEmpty()) {
      _putDemoData();
    }
    if (_administratorBox.isEmpty()) {
      _putAdminData();
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
  void _startNFCListener() {
    _nfcService.onNFCEvent.listen((tagId) {
      if (tagId != 'Error') {
        // Fetch member by NFC tag ID
        Member? member = getMemberByNfcTag(tagId);

        if (member != null) {
          logAttendance(member, checkInTime: DateTime.now());
        } else {
          // Handle case when the member with the NFC tag is not found
          // or any other error scenario
          print("Member not found or error in NFC scanning.");
        }
      }
    });
  }

  void logAttendance(Member member, {required DateTime checkInTime, DateTime? checkOutTime}) {
    _recordAttendance(member, checkInTime, checkOutTime: checkOutTime);
  }

  void _recordAttendance(Member member, DateTime checkInTime, {DateTime? checkOutTime}) {
    final attendance = Attendance(
      member: ToOne<Member>()..target = member,
      checkInTime: checkInTime,
      checkOutTime: checkOutTime ?? DateTime.now(), // Use DateTime.now() as a default if checkOutTime is null
    );
    _attendanceBox.put(attendance);
  }

  Member? getMemberByNfcTag(String tagId) {
    final query = _memberBox.query(Member_.nfcTagID.equals(tagId)).build();
    final members = query.find();
    return members.isNotEmpty ? members.first : null;
  }

  void _putDemoData() async {
    Faker faker = Faker();

    // Array of membership types
    List<MembershipType> membershipTypes = [
      MembershipType(
        typeName: 'VIP',
        fee: 100.0,
        discount: 0,
        isLifetime: true,
      ),
      MembershipType(
        typeName: 'Athlete',
        fee: 250.0,
        discount: 0,
        isLifetime: false,
      ),
      MembershipType(
        typeName: 'Standard',
        fee: 500.0,
        discount: 0,
        isLifetime: false,
      ),
    ];

    // Add the MembershipType objects to the _membershipTypeBox
    _membershipTypeBox.putMany(membershipTypes);

    for (int i = 0; i < 100; i++) {
      Member member = Member(
        firstName: faker.person.firstName(),
        lastName: faker.person.lastName(),
        contactNumber: faker.phoneNumber.us(),
        nfcTagID: faker.guid.guid(),
        dateOfBirth: faker.date.dateTime(minYear: 1950, maxYear: 2005),
        address: faker.address.streetAddress(),
        email: faker.internet.email(),
        membershipStartDate: DateTime.now(),
        membershipEndDate: DateTime.now().add(const Duration(days: 365)),
        photoPath: faker.image.image(),
      );

      // Assign a random membership type to the member
      member.membershipType.target = membershipTypes[faker.randomGenerator.integer(membershipTypes.length)];

      // When the Member is put, its MembershipType will automatically be put into the MembershipType Box.
      _memberBox.put(member);
    }
  }

  void _putAdminData() async {
    Administrator member1 = Administrator(
        name: 'Dominic Tañas',
        type: 'superadmin',
        username: 'dominicdt',
        password: '042323',
        nfcTagID: 'c3ff9310');

    Administrator member2 = Administrator(
        name: 'Jay Ann Garcia',
        type: 'admin',
        username: 'jayanngarcia',
        password: '042323',
        nfcTagID: 'b385aafd');

    // When the Member is put, its MembershipType will automatically be put into the MembershipType Box.
    _administratorBox.putMany([member1, member2]);
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
    // Create a query to find an administrator with the given NFC tag ID
    final query = _administratorBox.query(Administrator_.nfcTagID.equals(tagId)).build();

    // Find administrators with the specified NFC tag ID
    final List<Administrator> admins = query.find();

    // Return whether any administrator with the tag ID exists
    return admins.isNotEmpty;
  }

  Future<Administrator?> getAdministratorByTagId(String tagId) async {
    // Create a query to find an administrator with the given NFC tag ID
    final query = _administratorBox.query(Administrator_.nfcTagID.equals(tagId)).build();

    // Find and return the first matching administrator (or null if not found)
    final List<Administrator> admins = query.find();
    return admins.isNotEmpty ? admins.first : null;
  }
}
