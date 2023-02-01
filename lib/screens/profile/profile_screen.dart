import 'package:flutter/cupertino.dart';
import 'package:mokamayu/screens/screens.dart';

import '../../services/authentication/auth.dart';

class ProfileScreen extends StatelessWidget {
  final String? uid;

  const ProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AuthService().getCurrentUserID() == uid
        ? CurrentUserProfileContent(uid: uid)
        : OtherUserProfileContent(uid: uid);
  }
}
