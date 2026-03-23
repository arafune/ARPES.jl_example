# Copilot Instructions

## Commands

- Inspect the Julia environment from the repository root:
  ```bash
  julia --project=. -e 'using Pkg; Pkg.status()'
  ```
- Start Pluto in this project environment, then open `APRES_jl_test.jl` or `APRES_jl_test_filter.jl` from the Pluto UI:
  ```bash
  julia --project=. -e 'using Pluto; Pluto.run()'
  ```

## High-level architecture

- This repository is a Julia example workspace, not the `ARPES.jl` package itself. `Project.toml` pins a notebook-oriented environment and `Manifest.toml` resolves `ARPES` from a sibling checkout at `/Users/arafune/src/ARPES.jl`.
- `APRES_jl_test.jl` is a Pluto notebook for loading ARPES datasets with `load(..., loc="SPD")`, inspecting metadata and dimensional structure, and plotting the loaded result with Makie.
- `APRES_jl_test_filter.jl` is a Pluto notebook for generating synthetic 1D signals, wrapping them in `DimArray` objects with a named `:t` dimension, applying ARPES filter functions, and visually comparing the filtered outputs against the noisy input.
- The real implementation being exercised lives outside this repository in the sibling `ARPES.jl` checkout. Changes to algorithm behavior usually belong there; changes here should focus on notebooks, environment setup, or example workflows.

## Key conventions

- Keep the Pluto notebook format intact. These `.jl` files are exported Pluto notebooks, so preserve the notebook header, cell markers, and execution order comments when editing.
- The notebooks intentionally use `Pkg.develop(path="/Users/arafune/src/ARPES.jl/")` before `using ARPES`. Future changes should assume a local checkout workflow instead of a registry-installed package unless the user asks to make it portable.
- Data access is currently path-based and environment-specific. `APRES_jl_test.jl` mixes repository-adjacent test data from the sibling `ARPES.jl` checkout with a machine-local dataset path, so do not normalize those paths without confirming the desired workflow.
- Work with named dimensions instead of raw positional indexing when extending the notebooks. Existing code uses `DimArray`, `lookup`, `dims`, and `dimnum` to preserve axis semantics.
- `APRES_jl_test_filter.jl` follows a consistent pattern: generate clean/noisy reference data, convert it to `DimArray`, run one ARPES filter per cell, then compare the result in a dedicated Makie figure. Follow that pattern when adding new filter experiments.
- The notebooks currently import `GLMakie` directly even though `Project.toml` lists `WGLMakie`. Preserve the current plotting backend usage unless the user explicitly asks to switch or reconcile it.
