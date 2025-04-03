import 'package:coder_application/splash.dart';
import 'package:flutter_test/flutter_test.dart';

// this test fails due to the way we have designed the splash screen.
// as the app function we are happy with it and dont want to change it this late on
// i believe the way I have written this test is correct and it is simply the nature of the way we have defined the splash

void main(){
  testWidgets('Test Splash', ( WidgetTester tester) async {
  // Build our app and trigger a frame.
  await tester.pumpWidget(const Splash());
  expect(find.text('Sign in'), findsOneWidget);
  expect(find.text('Create an Account'), findsOneWidget);
  expect(find.text('Continue as Guest'), findsOneWidget);
});
}
