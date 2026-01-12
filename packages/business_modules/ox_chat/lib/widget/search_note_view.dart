import 'package:flutter/material.dart';
import 'package:ox_common/mixin/common_state_view_mixin.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:ox_module_service/ox_module_service.dart';
import 'package:chatcore/chat-core.dart';
import 'package:ox_discovery/model/moment_extension_model.dart';

class SearchNoteView extends StatefulWidget {
  final String searchQuery;

  const SearchNoteView({super.key, required this.searchQuery});

  @override
  State<SearchNoteView> createState() => _SearchNoteViewState();
}

class _SearchNoteViewState extends State<SearchNoteView>
    with CommonStateViewMixin {

  List<NoteDBISAR> _notes = [];
  String _currentSearchKeyword = ''; // Track current search keyword to ignore stale callbacks

  @override
  void initState() {
    super.initState();
    if (widget.searchQuery.isNotEmpty) {
      _searchNotes(widget.searchQuery);
    } else {
      updateStateView(CommonStateView.CommonStateView_NoData);
    }
  }

  @override
  stateViewCallBack(CommonStateView commonStateView) {
    switch (commonStateView) {
      case CommonStateView.CommonStateView_None:
        break;
      case CommonStateView.CommonStateView_NetworkError:
      case CommonStateView.CommonStateView_NoData:
        break;
      case CommonStateView.CommonStateView_NotLogin:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return commonStateViewWidget(
      context,
      ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 20.px),
        itemBuilder: (context, index) => _buildNoteWidget(_notes[index]),
        itemCount: _notes.length,
      ),
    );
  }

  Widget _buildNoteWidget(NoteDBISAR noteDB) {
    return OXModuleService.invoke(
      'ox_discovery',
      'momentWidget',
      [context],
      {
        #noteDB: noteDB,
      },
    );
  }

  void _searchNotes(String keyword) async {
    if (keyword.isEmpty) {
      _notes.clear();
      _currentSearchKeyword = '';
      updateStateView(CommonStateView.CommonStateView_NoData);
      setState(() {});
      return;
    }
    // Update current search keyword and clear previous results immediately
    _currentSearchKeyword = keyword;
    _notes.clear();
    if (mounted) {
      setState(() {});
    }
    // Show loading during search
    if (!OXLoading.isShow) {
      OXLoading.show();
    }
    try {
      List<NoteDBISAR> noteList = [];
      
      // Check if keyword is a hashtag (starts with #)
      if (keyword.startsWith('#')) {
        // Extract tag name (remove #)
        String tagName = keyword.substring(1);
        if (tagName.isNotEmpty) {
          // Use hashtag search instead of text search
          List<NoteDBISAR>? hashtagResults = await Moment.sharedInstance.loadHashTagsFromRelay(
            [tagName],
            limit: 100,
          );
          // Only use results if this is still the current search
          if (_currentSearchKeyword == keyword && mounted) {
            noteList = hashtagResults ?? [];
            // Filter out reactions
            noteList = noteList.where((note) => !note.isReaction).toList();
          }
        }
      } else {
        // Use regular keyword search for non-hashtag queries
        noteList = await Moment.sharedInstance.searchNotesWithKeyword(
          keyword,
          notesCallBack: (List<NoteDBISAR> newNotes) {
            // Real-time callback: add new notes as they arrive
            // Only process if this is still the current search keyword
            if (_currentSearchKeyword == keyword && mounted) {
              setState(() {
                // Avoid duplicates
                Set<String> existingIds = _notes.map((n) => n.noteId).toSet();
                for (var note in newNotes) {
                  if (!existingIds.contains(note.noteId)) {
                    _notes.add(note);
                    existingIds.add(note.noteId);
                  }
                }
                // Sort by createAt from new to old (descending)
                _notes.sort((a, b) => b.createAt.compareTo(a.createAt));
                if (_notes.isNotEmpty) {
                  updateStateView(CommonStateView.CommonStateView_None);
                }
              });
            }
          },
        );
      }
      
      // Final update with all results
      // Only update if this is still the current search keyword
      if (_currentSearchKeyword == keyword && mounted) {
        setState(() {
          _notes.clear();
          _notes.addAll(noteList);
          if (noteList.isEmpty) {
            updateStateView(CommonStateView.CommonStateView_NoData);
          } else {
            updateStateView(CommonStateView.CommonStateView_None);
          }
        });
      }
    } finally {
      // Hide loading after search completes
      if (OXLoading.isShow) {
        OXLoading.dismiss();
      }
    }
  }

  @override
  void didUpdateWidget(covariant SearchNoteView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.searchQuery != oldWidget.searchQuery) {
      // Clear results immediately when search query changes
      _notes.clear();
      _currentSearchKeyword = '';
      if (mounted) {
        setState(() {});
      }
      _searchNotes(widget.searchQuery);
    }
  }
}
