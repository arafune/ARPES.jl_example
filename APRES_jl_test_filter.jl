### A Pluto.jl notebook ###
# v0.20.24

using Markdown
using InteractiveUtils

# ╔═╡ c15bf91c-25be-11f1-be32-033906b121c8
begin
	using Pkg
	Pkg.develop(path="/Users/arafune/src/ARPES.jl/")
	using ARPES
	using GLMakie
	using DimensionalData
	using Random
end

# ╔═╡ 1bd4c237-c9b4-4614-877d-473e1eb92608
md"""#Check filter.jl

"""

# ╔═╡ 2bc94609-2b5f-47ad-b62e-0ca21fc9d576
begin
	Random.seed!(123)

n = 200
t = range(0, 10, length = n)

noise_level = 0.1

# -------------------------------
# Signals
# -------------------------------

# Sine wave
signal_sine = sin.(t)
noisy_sine = signal_sine .+ noise_level .* randn(n)

# Gaussian pulse
gaussian(x, μ, σ) = exp.(-((x .- μ) .^ 2) ./ (2σ^2))

signal_gauss = gaussian(t, 5.0, 0.5)
noisy_gauss = signal_gauss .+ noise_level .* randn(n)

# -------------------------------
# Test data
# -------------------------------

test_data = (
    sine = (clean = signal_sine, noisy = noisy_sine),
    gauss = (clean = signal_gauss, noisy = noisy_gauss),
    t = t,
)
end

# ╔═╡ 9607e110-2aea-4ed4-b13b-f43b245f215b
test_data.sine.noisy

# ╔═╡ 8b2c4307-e038-4e02-b06c-f746ab586eb8
function _random_monotonic_vector(n::Int, start = 0.0, stop = 10.0)
    @assert n>1 "n must be greater than 1)"
    v = rand(n-2)

    while length(unique(v)) < n-2
        push!(v, rand())
        v = unique(v)
    end

    v = sort(vcat(0.0, 1.0, v))
    return v .* (stop - start) .+ start
end

# ╔═╡ cda2c9e4-9772-4aef-8882-4d2d0f7ce597
plot(_random_monotonic_vector(200))

# ╔═╡ 296833b6-f1ca-411a-8605-ef6e77a75321
begin
	Z = DimArray(test_data.sine.clean, (Dim{:t}(test_data.t)))
	A = DimArray(test_data.sine.noisy, (Dim{:t}(test_data.t),))
	B = boxcar_filter_dim(A, :t, window=5)
	C = boxcar_filter_dim(A, :t, window=11)
end

# ╔═╡ d14b09ca-4dbd-4651-8ec9-ffd15d23ccd3
begin
	fig1 = Figure()
	ax1 = Axis(fig1[1, 1], title = "DimArray Plot")
	scatter!(ax1, lookup(A, 1), A.data, label = "Data A")
	lines!(ax1, lookup(B, 1), B.data, label = "Data B")
	lines!(ax1, lookup(C, 1), C.data, label = "Data B")
	fig1
end

# ╔═╡ aa4b6658-58e3-44a6-910d-c460f914ba0f
begin
	D = gaussian_filter_dim(A, :t, sigma=5.0)
	fig2 = Figure()
	ax2 = Axis(fig2[1, 1], title = "DimArray Plot")
	scatter!(ax2, lookup(A, 1), A.data, label = "Data A")
	lines!(ax2, lookup(D, 1), D.data, label = "Data D")
	fig2
end

# ╔═╡ 801917f0-5b6f-420a-bac9-c911ba301d75
begin
	E = binomial_filter_dim(A, :t, order=4)
	fig3 = Figure()
	ax3 = Axis(fig3[1, 1], title = "DimArray Plot")
	scatter!(ax3, lookup(A, 1), A.data, label = "Data A")
	lines!(ax3, lookup(E, 1), E.data, label = "Data E")
	fig3
end

# ╔═╡ 198069c2-b2a6-4c6c-9abe-fa317f9edd43
begin
	F = sg_filter_dim(A, :t, window=9, polyorder=2)
	fig4 = Figure()
	ax4 = Axis(fig4[1, 1], title = "DimArray Plot")
	scatter!(ax4, lookup(A, 1), A.data, label = "Data A")
	lines!(ax4, lookup(F, 1), F.data, label = "Data F")
	fig4
end

# ╔═╡ 8618698b-ec8b-4697-92eb-d53ae796d3ba
begin
	t_rnd = _random_monotonic_vector(200)
	Z_rnd = DimArray(sin.(t_rnd), (Dim{:t}(t_rnd)))
	A_rnd = DimArray(sin.(t_rnd) .+ noise_level .* randn(n), 
					 (Dim{:t}(t_rnd)))
	G = kalman_smooth_dim_llpf(A_rnd, :t, R=0.01, q=0.1)

end

# ╔═╡ 5bfddd97-a5f2-4faf-9e8b-a1290aebd773
begin
	fig5 = Figure()
	ax5 = Axis(fig5[1, 1], title="DimArray Plot")
	scatter!(ax5, lookup(A_rnd, 1), A_rnd.data, label="DataZ_rnd")
	lines!(ax5, lookup(Z_rnd, 1), Z_rnd.data, label="DataA_rnd")
	lines!(ax5, lookup(G, 1), G.data, label = "Data G")
	fig5
end

# ╔═╡ Cell order:
# ╠═1bd4c237-c9b4-4614-877d-473e1eb92608
# ╠═c15bf91c-25be-11f1-be32-033906b121c8
# ╠═2bc94609-2b5f-47ad-b62e-0ca21fc9d576
# ╠═9607e110-2aea-4ed4-b13b-f43b245f215b
# ╠═8b2c4307-e038-4e02-b06c-f746ab586eb8
# ╠═cda2c9e4-9772-4aef-8882-4d2d0f7ce597
# ╠═296833b6-f1ca-411a-8605-ef6e77a75321
# ╠═d14b09ca-4dbd-4651-8ec9-ffd15d23ccd3
# ╠═aa4b6658-58e3-44a6-910d-c460f914ba0f
# ╠═801917f0-5b6f-420a-bac9-c911ba301d75
# ╠═198069c2-b2a6-4c6c-9abe-fa317f9edd43
# ╠═8618698b-ec8b-4697-92eb-d53ae796d3ba
# ╠═5bfddd97-a5f2-4faf-9e8b-a1290aebd773
