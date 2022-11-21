### A Pluto.jl notebook ###
# v0.19.4

using Markdown
using InteractiveUtils

# ╔═╡ 974e0b6d-77f2-457a-aa67-42d9d2223797
begin
	using PlutoUI, ShortCodes
	PlutoUI.TableOfContents()
end

# ╔═╡ 9f4e38a0-b879-11ec-28e9-91a6cb916cea
md"""
# The Ising Model

"""

# ╔═╡ 7e923293-facf-40d5-83a3-383aa1e02bba
md"""
## Background

In the early 20th century, there was increasing demand to model macroscopic properties of matter using atomic models. Among these macroscopic properties was ferromagnetism. The Ising model was first suggested by Wilhelm Lenz in 1920. However, no further development occurred on the Ising model until Lenz's student, Ernst Ising published an analysis of the special case of one-dimensional Ising model. His analysis showed that in the case of a one-dimensional ferromagnetic Ising model there is no phase transition at any temperature. Based on this he incorrectly concluded that in higher dimensions there is no phase transition. After this Ernst Ising did no further research into the Ising model as in his words "I do not know of any reaction to my paper while I was in Europe (until 1947), except that Heisenberg mentioned it in one of his publications". Heisenberg only mentioned the Ising model as unsuccessful in order to justify the need of a more complex atomic interaction to explain ferromagnetism. It was not until the late 1930s where other atomic models started developing independently that the two-dimensional Ising model was studied further. This time it was realised that in the two-dimensional case a phase change does occur with different temperatures and in 1942 Lars Onsager announced his analytical solution of the two-dimensional Ising problem.
"""

# ╔═╡ 9f83d8de-292e-4e7b-af4e-265410dc8f76
md"""
## Theory

The Ising model assumes that the physical system can be represented by a regular lattice arrangement of molecules where these molecules can either have a spin of +1 (pointing up) or -1 (pointing down). It is also assumed that the molecules exert only short-range forces on each other therefore in the model only the neighbouring molecules are considered. Based on this model we can represent the energy (Hamiltonian) using the formula: 

$$E = - \mu B \sum_i s_i  -J \sum_{\langle i,j\rangle} s_i s_j$$

Where $B$ is the external magnetic field, $\mu$ is atomic magnetic moment $J$ is the interaction energy between 2 molecules $s_i$ and $s_j$. 

If $J > 0$ the system is considered ferromagnetic,

If $J < 0$ the system is considered antiferromagnetic and

If $J = 0$ there is no interaction between molecule spins.

Often (including our case) we are interested in the ferromagnetic two-dimensional Ising model with no external field applied. In this case we can simplify our formula for the energy (Hamiltonian) to only include the interaction energy between 2 molecules with the formula:

$$E = -J \sum_{\langle i,j\rangle} s_i s_j$$

Using this model Onsager's analytical solution suggests that a phase transition will occur at temperature given by:

$T_c = \dfrac{2J}{k (\log(1+\sqrt{2}))}$

This $T_c$ would correspond to the temperature where energy increases significantly with a small change in temperature.


"""

# ╔═╡ 2757f662-4fa0-491d-9cf3-855850c1b38c
md"""
## Numerical methods

Numerically it is impractical to solve for all possible evolutions in the Ising model as there are simply too many. For example, for a tiny $10\times 10$ matrix of molecules the partition function 

$$Z = \sum_{s_i} e^{-\beta U}$$

contains $2^{100}$ terms, a number impossibly big for a computer to calculate in any reasonable timeframe.

While it is impossible to compute the probabilities of all the possible states, using the Metropolis algorithm it is possible to evolve the system using the Boltzmann factors as guide for the probabilities of a particular evolution of the system. This algorithm, as described in Schroeder, chooses a random molecule and if flipping the molecule reduces the energy of the system, it flips it. On the other hand if flipping the molecule increases the energy of the system, the probability of flipping it becomes $e^{-\Delta E \beta}$. This process is then repeated to simulate the evolution of the system.  

To find the critical temperature $T_c$ at which phase transition occurs, computationally, we would run the Metropolis algorithm for sufficient number of evolutions at different temperatures and compare the energy in the final state using the formula 

$$E = -J \sum_{\langle i,j\rangle} s_i s_j$$

Packages needed may include Plots for plotting

"""

# ╔═╡ 9c92db81-139a-40fe-a510-62b3faab349a
md"""
## Preliminary Code

Using matrices in Julia the equation for energy has a simple representation 
"""

# ╔═╡ 335c4122-9265-41c3-84eb-d2efd98577a0
E(S,J) = sum(-J*2*S.*(
        circshift(S,(0, 1)).+
        circshift(S,(0,-1)).+
        circshift(S,(1, 0)).+
        circshift(S,(-1,0))))

# ╔═╡ 70374bfb-731e-4dd0-ae74-c744ac15f675
md"""
To quickly check that this function is returning values that make sense we can check that a random matrix is returning a higher value for energy than an ordered matrix
"""

# ╔═╡ 5b53b657-29d7-4a51-9b2f-057c22b0559e
S_random = rand([1.0, -1.0], 100, 100)

# ╔═╡ bb4ce592-a93c-4df6-b6c7-cdc886fa83e4
E(S_random,1)

