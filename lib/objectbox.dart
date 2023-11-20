

import 'models/model.dart';
import 'objectbox.g.dart';


class ObjectBox {
  late final Store _store;
  late final Box<Member> _memberBox;

  ObjectBox._create(this._store) {
    _memberBox = Box<Member>(_store);
  }

  static Future<ObjectBox> create() async {
    final store = await openStore(directory: getObjectBoxDirectory());
    return ObjectBox._create(store);
  }

  void addMember(String name, String membership) {
    final newMember = Member(name: name, membershipType: membership);
    _memberBox.put(newMember);
  }

  Stream<List<Member>> getMembersStream() {
    final query = _memberBox.query().build();
    return query.watch(triggerImmediately: true).map((event) => event.results);
  }

  // Add more methods for other operations as needed

  static String getObjectBoxDirectory() {
    // Replace this with your own directory logic
    // For example:
    // return Directory.current.path + '/objectbox';
    return '';
  }
}
