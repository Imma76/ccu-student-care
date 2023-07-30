import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Base extends ConsumerStatefulWidget {
  const Base({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _BaseState();
}

class _BaseState extends ConsumerState<Base> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
