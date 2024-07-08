import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:animated_theme_switcher/animated_theme_switcher.dart';

import 'theme_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final themeService = await ThemeService.instance;
  ThemeModel themeModel = themeService.initial;
  runApp(MyApp(themeModel));
}

class MyApp extends StatelessWidget {
  const MyApp(
    this.themeModel, {
    Key? key,
  }) : super(key: key);
  final ThemeModel themeModel;

  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      themeModel: themeModel,
      builder: (_, themeModel) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: themeModel.lightTheme,
          darkTheme: themeModel.darkTheme,
          themeMode: themeModel.themeMode,
          home: const MyHomePage(),
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  Future<ThemeService> future = ThemeService.instance;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ThemeSwitchingArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: _incrementCounter,
          tooltip: 'Increment',
          child: const Icon(
            Icons.add,
          ),
        ),
        drawer: Drawer(
          child: SafeArea(
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.topRight,
                  child: ThemeSwitcher(
                    builder: (context) {
                      return IconButton(
                        onPressed: () async {
                          // final themeSwitcher = ThemeSwitcher.of(context);
                          // final themeName =
                          //     ThemeModelInheritedNotifier.of(context)
                          //                 .theme
                          //                 .brightness ==
                          //             Brightness.light
                          //         ? 'dark'
                          //         : 'light';
                          // final service = await ThemeService.instance
                          //   ..saveTheme(themeName);
                          // final theme = service.getByName(themeName);
                          // themeSwitcher.changeTheme(theme: theme);
                        },
                        icon: const Icon(Icons.brightness_3, size: 25),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        appBar: AppBar(
          title: const Text(
            'Flutter Demo Home Page',
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: const TextStyle(fontSize: 90),
            ),
            FutureBuilder(
                future: future,
                builder: (context, snapshot) {
                  ThemeType? themType = snapshot.data?.getTheme();
                  return ListTile(
                    title: const Text('Themes'),
                    trailing: const Icon(Icons.color_lens),
                    subtitle: Text(themType?.name ?? ''),
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return ThemeSwitcher(builder: (context) {
                              return SimpleDialog(
                                title: const Text('Select Theme'),
                                children: ThemeType.values
                                    .map((e) => SimpleDialogOption(
                                          onPressed: () async {
                                            Navigator.pop(context);
                                            final service =
                                                await ThemeService.instance;
                                            service.saveTheme(e);
                                            context.updateTheme(
                                                animateTransition: false,
                                                lightTheme: e.getThemeData.$1,
                                                darkTheme: e.getThemeData.$2);
                                          },
                                          child: Text(e.name),
                                        ))
                                    .toList(),
                              );
                            });
                          });
                    },
                  );
                }),
            CheckboxListTile(
              title: const Text('Slow Animation'),
              value: timeDilation == 5.0,
              onChanged: (value) {
                setState(() {
                  timeDilation = value! ? 5.0 : 1.0;
                });
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ThemeSwitcher(
                  clipper: const ThemeSwitcherBoxClipper(),
                  builder: (context) {
                    return OutlinedButton(
                      child: const Text('Box Animation'),
                      onPressed: () async {
                        context.toggleThemeMode();
                        // final themeSwitcher = ThemeSwitcher.of(context);

                        // final themeName =
                        //     ThemeModelInheritedNotifier.of(context)
                        //                 .theme
                        //                 .brightness ==
                        //             Brightness.light
                        //         ? 'dark'
                        //         : 'light';
                        // final service = await ThemeService.instance
                        //   ..save(themeName);
                        // final theme = service.getByName(themeName);
                        // themeSwitcher.changeTheme(theme: theme);
                      },
                    );
                  },
                ),
                ThemeSwitcher(
                  clipper: const ThemeSwitcherCircleClipper(),
                  builder: (context) {
                    return OutlinedButton(
                      child: const Text('Circle Animation'),
                      onPressed: () async {
                        context.toggleThemeMode();
                        // final themeSwitcher = ThemeSwitcher.of(context);

                        // final themeName =
                        //     ThemeModelInheritedNotifier.of(context)
                        //                 .theme
                        //                 .brightness ==
                        //             Brightness.light
                        //         ? 'dark'
                        //         : 'light';
                        // final service = await ThemeService.instance
                        //   ..save(themeName);
                        // final theme = service.getByName(themeName);
                        // themeSwitcher.changeTheme(theme: theme);
                      },
                    );
                  },
                )
              ],
            ),
            ThemeSwitcher(builder: (context) {
              return SegmentedButton<ThemeMode>(
                  onSelectionChanged: (themeMode) async {
                    final service = await ThemeService.instance;
                    service.saveThemeMode(themeMode.first);
                    context.updateThemeMode(themeMode: themeMode.first);
                  },
                  segments: ThemeMode.values
                      .map((e) => ButtonSegment<ThemeMode>(
                          value: e, label: Text(e.name)))
                      .toList(),
                  selected: {context.themeMode});
            }),
          ],
        ),
      ),
    );
  }
}

class ThemeService {
  ThemeService._();
  static late SharedPreferences prefs;
  static ThemeService? _instance;

  static Future<ThemeService> get instance async {
    if (_instance == null) {
      prefs = await SharedPreferences.getInstance();
      _instance = ThemeService._();
    }
    return _instance!;
  }

  ThemeModel get initial {
    final themeMode = getThemeMode();
    final theme = getTheme();
    ThemeData light;
    ThemeData dark;
    switch (theme) {
      case ThemeType.flutterDefault:
        light = lightTheme;
        dark = darkTheme;
        break;
      case ThemeType.pink:
        light = PinkTheme.light;
        dark = PinkTheme.dark;
        break;
      case ThemeType.halloween:
        light = HalloweenTheme.light;
        dark = HalloweenTheme.dark;
        break;
      case ThemeType.blue:
        light = BlueTheme.light;
        dark = BlueTheme.dark;
        break;
      case ThemeType.yellow:
        light = YellowTheme.light;
        dark = YellowTheme.dark;
        break;
    }
    return ThemeModel(themeMode: themeMode, lightTheme: light, darkTheme: dark);
  }

  void saveThemeMode(ThemeMode themeMode) {
    prefs.setInt('themeMode', themeMode.index);
  }

  ThemeMode getThemeMode() {
    final index = prefs.getInt('themeMode');
    return ThemeMode.values[index ?? 0];
  }

  ThemeType getTheme() {
    final index = prefs.getInt('theme');
    return ThemeType.values[index ?? 0];
  }

  void saveTheme(ThemeType theme) {
    prefs.setInt('theme', theme.index);
  }
}
