import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../core/constants/kcolors.dart';
import 'app_text.dart';
import 'drop_down.dart';

class MultiSelectDropDown<T> extends StatefulWidget {
  final List<DropDownItem<T>> Function() selected;
  final String hinttext;
  final List<DropDownItem<T>> items;
  final ValueChanged<List<DropDownItem<T>>> onChanged;
  final bool showSearchBar;
  final FormFieldValidator<List<DropDownItem<T>>>? validator;
  final Widget? icon;
  final Widget? trailing;

  const MultiSelectDropDown({
    super.key,
    required this.selected,
    required this.hinttext,
    this.items = const [],
    required this.onChanged,
    this.showSearchBar = true,
    this.validator,
    this.icon,
    this.trailing,
  });

  @override
  State<MultiSelectDropDown<T>> createState() => _MultiSelectDropDown<T>();
}

class _MultiSelectDropDown<T> extends State<MultiSelectDropDown<T>> {
  void onItemDelete(DropDownItem<T> value) {
    List<DropDownItem<T>> selected = [...widget.selected()];
    selected.removeWhere((element) => element.id == value.id);
    widget.onChanged.call(selected);
  }

  List<DropDownItem<T>> get selectedItems => widget.selected();

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(highlightColor: Colors.transparent, splashColor: Colors.transparent),
      child: DropdownButtonFormField2<String>(
        value: null,
        onChanged: (value) {},
        validator: (value) => widget.validator?.call(selectedItems),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 8),
          prefixIcon: widget.icon,
          prefixIconConstraints: BoxConstraints(maxHeight: 40.sw, maxWidth: 40.sw),
          suffixIcon: widget.trailing,
          errorStyle: TextStyle(
            fontFamily: "Poppins",
            fontWeight: FontWeight.w400,
            color: Colors.red,
            fontSize: 12.px,
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: KColors.black10, width: 0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: KColors.black10, width: 0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: KColors.black10, width: 0),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.red, width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.red, width: 1.5),
          ),
          isDense: true,
          filled: true,
          fillColor: KColors.filled,
        ),
        dropdownStyleData: DropdownStyleData(
          padding: EdgeInsets.zero,
          offset: const Offset(0, -5),
          maxHeight: 250,
          elevation: 2,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black12),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        buttonStyleData: const ButtonStyleData(elevation: 10),
        customButton: SizedBox(
          width: double.infinity,
          child: Row(
            children: [
              if (selectedItems.isNotEmpty) ...[
                Expanded(
                  child: Builder(
                    builder: (context) {
                      return Wrap(
                        runSpacing: 0,
                        spacing: 5,
                        children: [
                          ...selectedItems.map((item) {
                            return Chip(
                              padding: const EdgeInsets.all(3),
                              elevation: 0,
                              onDeleted: () => onItemDelete(item),
                              deleteIconColor: KColors.white,
                              color: const WidgetStatePropertyAll(KColors.purple),
                              backgroundColor: KColors.bgColor.withValues(alpha: 0.05),
                              label: AppText(item.title ?? item.id, color: KColors.white, fontWeight: FontWeight.w400),
                              shape: const StadiumBorder(
                                side: BorderSide(color: Colors.transparent),
                              ),
                            );
                          }),
                        ],
                      );
                    },
                  ),
                ),
              ] else ...[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: AppText(
                      widget.hinttext,
                      fontWeight: FontWeight.w400,
                      maxLines: 1,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
              const SizedBox(width: 5),
              const Icon(
                Icons.arrow_drop_down,
                color: KColors.black60,
              ),
            ],
          ),
        ),
        isExpanded: true,
        items: [
          ...widget.items.map(
            (item) {
              return DropdownMenuItem<String>(
                value: item.title ?? item.id,
                child: StatefulBuilder(
                  builder: (context, menuSetState) {
                    List<String> selectedids = [...selectedItems.map((e) => e.id)];

                    return GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        List<DropDownItem<T>> selected = [...selectedItems];
                        List<String> ids = [...selected.map((e) => e.id)];
                        if (ids.contains(item.id)) {
                          selected.removeWhere((element) => element.id == item.id);
                        } else {
                          selected.add(item);
                        }

                        menuSetState(() {});
                        widget.onChanged.call(selected);
                      },
                      child: Row(
                        children: [
                          Expanded(child: AppText(item.title ?? item.id, height: 0, color: Colors.black)),
                          if (selectedids.contains(item.id)) const Icon(Icons.check, color: Colors.black),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
