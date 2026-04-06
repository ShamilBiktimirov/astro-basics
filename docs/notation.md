# Notation and conventions (astro-basics)

This document defines the recommended conventions for frames, DCMs, quaternions, and units
used across the toolbox.

## Reference frames

Use explicit suffixes:
- `I` : inertial (specify: J2000/ICRF/EME2000)
- `E` : Earth-fixed (ECEF/ITRF; specify model)
- `B` : body frame
- `O` : orbital / LVLH / RSW / RTN (specify which triad)

## Direction cosine matrices (DCMs)

Recommended naming: `C_A_B` maps coordinates **from frame B to frame A**:

`v_A = C_A_B * v_B`

Notes:
- This is a *passive* transform (change of basis). If you implement *active* rotations,
  document it clearly and avoid mixing conventions.

## Quaternions

State explicitly:
- ordering: scalar-first `[q0; q1; q2; q3]` or scalar-last
- what `q_A_B` means (rotation from B to A, or A to B)
- multiplication convention (left/right)

Recommended check in code:
- always normalize after propagation: `q = q / norm(q);`

## Units

Default:
- angles: radians (unless stated)
- distances: meters
- time: seconds

If a function expects degrees (common for classical orbital elements), make it explicit in:
- the H1 line
- the Inputs section of the docstring

## State vectors

Recommended:
- `rv = [r; v]` where `r` and `v` are 3×1 column vectors
- `x = [r; v; q; w]` etc. should be documented per function/script
