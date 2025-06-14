import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FilePicker limit parameter tests', () {
    late List<MethodCall> methodCalls;
    
    setUp(() {
      methodCalls = [];
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        const MethodChannel('miguelruivo.flutter.plugins.filepicker'),
        (MethodCall methodCall) async {
          methodCalls.add(methodCall);
          // Return empty list to simulate no files selected
          return <Map<String, dynamic>>[];
        },
      );
    });

    tearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        const MethodChannel('miguelruivo.flutter.plugins.filepicker'),
        null,
      );
    });

    test('pickFiles passes limit parameter correctly', () async {
      // Test with limit
      await FilePicker.platform.pickFiles(
        allowMultiple: true,
        limit: 5,
      );

      expect(methodCalls.length, 1);
      expect(methodCalls.first.method, 'any');
      expect(methodCalls.first.arguments['limit'], 5);
      expect(methodCalls.first.arguments['allowMultipleSelection'], true);
    });

    test('pickFiles works without limit parameter', () async {
      // Test without limit
      await FilePicker.platform.pickFiles(
        allowMultiple: true,
      );

      expect(methodCalls.length, 1);
      expect(methodCalls.first.method, 'any');
      expect(methodCalls.first.arguments['limit'], null);
      expect(methodCalls.first.arguments['allowMultipleSelection'], true);
    });

    test('pickFiles with limit 0 means no limit', () async {
      // Test with limit 0 (should mean no limit)
      await FilePicker.platform.pickFiles(
        allowMultiple: true,
        limit: 0,
      );

      expect(methodCalls.length, 1);
      expect(methodCalls.first.method, 'any');
      expect(methodCalls.first.arguments['limit'], 0);
      expect(methodCalls.first.arguments['allowMultipleSelection'], true);
    });

    test('pickFiles with single selection ignores limit', () async {
      // Test with single selection - limit should still be passed but ignored
      await FilePicker.platform.pickFiles(
        allowMultiple: false,
        limit: 5,
      );

      expect(methodCalls.length, 1);
      expect(methodCalls.first.method, 'any');
      expect(methodCalls.first.arguments['limit'], 5);
      expect(methodCalls.first.arguments['allowMultipleSelection'], false);
    });

    test('pickFiles with media type passes limit correctly', () async {
      // Test with media type
      await FilePicker.platform.pickFiles(
        type: FileType.media,
        allowMultiple: true,
        limit: 3,
      );

      expect(methodCalls.length, 1);
      expect(methodCalls.first.method, 'media');
      expect(methodCalls.first.arguments['limit'], 3);
      expect(methodCalls.first.arguments['allowMultipleSelection'], true);
    });
  });
}
