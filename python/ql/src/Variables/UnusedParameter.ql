/**
 * @name Unused parameter
 * @description Parameter is defined but not used
 * @kind problem
 * @tags maintainability
 * @problem.severity recommendation
 * @sub-severity high
 * @precision medium
 * @id py/unused-parameter
 */

import python
import Definition


predicate unused_parameter(FunctionObject f, LocalVariable v) {
  v.isParameter() and
  v.getScope() = f.getFunction() and
  not name_acceptable_for_unused_variable(v) and
  not exists(NameNode u | u.uses(v)) and
  not exists(Name inner, LocalVariable iv | inner.uses(iv) and iv.getId() = v.getId() and inner.getScope().getScope() = v.getScope())
}

predicate is_abstract(FunctionObject func) {
    ((Name)func.getFunction().getADecorator()).getId().matches("%abstract%")
}

from PyFunctionObject f, LocalVariable v
where v.getId() != "self" and unused_parameter(f, v) and not f.isOverridingMethod() and not f.isOverriddenMethod() and
not is_abstract(f)
select f, "The parameter '" + v.getId() + "' is never used."
