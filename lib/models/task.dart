/// L'unica entità del dominio: un'attività della to-do list.
class Task {
  Task({required this.title, this.isImportant = false, this.isDone = false})
    : id = _nextId++;

  static int _nextId = 0;

  /// Identificativo univoco, usato come chiave dei widget nell'elenco.
  final int id;

  /// Testo obbligatorio che descrive l'attività.
  final String title;

  /// Se l'attività è importante (per default no).
  final bool isImportant;

  /// Stato: `false` = da fare, `true` = completata. Una nuova attività è da fare.
  bool isDone;

  void toggleDone() => isDone = !isDone;
}
