// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:post_task/core/utils/validators.dart';

void main() {
  group('Validators', () {
    group('Email Validator', () {
      test('should return null for valid email', () {
        expect(Validators.email('test@example.com'), null);
        expect(Validators.email('user.name@domain.co.uk'), null);
      });

      test('should return error for invalid email', () {
        expect(Validators.email(''), 'Email is required');
        expect(Validators.email('invalid-email'), 'Please enter a valid email');
        expect(Validators.email('test@'), 'Please enter a valid email');
      });
    });

    group('Password Validator', () {
      test('should return null for valid password', () {
        expect(Validators.password('password123'), null);
        expect(Validators.password('123456'), null);
      });

      test('should return error for invalid password', () {
        expect(Validators.password(''), 'Password is required');
        expect(Validators.password('12345'), 'Password must be at least 6 characters');
      });
    });

    group('Username Validator', () {
      test('should return null for valid username', () {
        expect(Validators.username('john'), null);
        expect(Validators.username('user123'), null);
      });

      test('should return error for invalid username', () {
        expect(Validators.username(''), 'Username is required');
        expect(Validators.username('ab'), 'Username must be at least 3 characters');
      });
    });

    group('Post Content Validator', () {
      test('should return null for valid post content', () {
        expect(Validators.postContent('Hello world!'), null);
        expect(Validators.postContent('A' * 500), null);
      });

      test('should return error for invalid post content', () {
        expect(Validators.postContent(''), 'Post content cannot be empty');
        expect(Validators.postContent('A' * 501), 'Post content cannot exceed 500 characters');
      });
    });
  });
}
