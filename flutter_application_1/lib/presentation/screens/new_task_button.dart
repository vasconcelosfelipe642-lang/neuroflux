import 'package:flutter/material.dart';

import 'new_task_button_state.dart';

class NewTaskButton extends StatefulWidget {
  final VoidCallback onPressed;

  const NewTaskButton({super.key, required this.onPressed});

  @override
  State<NewTaskButton> createState() => NewTaskButtonState();
}
