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
  static const forgotPasswordLink = 'Esqueceu sua senha ?';
  static const forgotPasswordTitle = 'Recuperar senha';
  static const forgotPasswordSubtitle = 'Informe seu e-mail para receber instruções de recuperação.';
  static const forgotPasswordButton = 'Enviar';
  static const forgotPasswordCancel = 'Cancelar';
  static const forgotPasswordSuccess = 'Se este e-mail estiver cadastrado, enviaremos instruções para recuperação.';
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

  // ── Admin ─────────────────────────────────────────────────
  static const adminPanelLabel = 'Painel de controle,';
  static const adminExclusiveLabel = 'Painel exclusivo,';
  static const adminRoleTitle = 'Administrador';
  static const adminBadge = 'Admin';
  static const adminLogout = 'Sair';
  static const adminOverview = 'Visão Geral';
  static const adminRecentUsers = 'Usuários Recentes';
  static const adminManageUsers = 'Gerenciar Usuários';
  static const adminSeeAll = 'Ver todos →';
  static String adminRegisteredUsers(int n) => '$n Usuários Cadastrados';
  static String adminTasksCreated(int n) => '$n Tarefas Criadas';
  static String adminTasksCompleted(int n) => '$n Tarefas Concluídas';
  static String adminBannedUsers(int n) => '$n Usuários Banidos';
  static const adminBan = 'Banir';
  static const adminBanned = 'Banido';
  static const adminActiveUsers = 'Usuários ativos';
  static const adminBannedSection = 'Usuários banidos';
  static const adminSearchHint = 'Buscar usuário...';
  static const adminTasksCreatedLabel = 'Tarefas\nCriadas';
  static const adminTasksCompletedLabel = 'Tarefas\nConcluídas';
  static const adminCompletionRateLabel = 'Taxa de\nConclusão';
  static const adminRecentActivity = 'Atividade Recente';
  static const adminBanThisUser = 'Banir este usuário';
  static const adminBanTitle = 'Banir Usuário?';
  static const adminBanConfirm = 'Sim, banir usuário';
  static const adminCancel = 'Cancelar';
  static const adminActive = 'Ativo';
  static String adminBanWarning(String nome) =>
      'Esta ação é irreversível. $nome perderá acesso imediato ao app e não poderá fazer login novamente.';
  static String adminUserTasks(int n) => '$n tarefas';
  static String adminUserStatusActive(int tasks) => 'ativo • $tasks tarefas';
  static String adminUserStatusBanned(int tasks) => 'banido • $tasks tarefas';
  static String adminUserSubtitle(int tasks) => '$tasks tarefas · ativo';
  static const adminTaskCompleted = 'Concluída';
  static const adminTaskInProgress = 'Em andamento';
  static String adminActiveCount(int n) => 'Usuários ativos - $n';
  static String adminBannedCount(int n) => 'Usuários banidos - $n';
  static const adminBanSuccess = 'Usuário banido com sucesso.';
  static const adminLoadError = 'Não foi possível carregar os dados.';
  static const adminPromoteToAdmin = 'Promover a administrador';
  static const adminPromoteTitle = 'Promover usuário?';
  static String adminPromoteWarning(String nome) =>
      '$nome terá acesso ao painel administrativo e poderá gerenciar usuários.';
  static const adminPromoteConfirm = 'Sim, promover';
  static const adminPromoteSuccess = 'Usuário promovido a administrador.';
}