library coffee;

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:very_good_coffee/data/models/coffee/coffee_models.dart';
import 'package:very_good_coffee/data/models/result/result.dart';

part 'repository.dart';

part 'entities/coffee.dart';

part 'coffee.freezed.dart';

part 'cubit/coffee_cubit.dart';

part 'cubit/coffee_state.dart';