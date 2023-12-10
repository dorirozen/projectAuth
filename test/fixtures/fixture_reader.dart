import 'dart:io';

String fixture(String fileName) =>
    File('${Directory.current.path}/test/fixtures/$fileName')
        .readAsStringSync();
