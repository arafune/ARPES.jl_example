### A Pluto.jl notebook ###
# v0.20.24

using Markdown
using InteractiveUtils

# ╔═╡ d46591c2-1305-11f1-9828-95424f3f768a
begin
	using Pkg
   	#Pkg.develop(url="https://github.com/arafune/ARPES.jl")
	Pkg.develop(path="/Users/arafune/src/ARPES.jl/")
	using ARPES
	using CairoMakie
	using DimensionalData
	using Statistics
	Pkg.develop(path="/Users/arafune/src/ARPESPlots.jl/")
	using ARPESPlots
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

# ╔═╡ 93d2d2c4-0e19-492b-9545-fdd5b3b5c6d9
lines(data2[phi(3)])

# ╔═╡ 065bee8a-8893-4d10-94b3-e0a55756257f
data = rebin(data2, :phi, 20)

# ╔═╡ 5984d864-8c64-4cc7-9823-40d120534e1b
supertypes(Axis)

# ╔═╡ f1b89fb8-b3a9-483d-8959-a871856cbe82
heatmap(data)

# ╔═╡ f3a51a13-f572-469d-962c-560ebca62bf5
let

	xi = lookup(data2, :eV)
	t = lookup(data2, :phi)

	fig = Figure()
	ax = Axis3(fig[1,1];
	azimuth=-pi/4, elevation=pi/3,
    xgridvisible=false, ygridvisible=false, zgridvisible=false,
    (Symbol.([:x, :y, :z], "spinecolor_", [2 3]) .=> :transparent)...,
    xlabel="eV", ylabel="Emission Angle  ( degrees )", zlabel="Intensity")

	for (i, a_dimarray) in enumerate(eachslice(data2, dims=:phi))
		stack_axis_value = lookup(data2, :phi)[i]
		lines!(xi, fill(stack_axis_value, length(xi)), parent(a_dimarray), color=:black)

	end
										
fig
end

# ╔═╡ 7048190b-9b05-4c54-9375-ff191cb009a3
let

xi = -15:0.1:15
t = 0:30
u1data = [exp(-(x-0.5*(t-15))^2) for x in xi, t in t]

fig = Figure()
ax = Axis3(fig[1,1];
    azimuth=-1.46, elevation=1,
    xticks=-15:5:15, zticks=0:2,
    limits=(nothing, nothing, (0,2)),
    xgridvisible=false, ygridvisible=false, zgridvisible=false,
    (Symbol.([:x, :y, :z], "spinecolor_", [2 3]) .=> :transparent)...,
    xlabel=L"\xi", ylabel=L"t", zlabel=L"|u|")

for (tval, z) in Iterators.reverse(zip(t, eachcol(u1data)))
    tvals = fill(tval, length(xi))
    band!(Point3.(xi, tvals, 0), Point3.(xi, tvals, z), color=:white)
    lines!(xi, tvals, z, color=:black)
end

fig
end

# ╔═╡ 6c1d895d-dcc2-46b8-8f7c-cdadc14bef49
let

	xi = lookup(data, :eV)
	t = lookup(data, :phi)

	fig = Figure()
	ax = Axis3(fig[1,1];
	azimuth=-pi/4, elevation=pi/3,
    xgridvisible=false, ygridvisible=false, zgridvisible=false,
    (Symbol.([:x, :y, :z], "spinecolor_", [2 3]) .=> :transparent)...,
    xlabel="eV", ylabel="Emission Angle  ( degrees )", zlabel="Intensity")

	for (i, a_dimarray) in enumerate(eachslice(data, dims=:phi))
		stack_axis_value = lookup(data, :phi)[i]
		lines!(xi, fill(stack_axis_value, length(xi)), parent(a_dimarray), color=:black)

	end
										
fig
end

# ╔═╡ 7fef72e9-9f46-41d1-93c7-e31115a75809
let
	fig = Figure()
	ax = Axis3(fig[1,1];
	azimuth=-pi/1.8, elevation=pi/8,
    xgridvisible=false, ygridvisible=false, zgridvisible=false,
    (Symbol.([:x, :y, :z], "spinecolor_", [2 3]) .=> :transparent)...,
    xlabel="eV", ylabel="Emission Angle  ( degrees )", zlabel="Intensity")
	ylims!(ax, 12.5, -11)
	plot = waterfall_dispersion!(ax, data, :phi; mode=:fill)
fig
end

# ╔═╡ 5acc4238-4966-4c47-ae8c-59dc33732c25


# ╔═╡ cb2988f1-116c-4f3a-a309-499b8760fd4f
let
	fig = Figure()
	ax = Axis3(fig[1,1];
	azimuth=-pi/2.8, elevation=pi/8,
    xgridvisible=false, ygridvisible=false, zgridvisible=false,
    (Symbol.([:x, :y, :z], "spinecolor_", [2 3]) .=> :transparent)...,
    xlabel="eV", ylabel="Emission Angle  ( degrees )", zlabel="Intensity")
	ylims!(ax, 12, -12)
	plot = waterfall_dispersion!(ax, data, :phi;
								 cmap=:black,
								 mode=:hide,
								 alpha=1.0,
								 linewidth=0.2 )
	fig
end

# ╔═╡ Cell order:
# ╠═d46591c2-1305-11f1-9828-95424f3f768a
# ╠═7c544b98-aaf2-40cd-ba05-0caca640749a
# ╠═1b009bce-f40e-4e75-a61f-1a55951540d7
# ╠═93d2d2c4-0e19-492b-9545-fdd5b3b5c6d9
# ╠═065bee8a-8893-4d10-94b3-e0a55756257f
# ╠═5984d864-8c64-4cc7-9823-40d120534e1b
# ╠═f1b89fb8-b3a9-483d-8959-a871856cbe82
# ╠═f3a51a13-f572-469d-962c-560ebca62bf5
# ╠═7048190b-9b05-4c54-9375-ff191cb009a3
# ╠═6c1d895d-dcc2-46b8-8f7c-cdadc14bef49
# ╠═7fef72e9-9f46-41d1-93c7-e31115a75809
# ╠═5acc4238-4966-4c47-ae8c-59dc33732c25
# ╠═cb2988f1-116c-4f3a-a309-499b8760fd4f
