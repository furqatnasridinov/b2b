import 'package:b2b_seller/core/services/services.dart';
import 'package:flutter/material.dart';

class SnackbarCustomizationScreen extends StatefulWidget {
  const SnackbarCustomizationScreen({super.key});

  static const name = 'snackbarCustomizationScreen';
  static const path = '/snackbarCustomizationScreen';

  @override
  State<SnackbarCustomizationScreen> createState() =>
      _SnackbarCustomizationScreenState();
}

class _SnackbarCustomizationScreenState
    extends State<SnackbarCustomizationScreen> {
  TypeSnackBar? _snackBarType = TypeSnackBar.info;
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: 'Some text to show in Snackbar');
  }

  void _showSnack() {
    switch (_snackBarType) {
      case null:
        throw UnimplementedError();
      case TypeSnackBar.success:
        AppSnackBar.showSuccess(
          context: context,
          message: controller.text,
        );
      case TypeSnackBar.error:
        AppSnackBar.showError(
          context,
          message: controller.text,
        );
      case TypeSnackBar.info:
        AppSnackBar.showInfo(
          context,
          message: controller.text,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SnackBar Sample')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showSnack,
        icon: const Icon(Icons.play_arrow),
        label: const Text('Show Snackbar'),
      ),
      body: ListView(
        children: <Widget>[
          ExpansionTile(
            title: const Text('Behavior'),
            initiallyExpanded: true,
            children: TypeSnackBar.values.map((e) {
              return RadioListTile<TypeSnackBar>(
                  title: Text(e.name),
                  value: e,
                  groupValue: _snackBarType,
                  onChanged: (TypeSnackBar? value) {
                    setState(() {
                      _snackBarType = value;
                    });
                  },
                );
            },).toList(),
            /* <Widget>[
              RadioListTile<TypeSnackBar>(
                title: Text(TypeSnackBar.info.name),
                value: TypeSnackBar.info,
                groupValue: _snackBarType,
                onChanged: (TypeSnackBar? value) {
                  setState(() {
                    _snackBarType = value;
                  });
                },
              ),
              RadioListTile<TypeSnackBar>(
                title: Text(TypeSnackBar.success.name),
                value: TypeSnackBar.success,
                groupValue: _snackBarType,
                onChanged: (TypeSnackBar? value) {
                  setState(() {
                    _snackBarType = value;
                  });
                },
              ),
              RadioListTile<TypeSnackBar>(
                title: Text(TypeSnackBar.error.name),
                value: TypeSnackBar.error,
                groupValue: _snackBarType,
                onChanged: (TypeSnackBar? value) {
                  setState(() {
                    _snackBarType = value;
                  });
                },
              ),
            ], */
          ),

          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              controller: controller,
              maxLines: null,
              onChanged: (value) {
                setState(() {
                  
                });
              },
              onTapOutside: (event) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              decoration: const InputDecoration(
                counterStyle:  TextStyle(
                  height: double.minPositive,
                ),
                counterText: '',
                labelText: 'Snackbar message',
                border: OutlineInputBorder(),
              ),
            ),
          ),

          Column(
            children: TypeSnackBar.values.map(
              (e) {
                return Container(
                  //height: 50,
                  //constraints: const BoxConstraints(maxWidth: 350),
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                  decoration: BoxDecoration(
                    //color: Colors.grey,
                    borderRadius: BorderRadius.circular(16),
                    gradient: e.getGradient(),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  child: _body(e.getIconData()),
                );
              },
            ).toList(),
          ),

          // Avoid hiding content behind the floating action button
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _body(IconData icondata) {
    return Center(
      child: Row(
        children: [
           Icon(
            icondata,
            color: Colors.white,
            size: 32,
          ),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              controller.text,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
