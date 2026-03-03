### A Pluto.jl notebook ###
# v0.20.23

using Markdown
using InteractiveUtils

# ╔═╡ d46591c2-1305-11f1-9828-95424f3f768a
begin
	using Pkg
	Pkg.develop(path="/Users/arafune/src/ARPES.jl/")
	using ARPES
	using GLMakie
	using DimensionalData
end

# ╔═╡ 7c544b98-aaf2-40cd-ba05-0caca640749a
begin
	data1 = load("/Users/arafune/src/ARPES.jl/testdata/arpes_ch_resolved.itx", loc="SPD")
	data2 = load("/Users/arafune/src/ARPES.jl/testdata/spd_standard.itx", loc="SPD")
	data3 = load("/Users/arafune/OneDrive@NIMS/SpecsLab Prodigy/PES_146/PES_146 2026-01-15_16h23m18s_1_GrIr111.itx", loc="SPD")
end

# ╔═╡ 49811255-174d-45b1-9502-4d44f891f732
data1

# ╔═╡ Cell order:
# ╠═d46591c2-1305-11f1-9828-95424f3f768a
# ╠═7c544b98-aaf2-40cd-ba05-0caca640749a
# ╠═49811255-174d-45b1-9502-4d44f891f732
