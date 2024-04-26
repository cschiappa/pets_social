import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldInput extends StatefulWidget {
  final TextEditingController? textEditingController;
  final bool isPass;
  final String? labelText;
  final String? initialValue;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final TextInputType textInputType;
  final Widget? prefixIcon;
  final bool? suffixIcon;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization textCapitalization;

  const TextFieldInput({super.key, this.textEditingController, this.isPass = false, this.labelText, required this.textInputType, this.initialValue, this.onChanged, this.validator, this.prefixIcon, this.suffixIcon, this.inputFormatters, this.textCapitalization = TextCapitalization.none});

  @override
  State<TextFieldInput> createState() => _TextFieldInputState();
}

class _TextFieldInputState extends State<TextFieldInput> {
  bool _passwordVisible = true;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return TextFormField(
      textCapitalization: widget.textCapitalization,
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      controller: widget.textEditingController,
      decoration: InputDecoration(
        prefixIcon: widget.prefixIcon,
        filled: true,
        fillColor: const Color.fromARGB(255, 35, 35, 35),
        labelText: widget.labelText,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide(color: theme.colorScheme.secondary),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide(color: theme.colorScheme.secondary),
        ),
        contentPadding: const EdgeInsets.all(15),
        errorMaxLines: 5,
        suffixIcon: widget.suffixIcon == true ? _buildDefaultSuffixIcon() : null,
      ),
      keyboardType: widget.textInputType,
      obscureText: widget.isPass && _passwordVisible,
      initialValue: widget.initialValue,
      onChanged: widget.onChanged,
      validator: widget.validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      inputFormatters: widget.inputFormatters,
    );
  }

  Widget _buildDefaultSuffixIcon() {
    return IconButton(
      icon: Icon(
        _passwordVisible ? Icons.visibility : Icons.visibility_off,
        color: Theme.of(context).primaryColorDark,
      ),
      onPressed: () {
        setState(() {
          _passwordVisible = !_passwordVisible;
        });
      },
    );
  }
}
