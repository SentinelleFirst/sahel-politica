class Profile {
  String id;
  String firstname;
  String lastname;
  String email;
  String post;
  Map<String, Map<String, bool>> access;
  DateTime dateOfCreation;

  Profile(this.id, this.firstname, this.lastname, this.email, this.post,
      this.access, this.dateOfCreation);

  factory Profile.empty() {
    Profile p = Profile("", "", "", "", "Custom", {}, DateTime.now());
    p.initCustomAccess();
    return p;
  }

  factory Profile.copy(Profile p) {
    return Profile(p.id, p.firstname, p.lastname, p.email, p.post, p.access,
        p.dateOfCreation);
  }

  void initAdminAccess() {
    Map<String, bool> analyticsPage = {
      "view": true,
    };
    Map<String, bool> articlesPage = {
      "view": true,
      "publish": true,
      "edit": true,
      "create": true,
      "delete": true,
    };
    Map<String, bool> analysisPage = {
      "view": true,
      "publish": true,
      "edit": true,
      "create": true,
      "delete": true,
    };
    Map<String, bool> eventsPage = {
      "view": true,
      "publish": true,
      "edit": true,
      "delete": true,
    };
    Map<String, bool> messagesPage = {
      "view": true,
      "publish": true,
      "delete": true,
    };
    Map<String, bool> reservationsPage = {
      "view": true,
      "publish": true,
      "edit": true,
      "delete": true,
    };
    Map<String, bool> newslettersPage = {
      "view": true,
      "publish": true,
      "edit": true,
      "create": true,
      "delete": true,
    };

    access.addAll({
      "Analytics": analyticsPage,
      "Articles": articlesPage,
      "In-dept analysis": analysisPage,
      "Events": eventsPage,
      "Messages": messagesPage,
      "Reservations": reservationsPage,
      "Newsletters": newslettersPage,
    });
  }

  void initITAccess() {
    Map<String, bool> analyticsPage = {
      "view": true,
    };
    Map<String, bool> articlesPage = {
      "view": true,
      "publish": true,
      "edit": true,
      "create": true,
      "delete": true,
    };
    Map<String, bool> analysisPage = {
      "view": true,
      "publish": true,
      "edit": true,
      "create": true,
      "delete": true,
    };
    Map<String, bool> eventsPage = {
      "view": true,
      "publish": true,
      "edit": true,
      "delete": true,
    };
    Map<String, bool> messagesPage = {
      "view": true,
      "publish": true,
      "delete": true,
    };
    Map<String, bool> reservationsPage = {
      "view": true,
      "publish": true,
      "edit": true,
      "delete": true,
    };
    Map<String, bool> newslettersPage = {
      "view": true,
      "publish": true,
      "edit": true,
      "create": true,
      "delete": true,
    };

    access.addAll({
      "Analytics": analyticsPage,
      "Articles": articlesPage,
      "In-dept analysis": analysisPage,
      "Events": eventsPage,
      "Messages": messagesPage,
      "Reservations": reservationsPage,
      "Newsletters": newslettersPage,
    });
  }

  void initCMAccess() {
    Map<String, bool> analyticsPage = {
      "view": true,
    };
    Map<String, bool> articlesPage = {
      "view": false,
      "publish": false,
      "edit": false,
      "create": false,
      "delete": false,
    };
    Map<String, bool> analysisPage = {
      "view": false,
      "publish": false,
      "edit": false,
      "create": false,
      "delete": false,
    };
    Map<String, bool> eventsPage = {
      "view": true,
      "publish": true,
      "edit": true,
      "delete": true,
    };
    Map<String, bool> messagesPage = {
      "view": true,
      "publish": true,
      "delete": true,
    };
    Map<String, bool> reservationsPage = {
      "view": true,
      "publish": true,
      "edit": true,
      "delete": true,
    };
    Map<String, bool> newslettersPage = {
      "view": true,
      "publish": true,
      "edit": true,
      "create": true,
      "delete": true,
    };

    access.clear();

    access.addAll({
      "Analytics": analyticsPage,
      "Articles": articlesPage,
      "In-dept analysis": analysisPage,
      "Events": eventsPage,
      "Messages": messagesPage,
      "Reservations": reservationsPage,
      "Newsletters": newslettersPage,
    });
  }

  void initEditorAccess() {
    Map<String, bool> analyticsPage = {
      "view": false,
    };
    Map<String, bool> articlesPage = {
      "view": true,
      "publish": true,
      "edit": true,
      "create": true,
      "delete": true,
    };
    Map<String, bool> analysisPage = {
      "view": true,
      "publish": true,
      "edit": true,
      "create": true,
      "delete": true,
    };
    Map<String, bool> eventsPage = {
      "view": false,
      "publish": false,
      "edit": false,
      "delete": false,
    };
    Map<String, bool> messagesPage = {
      "view": false,
      "publish": false,
      "delete": false,
    };
    Map<String, bool> reservationsPage = {
      "view": false,
      "publish": false,
      "edit": false,
      "delete": false,
    };
    Map<String, bool> newslettersPage = {
      "view": false,
      "publish": false,
      "edit": false,
      "create": false,
      "delete": false,
    };

    access.clear();

    access.addAll({
      "Analytics": analyticsPage,
      "Articles": articlesPage,
      "In-dept analysis": analysisPage,
      "Events": eventsPage,
      "Messages": messagesPage,
      "Reservations": reservationsPage,
      "Newsletters": newslettersPage,
    });
  }

  void initCustomAccess() {
    Map<String, bool> analyticsPage = {
      "view": true,
    };
    Map<String, bool> articlesPage = {
      "view": true,
      "publish": false,
      "edit": false,
      "create": false,
      "delete": false,
    };
    Map<String, bool> analysisPage = {
      "view": true,
      "publish": false,
      "edit": false,
      "create": false,
      "delete": false,
    };
    Map<String, bool> eventsPage = {
      "view": true,
      "publish": false,
      "edit": false,
      "delete": false,
    };
    Map<String, bool> messagesPage = {
      "view": true,
      "publish": false,
      "delete": false,
    };
    Map<String, bool> reservationsPage = {
      "view": true,
      "publish": false,
      "edit": false,
      "delete": false,
    };
    Map<String, bool> newslettersPage = {
      "view": true,
      "publish": false,
      "edit": false,
      "create": false,
      "delete": false,
    };

    access.clear();

    access.addAll({
      "Analytics": analyticsPage,
      "Articles": articlesPage,
      "In-dept analysis": analysisPage,
      "Events": eventsPage,
      "Messages": messagesPage,
      "Reservations": reservationsPage,
      "Newsletters": newslettersPage,
    });
  }

  void setAcces(String page, String action, bool active) {
    access[page]![action] = active;
  }

  bool getAcces(String page, String action) {
    return access[page]![action]!;
  }

  String displayName() {
    return '$firstname $lastname';
  }
}
