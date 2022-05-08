### A Pluto.jl notebook ###
# v0.19.2

using Markdown
using InteractiveUtils

# ╔═╡ 92251784-821a-11eb-31e2-13dbf2328763
begin
		using PlutoUI, ShortCodes
		
		md"""
		!!! info "PHSI365 Computational Physics"
		
			__Ashton Bradley__, ashton.bradley@otago.ac.nz
		
			__Annika Seppälä__, annika.seppala@otago.ac.nz
		
			__Department of Physics, University of Otago__
		"""
end

# ╔═╡ f8347d2a-8211-11eb-10cc-7395ee57b7d0
md"""
# Projects
"""

# ╔═╡ 64202ebe-821a-11eb-3b9b-a3d87ede8b9f
md"""# Chaos 
Life is chaos. The term has come to mean many things. What do we mean by [Chaos Theory](https://en.wikipedia.org/wiki/Chaos_theory) in Physics, and more specifically the theory of dynamical systms? 

The situation was summarized by Lorenz:

>"Chaos: When the present determines the future, but the approximate present does not approximately determine the future."

This is often referred to as _sensitive dependence on initial conditions_.
Chaos theory is central for understanding weather prediction, fluid turbulence, stock markets, and a range of other systems crossing many disciplines.

In this project you will start by studying perhaps the simplest model in which the transition to Chaos can be observed, the [logistic map](https://en.wikipedia.org/wiki/Logistic_map). Once you have gained some clear understanding of the route to chaos, and a standard tool to analyse it, the Lyapunov exponent, you will move to studying chaotic dynamics in the [double-rod pendulum](https://en.wikipedia.org/wiki/Double_pendulum).  

You will set up and solve equations of motion for the double-rod pendulum, and find Lyapunov exponents characterising chaotic and non-chaotic behviour.

$(Resource("https://upload.wikimedia.org/wikipedia/commons/e/e3/Demonstrating_Chaos_with_a_Double_Pendulum.gif",:width=>300))
"""

# ╔═╡ 6a85a1ee-821a-11eb-19c2-67c8a59ede1d
md"""## Resources
### Lectures
- Two extra lectures on the logistic map and measures of chaos.

### Packages
- [DifferentialEquations](https://github.com/SciML/DifferentialEquations.jl)
- Possibly useful
  - [ChaosTools](https://github.com/JuliaDynamics/ChaosTools.jl)
  - [BifurcationKit](https://github.com/rveltz/BifurcationKit.jl)
"""

# ╔═╡ ab4011f4-ce77-4630-8990-38d9c4a350d1
md"### Books"

# ╔═╡ 86ea551e-c97b-4576-a499-34855bd234d3
DOI("10.1201/9780429492563")

# ╔═╡ 5e5fb8c8-cbbb-4b6f-b683-405c9a773aaf
md"### Articles"

# ╔═╡ 5a2641aa-1f8c-4463-80cb-8d5b49dd3ee6
DOI("10.1119/1.17335")

# ╔═╡ 8a2374ae-821a-11eb-27c3-31969a14fe70
md"""# Stratified Energy Storage
This project may interest students doing Energy Management courses.

Understanding the performance of energy storage devices is central to efficient energy use. This project focuses on dynamical modeling to determine optimal design parameters for a real-world stratified energy storage device such as a hot water tank. Your model will take the form of a one dimensional heat storage tank with input and output flow, and thermal losses. 

$(Resource("https://i.imgur.com/8odVw4U.png",:width=>400))
[Figure 1 from Jack and Wrobel](https://dx.doi.org/10.1016/j.applthermaleng.2008.11.021)

You will solve the equations of motion for the storage device in one spatial dimension, including time dependent boundary conditions. Your will compare your numerical solution with the analytical solution derived by Jack and Wrobel.
"""

# ╔═╡ a11924ec-821a-11eb-2e49-fb706aba40d3
md"""## Resources
### Lectures
- Partial differential equation lectures in part 1 of the course.

### Packages
- [DifferentialEquations](https://github.com/SciML/DifferentialEquations.jl)
"""

# ╔═╡ c45b644a-e3f9-4e80-9771-225161027a59
md"""
### Articles
"""

# ╔═╡ 0ea8d8b7-aaef-468c-90b9-23f2e5514420
DOI("10.1016/j.applthermaleng.2008.11.021")

