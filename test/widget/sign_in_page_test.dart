import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obd_vision/features/auth/domain/usecases/sign_in_with_email_usecase.dart';
import 'package:obd_vision/features/auth/domain/usecases/sign_in_with_google_usecase.dart';
import 'package:obd_vision/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:obd_vision/features/auth/presentation/pages/sign_in_page.dart';
import '../unit/sign_in_with_email_usecase_test.dart';

void main() {
  late MockAuthRepo mockRepo;
  late AuthCubit authCubit;

  setUp(() {
    mockRepo = MockAuthRepo();
    authCubit = AuthCubit(
      signInWithEmailUseCase: SignInWithEmailUseCase(mockRepo),
      signInWithGoogleUseCase: SignInWithGoogleUseCase(mockRepo),
    );
  });

  tearDown(() {
    authCubit.close();
  });

  testWidgets('SignInPage renders all Figma components correctly', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<AuthCubit>.value(
          value: authCubit,
          child: const SignInPage(),
        ),
      ),
    );

    // Verify Title & Labels
    expect(find.text('Sign in to your Account'), findsOneWidget);
    expect(find.text('Email address'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Forgot password?'), findsOneWidget);
    expect(find.text('Sign in'), findsOneWidget);
    expect(find.text('other way to sign in'), findsOneWidget);
    expect(find.text('Create Account'), findsOneWidget);

    // Verify Agreement
    expect(find.text('User Agreement'), findsOneWidget);
    expect(find.text('Privacy Policy'), findsOneWidget);
  });

  testWidgets('Tapping Sign in without agreeing to terms shows validation error', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<AuthCubit>.value(
          value: authCubit,
          child: const SignInPage(),
        ),
      ),
    );

    await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
    await tester.enterText(find.byType(TextFormField).last, 'password123');

    // Tap "Sign in" without checking the agreement
    await tester.tap(find.text('Sign in'));
    await tester.pump();

    // Verify SnackBar error
    expect(find.text('You must agree to the User Agreement & Privacy Policy'), findsOneWidget);
  });

  testWidgets('Tapping Sign in with agreement triggers successful login', (tester) async {
    bool loginSuccess = false;

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<AuthCubit>.value(
          value: authCubit,
          child: SignInPage(
            onSignInSuccess: () {
              loginSuccess = true;
            },
          ),
        ),
      ),
    );

    await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
    await tester.enterText(find.byType(TextFormField).last, 'password123');

    // Tap the agreement checkbox
    await tester.tap(find.byKey(const ValueKey('terms_checkbox')));
    await tester.pump();

    // Tap "Sign in"
    await tester.tap(find.text('Sign in'));
    await tester.pump();
    await tester.pumpAndSettle();

    expect(loginSuccess, isTrue);
  });
}
