import 'package:eduction_app/src/on_boarding/domain/usecases/cache_first_timer_US.dart';
import 'package:eduction_app/src/on_boarding/domain/usecases/check_if_user_first_time.dart';
import 'package:mocktail/mocktail.dart';

class MockCacheFirstTimer extends Mock implements CacheFirstTimer {}

class MockCheckIfUserFirstTimer extends Mock implements CheckIfUserFirstTimer {}
