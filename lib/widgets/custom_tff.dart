import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTff extends StatefulWidget {
  final TextEditingController controller;
  final AutovalidateMode? autovalidateMode;
  final String? Function(String? value)? validator;
  final Function()? onTap;
  final Function(PointerDownEvent event)? onTapOutside;
  final Function(PointerUpEvent event)? onTapUpOutside;
  final Function()? onEditingComplete;
  final Function(String)? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? textInputType;
  final Widget? label;
  final Widget? prefix;
  final Widget? prefixIcon;
  final Widget? suffix;
  final Widget? suffixIcon;

  final String? labelText;
  final String? prefixText;
  final String? suffixText;

  const CustomTff({
    required this.controller,
    this.autovalidateMode,
    this.validator,
    this.onTap,
    this.onTapOutside,
    this.onTapUpOutside,
    this.onEditingComplete,
    this.onChanged,
    this.inputFormatters,
    this.textInputType,
    this.label,
    this.prefix,
    this.prefixIcon,
    this.suffix,
    this.suffixIcon,
    this.labelText,
    this.prefixText,
    this.suffixText,
  });

  @override
  State<CustomTff> createState() => _CustomTffState();
}

class _CustomTffState extends State<CustomTff> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(

      controller: widget.controller,
      autovalidateMode: widget.autovalidateMode,
      validator: widget.validator,
      onTap: widget.onTap,
      onTapOutside: widget.onTapOutside,
      onTapUpOutside: widget.onTapUpOutside,
      onEditingComplete: widget.onEditingComplete,
      onChanged: widget.onChanged,
      inputFormatters: widget.inputFormatters,
      keyboardType: widget.textInputType,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyLarge,
      decoration: InputDecoration(
        label: widget.label,
        prefix: widget.prefix,
        prefixIcon: widget.prefixIcon,
        suffix: widget.suffix,
        suffixIcon: widget.suffixIcon,
        labelText: widget.labelText,
        prefixText: widget.prefixText,
        suffixText: widget.suffixText,
        labelStyle: Theme.of(context).textTheme.bodyMedium,
        prefixStyle: Theme.of(context).textTheme.bodyMedium,
        suffixStyle: Theme.of(context).textTheme.bodyMedium,
        filled: false,
        border: InputBorder.none,
      ),
    );
  }
}
