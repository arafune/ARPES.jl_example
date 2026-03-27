### A Pluto.jl notebook ###
# v0.20.24

using Markdown
using InteractiveUtils

# ╔═╡ 64ed254e-28bf-11f1-9c50-87021769f2be
begin
	using Pkg
	Pkg.develop(path=expanduser("~/src/ARPES.jl/"))
	using ARPES
	using GLMakie
	using DimensionalData
end

# ╔═╡ 86986ec4-5186-4b11-abc6-8db4bf86cab8
md"""
# Tutorial: ARPES.jl

## Introduction

ARPES.jl aims to provide a consistent workflow for ARPES data analysis through ARPESData, a simple data container built on DimensionalData.jl.

In most cases, you will need to:
* **Plot** the measured data.
* **Manipulate** the data using DimensionalData functions, as ARPESData acts as a thin wrapper around DimArray.

To follow this tutorial, the following packages are also required:

* `Makie` (e.g., GLMakie or CairoMakie) for visualization.
* `DimensionalData` for data handling.

"""

# ╔═╡ c23dbd62-ec44-43aa-a865-46711ea377a2
md"""
## Data loading

The load function in ARPES.jl provides a straightforward way to import your data.

It automatically identifies the file format based on the file extension. Additionally, an optional loc (location) argument is used to specify the facility or laboratory, ensuring the data is parsed according to specific local conventions.

### Under the Hood: The Two-Step Process

Internally, the load function executes two distinct steps:

1. **Format Parsing:** The raw file is loaded and converted into a DimArray object. This logic is handled by the scripts in the format/ directory.
2. **Normalization:** The DimArray is converted into an ARPESData object. This step aligns the data with ARPESData conventions based on the specific laboratory's customs, as defined in the location/ directory.
While standard users do not need to worry about this two-step mechanism, it is important to understand if you are using ARPES.jl with data from a new facility. In such cases, you will need to implement two new configuration files and place them in the respective format/ and location/ directories.

Once loaded, the data is returned as an ARPESData object, ready for analysis.
"""

# ╔═╡ f68545b1-e548-4d9e-9a19-bb1560fa2ae4
data = load("../ARPES.jl_testdata/spd_standard.itx", loc="SPD")  #SPD means "Surface PhotoDynamics"

# ╔═╡ 131c0460-4a16-4323-9f62-177dc447af5f
md"""
## Quick view of ARPESData
As mentioned above, ARPESData is a thin wrapper around DimArray. This section highlights several key features and conventions of the ARPESData structure.

### Predefined Dimension Names
To ensure consistency across the package, several dimension names are internally predefined:
- `phi`: Emission angle along the slit direction.
- `psi`: Emission angle perpendicular to the slit direction (for deflector-type analyzers).
- `eV`: Energy (unit: eV).
- `delay`: Time or position for pump-probe experiments.

### Metadata Management
The metadata is stored as a Dict and can be accessed using the metadata(data) function. This dictionary contains essential properties of the ARPES measurement.

While users can freely add or modify most metadata, certain reserved keys are used internally for calculations and should be handled with care:

- `:workfunction`: The work function of the analyzer, used for momentum conversion.
- `:hv` or `:hν`: The excitation photon energy.
- `:history:` A list of transformations applied to the data, used for provenance tracking.  (**Not yet fully impremented**)
- `:β`, `:χ`, `:δ`, `:ξ`: Geometry angles used in momentum conversion. The definitions follow Ref [X].

"""

# ╔═╡ 98faf1fe-06d0-4463-bd8a-1968f07b19db
md"""
## Visualization
Since DimArray is designed to work seamlessly with Makie.jl, and ARPESData is a thin wrapper around DimArray, all standard Makie plotting functions work directly with ARPESData.

For example, simply calling heatmap(data) on a 2D dataset will generate a plot where:
The horizontal and vertical axes are automatically labeled.
A colorbar is included by default.


### A Note on Plotting Philosophy
In principle, ARPES.jl does not provide specialized plotting functions (e.g., custom "ARPES-style" wrappers), even for common visualizations like waterfall plots.

While such functions are undeniably useful for analysis, a "waterfall" plot is typically just a collection of standard Makie functions with heavy fine-tuning. Because plot requirements often change depending on the specific dataset or the parameters being highlighted, a rigid, built-in function is rarely universal.

Instead of providing a fixed function that might need constant revision, we recommend developing your own plotting routines in Pluto.jl or JupyterLab notebooks. This allows you to maintain the flexibility needed for high-quality figures while keeping your specific visualization procedures as a reference for future work.
"""

# ╔═╡ 9a346493-7629-4fac-90f4-ec5b34738da3
heatmap(data)

