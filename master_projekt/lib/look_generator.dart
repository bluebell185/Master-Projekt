/* hier kommt die Logik hinter der "Generierung" der Looks hin

also Mapping der Antworten zu den fertigen Looks: 
- speichern der Antworten von occasion_description.dart und Weitergabe der Antworten
- basierend auf den Antworten den entsprechenden Look (als fertigen Filter) auswählen bzw. applyen

- Einbinden der DeepAR Kamera (für Application der Filter)

z.b.

String mapLookToFilter(Map<int, String> selectedOptions) {
  // Mapping der Antworten zu fertigen Look-Filtern
  if (selectedOptions.values.containsAll(['Casual', 'Sunny', 'Natural'])) {
    deepArController.switchEffect('assets/filters/look_natural.deepar');
  } else if (selectedOptions.values.containsAll(['Party', 'Rainy', 'Bold'])) {
    deepArController.switchEffect('assets/filters/look_bold.deepar');
  } else if (selectedOptions.values.containsAll(['Wedding', 'Snowy', 'Soft'])) {
    deepArController.switchEffect('assets/filters/look_romantic.deepar');
  }
  // Standard-Look, falls keine passende Kombination gefunden wird
  deepArController.switchEffect('assets/filters/look_default.deepar');
}

*/