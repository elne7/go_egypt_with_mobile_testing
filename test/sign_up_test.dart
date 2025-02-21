import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_egypt_with_firebase/features/auth/presentation/auth_bloc/auth_bloc.dart';
import 'package:go_egypt_with_firebase/features/auth/presentation/auth_bloc/auth_state.dart';
import 'package:go_egypt_with_firebase/features/auth/presentation/views/sign_up_page.dart';
import 'package:go_egypt_with_firebase/features/auth/presentation/widgets/auth_text_button.dart';
import 'package:go_egypt_with_firebase/features/auth/presentation/widgets/custom_button.dart';
import 'package:go_egypt_with_firebase/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:go_egypt_with_firebase/features/auth/presentation/widgets/title_text.dart';
import 'package:go_egypt_with_firebase/generated/l10n.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

class MockS extends Mock implements S {
  @override
  String get full_name => "Full Name";
  @override
  String get email_address => "Email Address";
  @override
  String get password => "Password";
  @override
  String get please_enter_your_full_name => "Please enter your full name";
  @override
  String get please_enter_a_valid_email => "Please enter a valid email";
  @override
  String get password_should_contain_at_least_6_characters =>
      "Password should contain at least 6 characters";
  String get sign_up =>"Sign up";
}
class MockAuthBloc extends Mock implements AuthBloc {
  @override
  Stream<AuthState> get stream => Stream.empty();
  @override
  AuthState get state => AuthInitial();

}
@GenerateMocks([S,AuthBloc])
void main() {
  late MockAuthBloc mockAuthBloc;
  late MockS mockS;
  late Widget builder;

  setUp(() {
    mockS = MockS();
    mockAuthBloc = MockAuthBloc();

    builder = MaterialApp(
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      locale: const Locale('en'),
      home: BlocProvider<AuthBloc>.value(
        value: mockAuthBloc,
        child: const SignUpPage(),
      ),
    );
  });


  group('SignUpPage Widget Test', () {
    testWidgets('Displays correct widgets', (WidgetTester tester) async {
      await tester.pumpWidget(builder);
      expect(find.byType(TitleText), findsOneWidget);
      expect(find.byType(CustomTextField), findsNWidgets(3));
      expect(find.byType(IntlPhoneField), findsOneWidget);
      expect(find.byType(CustomButton), findsOneWidget);
      expect(find.byType(AuthTextButton), findsOneWidget);
    });

    testWidgets('Validates input fields', (WidgetTester tester) async {
      await tester.pumpWidget(builder);
      await tester.enterText(find.bySemanticsLabel(mockS.full_name), '');
      await tester.tap(find.byType(CustomButton));
      await tester.pumpAndSettle();
      expect(find.text(mockS.please_enter_your_full_name), findsOneWidget);

      await tester.enterText(find.bySemanticsLabel(mockS.email_address), 'h');
      await tester.tap(find.byType(CustomButton));
      await tester.pumpAndSettle();
      expect(find.text(mockS.please_enter_a_valid_email), findsOneWidget);

      await tester.enterText(find.bySemanticsLabel(mockS.password), '123');
      await tester.tap(find.byType(CustomButton));
      await tester.pumpAndSettle();
      expect(find.text(mockS.password_should_contain_at_least_6_characters),
          findsOneWidget);

      await tester.enterText(find.bySemanticsLabel(mockS.full_name), 'Hanan');
      await tester.tap(find.byType(CustomButton));
      await tester.pumpAndSettle();
      await tester.enterText(
          find.bySemanticsLabel(mockS.email_address), 'hanan@gmail.com');
      await tester.tap(find.byType(CustomButton));
      await tester.pumpAndSettle();
      await tester.enterText(find.bySemanticsLabel(mockS.password), '123456');
      await tester.tap(find.byType(CustomButton));
      await tester.pumpAndSettle();
    });


  });
}
