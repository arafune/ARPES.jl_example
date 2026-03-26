### A Pluto.jl notebook ###
# v0.20.24

using Markdown
using InteractiveUtils

# ╔═╡ d46591c2-1305-11f1-9828-95424f3f768a
begin
	using Pkg
	Pkg.develop(path="/Users/arafune/src/ARPES.jl/")
	using ARPES
	using GLMakie
	using DimensionalData
	using Statistics
end

# ╔═╡ 7c544b98-aaf2-40cd-ba05-0caca640749a
begin
	data1 = load("/Users/arafune/src/ARPES.jl/testdata/arpes_ch_resolved.itx", loc="SPD")
	data2 = load("/Users/arafune/src/ARPES.jl/testdata/spd_standard.itx", loc="SPD")
	data3 = load("/Users/arafune/OneDrive@NIMS/SpecsLab Prodigy/PES_146/PES_146 2026-01-15_16h23m18s_1_GrIr111.itx", loc="SPD")
end

# ╔═╡ 1b009bce-f40e-4e75-a61f-1a55951540d7
begin
	phibin = Bins(10)
	binned_data = groupby(data2,  phi => phibin)
	bin_data_mean = mean.(binned_data, dims=phi)
#	heatmap(bin_data_mean)
end

# ╔═╡ 6cd95a03-0170-4887-9b1b-7a0cabe89476
bin_data_mean[2]

# ╔═╡ Cell order:
# ╠═d46591c2-1305-11f1-9828-95424f3f768a
# ╠═7c544b98-aaf2-40cd-ba05-0caca640749a
# ╠═1b009bce-f40e-4e75-a61f-1a55951540d7
# ╠═6cd95a03-0170-4887-9b1b-7a0cabe89476
