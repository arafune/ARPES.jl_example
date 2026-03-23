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
end

# ╔═╡ 7c544b98-aaf2-40cd-ba05-0caca640749a
begin
	data1 = load("/Users/arafune/src/ARPES.jl/testdata/arpes_ch_resolved.itx", loc="SPD")
	data2 = load("/Users/arafune/src/ARPES.jl/testdata/spd_standard.itx", loc="SPD")
	data3 = load("/Users/arafune/OneDrive@NIMS/SpecsLab Prodigy/PES_146/PES_146 2026-01-15_16h23m18s_1_GrIr111.itx", loc="SPD")
end

# ╔═╡ 1b009bce-f40e-4e75-a61f-1a55951540d7
heatmap(data2)

# ╔═╡ 6637ddfd-80b9-412a-8907-95e63b5b21c2
Dict(metadata(data1))

# ╔═╡ 66ec088a-c407-442c-a1ca-2fc12e68ee4a
begin
	shape_str = "200,400,300"
	dims_ = reverse(parse.(Int, split(shape_str, ",")))
end


# ╔═╡ 93631627-d146-4b97-855e-0ab7332dd507


# ╔═╡ 27e468ad-9884-4f87-8c46-e3eb32f43401
# ╠═╡ skip_as_script = true
#=╠═╡
val(data2.dims)
  ╠═╡ =#

# ╔═╡ 7a30575c-3d06-4931-a0e7-7f2fe94bb9ef
data2.dims[dimnum(data2.dims, :phi)]

# ╔═╡ d0556b3a-9dc2-4cde-8e08-ee5373013362
parent(lookup(data2, :eV))

# ╔═╡ 9e639591-b96b-4ef1-8c4b-25285a4d3530
parent(dims(data2)[dimnum(data2,:phi)])

# ╔═╡ 395d3784-943c-4343-856e-b4899cb76b55
typeof(val(lookup(data2, :phi)))

# ╔═╡ 8935e5ee-bf23-4d13-85ea-452b0dac5519
typeof(data2.dims[1])

# ╔═╡ e25e20fd-7756-43da-b2a0-40c11bd75695
typeof(dims(data2)[1]) <: DimensionalData.Dimension

# ╔═╡ 51cbdcc0-4744-47cc-af0e-6d797ca317ba
dims(data3)[1]

# ╔═╡ 071380d7-c149-4bd6-bfc3-54491064583f
x = range(5, 9, length = 120)


# ╔═╡ 3b05b892-a20f-4998-9cb4-76ce09d0d123
x

# ╔═╡ 4b336f59-8641-4c1b-81c1-d6e6a21a2e83
minimum(x)

# ╔═╡ b9c65489-8cf2-4c9b-9774-646fb1dc0b40
maximum(x)

# ╔═╡ ee321e81-bddc-4a5b-bf04-abba1f2bd497
step(x)

# ╔═╡ fdf01142-71e4-45a2-aedb-fdaf433f2842
typeof(x)

# ╔═╡ 90e97f0a-be06-412d-8ef9-17d561c9605c
StepRangeLen <: StepRange 

# ╔═╡ 7b7e2323-e677-4851-a150-0bcd2a8e6130
Range <: LinRange

# ╔═╡ f256c777-1bff-4d86-a446-c25053d9c86c
LinRange <: AbstractArray

# ╔═╡ 1ec47a81-25fc-4854-afc8-c45aa95b0b41
StepRangeLen <: LinRange

# ╔═╡ 2cf480b4-5751-496b-ae19-74a477527188
LinRange <: AbstractArray

# ╔═╡ d659d3da-34b8-437f-83e6-6294447f2599
supertype(supertype(typeof(x)))

# ╔═╡ 742fc928-7512-4288-b743-d2026aee2fba
y = [1, 2, 3, 4]

# ╔═╡ ee4591b6-1682-468e-b8e3-8b8d84024cd3
y .- 1

# ╔═╡ Cell order:
# ╠═d46591c2-1305-11f1-9828-95424f3f768a
# ╠═7c544b98-aaf2-40cd-ba05-0caca640749a
# ╠═1b009bce-f40e-4e75-a61f-1a55951540d7
# ╠═6637ddfd-80b9-412a-8907-95e63b5b21c2
# ╠═66ec088a-c407-442c-a1ca-2fc12e68ee4a
# ╠═93631627-d146-4b97-855e-0ab7332dd507
# ╠═27e468ad-9884-4f87-8c46-e3eb32f43401
# ╠═7a30575c-3d06-4931-a0e7-7f2fe94bb9ef
# ╠═d0556b3a-9dc2-4cde-8e08-ee5373013362
# ╟─9e639591-b96b-4ef1-8c4b-25285a4d3530
# ╠═395d3784-943c-4343-856e-b4899cb76b55
# ╠═8935e5ee-bf23-4d13-85ea-452b0dac5519
# ╠═e25e20fd-7756-43da-b2a0-40c11bd75695
# ╠═51cbdcc0-4744-47cc-af0e-6d797ca317ba
# ╠═071380d7-c149-4bd6-bfc3-54491064583f
# ╠═3b05b892-a20f-4998-9cb4-76ce09d0d123
# ╠═4b336f59-8641-4c1b-81c1-d6e6a21a2e83
# ╠═b9c65489-8cf2-4c9b-9774-646fb1dc0b40
# ╠═ee321e81-bddc-4a5b-bf04-abba1f2bd497
# ╠═fdf01142-71e4-45a2-aedb-fdaf433f2842
# ╠═90e97f0a-be06-412d-8ef9-17d561c9605c
# ╠═7b7e2323-e677-4851-a150-0bcd2a8e6130
# ╠═f256c777-1bff-4d86-a446-c25053d9c86c
# ╠═1ec47a81-25fc-4854-afc8-c45aa95b0b41
# ╠═2cf480b4-5751-496b-ae19-74a477527188
# ╠═d659d3da-34b8-437f-83e6-6294447f2599
# ╠═742fc928-7512-4288-b743-d2026aee2fba
# ╠═ee4591b6-1682-468e-b8e3-8b8d84024cd3
