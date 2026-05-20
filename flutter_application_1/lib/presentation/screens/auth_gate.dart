import 'package:flutter/material.dart';

import 'auth_gate_state.dart';

/// Controla se exibe auth ou home com base no estado do token.
/// Mantém-se montado na árvore para que logout e troca login/cadastro funcionem.
class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => AuthGateState();
}
