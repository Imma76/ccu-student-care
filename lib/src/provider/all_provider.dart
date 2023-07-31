



import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student_care/src/controller/auth_controller.dart';

import '../controller/central_state.dart';
import '../controller/image_controller.dart';
import '../controller/postController.dart';

final centralProvider = ChangeNotifierProvider<CentralState>((ref) =>CentralState());
final authProvider = ChangeNotifierProvider<AuthController>((ref) =>AuthController());
final postProvider = ChangeNotifierProvider<PostController>((ref) =>PostController());
final imageProvider = ChangeNotifierProvider<ImageController>((ref) =>ImageController());