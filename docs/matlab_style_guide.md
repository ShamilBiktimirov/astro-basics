# MATLAB Programming Style Guide

## Requirements

1. **Function, script, and variable names** start with a lowercase letter (e.g., `calcSunVect`).
2. **Class names** start with an uppercase letter (e.g., `Consts`).
3. **Physical constants** must be taken only from the corresponding class `Consts`.  
   If a constant is missing, add it with a proper reference and submit a pull request.
4. **Each script, function, or class** must include a short description specifying its purpose, inputs, outputs, and relevant references (if applicable).
5. **Add a space after commas** in arrays (e.g., `[1, 2, 3]`).
6. **Add spaces before and after mathematical operators** (e.g., `2 * a * cos(i)^2`).
7. **Variables should preferably use SI units**.  
   If non-SI units are used, the unit must be included in the variable name (e.g., `angleDeg`, `lengthKm`).
8. **Word separation in variable names** should follow either camelCase (`angleDeg`) or snake_case (`angle_deg`).  
   In camelCase, each new word starts with an uppercase letter while the rest are lowercase (e.g., `rvOrb`, `sunVec`).  
   This rule also applies to acronyms (e.g., `rvEci`).

## Recommendations

1. **Use clear and descriptive variable names**.  
   If a long name improves clarity, do not hesitate to use it. Avoid names that are only clear within a specific script or to a particular developer.
2. **Use a reasonable amount of comments** to describe code sections, allowing readers to quickly understand the code’s purpose and structure.
