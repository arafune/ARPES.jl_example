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
	using Statistics
end

# ╔═╡ 86986ec4-5186-4b11-abc6-8db4bf86cab8
md"""
# Tutorial: ARPES.jl

## Introduction

In ARPES.jl, simple `APRESData` object, which is very thin wrapper of `DimArray` object, named array object constructred in It aims to enable consistent workflows via `ARPESData`, an extension of [DimensionalData.jl](https://rafaqz.github.io/DimensionalData.jl) based data container.

ARPES.jl provides simple `load` function.
This funciton consists of two steps:

* Load the file to convert the DimArray object. (The files in `format/` directry provide this.)

* Conver DimArray object to ARPESData, to align ARPESData convention, from the lab's custom. (The files in the `location/` directory provide this.)

"""

# ╔═╡ c23dbd62-ec44-43aa-a865-46711ea377a2
md"""
## Data loading

By using `load` function, ARPESData is made.

From the suffix, load function identifies the file type format.
The optional argument, `loc`, identify the location of the facilities, which detemine the lab's custom.
"""

# ╔═╡ f68545b1-e548-4d9e-9a19-bb1560fa2ae4
data = load("../ARPES.jl_testdata/spd_standard.itx", loc="SPD")

# ╔═╡ 131c0460-4a16-4323-9f62-177dc447af5f
md"""
## Quick view of ARPESData
As noted above, the ARPESData is the thin wrapper of DimArray.

Here, several important points about ARPESData are pointed out.

* the dimensional name is internally predefined.
	* `phi`: Emission angle along the slit direction.
    * `psi`: Emission Angle perpendicular to the slit direction (For deflector type analyzer).
	* `eV`: Energy (unit is "eV")

	* `delay`: Time for pump-probe experiments.

* metadata, which is Dict object, can be got with `metadata(data)`, contains property of the ARPESData. While the users can handle most of the metadata freely, some of them must be care to use because they are used internally.

	* :workfunction  : The workfunction of the analyser, used in the momentum conversion.
	* :hv or :hν : The excitation photon energy.
	* :β, :χ :δ, :ξ : The angles used in momentum conversion. The definition is taken from Ref []
"""

# ╔═╡ 98faf1fe-06d0-4463-bd8a-1968f07b19db
md"""
## Plot

Since DimArray is designed for work with [Makie.jl](https://docs.makie.org/stable/) and ARPESData is the thin wrapper of DimArray, all plot function must work on ARPESData.

Just `heatmap(data)` shows the cut data, if data is 2D.  
The labels for horizontal and vertical are automatically shown, and colormap bar is also shown.
"""

# ╔═╡ 9a346493-7629-4fac-90f4-ec5b34738da3
heatmap(data)

# ╔═╡ 29fab7f0-8c8d-4008-89db-3d003ec65ed8
md"""
## Data Manipulation

All function defined in DimensionalData.jl must work on ARPESData, for data selection.

### Smoothing
For data smoothing, Kalman filter, boxcar, Savitzky-Golay, gaussian, and binomial filter are provided.  

* `kalman_smooth_dim_llpf`
* `boxcar_filter_dim`
* `sg_filter_dim`
* `binomial_filter_dim`
* `gaussian_filter_dim`

Kalman soomth filter can be used even though the Dimension is not equal-spacing. The other filter can be applied only when the Dimensional data is equally spacing. 

### Derivative analysis

The derivative based analysis, including curvature (1D or 2D), and minimum-gradient analysis, are provided.
"""

# ╔═╡ bedb2ef2-6a42-40cd-961f-9a7070f6ed3f
begin
	f = Figure()
	f1 = Axis(f[1, 1],
			  ylabel="Intensity",
			  xlabel="Final State Energy  ( eV )" )
	gamma = data[phi=Near(0.)]
	lines!(f1, gamma)
	
	f
end 

# ╔═╡ cc3e77f5-b4f5-462e-a1a4-962697124b28
md"""
### Momentum conversion
"""

# ╔═╡ 631ea681-d3be-4437-81f3-dd2abb19c363
begin
band_data = k_conversion(data)
heatmap(band_data)
end

# ╔═╡ afbf32a5-8061-47a7-a750-aa342a590481
begin
	phibin = Bins(10)
	binned_data = groupby(data,  phi => phibin)
	bin_data_mean = mean.(binned_data)
#	heatmap(bin_data_mean)
end

# ╔═╡ 95cfa197-76f4-4a5a-a664-777cda8f98b8


# ╔═╡ 9bad6636-d4c0-4a83-a7a8-0891d6975b4b


# ╔═╡ Cell order:
# ╠═86986ec4-5186-4b11-abc6-8db4bf86cab8
# ╠═64ed254e-28bf-11f1-9c50-87021769f2be
# ╠═c23dbd62-ec44-43aa-a865-46711ea377a2
# ╠═f68545b1-e548-4d9e-9a19-bb1560fa2ae4
# ╠═131c0460-4a16-4323-9f62-177dc447af5f
# ╠═98faf1fe-06d0-4463-bd8a-1968f07b19db
# ╠═9a346493-7629-4fac-90f4-ec5b34738da3
# ╠═29fab7f0-8c8d-4008-89db-3d003ec65ed8
# ╠═bedb2ef2-6a42-40cd-961f-9a7070f6ed3f
# ╠═cc3e77f5-b4f5-462e-a1a4-962697124b28
# ╠═631ea681-d3be-4437-81f3-dd2abb19c363
# ╠═afbf32a5-8061-47a7-a750-aa342a590481
# ╠═95cfa197-76f4-4a5a-a664-777cda8f98b8
# ╠═9bad6636-d4c0-4a83-a7a8-0891d6975b4b
