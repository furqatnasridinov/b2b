import 'package:b2b_seller/core/extensions/context_extension.dart';
import 'package:b2b_seller/core/services/delayed.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchFieldForPaginate extends StatefulWidget {
  const SearchFieldForPaginate({
    required this.searchController,
    required this.onSearch,
    this.hintText,
    this.focusNode,
    super.key,
  });

  final TextEditingController searchController;
  final void Function(String searchQuery) onSearch;
  final String? hintText;
  final FocusNode? focusNode;

  @override
  State<SearchFieldForPaginate> createState() => _SearchFieldForPaginateState();
}

class _SearchFieldForPaginateState extends State<SearchFieldForPaginate> {
  Debouncer debouncer = Debouncer(milliseconds: 1000);
  bool shouldSearch = false;

  @override
  void initState() {
    widget.searchController.addListener(
      () {
        final searchQuery = widget.searchController.text.trim();
        final bool moreThan1Char = searchQuery.length > 1;
        if (moreThan1Char) {
          debouncer.run(() {
            widget.onSearch(searchQuery);
            shouldSearch = true;
          });
        } else if (searchQuery.isEmpty && shouldSearch) {
          debouncer.run(() {
            widget.onSearch('');
            shouldSearch = false;
          });
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;

    return SizedBox(
      height: 48,
      width: double.infinity,
      child: TextField(
        focusNode: widget.focusNode,
        enableInteractiveSelection: false,
        controller: widget.searchController,
        style: context.textTheme.bodyLarge,
        decoration: InputDecoration(
          filled: true,
          fillColor: colors.surfaceContainerLow,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 13),
          hintText: widget.hintText ?? 'Поиск',
          hintStyle: context.textTheme.bodyLarge?.copyWith(
            color: colors.onSurfaceVariant.withValues(alpha: 0.6),
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 16, right: 12),
            child: Icon(
              CupertinoIcons.search,
              size: 22,
              color: colors.onSurfaceVariant.withValues(alpha: 0.7),
            ),
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 50,
            minHeight: 48,
          ),
          suffixIcon: AnimatedBuilder(
            animation: widget.searchController,
            builder: (context, child) {
              if (widget.searchController.text.isNotEmpty) {
                return GestureDetector(
                  onTap: () {
                    widget.searchController.clear();
                  },
                  child: Icon(
                    Icons.close_rounded,
                    size: 19,
                    color: colors.onSurfaceVariant,
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          suffixIconConstraints: const BoxConstraints(
            minWidth: 44,
            minHeight: 48,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),
        ),
        cursorColor: colors.primary,
        onTapOutside: (event) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
      ),
    );
  }
}
