import 'package:boostnote_mobile/business_logic/model/Folder.dart';
import 'package:boostnote_mobile/business_logic/service/FolderService.dart';
import 'package:boostnote_mobile/business_logic/service/NoteService.dart';
import 'package:boostnote_mobile/business_logic/service/TagService.dart';
import 'package:boostnote_mobile/presentation/localization/app_localizations.dart';
import 'package:boostnote_mobile/presentation/notifiers/FolderNotifier.dart';
import 'package:boostnote_mobile/presentation/notifiers/NoteOverviewNotifier.dart';
import 'package:boostnote_mobile/presentation/notifiers/TagsNotifier.dart';
import 'package:boostnote_mobile/presentation/pages/folders/FoldersPage.dart';
import 'package:boostnote_mobile/presentation/pages/notes/NotesPage.dart';
import 'package:boostnote_mobile/presentation/pages/settings/Settings.dart';
import 'package:boostnote_mobile/presentation/pages/tags/TagsPage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PageNavigator {

  NoteService _noteService = NoteService();
  FolderService _folderService = FolderService();
  TagService _tagService = TagService();
  PageNavigatorState pageNavigatorState;
  List<PageNavigatorState> history;
  NoteOverviewNotifier _noteOverviewNotifier;
  FolderNotifier _folderNotifier;
  TagsNotifier _tagsNotifier;

  static final PageNavigator navigationService = new PageNavigator._internal();

  PageNavigator._internal(){
    history = List();
    pageNavigatorState = PageNavigatorState.ALL_NOTES;
    history.add(pageNavigatorState);
  }

  factory PageNavigator(){
    return navigationService;
  }

  void navigateToAllNotes(BuildContext context){
    _noteOverviewNotifier = Provider.of<NoteOverviewNotifier>(context);
    pageNavigatorState = PageNavigatorState.ALL_NOTES;
    history.add(pageNavigatorState);
    _noteOverviewNotifier.pageTitle = AppLocalizations.of(context).translate('all_notes');

    _noteService.findNotTrashed().then((notes){
      _noteOverviewNotifier.notes = notes;
      Route route = PageRouteBuilder( 
        pageBuilder: (c, a1, a2) => NotesPage(),
        transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
        transitionDuration: Duration(milliseconds: 0),
      );
      Navigator.of(context).push(
        route
      );
    });
  }

  void navigateToNotesInFolder(BuildContext context, Folder folder){
    _noteOverviewNotifier = Provider.of<NoteOverviewNotifier>(context);
    _folderNotifier = Provider.of<FolderNotifier>(context);
    _folderNotifier.selectedFolder = folder;
    pageNavigatorState = PageNavigatorState.NOTES_IN_FOLDER;
    history.add(pageNavigatorState);
    _noteOverviewNotifier.pageTitle = folder.name;

    _noteService.findNotesIn(folder).then((notes){
      _noteOverviewNotifier.notes = notes;
      Route route = PageRouteBuilder( 
        pageBuilder: (c, a1, a2) => NotesPage(),
        transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
        transitionDuration: Duration(milliseconds: 0),
      );
      Navigator.of(context).push(
        route
      );
    });
  }

  void navigateToNotesWithTag(BuildContext context, String tag){
    _noteOverviewNotifier = Provider.of<NoteOverviewNotifier>(context);
    _tagsNotifier = Provider.of<TagsNotifier>(context);
    pageNavigatorState = PageNavigatorState.NOTES_WITH_TAG;
    history.add(pageNavigatorState);
    _noteOverviewNotifier.pageTitle = tag;
    _tagsNotifier.selectedTag = tag;

    _noteService.findNotesByTag(tag).then((notes){
      _noteOverviewNotifier.notes = notes;
      Route route = PageRouteBuilder( 
        pageBuilder: (c, a1, a2) => NotesPage(),
        transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
        transitionDuration: Duration(milliseconds: 0),
      );
      Navigator.of(context).push(
        route
      );
    });
  }

  void navigateToStarredNotes(BuildContext context){
    _noteOverviewNotifier = Provider.of<NoteOverviewNotifier>(context);
    pageNavigatorState = PageNavigatorState.STARRED;
    history.add(pageNavigatorState);
    _noteOverviewNotifier.pageTitle = AppLocalizations.of(context).translate('starredNotes');

    _noteService.findStarred().then((notes){
      _noteOverviewNotifier.notes = notes;
      Route route = PageRouteBuilder( 
        pageBuilder: (c, a1, a2) => NotesPage(),
        transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
        transitionDuration: Duration(milliseconds: 0),
      );
      Navigator.of(context).push(
        route
      );
    });
  }

  void navigateToTrash(BuildContext context){
    _noteOverviewNotifier = Provider.of<NoteOverviewNotifier>(context);
    pageNavigatorState = PageNavigatorState.TRASH;
    history.add(pageNavigatorState);
    _noteOverviewNotifier.pageTitle = AppLocalizations.of(context).translate('trash');

    _noteService.findTrashed().then((notes){
      _noteOverviewNotifier.notes = notes;
      Route route = PageRouteBuilder( 
        pageBuilder: (c, a1, a2) => NotesPage(),
        transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
        transitionDuration: Duration(milliseconds: 0),
      );
      Navigator.of(context).push(
        route
      );
    });
  }

  void navigateToFolders(BuildContext context){
    _folderNotifier =  Provider.of<FolderNotifier>(context);
    pageNavigatorState = PageNavigatorState.FOLDERS;
    history.add(pageNavigatorState);

    _folderService.findAllUntrashed().then((folders) {
      _folderNotifier.folders = folders;
      Route route = PageRouteBuilder( 
        pageBuilder: (c, a1, a2) => FoldersPage(),
        transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
        transitionDuration: Duration(milliseconds: 0),
      );
      Navigator.of(context).push(
        route
      );
    });
  }

  void navigateToTags(BuildContext context){
    _tagsNotifier =  Provider.of<TagsNotifier>(context);
    pageNavigatorState = PageNavigatorState.TAGS;
    history.add(pageNavigatorState);
    
    _tagService.findAll().then((tags) {
      _tagsNotifier.tags = tags;
      Route route = PageRouteBuilder( 
        pageBuilder: (c, a1, a2) => TagsPage(),
        transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
        transitionDuration: Duration(milliseconds: 0),
      );
      Navigator.of(context).push(
        route
      );
    });
  }

  void navigateToSettings(BuildContext context) {
    pageNavigatorState = PageNavigatorState.SETTINGS;
    history.add(pageNavigatorState);
    Route route = PageRouteBuilder( 
      pageBuilder: (c, a1, a2) => Settings(),
      transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
      transitionDuration: Duration(milliseconds: 0),
    );
    Navigator.of(context).push(
      route
    );
  }

  void navigateBack(BuildContext context) {
    history.removeLast();
    pageNavigatorState = history.last;
    _folderNotifier = Provider.of<FolderNotifier>(context);
    _folderNotifier.selectedFolder = null;
    _noteOverviewNotifier = Provider.of<NoteOverviewNotifier>(context);
    switch (pageNavigatorState) {
      case PageNavigatorState.ALL_NOTES:
        _noteService.findNotTrashed().then((notes) => _noteOverviewNotifier.notes = notes);
        break;
      case PageNavigatorState.STARRED:
        _noteService.findStarred().then((notes) => _noteOverviewNotifier.notes = notes);
        break;
      case PageNavigatorState.TRASH:
        _noteService.findTrashed().then((notes) => _noteOverviewNotifier.notes = notes);
        break;
      default:
    }
  }

}

  enum PageNavigatorState {
    ALL_NOTES,
    NOTES_IN_FOLDER,
    NOTES_WITH_TAG,
    FOLDERS,
    TAGS,
    STARRED,
    TRASH,
    SETTINGS,
    ABOUT
  }