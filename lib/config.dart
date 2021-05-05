import 'package:flutter/foundation.dart';

const bool isProduction = bool.fromEnvironment('dart.vm.product');
const bool isDevelopment = !isProduction;

const defaultTargetPlatform = TargetPlatform.android;
final hostToEmulator =
    defaultTargetPlatform == TargetPlatform.android ? '10.0.2.2' : 'localhost';
