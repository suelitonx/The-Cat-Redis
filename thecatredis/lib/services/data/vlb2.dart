import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// ValueListenableBuilder for three ValueListenable
class VLB2<A, B> extends StatelessWidget {
  const VLB2({super.key, required this.first, required this.second, required this.builder, this.child});

  final ValueListenable<A> first;
  final ValueListenable<B> second;
  final Widget? child;
  final Widget Function(BuildContext context, A a, B b, Widget? child) builder;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<A>(
      valueListenable: first,
      builder: (context, a, _) {
        return ValueListenableBuilder<B>(
          valueListenable: second,
          builder: (context, b, _) {
            return builder(context, a, b, child);
          },
        );
      },
    );
  }
}

//With controller
class VLB2C<A, B> extends StatelessWidget {
  const VLB2C({super.key, required this.first, required this.second, required this.builder, this.child, required this.controllerListenable});

  final Listenable controllerListenable;
  final ValueListenable<A> first;
  final ValueListenable<B> second;
  final Widget? child;
  final Widget Function(BuildContext context, A a, B b, Widget? child) builder;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controllerListenable,
      builder: (context, _) {
        return ValueListenableBuilder<A>(
          valueListenable: first,
          builder: (context, a, _) {
            return ValueListenableBuilder<B>(
              valueListenable: second,
              builder: (context, b, _) {
                return builder(context, a, b, child);
              },
            );
          },
        );
      },
    );
  }
}
