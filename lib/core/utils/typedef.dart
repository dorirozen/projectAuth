import 'package:dartz/dartz.dart';

import '../error/failures.dart';

typedef ResultFuture<T> = Future<Either<Failure, T>>;
typedef ResultVoid = ResultFuture<void>;

typedef DataMap = Map<String, dynamic>;
