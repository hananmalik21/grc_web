import 'package:grc/features/hiring/application/talent_pools/add_talent_pool_args.dart';
import 'package:grc/features/hiring/application/talent_pools/controllers/add_talent_pool_controller.dart';
import 'package:grc/features/hiring/application/talent_pools/states/add_talent_pool_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final addTalentPoolProvider =
    AutoDisposeNotifierProviderFamily<AddTalentPoolNotifier, AddTalentPoolState, AddTalentPoolArgs>(
      AddTalentPoolNotifier.new,
    );