# ╔═╡ aa92c28a-821a-11eb-2602-9db0a2a87c72
md"""# Fermi-Pasta-Ulam-Tsingou problem
A pioneering study in computational physics was carried out at the Los Alamos National Laboratory using the MANIAC computer, published in 1955. The work involved simulating the motion of a one-dimensional chain of coupled oscillators. Each oscillator consists of a mass coupled to its nearest neigbours with springs obeying Hooke's law. 

If the masses were only coupled by regular springs, the coupling is purely linear. This means that if energy starts in a particular mode of vibration of the chain (normal mode), then it will stay in that mode, since the modes are linearly independent. 

FPUT wanted to know what would happen if they added a weak nonlinear coupling between the masses. They expected that the interaction would cause energy to thermalize, and the system would approach equipartition of energy predicted by statistical mechanics. But there were some interesting surprises in store! They found that energy would periodically return to the origional mode, a result known as the FPU paradox. The FPUT problem was possible the first time that computers revealed something really surprising that could not be understood with existing techniques. Since then it has impacted many fields of study including ergodicity, chaos, solitary waves and solitons, integrability, and Bose-Einstein condensates. 

> In fact, FPUT initiated a new approach to studying the physical laws of nature: __computer experiments__.

In this lab you will study the energy dynamics of a system of linearly and nonlinearly coupled oscillators. First you will find the normal modes of your coupled chain and check linear dynamics has no energy mixing. Then you will study the pioneering FPUT numerical experiments on energy mixing, including both $\alpha$ and $\beta$ types of nonlinearity.
"""

# ╔═╡ b68c8f80-821a-11eb-2061-ef18b60ce1fd
md"""## Resources
### Lectures
- Lectures on coupled oscillators in part 1 of the course.

### Packages
- [DifferentialEquations](https://github.com/SciML/DifferentialEquations.jl)
"""

# ╔═╡ 7499d946-55ac-4c65-907a-168668e0e28a
md"""
### Books
"""

# ╔═╡ d4af6771-4338-4726-850e-43e02bd16fea
DOI("10.1201/9780429492563")

# ╔═╡ 67f27319-49fc-41e7-8307-10a88c3ed352
md"### Articles"

# ╔═╡ fc369016-14d5-4e6a-941d-505eb1ca64af
DOI.(["10.1063/1.2835154","10.1063/1.1861264","10.1063/1.1889345","10.1063/1.1855036"])

# ╔═╡ beb3eb7e-821a-11eb-253f-198adf942a91
md"""# Model of global temperature

This project may interest students who want to learn about the climate system, data mining, and methods that form the basis of machine learning.

You will use multiple linear regression to investigate how different factors contribute to global temperatures. This will enable you to form a model of global temperature change and assess the exact contributions of various forcing factors (and how these change over time) to the global temperature. 

The dataset you will be modelling is the GISS Surface temperature from NASA (National Aeronautics and Space Administration, Goddard Institute for Space Studies). You will need to retrieve the NetCDF file of the Land-Ocean Temperature Index, ERSSTv5 with 1200km smoothing.

The article by __Kokic et al__ discusses factors that influence global temperatures (solar irradiance, greenhouse gases etc.) and the basics of regression modelling. You will need to report all data you are using, so keep track of all data sources.

How do things change if you model only Southern Hemisphere average temperature?
"""

# ╔═╡ c5d6d860-821a-11eb-30da-69e81a75888f
md"""## Resources
### Lectures
- Lectures on data analysis in part 2 of the course.

### Data Sets

- Hansen, J., R. Ruedy, M. Sato, and K. Lo, 2010: Global surface temperature change, Rev. Geophys., 48, RG4004, doi:10.1029/2010RG000345. GISTEMP Team, 2019: GISS Surface Temperature Analysis (GISTEMP). NASA Goddard Institute for Space Studies. Dataset accessed YYYY-MM-DD at [https://data.giss.nasa.gov/gistemp/](https://data.giss.nasa.gov/gistemp/)

### Packages
- [NetCDF](https://github.com/JuliaGeo/NetCDF.jl)
"""

# ╔═╡ 902c997c-1ab5-4892-adc0-61c4b8bf8aa7
md"""
### Articles
"""

# ╔═╡ 71c5c96c-0826-42d6-b570-c91c8d758ade
DOI("10.1016/j.crm.2014.03.002")

# ╔═╡ d15fe938-821a-11eb-3701-6b1a7d076edf
md"""
# Phase transition of the 2D Ising model
This project may be of interest to students wanting to learn about statistical physics, and the widely Markov chain Monte-Carlo method.


This project investigates a classic statistical physics problem, the Ising model.

The Ising model can be used to simulate how a macroscopic property of a material (which we could measure), arises from microstates (which would be difficult to measure). The macrosopic property could be temperature, pressure, magnetism, neurosciences, sea ice, or any other system with two states. In this project you will explore ferromagnetism. 

The total energy (Hamiltonian) of the system can be expressed as

$$E = - \mu B\sum_is_i  -J\sum_{\langle i,j\rangle}s_is_j$$

where $\mu$ is the atomic *magnetic moment*, $B$ is external magnetic field and $J$, is called the *exchange energy* and it specifies the strenght of the spin-spin interaction between the atoms.

In this project you will simulate the Ising model using the Metropolis algorithm and determine the phase transition temperature in 2D lattice.

You will contrast your computational solution to Onsager's analytical solution for the Ising model which predicts that the phase transition occurs at a critical temperature

$T_c = \dfrac{2J}{k (\log(1+\sqrt{2}))}$

$(Resource("https://upload.wikimedia.org/wikipedia/commons/e/e6/Ising_quench_b10.gif",:width=>400))
[HeMath, CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0")

"""

