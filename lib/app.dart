import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:nsfw/file.dart';
import 'package:nsfw/link.dart';
import 'package:profanity_filter/profanity_filter.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final ProfanityFilter _profanityFilter = ProfanityFilter();
  String inputText = '';
  bool badFound = false;
  final TextEditingController _textEditingController = TextEditingController();
  final link = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // final progressController = StreamController<double>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('NSFW'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              if (badFound) const Text('Profanity words found '),
              TextField(
                controller: _textEditingController,
                onChanged: (text) {
                  // Filter out profanity
                  final filteredText = _profanityFilter.censor(text);
                  if (filteredText == text) {
                    inputText = text;
                  } else {
                    setState(() {
                      badFound = true;
                    });
                  }
                  _textEditingController.value = TextEditingValue(
                    text: filteredText,
                    selection: TextSelection.fromPosition(
                      TextPosition(offset: filteredText.length),
                    ),
                  );
                },
                decoration: const InputDecoration(
                  hintText: 'Type something...',
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FromLink(),
                        ));
                  },
                  child: Text('Image Link NSFW')),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NSFWDetectorFile(),
                        ));
                  },
                  child: Text('File NSFW')),
            ],
          ),
        ),
      ),
    );
  }
}
