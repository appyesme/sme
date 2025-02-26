import 'package:flutter/material.dart';

import '../../../env_options.dart';
import '../constants/kcolors.dart';
import '../enums/enums.dart';

const String appName = "sme";
const String appLogo = "assets/images/logo.png";

enum ApiVersion { v1, v2 }

String apiUrlV1 = "${EnvOptions.API_URL}/${ApiVersion.v1.name}";

bool get isENTREPRENEUR => userType == UserType.ENTREPRENEUR;

bool get isLoggedIn => userId != null;

String? _userId;
String? get userId => _userId;
set userId(String? value) => _userId = value;

UserType? _userType;
UserType? get userType => _userType;
set userType(UserType? value) => _userType = value;

String? _authToken;
String? get authToken => _authToken;
set authToken(String? value) => _authToken = value;

const List<BoxShadow> boxShadow = [BoxShadow(color: KColors.black10, blurRadius: 5)];