# ╔═╡ dd69634e-821a-11eb-0f1b-136cd41547d0
md"""## Resources
### Lectures
- Two Pluto notebook lectures on Markov chain Monte-Carlo methods.

"""

# ╔═╡ 09509c58-675d-4972-bfb6-97193b142836
md"""
### Books
"""

# ╔═╡ 9605f6f2-55c5-4267-91e7-7e536cb11aba
DOI("10.1093/oso/9780192895547.001.0001")

# ╔═╡ 0da4cad8-bfcd-4a6b-aa86-05e952d0c94b
md"""
### Articles
"""

# ╔═╡ 4b423aba-d747-40f2-ad76-77c2e60aea27
DOI("10.1103/PhysRev.65.117")

# ╔═╡ e7bd0790-821a-11eb-2774-e95c6a26049c
md"""# Non-linear Schrödinger equation
This project may interest students wanting to learn more about the dynamics of quantum systems of photons or cold atoms that commonly arise in laboratory settings.

What does "nonlinear" mean in the nonlinear Schrödinger equation? It refers to a nonlinearity in the wavefunction appearing the equation of motion that describes different physical processes in difference systems, due to the broad applicability of the NLSE. The NLSE is an amazingly powerful tool in understanding many systems including for example Bose-Einstein condensates, and photon-crystal interactions in nonlinear optics; it is also used as a toy model of phenomena like superfluid helium dynamics, and pulsar glitches. 

This project involves simulating the NLSE in 1 dimension and studying paricular kinds of dynamics that can occur. You will write code to solve the linear Schrödinger equation for particlar boundary conditions, and then add in the nonlinearity. You will first solve the NLSE in imaginary time to debug your code and find ground states, and then study dynamics.

While not analytically soluble in general, the NLSE in 1D supports bright and dark solitons - nonlinear exciations that move without change of shape. Solitons are used in many real word optical communications settings, and provide a solid test of numerical simulations as they are invariant under collisions. 

You will model periodic revivals in the NLSE dynamics arising from a temporal soliton, and test the invariance under collision for spatial solitons. 

$(Resource("https://i.imgur.com/x86rPLq.gif",:width=>200))

"""

# ╔═╡ f0be72c2-821a-11eb-1f43-bb3ae1f7796d
md"""## Resources
### Lectures
- Partial differential equations lectures from part 1 of the course.

### Packages
- [DifferentialEquations](https://github.com/SciML/DifferentialEquations.jl)
"""

# ╔═╡ ec035160-347d-4776-a2b7-eb18c4aa4a96
md"""
### Books
"""

# ╔═╡ d8400659-51a0-4c47-8599-d45e36268b36
DOI("10.1007/978-3-319-42476-7_3")

# ╔═╡ d133fcec-e7e4-4042-bfa5-ec92fc2c8ef6
md"""
### Articles  
"""

# ╔═╡ 97b870f4-16ba-4155-88cb-395f986c3dca
DOI.(["10.1103/RevModPhys.71.463","10.1007/978-3-319-42476-7"])

# ╔═╡ f8b0a478-821a-11eb-21b7-cd42deec339c
md"""# Synchronization 
Systems of coupled phase oscillators arise in many physical settings, including arrays of Josephson junctions, neuronal networks, and fireflys. In this project you will study the dynamics of coupled oscillators with a particular interaction, known as the [Kuramoto model](https://en.wikipedia.org/wiki/Kuramoto_model).

$(Resource("https://upload.wikimedia.org/wikipedia/commons/thumb/9/9e/KuramotoModelPhaseLocking.ogv/480px--KuramotoModelPhaseLocking.ogv.jpg",:width=>400))

[Stewart Heitmann, Own work](https://en.wikipedia.org/wiki/File:KuramotoModelPhaseLocking.ogv)
[Attribution-Share Alike 3.0 Unported](https://creativecommons.org/licenses/by-sa/3.0/deed.en)

When coupled to each other, phase oscillators can exhibit a remarkable phenomenon of dynamical _synchronization_, whereby due to their interactions the oscillators can organize into a collective motion with a common angular frequency, even if the oscillators themselves have a spread of natural frequencies. 

The synchronization transition in the Kuramoto model is a rare example of a dynamical phase transition that can be understood analytically.


You will set up and solve a model of phase oscillators, and explore the transition to synchronization, both numerically, and analytically. You will analyse the dynamical phase transition in system using an order paramter of the transition and identify a critical coupling strength for synchronization, and explore the dependence of the transition on the oscillator frequency distribution.
"""

