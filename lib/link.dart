import 'package:flutter/material.dart';
import 'package:nsfw/api/api.dart';

class FromLink extends StatefulWidget {
  const FromLink({super.key});

  @override
  State<FromLink> createState() => _FromLinkState();
}

class _FromLinkState extends State<FromLink> {
  final link = TextEditingController();
  final globalkey = GlobalKey<FormState>();
  bool _isImageNSFW = false;
  bool _isLoading = false;
  String getText = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('From Link'),
      ),
      body: Form(
        key: globalkey,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              TextFormField(
                controller: link,
                decoration: const InputDecoration(
                  hintText: 'Paste link',
                  errorStyle: TextStyle(color: Colors.red),
                  errorBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  focusedErrorBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  hintStyle: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Link Required';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () async {
                  if (globalkey.currentState!.validate()) {
                    setState(() {
                      _isLoading = true;
                    });
                    await APIAccess.detectNSFW(link.text).then((value) {
                      // setState(() {
                      _isImageNSFW = value['unsafe'];
                      getText = (value['objects'] as List)
                          .map((e) => e['label'])
                          .toList()
                          .join(', ');
                      // });
                    });
                    setState(() {
                      _isLoading = false;
                    });
                  }
                },
                child: _isLoading
                    ? SizedBox(
                        height: 14,
                        width: 14,
                        child: const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ))
                    : const Text('Detect NSFW'),
              ),
              if (_isImageNSFW)
                Column(
                  children: [
                    const Text(
                      'The image is NSFW!',
                      style: TextStyle(color: Colors.red),
                    ),
                    Text(getText)
                  ],
                ),
              Text(
                  'YOu will get Information from API as you mention on my Linkedin'),
              Text(getText)
            ],
          ),
        ),
      ),
    );
  }
}
