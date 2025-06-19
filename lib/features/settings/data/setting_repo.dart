abstract class SettingRepo {
  Future<bool> fetchAutomaticAssignment();
  Future<void> updateAutomaticAssignment(bool value);
}
