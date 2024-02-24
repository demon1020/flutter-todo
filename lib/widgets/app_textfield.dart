import '/core.dart';

class AppTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  bool obscureText;
  final bool showSuffixIcon;
  final FormFieldValidator? validator;
  final TextInputType textInputType;

  AppTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    this.showSuffixIcon = false,
    this.validator,
    this.textInputType = TextInputType.text,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.obscureText,
      validator: widget.validator,
      keyboardType: widget.textInputType,
      decoration: InputDecoration(
        suffixIcon: widget.showSuffixIcon
            ? IconButton(
                onPressed: () {
                  widget.obscureText = !widget.obscureText;
                  setState(() {});
                },
                icon: widget.obscureText
                    ? const Icon(Icons.remove_red_eye_outlined)
                    : const Icon(Icons.lock),
              )
            : const SizedBox.shrink(),
        fillColor: AppColor.lightGrey.withOpacity(0.1),
        filled: true,
        hintText: widget.hintText,
        hintStyle: const TextStyle(color: AppColor.lightGrey),

      ),
    );
  }
}
