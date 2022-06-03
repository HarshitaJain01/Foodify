import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:foodify/utils/theme.dart';

import 'InputWrapper.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final isLightMode = Theme.of(context).brightness == Brightness.light;
    return Listener(
      onPointerUp: (e) {
        final rb = context.findRenderObject() as RenderBox;
        final result = BoxHitTestResult();
        rb.hitTest(result, position: e.position);

        final hitTargetIsEditable =
            result.path.any((entry) => entry.target is RenderEditable);

        if (!hitTargetIsEditable) {
          final currentFocus = FocusScope.of(context);
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: LayoutBuilder(
          builder: (context, constraint) {
            return Stack(
              children: [
                Container(
                  width: double.infinity * 1,
                  height: double.infinity * 0.5,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                            "assets/images/loginpage_backgroundimage.jpg"),
                        fit: BoxFit.cover),
                  ),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: screenSize.height * 0.27,
                      ),
                      Expanded(
                          child: SingleChildScrollView(
                        child: Container(
                          decoration: BoxDecoration(
                              color: (isLightMode
                                  ? lightThemeData(context).bottomAppBarColor
                                  : darkThemeData(context)
                                      .scaffoldBackgroundColor),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              )),
                          child: InputWrapper(),
                        ),
                      )),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
