abstract final class AppStrings {
  // ── Header ────────────────────────────────────────────────
  static const greetingPrefix = 'Bom dia,';
  static const userInitials = 'MS';

  // ── Tasks screen ──────────────────────────────────────────
  static const dayProgress = 'Progresso do Dia';
  static const today = 'Hoje';
  static const noTasksTitle = 'Nenhuma tarefa ainda';
  static const noTasksSubtitle = 'Toque em "Nova Tarefa" para começar';
  static const newTask = '+ Nova Tarefa';
  static String tasksCompleted(int done, int total) =>
      '$done de $total tarefas concluídas';

  // ── Modal ─────────────────────────────────────────────────
  static const modalTitle = 'Nova Tarefa';
  static const taskFieldLabel = 'O que você precisa fazer?';
  static const taskFieldHint = 'Ex: Tomar remédio às 14h';
  static const subtaskFieldLabel = 'Subtarefas (opcional)';
  static const subtaskFieldHint = 'Ex: Separar documentos';
  static const addSubtask = 'Adicionar';
  static const addTask = 'Adicionar Tarefa';

  // ── Progress screen ───────────────────────────────────────
  static const tasksComplete = 'Tarefas Completas';
  static const tasksPending = 'Tarefas Pendentes';

  // ── Bottom nav ────────────────────────────────────────────
  static const navTasks = 'Tarefas';
  static const navProgress = 'Progresso';

  // ── Auth — compartilhado ──────────────────────────────────
  static const appTagline = 'Pequenas etapas, grandes conquistas';
  static const emailLabel = 'E-mail';
  static const emailHint = 'seu@email.com';
  static const passwordLabel = 'Senha';
  static const passwordHint = '••••••••';

  // ── Auth — Login ──────────────────────────────────────────
  static const loginTitle = 'Bem-vindo de volta';
  static const loginSubtitle = 'Entre para continuar sua jornada';
  static const loginButton = 'Entrar';
  static const noAccount = 'Não tem uma conta? ';
  static const signUpLink = 'Cadastre-se';

  // ── Auth — Register ───────────────────────────────────────
  static const registerTitle = 'Criar conta';
  static const registerSubtitle = 'Comece sua jornada com o NeuroFlux';
  static const nameLabel = 'Nome completo';
  static const nameHint = 'Ex: Maria Silva';
  static const confirmPasswordLabel = 'Confirmar senha';
  static const confirmPasswordHint = '••••••••';
  static const registerButton = 'Criar conta';
  static const hasAccount = 'Já tem uma conta? ';
  static const loginLink = 'Entrar';
  static const termsText =
      'Ao criar conta, você concorda com os Termos de Uso e a Política de Privacidade';

  // ── Erros genéricos ───────────────────────────────────────
  static const genericError = 'Algo deu errado. Tente novamente.';
  static const networkError = 'Sem conexão. Verifique sua internet.';
  static const sessionExpired = 'Usuário ou senha são inválidos';
}