# ╔═╡ fe74e504-821a-11eb-2510-3d5c835a28bc
md"""## Resources
### Lectures
- Dynamical systems lectures in part 1 of the course.

### Packages
- [DifferentialEquations](https://github.com/SciML/DifferentialEquations.jl)
"""

# ╔═╡ 72b48824-6684-4b92-bd69-f1ac554dff3c
md"""
### Books
"""

# ╔═╡ 9e1be287-4d23-4ebb-b2c7-63804265af4d
DOI("10.1201/9780429492563")

# ╔═╡ 7bb477d6-99bc-4348-aeb5-99e1dee29e75
md"""
### Articles
"""

# ╔═╡ e1138025-dc90-4087-97ad-809ad68310b0
DOI.(["10.1016/S0167-2789(00)00094-4","10.1038/30918"])

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
ShortCodes = "f62ebe17-55c5-4640-972f-b59c0dd11ccf"

[compat]
PlutoUI = "~0.7.35"
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
git-tree-sha1 = "7d58534ffb62cd947950b3aa9b993e63307a6125"
uuid = "0f8b85d8-7281-11e9-16c2-39a750bddbf1"
version = "1.9.2"

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
git-tree-sha1 = "13468f237353112a01b2d6b32f3d0f80219944aa"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.2.2"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "85bf3e4bd279e405f91489ce518dedb1e32119cb"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.35"

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
# ╟─92251784-821a-11eb-31e2-13dbf2328763
# ╟─f8347d2a-8211-11eb-10cc-7395ee57b7d0
# ╟─64202ebe-821a-11eb-3b9b-a3d87ede8b9f
# ╟─6a85a1ee-821a-11eb-19c2-67c8a59ede1d
# ╟─ab4011f4-ce77-4630-8990-38d9c4a350d1
# ╟─86ea551e-c97b-4576-a499-34855bd234d3
# ╟─5e5fb8c8-cbbb-4b6f-b683-405c9a773aaf
# ╟─5a2641aa-1f8c-4463-80cb-8d5b49dd3ee6
# ╟─8a2374ae-821a-11eb-27c3-31969a14fe70
# ╟─a11924ec-821a-11eb-2e49-fb706aba40d3
# ╟─c45b644a-e3f9-4e80-9771-225161027a59
# ╟─0ea8d8b7-aaef-468c-90b9-23f2e5514420
# ╟─aa92c28a-821a-11eb-2602-9db0a2a87c72
# ╟─b68c8f80-821a-11eb-2061-ef18b60ce1fd
# ╟─7499d946-55ac-4c65-907a-168668e0e28a
# ╟─d4af6771-4338-4726-850e-43e02bd16fea
# ╟─67f27319-49fc-41e7-8307-10a88c3ed352
# ╟─fc369016-14d5-4e6a-941d-505eb1ca64af
# ╟─beb3eb7e-821a-11eb-253f-198adf942a91
# ╟─c5d6d860-821a-11eb-30da-69e81a75888f
# ╟─902c997c-1ab5-4892-adc0-61c4b8bf8aa7
# ╟─71c5c96c-0826-42d6-b570-c91c8d758ade
# ╟─d15fe938-821a-11eb-3701-6b1a7d076edf
# ╟─dd69634e-821a-11eb-0f1b-136cd41547d0
# ╟─09509c58-675d-4972-bfb6-97193b142836
# ╟─9605f6f2-55c5-4267-91e7-7e536cb11aba
# ╟─0da4cad8-bfcd-4a6b-aa86-05e952d0c94b
# ╟─4b423aba-d747-40f2-ad76-77c2e60aea27
# ╟─e7bd0790-821a-11eb-2774-e95c6a26049c
# ╟─f0be72c2-821a-11eb-1f43-bb3ae1f7796d
# ╟─ec035160-347d-4776-a2b7-eb18c4aa4a96
# ╟─d8400659-51a0-4c47-8599-d45e36268b36
# ╟─d133fcec-e7e4-4042-bfa5-ec92fc2c8ef6
# ╟─97b870f4-16ba-4155-88cb-395f986c3dca
# ╟─f8b0a478-821a-11eb-21b7-cd42deec339c
# ╟─fe74e504-821a-11eb-2510-3d5c835a28bc
# ╟─72b48824-6684-4b92-bd69-f1ac554dff3c
# ╟─9e1be287-4d23-4ebb-b2c7-63804265af4d
# ╟─7bb477d6-99bc-4348-aeb5-99e1dee29e75
# ╟─e1138025-dc90-4087-97ad-809ad68310b0
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