# ╔═╡ 6081d61e-92cf-4e0a-b540-5a8b6501682c
S_ordered = rand([1.0], 100, 100)

# ╔═╡ e401aeaa-09b4-4369-bf62-3d040128f3d7
E(S_ordered,1)

# ╔═╡ 8c09d95c-88ed-4752-a96a-e4dd1fd33bcb
md"""
We can see that the ordered matrix with all molecules having +1 spin returns a highly negative energy of -80000 while the random matrix returns a higher value of energy of around 0 as would be expected.
"""

# ╔═╡ 7adffb62-9000-417c-92a4-5dd0df20ca22
md"""
$(DOI("10.1103/RevModPhys.39.883"))

$(DOI("10.1063/1.1699114"))

$(DOI("10.1093/oso/9780192895547.001.0001"))
"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
ShortCodes = "f62ebe17-55c5-4640-972f-b59c0dd11ccf"

[compat]
PlutoUI = "~0.7.38"
ShortCodes = "~0.3.3"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.7.2"
manifest_format = "2.0"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "8eaf9f1b4921132a4cff3f36a1d9ba923b14a481"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.4"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "ded953804d019afa9a3f98981d99b33e3db7b6da"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "024fe24d83e4a5bf5fc80501a314ce0d1aa35597"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.0"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.HTTP]]
deps = ["Base64", "Dates", "IniFile", "Logging", "MbedTLS", "NetworkOptions", "Sockets", "URIs"]
git-tree-sha1 = "0fa77022fe4b511826b39c894c90daf5fce3334a"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "0.9.17"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[deps.HypertextLiteral]]
git-tree-sha1 = "2b078b5a615c6c0396c77810d92ee8c6f470d238"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.3"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "f7be53659ab06ddc986428d3a9dcc95f6fa6705a"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.2"

[[deps.IniFile]]
git-tree-sha1 = "f550e6e32074c939295eb5ea6de31849ac2c9625"
uuid = "83e8ac13-25f8-5344-8a64-a9f2b223428f"
version = "0.5.1"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "3c837543ddb02250ef42f4738347454f95079d4e"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.3"

[[deps.JSON3]]
deps = ["Dates", "Mmap", "Parsers", "StructTypes", "UUIDs"]
git-tree-sha1 = "8c1f668b24d999fb47baf80436194fdccec65ad2"
uuid = "0f8b85d8-7281-11e9-16c2-39a750bddbf1"
version = "1.9.4"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "3d3e902b31198a27340d0bf00d6ac452866021cf"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.9"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "Random", "Sockets"]
git-tree-sha1 = "1c38e51c3d08ef2278062ebceade0e46cefc96fe"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.0.3"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[deps.Memoize]]
deps = ["MacroTools"]
git-tree-sha1 = "2b1dfcba103de714d31c033b5dacc2e4a12c7caa"
uuid = "c03570c3-d221-55d1-a50c-7939bbd78826"
version = "0.4.4"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"

[[deps.Parsers]]
deps = ["Dates"]
git-tree-sha1 = "621f4f3b4977325b9128d5fae7a8b4829a0c2222"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.2.4"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "670e559e5c8e191ded66fa9ea89c97f10376bb4c"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.38"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.ShortCodes]]
deps = ["Base64", "CodecZlib", "HTTP", "JSON3", "Memoize", "UUIDs"]
git-tree-sha1 = "0fcc38215160e0a964e9b0f0c25dcca3b2112ad1"
uuid = "f62ebe17-55c5-4640-972f-b59c0dd11ccf"
version = "0.3.3"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.StructTypes]]
deps = ["Dates", "UUIDs"]
git-tree-sha1 = "d24a825a95a6d98c385001212dc9020d609f2d4f"
uuid = "856f2bd8-1eba-4b0a-8007-ebc267875bd4"
version = "1.8.1"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.TranscodingStreams]]
deps = ["Random", "Test"]
git-tree-sha1 = "216b95ea110b5972db65aa90f88d8d89dcb8851c"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.9.6"

[[deps.URIs]]
git-tree-sha1 = "97bbe755a53fe859669cd907f2d96aee8d2c1355"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.3.0"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
"""

# ╔═╡ Cell order:
# ╟─974e0b6d-77f2-457a-aa67-42d9d2223797
# ╟─9f4e38a0-b879-11ec-28e9-91a6cb916cea
# ╟─7e923293-facf-40d5-83a3-383aa1e02bba
# ╠═9f83d8de-292e-4e7b-af4e-265410dc8f76
# ╟─2757f662-4fa0-491d-9cf3-855850c1b38c
# ╟─9c92db81-139a-40fe-a510-62b3faab349a
# ╠═335c4122-9265-41c3-84eb-d2efd98577a0
# ╟─70374bfb-731e-4dd0-ae74-c744ac15f675
# ╟─5b53b657-29d7-4a51-9b2f-057c22b0559e
# ╠═bb4ce592-a93c-4df6-b6c7-cdc886fa83e4
# ╟─6081d61e-92cf-4e0a-b540-5a8b6501682c
# ╠═e401aeaa-09b4-4369-bf62-3d040128f3d7
# ╟─8c09d95c-88ed-4752-a96a-e4dd1fd33bcb
# ╠═7adffb62-9000-417c-92a4-5dd0df20ca22
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
