import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_script_siamna/helpers/form_script.dart';
import 'package:get/state_manager.dart';
import 'package:recase/recase.dart';
import 'package:snack/snack.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Column(
            children: [
              Container(
                width: 500,
                child: Column(
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.text,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'[a-zA-Z0-9]')),
                      ],
                      decoration: InputDecoration(
                        labelText: 'App Name',
                      ),
                      controller: TextEditingController(text: 'KawnekTemplate'),
                      onChanged: (value) {
                        var snakeValue = ReCase(value).snakeCase;
                        if (RegExp(r'^[0-9]').hasMatch(snakeValue)) {
                          app_name.value = "_$snakeValue";
                        } else
                          app_name.value = snakeValue;
                      },
                    ),
                    TextFormField(
                      decoration:
                          InputDecoration(labelText: 'Git repository url'),
                      onChanged: (value) {
                        git_url.value = value.replaceFirst(
                            RegExp(r'(http|https):\/\/'), '');
                      },
                      controller: TextEditingController(
                          text:
                              'https://github.com/blalmal10a/laravel11-filament3-template'),
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Git token'),
                      onChanged: (value) => git_token.value = value,
                    ),
                    TextFormField(
                      decoration:
                          InputDecoration(labelText: 'Database password'),
                      controller: TextEditingController(text: 'watoke'),
                      onChanged: (value) => mariadb_password.value = value,
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'PHP EXTENSIONS'),
                      controller: TextEditingController(
                          text: 'intl,mbstring,gd,dom,xml,curl,zip,mysql'),
                      onChanged: (value) => php_extensions.value = value,
                    ),
                    TextFormField(
                      controller: TextEditingController(text: '000-default'),
                      decoration: InputDecoration(labelText: 'DOMAIN NAME'),
                      onChanged: (value) => domain_name.value = value,
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () async {
                        await Clipboard.setData(
                            ClipboardData(text: autoInstallScript));
                        SnackBar(
                          width: 300,
                          behavior: SnackBarBehavior.floating,
                          content: Text('SCRIPT HAS BEEN COPIED TO CLIPBOARD'),
                        ).show(context);
                      },
                      child: Text('COPY SCRIPT'),
                    ),
                  ],
                ),
              ),
              Obx(() => Text(autoInstallScript))
            ],
          ),
        ));
  }
}
