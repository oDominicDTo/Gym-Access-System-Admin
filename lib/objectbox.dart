import 'dart:io';
import 'package:faker/faker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'models/model.dart';
import 'objectbox.g.dart'; // Assuming Member entity is defined in model.dart
import 'package:gym_kiosk_admin/services/nfc_service.dart';
import 'dart:math';

class ObjectBox {
  late final Store _store;

  late final Admin _admin;
  late final Box<Administrator> _administratorBox;
  late final Box<Member> _memberBox;
  late final Box<CheckIn> _checkInBox;
  late final Box<CheckOut> _checkOutBox;
  late final Box<MembershipType> _membershipTypeBox;
  late final NFCService _nfcService;
  late final Box<RenewalLog> _renewalLogBox;
  late final Box<UserFeedback> _feedbackBox;
  late final Box<NewMemberLog> _newMemberLogBox;
  late final Box<AdminRenewalLog> _adminRenewalLogBox;
  ObjectBox._create(this._store) {
    // Optional: enable ObjectBox Admin on debug builds.
    // https://docs.objectbox.io/data-browser
    if (Admin.isAvailable()) {
      // Keep a reference until no longer needed or manually closed.
      _admin = Admin(_store);
    }
    _administratorBox = Box<Administrator>(_store);
    _memberBox = Box<Member>(_store);
    _checkInBox = Box<CheckIn>(_store);
    _checkOutBox = Box<CheckOut>(_store);
    _membershipTypeBox = Box<MembershipType>(_store);
    _nfcService = NFCService();
    _renewalLogBox = Box<RenewalLog>(_store);
    _feedbackBox = Box<UserFeedback>(_store);
    _newMemberLogBox = Box<NewMemberLog>(_store);
    _adminRenewalLogBox = Box<AdminRenewalLog>(_store);

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
        Member? member = getMemberByNfcTag(tagId);

        if (member != null) {
          logCheckIn(member, checkInTime: DateTime.now());
        } else {
          print("Member not found or error in NFC scanning.");
        }
      }
    });
  }

  void logCheckIn(Member member, {required DateTime checkInTime}) {
    _recordCheckIn(member, checkInTime);
  }

  void logCheckOut(Member member, {required DateTime checkOutTime}) {
    _recordCheckOut(member, checkOutTime);
  }

  void _recordCheckIn(Member member, DateTime checkInTime) {
    final checkIn = CheckIn(
      member: ToOne<Member>()
        ..target = member,
      checkInTime: checkInTime,
    );
    _checkInBox.put(checkIn);
  }

  void _recordCheckOut(Member member, DateTime checkOutTime) {
    final checkOut = CheckOut(
      member: ToOne<Member>()
        ..target = member,
      checkOutTime: checkOutTime,
    );
    _checkOutBox.put(checkOut);
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
    Member member1 = Member(
      firstName: 'Dominic John',
      lastName: 'Tanas',
      contactNumber: '09178701138',
      nfcTagID: 'c37cd1ec',
      dateOfBirth: DateTime(2001, 04, 29),
      address: 'Zapote',
      email: 'dominic@example.com',
      membershipStartDate: DateTime.now(),
      membershipEndDate: DateTime.now().add(const Duration(days: 30)),
      photoPath: 'dom.jpg',
    );
    member1.membershipType.target =
    membershipTypes[faker.randomGenerator.integer(membershipTypes.length)];

    Member member2 = Member(
      firstName: 'Jay Ann',
      lastName: 'Garcia',
      contactNumber: '09672182672',
      nfcTagID: 'd3bcf3ec',
      dateOfBirth: DateTime(2001, 7, 14),
      address: 'Bungahan',
      email: 'jay@example.com',
      membershipStartDate: DateTime.now(),
      membershipEndDate: DateTime.now().add(const Duration(days: 30)),
      photoPath: 'jayan.jpg',
    );
    member2.membershipType.target =
    membershipTypes[faker.randomGenerator.integer(membershipTypes.length)];

    // When the Member is put, its MembershipType will automatically be put into the MembershipType Box.
    _memberBox.putMany([member1, member2]);


    for (int i = 0; i < 100; i++) {
      int randomDays = Random().nextInt(365 * 2) -
          365; // generates a random integer between -365 and 365
      Member member = Member(
        firstName: faker.person.firstName(),
        lastName: faker.person.lastName(),
        contactNumber: faker.phoneNumber.us(),
        nfcTagID: faker.guid.guid(),
        dateOfBirth: faker.date.dateTime(minYear: 1950, maxYear: 2005),
        address: faker.address.streetAddress(),
        email: faker.internet.email(),
        membershipStartDate: DateTime.now(),
        membershipEndDate: DateTime.now().add(Duration(days: randomDays)),
        // adds or subtracts the random number of days from the current date
        photoPath: faker.image.image(),
      );

      // Assign a random membership type to the member
      member.membershipType.target =
      membershipTypes[faker.randomGenerator.integer(membershipTypes.length)];

      // When the Member is put, its MembershipType will automatically be put into the MembershipType Box.
      _memberBox.put(member);
    }

    List<String> sentences = faker.lorem.sentences(3);
    String feedbackText = sentences.join(' ');
    for (int i = 0; i < 30; i++) {
      UserFeedback feedback = UserFeedback(
        submissionTime: faker.date.dateTime(minYear: 2022, maxYear: 2024),
        feedbackText: feedbackText,
        category: faker.randomGenerator.element(
            ['UI', 'Functionality', 'Performance']),
        title: faker.lorem.words(3).join(' '),
        // Generate a title using faker
        name: faker.randomGenerator.boolean()
            ? faker.person.firstName()
            : 'Anonymous',
        isUser: faker.randomGenerator.boolean(),
      );

      _feedbackBox.put(feedback);
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

  List<String> getAllMemberNames() {
    final members = _memberBox.getAll();
    return members.map((member) => '${member.firstName} ${member.lastName}')
        .toList();
  }

  // Assuming you have a Box<Member> instance named 'box'
  List<Member> getMembersSortedByStartDate() {
    final query = _memberBox.query(Member_.membershipStartDate.notNull())
        .build();
    final members = query.find();
    query.close();

    members.sort((a, b) =>
        b.membershipStartDate.compareTo(a.membershipStartDate));

    return members;
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

  void updateMembershipDuration(int memberId, int additionalDays) {
    final member = _memberBox.get(memberId);
    if (member != null) {
      // To add days to the membership duration
      member.extendMembership(additionalDays);

      // To subtract days from the membership duration
      // member.extendMembership(-additionalDays);

      _memberBox.put(member);
    }
  }

  void updateMembershipDurationForAllMembers(int days) {
    final members = _memberBox.getAll(); // Retrieve all members

    for (final member in members) {
      member.extendMembership(
          days); // Extend membership duration for each member
      _memberBox.put(member); // Update the member in the database
    }
  }

  void updateMembershipDurationForSelectedMembers(List<int> selectedMemberIds,
      int days) {
    for (final memberId in selectedMemberIds) {
      final member = _memberBox.get(memberId);

      if (member != null) {
        member.extendMembership(
            days); // Extend membership duration for each selected member
        _memberBox.put(member); // Update the member in the database
      }
    }
  }

  void updateMembershipType(MembershipType updatedMembershipType) {
    final existingType = _membershipTypeBox.get(updatedMembershipType.id);
    if (existingType != null) {
      existingType.typeName = updatedMembershipType.typeName;
      existingType.fee = updatedMembershipType.fee;
      existingType.discount = updatedMembershipType.discount;
      existingType.isLifetime = updatedMembershipType.isLifetime;
      _membershipTypeBox.put(existingType);
    }
  }

  void deleteMembershipType(int id) {
    _membershipTypeBox.remove(id);
  }

  Future<bool> checkTagIDExists(String tagId) async {
    final memberQuery = _memberBox.query(Member_.nfcTagID.equals(tagId))
        .build();
    final adminQuery = _administratorBox.query(
        Administrator_.nfcTagID.equals(tagId)).build();

    final List<Member> members = memberQuery.find();
    final List<Administrator> admins = adminQuery.find();

    return (members.isNotEmpty || admins.isNotEmpty);
  }

// CRUD methods for Administrator entity

  Future<Administrator?> getAdministratorByTagId(String tagId) async {
    // Create a query to find an administrator with the given NFC tag ID
    final query = _administratorBox.query(Administrator_.nfcTagID.equals(tagId))
        .build();

    // Find and return the first matching administrator (or null if not found)
    final List<Administrator> admins = query.find();
    return admins.isNotEmpty ? admins.first : null;
  }


  Future<int> addAdministrator(Administrator admin) async {
    return _administratorBox.put(admin);
  }

  Administrator getAdministrator(int id) {
    return _administratorBox.get(id)!;
  }

  void deleteAdministrator(int id) {
    _administratorBox.remove(id);
  }

  List<Administrator> getAllAdministrators() {
    return _administratorBox.getAll();
  }

  List<Administrator> getStaffAdministrators() {
    final query = _administratorBox.query(Administrator_.type.equals('staff'))
        .build();
    return query.find();
  }

  Future<String?> getAdminNameByLoginDetails({
    String? nfcTagId,
    String? username,
    String? password,
  }) async {
    String? adminName;

    if (nfcTagId != null) {
      // Fetch admin by NFC tag ID
      final adminByNFC = await getAdministratorByTagId(nfcTagId);
      if (adminByNFC != null) {
        adminName = adminByNFC.name;
      }
    } else if (username != null && password != null) {
      // Authenticate admin by username and password
      final authenticatedAdmin = authenticateAdmin(username, password);
      if (authenticatedAdmin != null) {
        adminName = authenticatedAdmin.name;
      }
    }

    return adminName;
  }

  Future<Administrator?> getAdministratorByUsername(String username) async {
    final query = _administratorBox.query(
        Administrator_.username.equals(username)).build();
    final List<Administrator> admins = query.find();
    return admins.isNotEmpty ? admins.first : null;
  }

  void updateAdministrator(Administrator updatedAdmin) async {
    final existingAdmin = _administratorBox.get(updatedAdmin.id);
    if (existingAdmin != null) {
      existingAdmin.name = updatedAdmin.name;
      existingAdmin.username = updatedAdmin.username;
      existingAdmin.password = updatedAdmin.password;

      // Check if the new NFC tag ID exists for any Member or Administrator
      final isTagIDExists = await checkTagIDExists(updatedAdmin.nfcTagID);

      // Update NFC tag ID only if it doesn't exist for any Member or Administrator
      if (!isTagIDExists) {
        existingAdmin.nfcTagID = updatedAdmin.nfcTagID;

        _administratorBox.put(existingAdmin);

        // Update associated Member NFC tag ID if it exists
        final existingMember = _memberBox.get(existingAdmin.id);
        if (existingMember != null) {
          existingMember.nfcTagID = updatedAdmin.nfcTagID;
          _memberBox.put(existingMember);
        }
      }
    }
  }

  // CRUD methods for RenewalLog entity

  // Create a new RenewalLog entry
  Future<int> addRenewalLog(RenewalLog renewalLog) async {
    return _renewalLogBox.put(renewalLog);
  }

  // Retrieve a RenewalLog by ID
  RenewalLog getRenewalLog(int id) {
    return _renewalLogBox.get(id)!;
  }

  // Update an existing RenewalLog entry
  void updateRenewalLog(RenewalLog updatedRenewalLog) {
    _renewalLogBox.put(updatedRenewalLog);
  }

  // Delete a RenewalLog entry by ID
  void deleteRenewalLog(int id) {
    _renewalLogBox.remove(id);
  }

  // Retrieve all RenewalLog entries
  List<RenewalLog> getAllRenewalLogs() {
    return _renewalLogBox.getAll();
  }

  // Retrieve all RenewalLog entries asynchronously
  Future<List<RenewalLog>> getAllRenewalLogsAsync() async {
    return _renewalLogBox.getAllAsync();
  }

  Future<List<RenewalLog>> getRenewalLogsForYear(int year) async {
    final startOfYear = DateTime(year, 1, 1);
    final endOfYear = DateTime(
        year,
        12,
        31,
        23,
        59,
        59,
        999);

    final query = _renewalLogBox.query(
        RenewalLog_.renewalDate.greaterThan(
            startOfYear.millisecondsSinceEpoch) &
        RenewalLog_.renewalDate.lessThan(endOfYear.millisecondsSinceEpoch)
    ).build();

    final renewalLogs = query.find();
    return renewalLogs;
  }

  Administrator? authenticateAdmin(String username, String password) {
    final query = _administratorBox.query(
        Administrator_.username.equals(username)).build();
    final List<Administrator> admins = query.find();
    if (admins.isNotEmpty && admins.first.password == password) {
      return admins.first; // Return the authenticated administrator
    }
    return null; // Return null if authentication fails
  }

  Future<void> addFeedbackUser({
    String? name,
    required String title,
    required String category,
    required String feedbackText,
  }) async {
    final feedback = UserFeedback(
      submissionTime: DateTime.now(),
      feedbackText: feedbackText,
      category: category,
      title: title,
      isUser: true,
      name: name,
    );

    _feedbackBox.put(feedback);
  }

  Future<void> addFeedbackAdmin({
    String? name,
    required String title,
    required String category,
    required String feedbackText,
  }) async {
    final feedback = UserFeedback(
      submissionTime: DateTime.now(),
      feedbackText: feedbackText,
      category: category,
      title: title,
      isUser: false,
      // Assuming this is set for admin submissions
      name: name,
    );

    _feedbackBox.put(feedback);
  }

  UserFeedback getFeedback(int id) {
    return _feedbackBox.get(id)!;
  }

  void updateFeedback(UserFeedback updatedFeedback) {
    _feedbackBox.put(updatedFeedback);
  }

  void deleteFeedback(int id) {
    _feedbackBox.remove(id);
  }

  List<UserFeedback> getAllFeedback() {
    return _feedbackBox.getAll();
  }

  // Retrieve all Feedback entries asynchronously
  Future<List<UserFeedback>> getAllFeedbackAsync() async {
    return _feedbackBox.getAllAsync();
  }

  Future<List<UserFeedback>> getFeedbackSortedByTimeUser(bool isUser) async {
    final query = _feedbackBox
        .query(UserFeedback_.isUser.equals(isUser))
        .order(UserFeedback_.submissionTime, flags: Order.descending)
        .build();
    return query.find();
  }

  Future<List<UserFeedback>> getFeedbackSortedByTimeAdmin(bool isUser) async {
    final query = _feedbackBox
        .query(UserFeedback_.isUser.equals(!isUser))
        .order(UserFeedback_.submissionTime, flags: Order.descending)
        .build();
    return query.find();
  }

  Future<Map<String, Map<String, int>>> getMembershipStatusData() async {
    final List<MembershipType> membershipTypes = _membershipTypeBox.getAll();
    final Map<String, Map<String, int>> membershipData = {};

    for (var type in membershipTypes) {
      final String typeName = type.typeName;

      int activeCount = 0;
      int expiredCount = 0;
      int inactiveCount = 0;

      // Filter members by type
      final membersOfType = _memberBox.query(Member_.membershipType.equals(type.id)).build().find();

      for (var member in membersOfType) {
        switch (member.getMembershipStatus()) {
          case MembershipStatus.active:
            activeCount++;
            break;
          case MembershipStatus.expired:
            expiredCount++;
            break;
          case MembershipStatus.inactive:
            inactiveCount++;
            break;
        }
      }

      membershipData[typeName] = {
        'Active': activeCount,
        'Expired': expiredCount,
        'Inactive': inactiveCount,
      };
    }

    return membershipData;
  }

  // CRUD methods for NewMemberLog entity

  Future<int> addNewMemberLog(NewMemberLog newMemberLog) async {
    return _newMemberLogBox.put(newMemberLog);
  }

  NewMemberLog getNewMemberLog(int id) {
    return _newMemberLogBox.get(id)!;
  }

  void updateNewMemberLog(NewMemberLog updatedNewMemberLog) {
    _newMemberLogBox.put(updatedNewMemberLog);
  }

  void deleteNewMemberLog(int id) {
    _newMemberLogBox.remove(id);
  }

  List<NewMemberLog> getAllNewMemberLogs() {
    return _newMemberLogBox.getAll();
  }

  Future<List<NewMemberLog>> getAllNewMemberLogsAsync() async {
    return _newMemberLogBox.getAllAsync();
  }

  Future<List<NewMemberLog>> getNewMemberLogsForYear(int year) async {
    final startOfYear = DateTime(year, 1, 1);
    final endOfYear = DateTime(
      year,
      12,
      31,
      23,
      59,
      59,
      999,
    );

    final query = _newMemberLogBox.query(
      NewMemberLog_.creationDate.greaterThan(
        startOfYear.millisecondsSinceEpoch,
      ) &
      NewMemberLog_.creationDate.lessThan(
        endOfYear.millisecondsSinceEpoch,
      ),
    ).build();

    final newMemberLogs = query.find();
    return newMemberLogs;
  }
  Future<List<NewMemberLog>> getNewMemberLogsForYearAndMonth(int year, int month) async {
    final startOfMonth = DateTime(year, month, 1).millisecondsSinceEpoch;
    final endOfMonth = DateTime(year, month + 1, 0, 23, 59, 59, 999).millisecondsSinceEpoch;

    final query = _newMemberLogBox.query(
      NewMemberLog_.creationDate.greaterThan(startOfMonth) &
      NewMemberLog_.creationDate.lessThan(endOfMonth),
    ).build();

    final newMemberLogs = query.find();
    return newMemberLogs;
  }


  Future<int> addAdminRenewalLog(AdminRenewalLog adminRenewalLog) async {
    return _adminRenewalLogBox.put(adminRenewalLog);
  }

  AdminRenewalLog getAdminRenewalLog(int id) {
    return _adminRenewalLogBox.get(id)!;
  }

  void updateAdminRenewalLog(AdminRenewalLog updatedAdminRenewalLog) {
    _adminRenewalLogBox.put(updatedAdminRenewalLog);
  }

  void deleteAdminRenewalLog(int id) {
    _adminRenewalLogBox.remove(id);
  }

  List<AdminRenewalLog> getAllAdminRenewalLogs() {
    return _adminRenewalLogBox.getAll();
  }

  Future<List<AdminRenewalLog>> getAllAdminRenewalLogsAsync() async {
    return _adminRenewalLogBox.getAllAsync();
  }

  Future<List<AdminRenewalLog>> getAdminRenewalLogsForYear(int year) async {
    final startOfYear = DateTime(year, 1, 1);
    final endOfYear = DateTime(
      year,
      12,
      31,
      23,
      59,
      59,
      999,
    );

    final query = _adminRenewalLogBox.query(
      AdminRenewalLog_.renewalDate.greaterThan(
        startOfYear.millisecondsSinceEpoch,
      ) &
      AdminRenewalLog_.renewalDate.lessThan(
        endOfYear.millisecondsSinceEpoch,
      ),
    ).build();

    final adminRenewalLogs = query.find();
    return adminRenewalLogs;
  }

}