# ╔═╡ 29fab7f0-8c8d-4008-89db-3d003ec65ed8
md"""
## Data Manipulation

### Selection
Since ARPESData is built on DimensionalData.jl, all selection and slicing functions defined in that package work out of the box. You can leverage its powerful indexing and selecting capabilities to sub-sample your data.

### Binning and Rebinning
DimensionalData provides the Bins object and groupby function, allowing you to perform data binning in just a few lines of code.

While a one-liner is possible using the standard library, ARPES.jl provides a more convenient rebin function for common workflows. This is particularly useful when you need to quickly reduce data density or improve the signal-to-noise ratio.

For example:

```julia
# Bins the data along the :phi direction into 10 divisions
binned_data = rebin(data, :phi, 10)
```
"""

# ╔═╡ bedb2ef2-6a42-40cd-961f-9a7070f6ed3f
begin
	f = Figure()
	f0 = Axis(f[1, 1], 
			  ylabel="Final State Energy  ( eV )",
			  xlabel="Emission Angle  ( deg )")
	heatmap!(f0, data)
	f1 = Axis(f[1, 2],
			  ylabel="Intensity",
			  xlabel="Final State Energy  ( eV )" )
	gamma = data[phi=Near(0.)]
	lines!(f1, gamma)
	f2 = Axis(f[2, 1],
			  ylabel="Final State Energy  ( eV )",
			  xlabel="Emission Angle  ( deg )"
			 )
	heatmap!(f2, data[phi=Touches(-15, .0)])
	f3 = Axis(f[2,2],   ylabel="Final State Energy  ( eV )",
			  xlabel="Emission Angle  ( deg )")
	heatmap!(f3, rebin(data, :phi, 10))
	f
end 

# ╔═╡ dc548a3e-8577-4052-a26e-10f03c140a43
md"""

## Advanced Analysis Tools

### Data Smoothing
ARPES.jl provides several filtering methods to reduce noise and enhance spectral features. These include:

* **Kalman Filter**: `kalman_smooth_dim_llpf`
* **Boxcar Filter**: `boxcar_filter_dim`
* **Savitzky-Golay (SG) Filter**: `sg_filter_dim`
* **Binomial Filter**: `binomial_filter_dim`
* **Gaussian Filter**: `gaussian_filter_dim`

#### Important Note on Grid Spacing:
The Kalman smoothing filter is robust enough to handle data with non-uniform (unequal) dimensional spacing. In contrast, all other filters (Boxcar, SG, Binomial, and Gaussian) require the data to be sampled on an equally spaced grid.

### Derivative Analysis
For identifying dispersive features and band positions, the following derivative-based methods are available:

- Curvature Analysis: Supports both 1D and 2D curvature calculations to highlight peaks and shoulders in the spectra.
- Minimum-Gradient Analysis: Useful for tracking band dispersion by locating local minima in the gradient.
"""

# ╔═╡ c43b8723-cde9-4354-9627-c29b187c77b8


# ╔═╡ cc3e77f5-b4f5-462e-a1a4-962697124b28
md"""
## Momentum Conversion
For converting photoemission data from angles to momentum space (k-space), ARPES.jl provides the k_conversion function.

In most cases, simply calling 
```julia
k_conversion(data)
```
will correctly return the momentum-converted (band) data.

### Core Algorithm
The conversion logic is based on the comprehensive framework summarized by Ishida and Shin [Ref]. Unlike many simplified conversion routines, this implementation does not rely on the small-angle approximation, ensuring high accuracy even for wide-angle measurements.

The function automatically utilizes the geometry and energy parameters stored in the metadata (such as `:workfunction`, `:hv`, and the angles `:β`, `:χ`, `:δ`, `:ξ`) to perform the coordinate transformation.
"""

# ╔═╡ 631ea681-d3be-4437-81f3-dd2abb19c363
begin
	band_data = k_conversion(data)
	heatmap(band_data)
end

# ╔═╡ 95cfa197-76f4-4a5a-a664-777cda8f98b8


# ╔═╡ Cell order:
# ╟─86986ec4-5186-4b11-abc6-8db4bf86cab8
# ╠═64ed254e-28bf-11f1-9c50-87021769f2be
# ╟─c23dbd62-ec44-43aa-a865-46711ea377a2
# ╠═f68545b1-e548-4d9e-9a19-bb1560fa2ae4
# ╠═131c0460-4a16-4323-9f62-177dc447af5f
# ╟─98faf1fe-06d0-4463-bd8a-1968f07b19db
# ╠═9a346493-7629-4fac-90f4-ec5b34738da3
# ╠═29fab7f0-8c8d-4008-89db-3d003ec65ed8
# ╟─bedb2ef2-6a42-40cd-961f-9a7070f6ed3f
# ╠═dc548a3e-8577-4052-a26e-10f03c140a43
# ╠═c43b8723-cde9-4354-9627-c29b187c77b8
# ╟─cc3e77f5-b4f5-462e-a1a4-962697124b28
# ╠═631ea681-d3be-4437-81f3-dd2abb19c363
# ╠═95cfa197-76f4-4a5a-a664-777cda8f98b8
