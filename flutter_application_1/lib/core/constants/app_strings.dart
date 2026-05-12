abstract final class AppStrings {
  // Header
  static const greetingPrefix = 'Bom dia,';
  static const userName = 'Maria Silva';
  static const userInitials = 'MS';

  // Tasks screen
  static const dayProgress = 'Progresso do Dia';
  static const today = 'Hoje';
  static const noTasksTitle = 'Nenhuma tarefa ainda';
  static const noTasksSubtitle = 'Toque em "Nova Tarefa" para começar';
  static const newTask = '+ Nova Tarefa';
  static String tasksCompleted(int done, int total) =>
      '$done de $total tarefas concluídas';

  // Modal
  static const modalTitle = 'Nova Tarefa';
  static const taskFieldLabel = 'O que você precisa fazer?';
  static const taskFieldHint = 'Ex: Tomar remédio às 14h';
  static const subtaskFieldLabel = 'Subtarefas (opcional)';
  static const subtaskFieldHint = 'Ex: Separar documentos';
  static const addSubtask = 'Adicionar';
  static const addTask = 'Adicionar Tarefa';

  // Progress screen
  static const tasksComplete = 'Tarefas Completas';
  static const tasksPending = 'Tarefas Pendentes';

  // Bottom nav
  static const navTasks = 'Tarefas';
  static const navProgress = 'Progresso';
}
