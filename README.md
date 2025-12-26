# astro-basics

**astro-basics** is a lightweight MATLAB toolbox providing reusable building blocks for
**astrodynamics and spacecraft dynamics&control research**.  
It is intended as a *research support library*, not a monolithic mission-analysis framework.

The repository collects frequently used utilities for:
- coordinate and reference frame transformations
- orbital and relative motion dynamics & control
- rigid body kinematics and dynamics & control
- coverage analysis and simulation 
- interplanetary mission design
- numerical analysis and visualization

The focus is on **clarity, modularity, and reusability** for academic and applied research.

---

## Repository structure

```text
astro-basics/
├─ control/                    # Control-related utilities
├─ coordinateTransformations/  # Frame transforms, DCMs, time/rotation utilities
├─ coreInterplanetary/         # Interplanetary mission design helpers
├─ orbitDesign/                # Orbit design and secular properties
├─ rhs/                        # Right-hand-side dynamics models for integration
├─ quaternions/                # Quaternion utilities
├─ coverageGeometry/           # Coverage and geometric metrics
├─ forceTorqueModels/          # Force and torque models
├─ visualization/              # Plotting and visualization helpers
├─ miscellaneous/              # General-purpose utilities
├─ examples/                   # Example scripts and demonstrations
├─ data/                       # Constants and reference data
├─ docs/                       # Documentation (notation, API reference)
├─ README.md                   # Project overview
├─ LICENSE                     # MIT license
└─ CITATION.cff                # Citation metadata
```



---

## Installation

Clone or download the repository and add it to your MATLAB path:

```matlab
addpath(genpath('<path-to>/astro-basics'));
savepath;
```

Alternatively, place the path addition in your startup.m or a MATLAB project file .prj

---

## Quick start

Explore the example scripts located in the examples/ folder.
They demonstrate typical use cases such as:
- orbital motion dynamics
- angular motion dynamics
- Earth coverage analysis
- dV map design for an interplanetary transfer


--- 

## Documentation

Additional documentation is provided in the docs/ folder:
docs/notation.md

Reference-frame conventions, DCM notation, quaternion conventions, and units.
docs/api_reference.md

Function-level API reference grouped by module (auto-generated from code).
Users are encouraged to consult these documents before extending the toolbox.


### Conventions

- Units: SI units are used unless explicitly stated otherwise.
- Vectors: Column vectors (3×1) are assumed by default.
- Frames and DCMs:
  Direction cosine matrices follow the convention
  $$dcm^{AB}$$ — mapping coordinates from frame B to frame A according to $$r^A = dcm^{AB} \cdot r^B$$

---

## Contributors

This repository is primarily developed and maintained by **Shamil Biktimirov**.

The project has also benefited from contributions, discussions, testing, bug fixes, refactoring, enhancements, and feedback by **Fatima Alnaqbi**.

Unless explicitly stated otherwise, contributors are not considered authors of the software for citation purposes.

## Citation
If you use this toolbox in academic work, please cite it using the provided CITATION.cff file in the repository root.
