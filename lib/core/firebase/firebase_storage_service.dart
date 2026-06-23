import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:injectable/injectable.dart';

abstract class IFirebaseStorageService {
  Future<String> uploadPdfReport({required String filePath, required String destinationPath});
}

@LazySingleton(as: IFirebaseStorageService)
class FirebaseStorageService implements IFirebaseStorageService {
  final FirebaseStorage _storage;

  FirebaseStorageService() : _storage = FirebaseStorage.instance;

  @override
  Future<String> uploadPdfReport({
    required String filePath,
    required String destinationPath,
  }) async {
    final file = File(filePath);
    final ref = _storage.ref().child(destinationPath);
    final uploadTask = ref.putFile(
      file,
      SettableMetadata(contentType: 'application/pdf'),
    );
    final snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }
}
