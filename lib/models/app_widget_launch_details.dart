enum NoteWidgetLaunchAction { Select, Add, Show, None }

class NoteWidgetLaunchDetails {
  final String? launchedNoteID;
  final NoteWidgetLaunchAction launchAction;

  NoteWidgetLaunchDetails(
    this.launchedNoteID, {
    this.launchAction = NoteWidgetLaunchAction.None,
  });

  static NoteWidgetLaunchDetails fromMap(Map? map) {
    if (map != null) {
      final noteID = map['noteId'];
      final launchAction = map['launchAction'];

      if (launchAction != -1)
        return NoteWidgetLaunchDetails(noteID, launchAction: NoteWidgetLaunchAction.values[launchAction]);
    }

    return NoteWidgetLaunchDetails(null);
  }
}
