import 'package:firebase_database/firebase_database.dart';

final databaseReference = FirebaseDatabase.instance.reference();

DatabaseReference getDbRef() {
  return databaseReference;
}
