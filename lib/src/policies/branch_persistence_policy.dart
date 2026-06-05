import 'package:flutter/foundation.dart';

/// Controls how branch widget state is kept alive.
@immutable
class BranchPersistencePolicy {
  /// Uses an IndexedStack and optionally lazy-loads branches.
  const BranchPersistencePolicy.indexedStack({this.lazyLoadBranches = true});

  /// Whether a branch is built only after it is visited.
  final bool lazyLoadBranches;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is BranchPersistencePolicy &&
            other.lazyLoadBranches == lazyLoadBranches;
  }

  @override
  int get hashCode => lazyLoadBranches.hashCode;
}
