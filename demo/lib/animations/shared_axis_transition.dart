import 'package:animations/animations.dart';
import 'package:demo/tv/focusable.dart';
import 'package:flutter/material.dart';

class MySharedAxisTransitionPage extends StatefulWidget {
  const MySharedAxisTransitionPage({
    super.key,
  });
  @override
  createState() => _MySharedAxisTransitionPageState();
}

class _MySharedAxisTransitionPageState
    extends State<MySharedAxisTransitionPage> {
  SharedAxisTransitionType? _transitionType =
      SharedAxisTransitionType.horizontal;

  int _step = 0;
  bool _reverse = false;

  _backup() {
    if (_step > 0) {
      setState(() {
        _reverse = true;
        _step--;
      });
    }
  }

  void _next() {
    final step = _step + 1;
    if (step < _steps.length) {
      if (_steps[_step].save()) {
        setState(() {
          _reverse = false;
          _step = step;
        });
      }
    }
  }

  final _steps = <_StepView>[];
  @override
  void initState() {
    super.initState();
    _steps.addAll([
      _SinginState(
        next: _next,
      ),
      _SwitchState(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Shared axis"),
        backgroundColor: colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FocusableWidget(
                child: TextButton(
                  onPressed: _backup,
                  child: const Text('BACK'),
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SharedAxisTransitionType.horizontal,
                    SharedAxisTransitionType.vertical,
                    SharedAxisTransitionType.scaled
                  ].map((val) {
                    Widget label;
                    switch (val) {
                      case SharedAxisTransitionType.horizontal:
                        label = const Text('X');
                        break;
                      case SharedAxisTransitionType.vertical:
                        label = const Text('Y');
                        break;
                      default:
                        label = const Text('Z');
                        break;
                    }
                    return Row(children: [
                      FocusableWidget(
                        onOK: (focusNode, event) {
                          setState(() => _transitionType = val);
                          return KeyEventResult.handled;
                        },
                        child: Radio<SharedAxisTransitionType>(
                          value: val,
                          groupValue: _transitionType,
                          onChanged: (value) {
                            setState(() => _transitionType = value);
                          },
                        ),
                      ),
                      label,
                    ]);
                  }).toList(),
                ),
              ),
              FocusableWidget(
                child: TextButton(
                  onPressed: _next,
                  child: const Text('NEXT'),
                ),
              ),
            ],
          ),
          const Divider(thickness: 2.0),
          Expanded(
            child: PageTransitionSwitcher(
              reverse: _reverse,
              transitionBuilder:
                  (child, primaryAnimation, secondaryAnimation) =>
                      SharedAxisTransition(
                animation: primaryAnimation,
                secondaryAnimation: secondaryAnimation,
                transitionType: _transitionType!, // 設置特效
                child: child,
              ),
              child: _steps[_step].build(context),
            ),
          ),
        ],
      ),
      floatingActionButton: _step + 1 != _steps.length
          ? null
          : FloatingActionButton(
              child: const Icon(Icons.send),
              onPressed: () {
                for (var step in _steps) {
                  step.debugPrintValue();
                }
              },
            ),
    );
  }
}

abstract class _StepView {
  Widget build(BuildContext context);
  bool save() {
    return true;
  }

  void debugPrintValue();
}

class _SinginState extends _StepView {
  final form = GlobalKey<FormState>();
  final VoidCallback next;
  _SinginState({
    required this.next,
  });
  String name = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return _SinginView(
      state: this,
    );
  }

  @override
  bool save() {
    final state = form.currentState;
    if (state?.validate() ?? false) {
      state!.save();
      return true;
    }
    return false;
  }

  @override
  void debugPrintValue() {
    debugPrint("name=$name password=$password");
  }
}

class _SinginView extends StatelessWidget {
  const _SinginView({
    Key? key,
    required this.state,
  }) : super(key: key);
  final _SinginState state;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: state.form,
      child: ListView(
        children: [
          TextFormField(
            initialValue: state.name,
            decoration: const InputDecoration(
              labelText: "用戶名",
            ),
            onChanged: (value) {
              state.name = value;
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              return (value?.trim().length ?? 0) < 4 ? "用戶名無效" : null;
            },
            onSaved: (newValue) {
              state.name = newValue?.trim() ?? '';
            },
            onEditingComplete: () {
              FocusScope.of(context).nextFocus();
            },
          ),
          TextFormField(
            initialValue: state.password,
            decoration: const InputDecoration(
              labelText: "密碼",
            ),
            onChanged: (value) {
              state.password = value;
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              return (value?.trim().length ?? 0) < 4 ? "密碼無效" : null;
            },
            onSaved: (newValue) {
              state.password = newValue?.trim() ?? '';
            },
            onEditingComplete: () {
              state.next();
            },
          )
        ],
      ),
    );
  }
}

class _SwitchState extends _StepView {
  _SwitchState();
  @override
  Widget build(BuildContext context) {
    return _SwitchView(state: this);
  }

  bool sendDebug = true;
  bool allowReport = true;
  bool allowNotification = true;
  @override
  void debugPrintValue() {
    debugPrint(
        "sendDebug=$sendDebug allowReport=$allowReport allowNotification=$allowNotification");
  }
}

class _SwitchView extends StatefulWidget {
  const _SwitchView({
    Key? key,
    required this.state,
  }) : super(key: key);
  final _SwitchState state;
  @override
  createState() => _SwitchViewState();
}

class _SwitchViewState extends State<_SwitchView> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SwitchListTile(
          title: const Text("發送測試報告"),
          value: widget.state.sendDebug,
          onChanged: (value) => setState(() => widget.state.sendDebug = value),
        ),
        SwitchListTile(
          title: const Text("允許收集用戶信息"),
          value: widget.state.allowReport,
          onChanged: (value) =>
              setState(() => widget.state.allowReport = value),
        ),
        SwitchListTile(
          title: const Text("接收服務器通知"),
          value: widget.state.allowNotification,
          onChanged: (value) =>
              setState(() => widget.state.allowNotification = value),
        ),
      ],
    );
  }
}
