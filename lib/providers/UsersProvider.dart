import 'dart:math';
import 'dart:typed_data';
import 'package:agreement_frontend/constants/Constants.dart';
import 'package:agreement_frontend/exceptions/UserException.dart';
import 'package:agreement_frontend/models/model.dart';
import 'package:flutter/foundation.dart';
import 'package:pointycastle/key_generators/api.dart';
import 'package:pointycastle/key_generators/rsa_key_generator.dart';
import 'package:pointycastle/pointycastle.dart';
import 'package:pointycastle/random/fortuna_random.dart';
import 'package:rsa_encrypt/rsa_encrypt.dart';

class UsersProvider with ChangeNotifier {
  List<User> _users;

  bool _isUserLoggedIn = false;

  bool get isUserLoggedIn {
    return _isUserLoggedIn;
  }

  List<User> get users {
    return [..._users];
  }

  Future<void> autoCreateUser() async {
    Map<String, String> keys = _generateKeyPairs();

    final result = await User(
            private_key: keys["private_key"],
            public_key: keys["public_key"],
            isActive: true,
            createdAt: DateTime.now().millisecondsSinceEpoch,
            updatedAt: DateTime.now().millisecondsSinceEpoch)
        .save();

    if (result > 0) {
      _isUserLoggedIn = true;
      notifyListeners();
    }
  }

  Map<String, String> _generateKeyPairs() {
    final keyParams = RSAKeyGeneratorParameters(BigInt.from(65537), 2048, 5);
    final random = Random.secure();

    List<int> seeds = [];
    for (int i = 0; i < 32; i++) {
      seeds.add(random.nextInt(255));
    }
    final secureRandom = FortunaRandom()
      ..seed(KeyParameter(Uint8List.fromList(seeds)));
    final rngParams = new ParametersWithRandom(keyParams, secureRandom);
    final key = new RSAKeyGenerator()..init(rngParams);
    final keyPair = key.generateKeyPair();
    final rsaHelper = RsaKeyHelper();

    Map<String, String> map = {};
    String encodedPrivateKey =
        rsaHelper.encodePrivateKeyToPemPKCS1(keyPair.privateKey);
    String encodedPublicKey =
        rsaHelper.encodePublicKeyToPemPKCS1(keyPair.publicKey);

    map["private_key"] = encodedPrivateKey;
    map["public_key"] = encodedPublicKey;

    return map;
  }

  Future<void> autoLogin() async {
    final user = await User().select().toSingle();
    if (user != null) {
      _isUserLoggedIn = user.isActive;
      notifyListeners();
    }
  }

  Future<void> userSignIn(final email, final password) async {
    final user = await User()
        .select()
        .email
        .equals(email)
        .and
        .password
        .equals(password)
        .and
        .isActive
        .equals(true)
        .toSingle();
    if (user == null) {
      throw UserException(Constants.USER_DOES_NOT_EXISTS_EXCEPTION_MESSAGE);
    } else {
      _isUserLoggedIn = user.isActive;
      notifyListeners();
    }
  }
}
