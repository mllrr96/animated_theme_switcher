import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

import 'theme_config.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      themeModel: ThemeModel(
        themeMode: ThemeMode.system,
        lightTheme: PinkTheme.light,
        darkTheme: PinkTheme.dark,
      ),
      builder: (context, themeModel) {
        return MaterialApp(
          title: 'Flutter Demo',
          themeMode: themeModel.themeMode,
          theme: themeModel.lightTheme,
          darkTheme: themeModel.darkTheme,
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

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ThemeSwitchingArea(
      child: Scaffold(
        drawer: Drawer(
          child: SafeArea(
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.topRight,
                  child: ThemeSwitcher.withThemeModel(
                    builder: (_, switcher, theme) {
                      return IconButton(
                        onPressed: () => switcher.updateTheme(
                          lightTheme: lightTheme,
                          darkTheme: darkTheme,
                        ),
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
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              const Text(
                'You have pushed the button this many times:',
              ),
              Text(
                '$_counter',
                style: const TextStyle(fontSize: 200),
              ),
              CheckboxListTile(
                title: const Text('Slow Animation'),
                value: timeDilation == 5.0,
                onChanged: (value) {
                  setState(() {
                    timeDilation = value != null && value ? 5.0 : 1.0;
                  });
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ThemeSwitcher.switcher(
                    clipper: const ThemeSwitcherBoxClipper(),
                    builder: (context, switcher) {
                      return TapDownButton(
                        child: const Text('Box Animation'),
                        onTap: (details) {
                          switcher.toggleThemeMode(
                            offset: details.localPosition,
                          );
                        },
                      );
                    },
                  ),
                  ThemeSwitcher(
                    clipper: const ThemeSwitcherCircleClipper(),
                    builder: (context) {
                      return TapDownButton(
                        child: const Text('Circle Animation'),
                        onTap: (details) {
                          context.toggleThemeMode(
                            offset: details.localPosition,
                          );
                        },
                      );
                    },
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ThemeSwitcher(
                    clipper: const ThemeSwitcherBoxClipper(),
                    builder: (context) {
                      return TapDownButton(
                        child: const Text('Box (Reverse)'),
                        onTap: (details) {
                          final themeModel =
                              ThemeModelInheritedNotifier.of(context)
                                  .themeModel;
                          final correctTheme =
                              themeModel.themeMode == ThemeMode.system
                                  ? MediaQuery.of(context).platformBrightness ==
                                          Brightness.dark
                                      ? themeModel.darkTheme
                                      : themeModel.lightTheme
                                  : themeModel.themeMode == ThemeMode.light
                                      ? themeModel.lightTheme
                                      : themeModel.darkTheme;
                          context.toggleThemeMode(
                            offset: details.localPosition,
                            isReversed:
                                correctTheme.brightness == Brightness.dark
                                    ? true
                                    : false,
                          );
                        },
                      );
                    },
                  ),
                  ThemeSwitcher(
                    clipper: const ThemeSwitcherCircleClipper(),
                    builder: (context) {
                      return TapDownButton(
                        child: const Text('Circle (Reverse)'),
                        onTap: (details) {
                          final themeModel =
                              ThemeModelInheritedNotifier.of(context)
                                  .themeModel;
                          final correctTheme =
                              themeModel.themeMode == ThemeMode.system
                                  ? MediaQuery.of(context).platformBrightness ==
                                          Brightness.dark
                                      ? themeModel.darkTheme
                                      : themeModel.lightTheme
                                  : themeModel.themeMode == ThemeMode.light
                                      ? themeModel.lightTheme
                                      : themeModel.darkTheme;
                          context.toggleThemeMode(
                            offset: details.localPosition,
                            isReversed:
                                correctTheme.brightness == Brightness.dark
                                    ? true
                                    : false,
                          );
                        },
                      );
                    },
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ThemeSwitcher(
                    builder: (context) {
                      return Checkbox(
                        value: ThemeModelInheritedNotifier.of(context)
                                    .lightTheme ==
                                PinkTheme.light ||
                            ThemeModelInheritedNotifier.of(context).darkTheme ==
                                PinkTheme.dark,
                        onChanged: (needPink) {
                          final pink = needPink ?? false;
                          final themeModel = ThemeModel(
                              themeMode: ThemeMode.system,
                              lightTheme: pink ? PinkTheme.light : lightTheme,
                              darkTheme: pink ? PinkTheme.dark : darkTheme);
                          context.updateTheme(
                              lightTheme: themeModel.lightTheme,
                              darkTheme: themeModel.darkTheme);
                        },
                      );
                    },
                  ),
                  ThemeSwitcher(
                    builder: (context) {
                      return Checkbox(
                        value: ThemeModelInheritedNotifier.of(context)
                                .themeModel ==
                            BlueTheme.dark,
                        onChanged: (needDarkBlue) {
                          // ThemeSwitcher.of(context).changeTheme(
                          //   theme: needDarkBlue != null && needDarkBlue
                          //       ? darkBlueTheme
                          //       : lightTheme,
                          // );
                        },
                      );
                    },
                  ),
                  ThemeSwitcher(
                    builder: (context) {
                      return Checkbox(
                        value: ThemeModelInheritedNotifier.of(context)
                                    .lightTheme ==
                                HalloweenTheme.light ||
                            ThemeModelInheritedNotifier.of(context).darkTheme ==
                                HalloweenTheme.dark,
                        onChanged: (needBlue) {
                          // ThemeSwitcher.of(context).changeTheme(
                          //   theme: needBlue != null && needBlue
                          //       ? halloweenTheme
                          //       : lightTheme,
                          // );
                        },
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _incrementCounter,
          tooltip: 'Increment',
          child: const Icon(
            Icons.add,
          ),
        ),
      ),
    );
  }
}

class TapDownButton extends StatelessWidget {
  const TapDownButton({
    Key? key,
    required this.onTap,
    required this.child,
  }) : super(key: key);

  final void Function(TapDownDetails details) onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 16.0,
          horizontal: 24.0,
        ),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(24.0),
          ),
          border: Border.all(width: 1.0),
        ),
        child: child,
      ),
    );
  }
}
