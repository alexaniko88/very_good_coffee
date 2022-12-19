#!/usr/bin/env bash
flutter test --coverage
lcov --remove coverage/lcov.info "*.freezed.dart" -o coverage/lcov.info
lcov --remove coverage/lcov.info "*.g.dart" -o coverage/lcov.info
lcov --remove coverage/lcov.info "lib/di/*" -o coverage/lcov.info
lcov --remove coverage/lcov.info "lib/data/modules/modules.dart" -o coverage/lcov.info
lcov --remove coverage/lcov.info "lib/presentation/common/restart_widget.dart" -o coverage/lcov.info
genhtml -o coverage coverage/lcov.info --no-function-coverage -s -p `pwd`
open coverage/index.html