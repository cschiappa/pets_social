import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pets_social/features/tag/controller/tag_controller.dart';
import 'package:pets_social/features/tag/widgets/chips_input.dart';

class TagTextField extends ConsumerStatefulWidget {
  final String tag;
  final String? helper;
  final String? hintText;
  final String? Function(String?)? validator;
  final GlobalKey<FormState>? formKeyTwo;
  final bool? readOnly;

  const TagTextField({super.key, required this.tag, this.helper, this.hintText, this.validator, this.formKeyTwo, this.readOnly});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TagTextFieldState();
}

class _TagTextFieldState extends ConsumerState<TagTextField> {
  List<String> _suggestions = <String>[];
  final FocusNode _chipFocusNode = FocusNode();
  final ScrollController scrollController = ScrollController();
  bool isLocked = false;

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      return Column(
        children: [
          ChipsInput(
            strutStyle: const StrutStyle(fontSize: 15),
            values: ref.watch(selectedTagsProvider(widget.tag)),
            chipBuilder: _chipBuilder,
            onChanged: _onChanged,
            onTextChanged: _onSearchChanged,
            onSubmitted: _onSubmitted,
            helper: widget.helper,
            hintText: widget.hintText,
            validator: widget.validator,
            formKeyTwo: widget.formKeyTwo,
            readOnly: isLocked,
          ),
          if (_suggestions.isNotEmpty)
            Scrollbar(
              controller: scrollController,
              thumbVisibility: true,
              child: ListView.builder(
                controller: scrollController,
                shrinkWrap: true,
                itemCount: _suggestions.length,
                itemBuilder: (context, index) {
                  final suggestion = _suggestions[index];
                  return ListTile(
                    visualDensity: const VisualDensity(vertical: -4),
                    title: Text(suggestion.tr()),
                    onTap: () {
                      _selectSuggestion.call(suggestion);
                    },
                  );
                },
              ),
            ),
        ],
      );
    });
  }

  //INPUT CHIP
  Widget _chipBuilder(BuildContext context, String tag) {
    final ThemeData theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(right: 3),
      child: InputChip(
        key: ObjectKey(tag),
        deleteIconColor: theme.colorScheme.primary,
        label: Text(tag.tr()),
        onDeleted: () => _onChipDeleted(tag),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: const EdgeInsets.all(2),
      ),
    );
  }

  //SELECTED TAG CHANGES
  void _onChanged(List<String> data) {
    ref.read(selectedTagsProvider(widget.tag).notifier).update((state) => data);
  }

  //SEARCH CHANGES
  Future<void> _onSearchChanged(String value) async {
    final List<String> results = await _suggestionCallback(value);
    final selectedTags = ref.watch(selectedTagsProvider(widget.tag));
    setState(() {
      _suggestions = results.where((String petTag) => !selectedTags.contains(petTag)).toList();
    });
  }

  //SELECT SUGGESTION
  void _selectSuggestion(String tag) {
    ref.read(selectedTagsProvider(widget.tag)).add(tag);
    final petTag = ref.watch(selectedTagsProvider('petTag'));
    final widgetTag = ref.watch(selectedTagsProvider(widget.tag));

    setState(() {
      _suggestions = <String>[];

      if (widgetTag == petTag && petTag.length == 1) {
        isLocked = true;
      }
    });
  }

  //DELETE CHIP
  void _onChipDeleted(String tag) {
    ref.read(selectedTagsProvider(widget.tag)).remove(tag);
    final petTag = ref.watch(selectedTagsProvider('petTag'));
    final widgetTag = ref.watch(selectedTagsProvider(widget.tag));

    setState(() {
      _suggestions = <String>[];

      if (widgetTag == petTag && petTag.length != 1) {
        isLocked = false;
      }
    });
  }

  //SUBMIT
  void _onSubmitted(String text) {
    if (text.trim().isNotEmpty) {
      ref.read(selectedTagsProvider(widget.tag).notifier).update((state) => <String>[...state, text.trim()]);
    } else {
      _chipFocusNode.unfocus();
      ref.read(selectedTagsProvider(widget.tag).notifier).update((state) => <String>[]);
    }
  }

  FutureOr<List<String>> _suggestionCallback(String text) async {
    final petTags = ref.watch(getPetTagsCollectionProvider).valueOrNull;
    if (text.isNotEmpty && petTags != null) {
      return petTags.where((String petTag) {
        return petTag.tr().toLowerCase().contains(text.toLowerCase());
      }).toList();
    }
    return const <String>[];
  }
}
