enum SingleNoteWidgetLaunchAction { Select, Add, Show, None }

class SingleNoteWidgetLaunchDetails {
  final String? launchedNoteID;
  final SingleNoteWidgetLaunchAction launchAction;

  const SingleNoteWidgetLaunchDetails(
    this.launchedNoteID, {
    this.launchAction = SingleNoteWidgetLaunchAction.None,
  });

  static SingleNoteWidgetLaunchDetails fromMap(Map? map) {
    if (map != null) {
      final noteID = map['noteId'];
      final launchAction = map['launchAction'];

      if (launchAction != -1)
        return SingleNoteWidgetLaunchDetails(noteID, launchAction: SingleNoteWidgetLaunchAction.values[launchAction]);
    }

    return SingleNoteWidgetLaunchDetails(null);
  }
}
