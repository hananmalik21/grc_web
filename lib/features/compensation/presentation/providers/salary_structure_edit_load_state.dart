sealed class SalaryStructureEditLoadState {
  const SalaryStructureEditLoadState();
}

class SalaryStructureEditLoading extends SalaryStructureEditLoadState {
  const SalaryStructureEditLoading();
}

class SalaryStructureEditLoaded extends SalaryStructureEditLoadState {
  const SalaryStructureEditLoaded();
}

class SalaryStructureEditError extends SalaryStructureEditLoadState {
  final String message;
  const SalaryStructureEditError(this.message);
}
