import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eduction_app/src/auth/data/datasources/auth_remote_data_source.dart';
import 'package:eduction_app/src/auth/data/repos/auth_repo_impl.dart';
import 'package:eduction_app/src/auth/domain/repos/auth_repo.dart';
import 'package:eduction_app/src/auth/domain/usecases/forgotpasswordUS.dart';
import 'package:eduction_app/src/auth/domain/usecases/signInUS.dart';
import 'package:eduction_app/src/auth/domain/usecases/signUpUS.dart';
import 'package:eduction_app/src/auth/domain/usecases/updateUserUS.dart';
import 'package:eduction_app/src/auth/presention/bloc/auth_bloc.dart';
import 'package:eduction_app/src/on_boarding/data/repos_impl/on_boarding_repo_impl.dart';
import 'package:eduction_app/src/on_boarding/domain/usecases/cache_first_timer_US.dart';
import 'package:eduction_app/src/on_boarding/domain/usecases/check_if_user_first_time.dart';
import 'package:eduction_app/src/on_boarding/presention/cubit/on_boarding_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../src/on_boarding/data/datasources/on_boarding_local_data_source.dart';
import '../../src/on_boarding/domain/repos/on_boarding_repo.dart';

part 'injection_container.main.dart';
