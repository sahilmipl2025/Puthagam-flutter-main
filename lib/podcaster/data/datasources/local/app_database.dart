import 'package:get_storage/get_storage.dart';

class LocalStorageKeys {
  static const KEY_TOKEN = "token";
  static const KEY_ID = "id";
  static const KEY_NAME = "name";
}

class LocalStorages {
  static final GetStorage _storage = GetStorage();

  static saveAuthorId(String token) {
    _storage.write(LocalStorageKeys.KEY_ID, token);
  }

  static String readAuthorID() {
    return _storage.read(LocalStorageKeys.KEY_ID) ?? "";
  }

  static saveName(String name) {
    _storage.write(LocalStorageKeys.KEY_NAME, name);
  }

  static String readName() {
    return _storage.read(LocalStorageKeys.KEY_NAME) ?? "";
  }
}
