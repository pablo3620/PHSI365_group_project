### A Pluto.jl notebook ###
# v0.19.2

using Markdown
using InteractiveUtils

# ╔═╡ 526b4478-5e8a-11eb-3ec2-b1c78e073c6b
begin
	using PlutoUI, Plots, Plots.Measures, LaTeXStrings, ShortCodes
	gr(legend=false,size=(650,200),bottom_margin=0.5cm,left_margin=0.3cm)
	
	md"""
	!!! info "PHSI365 Computational Physics"
	
		__Ashton Bradley__, ashton.bradley@otago.ac.nz
	
		__Annika Seppälä__, annika.seppala@otago.ac.nz
	
		__Department of Physics, University of Otago__
	"""
end

# _Climate visualisation made with_ [Makie.jl](http://juliaplots.org/MakieReferenceImages/gallery//worldclim_visualization/index.html)

# ╔═╡ a23282bb-563b-4b6b-bb3d-8d45ff46e419
using Random

# ╔═╡ 3ea52ea4-5e8a-11eb-1b9a-135782cc1d1c
html"<button onclick=present()>Present</button>"

# ╔═╡ 4701a74e-5e8a-11eb-157c-cd77b97a6770
	md"""$$\def\julia{\texttt{julia}}
	\def\dashint{{\int\!\!\!\!\!\!-\,}}
	\def\infdashint{\dashint_{\!\!\!-\infty}^{\,\infty}}
	\def\D{\,{\rm d}}
	\def\E{{\rm e}}
	\def\dx{\D x}
	\def\dt{\D t}
	\def\dz{\D z}
	\def\C{{\mathbb C}}
	\def\R{{\mathbb R}}
	\def\CC{{\cal C}}
	\def\HH{{\cal H}}
	\def\I{{\rm i}}
	\def\Res_#1{\underset{#1}{\rm Res}}\,
	\def\sech{{\rm sech}\,}
	\def\vc#1{{\mathbf #1}}
	\def\qq{\qquad\qquad}
	\def\qfor{\qquad\hbox{for}\qquad}
	\def\qwhere{\qquad\hbox{where}\qquad}
	\def\em{\epsilon_m}
	\def\unit#1{{\rm #1}}
	\def\vec#1{{\mathbf #1}}
	\def\ale#1{\begin{align}#1\end{align}}
	\def\boxe#1{\begin{align}\boxed{\quad #1\quad}\end{align}}$$
	"""

# ╔═╡ 4b5ba5a6-5cb7-42e0-9e7c-b7d382c2d74c
PlutoUI.TableOfContents()

# ╔═╡ 7d1121dc-f06b-4d13-9156-d083818ab350
md"""
#### Markov Chain Monte-Carlo

- A simple description of MCMC.
- An example: A general algorithm for sampling equilibrium thermal states of essentially arbitrary physical systems. 

"""

# ╔═╡ 4f262b28-0934-42a7-b683-4a15a2715678
md"""
# MCMC Introduction

First of all it's called "Markov Chain Monte Carlo" but we might as well call it **Markov Chain Sampling Method**. 
We use random walks (the Markov Chain) to sample a distribution.

In Physics you would often start with some measured data $D$ as you input, apply MCMC and get an output. The output is not a "best-fit" to the data, that is not the goal of MCMC, rather is gives us an idea of **posterior** ("joint a-posterior probability distribution") **distributions**. 

Our measured data is influenced by a set of parameters $x_i, i=1,...n$ and we want to learn about these. In order to do that we can use our data, but we also need some kind of a model or *hypothesis* that would describe the data $D$ based on our parameters $x_i$. 

**We can think of the MCMC proccess as looking for a credible range for our parameters $x_i$ that would be allowed by the data $D$.**

In order to do this we need an educated guess of what out parameters might be before (prior) we use the data, this the **priori**. **Posterior** is what we think our parameters are after (post) we have used the data to constrain them.

## Bayes' Theorem
Our posterior $P$ relies on what our initial guess (*priori*) is based on our **hypothesis** $H$, and how we think our data is distributed. So we need to make an educated guess on the distribution of our data. This can be represented using [Bayes' theorem](https://en.wikipedia.org/wiki/Bayes%27_theorem) as

!!! info "Bayes' Theorem"
	$P(x_i | D, H) = \frac{P(D|x_i,H) P(x_i|H)}{P(D,H)}$
  
Where 
- $P(x_i | D, H)$ is the distribution of our variables $x_i$ based on our data and hypothesis/model. This is what we want to solve.

- $P(D|x_i,H)$ is our educated guess of the distribution of the data based on the variables $x_i$ and our hypothesis, a "likelihood".
- $P(x_i|H)$ is our prior guess of the range of $x_i$ based on our hypothesis. 
- The scaling factor $P(D,H)$ is the "evidence" (evidence that our data was generated based on our model hypothesis) which does not depend on $x_i$. This is a constant (so it is sometimes just left out).

For MCMC with observations, to determine the likelihood we assume there is some noise in the data. So our observations = "true values" + noise. Usual assumption would be to take the noise to be normally distributed (white noise) and our likelihood is then the probability density function (pdf, gaussian) divided by the measurement uncertaintly.

With MCMC we sample the $x_i$ space to calculate the posterior probability.
"""

# ╔═╡ 518820e4-86fa-40c0-b7d5-5c144b3f2e03
md"""
## An example

We can visualise Bayes' theorem above in a simple example where we are looking for the probability of finding glasses wearing astigmatic $(A)$ people, given that we know who has a beard $(B)$. We could express Bayes' theorem as:

$$P(A\;|\;B) P(B)=P(B\;|\;A)P(A)$$

where $P(A\;|\;B)$ is the probability of having glasses, based on our knowledge of beard, $P(B)$ is simply the probability of having a beard, $P(B\;|\;A)$ is the probability of having a beard, given that we know of glasses, and $P(A)$ is the probability of wearing glasses. The following visualisation shows how to get the two sides of the theorem arrive in the same result and thus that we can use the theorem to find the astigmatic people, by using an educated guess of probability of having a beard if you happen to need glasses:

$$P(A\;|\;B) =\frac{P(B\;|\;A)P(A)}{P(B)}$$

$(Resource("https://upload.wikimedia.org/wikipedia/commons/b/bf/Bayes_theorem_visualisation.svg",:width => 400))

[By Cmglee - Own work, CC BY-SA 3.0](https://commons.wikimedia.org/w/index.php?curid=33268427)

"""

# ╔═╡ 5cb3ecaa-8e67-4f28-b8c1-d8dbf0584d97
md"""
## Use of MCMC to understand uncertainty

MCMC methods are often implemented to investigate and understanding uncertainties in complex physical systems. For example, in remote sensing satellite measurements. In atmospheric science, space based measurements of how solar radiation is absorbed and scattered in the atmosphere can be used to invert the information of the absorbing and scattering gas molecules in the atmosphere. 

The process needs initial, *a priori*, guesses of how much of each different gas there is in the atmosphere. This is fed into a model, the output of which is contrasted to the observations. Now we have uncertainty both from the model, and the observations - the distributions might be very different. [MCMC methods help understand how those uncertainties are passed onto the concentrations of the gas molecules](https://agupubs.onlinelibrary.wiley.com/doi/pdf/10.1029/2004JD004927) - which is the main outcome of the satellite observation. 

Some visualisations of MCMC algoriths for sampling distributions with random walk here: [MCMC interactive gallery](https://chi-feng.github.io/mcmc-demo/)

[A nice example on how to do this with Julia here](https://torfjelde.github.io/presentations/cambridge-julia-meetup/)
"""

# ╔═╡ a68528a3-617d-4469-a001-b128c13be1f6
md"""
# More uses for MCMC in Physics

In Physics MCMC techniques can help us investigate microstates ([Statistical Mechanics](https://en.wikipedia.org/wiki/Statistical_mechanics)). 

The goal could be to simulate how a macroscopic property of a material (which we could measure), arises from microstates (which would be difficult to measure). The macrosopic property could be temperature, pressure, or as in the following example, magnetism.
"""

# ╔═╡ 20ee9b92-7741-4a20-9288-01d7c2e95ae5
md"""
# Example: Ising model

Ferromagnetism of a material (say, iron) arises from the magnetic aligment of the atoms in the microscopic lattice. In this case this alignment is due to some external magnetic field $B$. 
Individual atoms (which we will identify by their locations in a lattice, $i$) have a their own magnetic *spin*, $(s_i)$. We could think of the spins as microsopic magnetic fields. 
These spins point either up $(s_i = +1)$, or down $(s_i = -1)$. The atoms in the material are arranged in a lattice and interact with their nearest neighbours. 

This approach will allow us to model the alignment of small magnetic domains, under the influence of an external magnetic field, as the system energy is varied. 

The solution, the Ising model, was found analytically in 1924 for one dimension. The analytical solution in 2D was first obtained in 1944. No one has ever been able to find an **analytical** solution of the Ising model in more than 2D. 

Besides magnetism, it has applications e.g. for *lattice model of gas*, *neuroscience*, as well as *sea ice modelling* (or **any other systems with 2 states**!).

"""

# ╔═╡ ceaf0668-2c42-4aac-8cf4-16cb91715d79
md"""
## System Energy

The total energy of the system can be expressed as

!!! info "Ising Model"

	$E = - \mu B\sum_is_i  -J\sum_{\langle i,j\rangle}s_is_j$

	where $\mu$ is the atomic _magnetic moment_, and $J$ is called the *exchange 		energy*, specifying the strength of the spin-spin interaction between the atoms.

**The physical system tends towards an overall state where this energy is minimised, but this is disrupted by heat!** Why? We will get to this soon.

Now, looking at the energy equation, we can see that it is made of two forms of energy in the system:

#### Domain alignment 
The energy from each spin due to alignment with an external magnetic field $B$ is given by

$-\mu B\sum_is_i$

If $B$ is positive, then the energy is reduced when the spin is $+1$, corresponding to alignment with a magnetic field pointing in the up direction. 

#### Nearest-neighbour interactions
Each spin interacts with the net magnetic field caused by neighbouring spins. In a ferromagnetic material each spin domain wants to align with its neighbours, so the total energy is

$- J\sum_{\langle i,j\rangle}s_is_j$

where $\langle i,j\rangle$ denotes a sum over all $i$, and for each $j$ (so all pairs of $i,j$). In essence, we sum over the nearest neighbours $i$ for each $j$.  
$J>0$ describes a ferromagnetic material ($J<0$ would be something called *antiferromagnetic*, and for $J=0$ the spins do not interact). 



Without considering thermal energy, there are **two competing physical processes**: the spins want to align with the external magnetic field, but they also want to align with each other. **Thus if they start in a random configuration, they can evolve to have localised domains of alignment.**

In this case a very important question we wanted to answer might be: 

!!! info "Magnetization"

	What is the net magnetisation

	$$M\equiv \langle \sum_i s_i\rangle$$

	as a function of temperature? To answer this, we would need to have an idea of the spin states.
"""

# ╔═╡ 8b38e0e4-264f-482c-b593-911c6ca82cff
md"""
# Boltzmann weight - Probability of occupying a state with energy $E_n$

We need to figure out how to represent probabilies for different states and in the process we see how temperature influences things.

Consider a system with a set of available microstates labeled by $n$, occuring with corresponding probabilities $p_n$. 

For any physical quantity $A$, the average value $\langle A\rangle$ is given by 

$$\langle A\rangle=\sum_n p_nA_n.$$

Given the energies $E_n$, the system energy is defined as

$$E\equiv\langle E\rangle=\sum_n E_np_n$$

and the system entropy $S$ (this is a Statistical mechanics definition based on probabilities of different states)

$$S \equiv -k_B\sum_np_n\log{p_n}$$

Here, the probabilities must satisfy $\sum_n p_n=1$, and $k_B$ is the Boltzmann constant. 

The entropy is important because the maximum entropy state corresponds to the **equilibrium state of the system**. Usually we are interested in maximising entropy, subject to some constraints imposed upon the system. 

### Canonical distribution
If we maximimise $S$ subject to the constraint of fixed mean energy $E$ (use a Lagrange multiplier for the constraint), we find an exact expression for $p_n$ given by 

!!! info "Canonical Distribution"

	$p_n=\cfrac{e^{-\beta E_n}}{Z}$

	where $\beta=1/(k_B T)$ defines the system temperature $T$, and where the 	 normalisation is determined by $\sum_n p_n=1$, namely

	$\sum_n e^{-\beta E_n} =Z.$

"""

# ╔═╡ 07fb8cd7-fe26-4769-8b01-31754961201d
md"""
This statement of the equilibrium probability distribution of the system at fixed average energy is known as the __canonical distribution__. Physically it corresponds to immersing the system in a very large energy reservoir at fixed temperature $T$, which has the effect of clamping the mean energy to a value set by $T$.

*So this is where heat comes into play!*


If we think in term of Bayes' theorem, **this is our educated guess for the distribution**.

"""

# ╔═╡ 9bd6ed2d-c4d5-452b-83a5-775df84975ee
md"""
# Markov-Chain Monte-Carlo
We can solve this problem using the MCMC method of sampling thermal equilibrium states. 

An ideal statistical ensemble consists of an infinite number of copies of the system, for the purpose of taking averages. Computer resource limitations rule that out. So we generate the members of the ensemble one at a time and replace the ensemble average by a time average. The accuracy limitation is then set by the computer run time, rather than the size of its memory. 

Consider a system with states labeled by $n$, and the energy of the state $E_n$. In the canonical ensemble, the relative probability for the occurence of state $n$ is $e^{-\beta E_n}$.

Let $\pi_n$ be the probability distribution of the equilibrium ensemble given above  

$$\pi_n\equiv\frac{e^{-\beta E_n}}{Z}\tag{1}$$

We want to generate a sequence of states $n_1\to n_2\to \dots \to n_q\to n_{q+1}\to\dots$ which starts at an arbitrary initial state $n_1$, and, after a "warm up" (also called "burn-in") period of $q$ steps, reaches a steady sequence of equilibrium states. From the $q$th step onwards, there should be an equivalence between a "time average" over the sequence, and an ensemble average over the canonical ensemble. 
"""

# ╔═╡ 0bea1fe1-7e61-4246-8b6f-0bc85492f2d2
md"""
This is achieved via a Markov process with particular transition probability 

$$T(i\;|\; j)=T_{ji}=\textrm{Prob. of transition from state}\;i\; \textrm{to state}\;j\;$$

The process is chosen to satisfy the condition of __detailed balance__ for a Markov proces that we introduced in the last lecture:

>$$T_{ij}\pi_j=T_{ji}\pi_i\tag{2}$$

where we saw that this condition implies that the Markov chain has a stationary distribution $\pi_i$. 

Notice here that the normalization factor $Z$ cancels out of the detailed balance condition; this will be helpful when we set up an algorithm for sampling the equilibrium distriubtion.

## Transition probabilities for MCMC
Given that we aim to sample the stationary canonical distribution (1), the transition probabilities are chosen to satisfy:  

$$T_{ij}\leq 1,\quad\quad\sum_i T_{ij}=1,\tag{3}$$

which guarantees that $T_{ij}$ is a transition matrix, and also condition for detailed balance according to (1) and (2):

>$$T_{ij}e^{-\beta E_j}=T_{ji}e^{-\beta E_i}\tag{4}$$

In fact, the second condition in (3) is not entirely necessary (since $Z$ cancels out of (2)), but greatly simplifies our discussion of the properties of MCMC. 
"""

# ╔═╡ 6c1d7257-d701-492a-9911-04793a194cfa
md"""
__Theorem:__ The Markov process defined by (3) and (4) eventually leads to the equilibrium ensemble. 

__Proof:__ Summing the detailed balance condition, we have

$$\sum_ie^{-\beta E_j}T_{ij}=e^{-\beta E_j}=\sum_ie^{-\beta E_i}T_{ji}$$

or

$$\sum_iT_{ji}e^{-\beta E_i}=e^{-\beta E_j}\tag{5}$$

which means, since a factor of $Z^{-1}$ can be applied, that the equilibrium distribution is an eigenstate of the transition matrix, i.e. it is one possible steady state solution. 

How do we know that the Markov chain always converges to $\pi$?
"""

# ╔═╡ e7d8329e-51f7-4e50-9a8d-2c4c5427eb25
md"""
Given two ensembles represented by the probabilities of each state $f\equiv \{f_n\}$ and $g\equiv \{g_n\}$, we define the distance between the ensembles as

$$d(f,g)\equiv\sum_j\big|f_j-g_j\big|$$

In our Ising model example, $f_n$ can be taken to be the fraction of the total number of copies of the system for which site $n$ has spin up.

We assume that $f$ **is obtained from $g$ by a transition**, that is, we take the ensemble $g$, and evolve our Markov chain one step for every element of ensemble, according to our transition rule (4). For the Ising model this means for each element of the ensemble, go through each lattice site, and update the ensemble according to the correct probabilities for choosing a new state of spin, either up or down (we will see how to do this shortly). Do this once, to create a new ensemble from the old, advancing one step down the Markov chain. 

Then $f_j=\sum_kg_kT_{jk}$, and the new distance from equilibrium is

$$d(f,\pi)=\sum_j\Big|\sum_k g_kT_{jk}-\pi_j\Big|$$

but according to (5) $\pi_j=\sum_k \pi_kT_{jk}$, and so

$$d(f,\pi)=\sum_j\Big|\sum_k[g_k-\pi_k]T_{jk}\Big|\leq \sum_j\sum_k\Big|g_k-\pi_k\Big|T_{jk}=\sum_k\Big|g_k-\pi_k\Big|$$

and hence

>$$d(f,\pi)\leq d(g,\pi)$$

and so the distance from the equilibrium ensemble __cannot increase__ along the Markov chain! 

Usually it will decrease, eventually reaching the stationary ensemble (5).
"""

# ╔═╡ 5c06e536-ad21-4759-a445-749bb6a32d35
md"""
# Metropolis-Hastings algorithm

A simple (and popular) recipe can be followed to sample according to (4):

1. Suppose the current state of the Markov chain is $j$
1. Make a trial change to $i$
1. If $E_i<E_j$ accept the change
1. If $E_i> E_j$, accept the change with probability $e^{-\beta(E_i-E_j)}$

The probabilistic transition in the last step simulates thermal fluctuations.

The relative transition probabilities for this algorithm are

$$T_{ij}=\begin{cases}1\quad\quad\quad \quad\quad\quad \textrm{if}\;\; E_i<E_j\\
e^{-\beta(E_i-E_j)}\quad\quad\quad \textrm{if}\;\; E_i>E_j
\end{cases}$$

Notice that if $E_i\gg E_j$, the transition can still occur, but with much lower probability. (In general, the Metropolis-Hastings algorithm could as well be set up to reject steps if they do not fulfil the set conditions.)

The reason this transition matrix works is that it is only the _relative probabilities_ for $i\to j$ and $j\to i$ that have to be chosen correctly, and the ratio of the second case to the first is just a restatement of the detailed balance condition (4):

$$T_{ij}=T_{ji}e^{-\beta (E_i-E_j)}$$
"""

# ╔═╡ c852a425-2d0c-4405-9ca0-a2edbb9c201a
md"""
For implementing the interactions between nearest neightbours in a lattice, the `circshift` function will be useful. Let's see how it works:
"""

# ╔═╡ 5ae6dd99-3c25-4240-b545-abcde49005b4
# First we make a nice matrix where we can easily distinguish the individual elements
b = [-1 1 -1 -1
	1 1 1 -1
	-1 -1 1 -1 	
	1 1 -1 1]
#b = reshape(Vector(1:16), (4,4))

# ╔═╡ 475c089a-0770-4147-95b6-58ed8cf4e2fe
# Apply circshift in one first dimension
circshift(b,(1,0))

# ╔═╡ fd2758f7-2d24-4d22-b632-9d2fa2f4e2b9
# And now in the other dimension
circshift(b,(0,1))

# ╔═╡ ddb80935-6a85-43a4-b501-200187b6f740
circshift(b,(1,0)).+circshift(b,(0,1))

# ╔═╡ 271b5b1a-db01-4d5a-b98a-a5891302a23a
# Flip a spin with the modified Metropolis rate
function flip(s,ΔE,β)
    # scaler variable is used to make the algorithm faster. we set a scaling value which will limit the times we actually flip the spin for negative ΔE.
    # Otherwise we would end up fliping many more spins for each step!
    scaler = 0.5
    if ΔE < 0
        rand() < scaler ? (return -s) : (return s)
    else
        rand() < scaler*exp(-β*ΔE) ? (return -s) : (return s)
    end
end

# ╔═╡ 0638a292-22d2-4c0a-8b21-93a88982dd52
# step entire lattice one step forward in "time" along the Markov chain
function step!(S,β)
    ΔE = 2*S.*(
        circshift(S,(0, 1)).+
        circshift(S,(0,-1)).+
        circshift(S,(1, 0)).+
        circshift(S,(-1,0)))
    
    for i in eachindex(S)
        S[i] = flip(S[i],ΔE[i],β)
    end
    return
end

# ╔═╡ 19456ff4-6d4c-4310-9fe5-1f35ad77ee56
begin
	S = rand([1.0, -1.0], 60, 60) # random spin [1, -1] matrix (very high T)
	heatmap(S,aspect_ratio=1,axis=false,ticks=false,c=:grayC)
end

# ╔═╡ 1c0d86d1-1c00-404e-8644-23468b994b87
begin
	Random.seed!(1234)
	S0 = rand([1.0, -1], 60, 60); # initial condition
	T = 0.01# set kB = 1
	anim = @animate for i in 1:400
		for j in 1:10
			step!(S0, 1.0/T)
		end
		heatmap(S0,aspect_ratio=1,axis=false,ticks=false,c=:grayC)
	end
end

# ╔═╡ d375ece7-745b-4f51-ac11-70d1f6e354bb
gif(anim, "ising.gif", fps = 20)

# ╔═╡ de85b19e-e0d8-41bc-ace5-3eafa175d938
# begin
# 	result = []
# 	for i in 1:50000
# 		step!(S0, 1.0/T)
# 		append!(result, sum(S0)/length(S0))
# 	end
# end

# ╔═╡ c925b210-d434-4938-9850-3c38ea540f58
begin
	T
	heatmap(S0,aspect_ratio=1,axis=false,ticks=false,c=:grayC)
end

# ╔═╡ d474a9b5-55d7-401d-a479-fce356cf5db6
plot(result[1:500:50000])

# ╔═╡ d2951d45-e898-4eaa-abe8-8f336e117813
sum(result[25000:50000])/length(result[25000:50000])

# ╔═╡ 8cc4093e-f7f8-4338-900c-943edb540ec2
md"""

This is what it would look like, from a random state ($t\to\infty$) for inverse temperature $\beta=10$.

$(Resource("https://upload.wikimedia.org/wikipedia/commons/archive/e/e6/20160220081743%21Ising_quench_b10.gif",:width=>800))

[By HeMath - Own work, CC BY-SA 4.0](https://commons.wikimedia.org/w/index.php?curid=37327967)
"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
LaTeXStrings = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
Random = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"
ShortCodes = "f62ebe17-55c5-4640-972f-b59c0dd11ccf"

[compat]
LaTeXStrings = "~1.3.0"
Plots = "~1.27.3"
PlutoUI = "~0.7.37"
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

[[deps.Adapt]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "af92965fb30777147966f58acb05da51c5616b5f"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "3.3.3"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "19a35467a82e236ff51bc17a3a44b69ef35185a2"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.8+0"

[[deps.Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "4b859a208b2397a7a623a03449e4636bdb17bcf2"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.16.1+1"

[[deps.ChainRulesCore]]
deps = ["Compat", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "9950387274246d08af38f6eef8cb5480862a435f"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.14.0"

[[deps.ChangesOfVariables]]
deps = ["ChainRulesCore", "LinearAlgebra", "Test"]
git-tree-sha1 = "bf98fa45a0a4cee295de98d4c1462be26345b9a1"
uuid = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
version = "0.1.2"

[[deps.CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "ded953804d019afa9a3f98981d99b33e3db7b6da"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.0"

[[deps.ColorSchemes]]
deps = ["ColorTypes", "Colors", "FixedPointNumbers", "Random"]
git-tree-sha1 = "12fc73e5e0af68ad3137b886e3f7c1eacfca2640"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.17.1"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "024fe24d83e4a5bf5fc80501a314ce0d1aa35597"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.0"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "417b0ed7b8b838aa6ca0a87aadf1bb9eb111ce40"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.8"

[[deps.Compat]]
deps = ["Base64", "Dates", "DelimitedFiles", "Distributed", "InteractiveUtils", "LibGit2", "Libdl", "LinearAlgebra", "Markdown", "Mmap", "Pkg", "Printf", "REPL", "Random", "SHA", "Serialization", "SharedArrays", "Sockets", "SparseArrays", "Statistics", "Test", "UUIDs", "Unicode"]
git-tree-sha1 = "96b0bc6c52df76506efc8a441c6cf1adcb1babc4"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "3.42.0"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[deps.Contour]]
deps = ["StaticArrays"]
git-tree-sha1 = "9f02045d934dc030edad45944ea80dbd1f0ebea7"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.5.7"

[[deps.DataAPI]]
git-tree-sha1 = "cc70b17275652eb47bc9e5f81635981f13cea5c8"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.9.0"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "3daef5523dd2e769dad2365274f760ff5f282c7d"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.11"

[[deps.DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.DelimitedFiles]]
deps = ["Mmap"]
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "b19534d1895d702889b219c382a6e18010797f0b"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.8.6"

[[deps.Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[deps.EarCut_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "3f3a2501fa7236e9b911e0f7a588c657e822bb6d"
uuid = "5ae413db-bbd1-5e63-b57d-d24a61df00f5"
version = "2.2.3+0"

[[deps.Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "ae13fcbc7ab8f16b0856729b050ef0c446aa3492"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.4.4+0"

[[deps.FFMPEG]]
deps = ["FFMPEG_jll"]
git-tree-sha1 = "b57e3acbe22f8484b4b5ff66a7499717fe1a9cc8"
uuid = "c87230d0-a227-11e9-1b43-d7ebe4e7570a"
version = "0.4.1"

[[deps.FFMPEG_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "Pkg", "Zlib_jll", "libass_jll", "libfdk_aac_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "d8a578692e3077ac998b50c0217dfd67f21d1e5f"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "4.4.0+0"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Fontconfig_jll]]
deps = ["Artifacts", "Bzip2_jll", "Expat_jll", "FreeType2_jll", "JLLWrappers", "Libdl", "Libuuid_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "21efd19106a55620a188615da6d3d06cd7f6ee03"
uuid = "a3f928ae-7b40-5064-980b-68af3947d34b"
version = "2.13.93+0"

[[deps.Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

[[deps.FreeType2_jll]]
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "87eb71354d8ec1a96d4a7636bd57a7347dde3ef9"
uuid = "d7e528f0-a631-5988-bf34-fe36492bcfd7"
version = "2.10.4+0"

[[deps.FriBidi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "aa31987c2ba8704e23c6c8ba8a4f769d5d7e4f91"
uuid = "559328eb-81f9-559d-9380-de523a88c83c"
version = "1.0.10+0"

[[deps.GLFW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libglvnd_jll", "Pkg", "Xorg_libXcursor_jll", "Xorg_libXi_jll", "Xorg_libXinerama_jll", "Xorg_libXrandr_jll"]
git-tree-sha1 = "51d2dfe8e590fbd74e7a842cf6d13d8a2f45dc01"
uuid = "0656b61e-2033-5cc2-a64a-77c0f6c09b89"
version = "3.3.6+0"

[[deps.GR]]
deps = ["Base64", "DelimitedFiles", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Pkg", "Printf", "Random", "RelocatableFolders", "Serialization", "Sockets", "Test", "UUIDs"]
git-tree-sha1 = "9f836fb62492f4b0f0d3b06f55983f2704ed0883"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.64.0"

[[deps.GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Pkg", "Qt5Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "a6c850d77ad5118ad3be4bd188919ce97fffac47"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.64.0+0"

[[deps.GeometryBasics]]
deps = ["EarCut_jll", "IterTools", "LinearAlgebra", "StaticArrays", "StructArrays", "Tables"]
git-tree-sha1 = "83ea630384a13fc4f002b77690bc0afeb4255ac9"
uuid = "5c1252a2-5f33-56bf-86c9-59e7332b4326"
version = "0.4.2"

[[deps.Gettext_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "9b02998aba7bf074d14de89f9d37ca24a1a0b046"
uuid = "78b55507-aeef-58d4-861c-77aaff3498b1"
version = "0.21.0+0"

[[deps.Glib_jll]]
deps = ["Artifacts", "Gettext_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "a32d672ac2c967f3deb8a81d828afc739c838a06"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.68.3+2"

[[deps.Graphite2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "344bf40dcab1073aca04aa0df4fb092f920e4011"
uuid = "3b182d85-2403-5c21-9c21-1e1f0cc25472"
version = "1.3.14+0"

[[deps.Grisu]]
git-tree-sha1 = "53bb909d1151e57e2484c3d1b53e19552b887fb2"
uuid = "42e2da0e-8278-4e71-bc24-59509adca0fe"
version = "1.0.2"

[[deps.HTTP]]
deps = ["Base64", "Dates", "IniFile", "Logging", "MbedTLS", "NetworkOptions", "Sockets", "URIs"]
git-tree-sha1 = "0fa77022fe4b511826b39c894c90daf5fce3334a"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "0.9.17"

[[deps.HarfBuzz_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "Graphite2_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg"]
git-tree-sha1 = "129acf094d168394e80ee1dc4bc06ec835e510a3"
uuid = "2e76f6c2-a576-52d4-95c1-20adfe4de566"
version = "2.8.1+1"

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

[[deps.InverseFunctions]]
deps = ["Test"]
git-tree-sha1 = "91b5dcf362c5add98049e6c29ee756910b03051d"
uuid = "3587e190-3f89-42d0-90ee-14403ec27112"
version = "0.1.3"

[[deps.IrrationalConstants]]
git-tree-sha1 = "7fd44fd4ff43fc60815f8e764c0f352b83c49151"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.1.1"

[[deps.IterTools]]
git-tree-sha1 = "fa6287a4469f5e048d763df38279ee729fbd44e5"
uuid = "c8e1da08-722c-5040-9ed9-7db0dc04731e"
version = "1.4.0"

[[deps.IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[deps.JLLWrappers]]
deps = ["Preferences"]
git-tree-sha1 = "abc9885a7ca2052a736a600f7fa66209f96506e1"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.4.1"

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

[[deps.JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b53380851c6e6664204efb2e62cd24fa5c47e4ba"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "2.1.2+0"

[[deps.LAME_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f6250b16881adf048549549fba48b1161acdac8c"
uuid = "c1c5ebd0-6772-5130-a774-d5fcae4a789d"
version = "3.100.1+0"

[[deps.LERC_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bf36f528eec6634efc60d7ec062008f171071434"
uuid = "88015f11-f218-50d7-93a8-a6af411a945d"
version = "3.0.0+1"

[[deps.LZO_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e5b909bcf985c5e2605737d2ce278ed791b89be6"
uuid = "dd4b983a-f0e5-5f8d-a1b7-129d4a5fb1ac"
version = "2.10.1+0"

[[deps.LaTeXStrings]]
git-tree-sha1 = "f2355693d6778a178ade15952b7ac47a4ff97996"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.0"

[[deps.Latexify]]
deps = ["Formatting", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "Printf", "Requires"]
git-tree-sha1 = "4f00cc36fede3c04b8acf9b2e2763decfdcecfa6"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.15.13"

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

[[deps.Libffi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "0b4a5d71f3e5200a7dff793393e09dfc2d874290"
uuid = "e9f186c6-92d2-5b65-8a66-fee21dc1b490"
version = "3.2.2+1"

[[deps.Libgcrypt_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgpg_error_jll", "Pkg"]
git-tree-sha1 = "64613c82a59c120435c067c2b809fc61cf5166ae"
uuid = "d4300ac3-e22c-5743-9152-c294e39db1e4"
version = "1.8.7+0"

[[deps.Libglvnd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll", "Xorg_libXext_jll"]
git-tree-sha1 = "7739f837d6447403596a75d19ed01fd08d6f56bf"
uuid = "7e76a0d4-f3c7-5321-8279-8d96eeed0f29"
version = "1.3.0+3"

[[deps.Libgpg_error_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c333716e46366857753e273ce6a69ee0945a6db9"
uuid = "7add5ba3-2f88-524e-9cd5-f83b8a55f7b8"
version = "1.42.0+0"

[[deps.Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "42b62845d70a619f063a7da093d995ec8e15e778"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.16.1+1"

[[deps.Libmount_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9c30530bf0effd46e15e0fdcf2b8636e78cbbd73"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.35.0+0"

[[deps.Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "LERC_jll", "Libdl", "Pkg", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "c9551dd26e31ab17b86cbd00c2ede019c08758eb"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.3.0+1"

[[deps.Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7f3efec06033682db852f8b3bc3c1d2b0a0ab066"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.36.0+0"

[[deps.LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.LogExpFunctions]]
deps = ["ChainRulesCore", "ChangesOfVariables", "DocStringExtensions", "InverseFunctions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "58f25e56b706f95125dcb796f39e1fb01d913a71"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.10"

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

[[deps.Measures]]
git-tree-sha1 = "e498ddeee6f9fdb4551ce855a46f54dbd900245f"
uuid = "442fdcdd-2543-5da2-b0f3-8c86c306513e"
version = "0.3.1"

[[deps.Memoize]]
deps = ["MacroTools"]
git-tree-sha1 = "2b1dfcba103de714d31c033b5dacc2e4a12c7caa"
uuid = "c03570c3-d221-55d1-a50c-7939bbd78826"
version = "0.4.4"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "bf210ce90b6c9eed32d25dbcae1ebc565df2687f"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.0.2"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[deps.NaNMath]]
git-tree-sha1 = "737a5957f387b17e74d4ad2f440eb330b39a62c5"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.0.0"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[deps.Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "887579a3eb005446d514ab7aeac5d1d027658b8f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+1"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "ab05aa4cc89736e95915b01e7279e61b1bfe33b8"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "1.1.14+0"

[[deps.Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "51a08fb14ec28da2ec7a927c4337e4332c2a4720"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.3.2+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[deps.PCRE_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b2a7af664e098055a7529ad1a900ded962bca488"
uuid = "2f80f16e-611a-54ab-bc61-aa92de5b98fc"
version = "8.44.0+0"

[[deps.Parsers]]
deps = ["Dates"]
git-tree-sha1 = "85b5da0fa43588c75bb1ff986493443f821c70b7"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.2.3"

[[deps.Pixman_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b4f5d02549a10e20780a24fce72bea96b6329e29"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.40.1+0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[deps.PlotThemes]]
deps = ["PlotUtils", "Requires", "Statistics"]
git-tree-sha1 = "a3a964ce9dc7898193536002a6dd892b1b5a6f1d"
uuid = "ccf2f8ad-2431-5c83-bf29-c5338b663b6a"
version = "2.0.1"

[[deps.PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "Printf", "Random", "Reexport", "Statistics"]
git-tree-sha1 = "bb16469fd5224100e422f0b027d26c5a25de1200"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.2.0"

[[deps.Plots]]
deps = ["Base64", "Contour", "Dates", "Downloads", "FFMPEG", "FixedPointNumbers", "GR", "GeometryBasics", "JSON", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "Pkg", "PlotThemes", "PlotUtils", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "Requires", "Scratch", "Showoff", "SparseArrays", "Statistics", "StatsBase", "UUIDs", "UnicodeFun", "Unzip"]
git-tree-sha1 = "5f6e1309595e95db24342e56cd4dabd2159e0b79"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.27.3"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "bf0a1121af131d9974241ba53f601211e9303a9e"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.37"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "d3538e7f8a790dc8903519090857ef8e1283eecd"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.2.5"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.Qt5Base_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Fontconfig_jll", "Glib_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "OpenSSL_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libxcb_jll", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_keysyms_jll", "Xorg_xcb_util_renderutil_jll", "Xorg_xcb_util_wm_jll", "Zlib_jll", "xkbcommon_jll"]
git-tree-sha1 = "c6c0f690d0cc7caddb74cef7aa847b824a16b256"
uuid = "ea2cea3b-5b76-57ae-a6ef-0a8af62496e1"
version = "5.15.3+1"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.RecipesBase]]
git-tree-sha1 = "6bf3f380ff52ce0832ddd3a2a7b9538ed1bcca7d"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.2.1"

[[deps.RecipesPipeline]]
deps = ["Dates", "NaNMath", "PlotUtils", "RecipesBase"]
git-tree-sha1 = "dc1e451e15d90347a7decc4221842a022b011714"
uuid = "01d81517-befc-4cb6-b9ec-a95719d0359c"
version = "0.5.2"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.RelocatableFolders]]
deps = ["SHA", "Scratch"]
git-tree-sha1 = "cdbd3b1338c72ce29d9584fdbe9e9b70eeb5adca"
uuid = "05181044-ff0b-4ac5-8273-598c1e38db00"
version = "0.1.3"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[deps.Scratch]]
deps = ["Dates"]
git-tree-sha1 = "0b4b7f1393cff97c33891da2a0bf69c6ed241fda"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.1.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"

[[deps.ShortCodes]]
deps = ["Base64", "CodecZlib", "HTTP", "JSON3", "Memoize", "UUIDs"]
git-tree-sha1 = "0fcc38215160e0a964e9b0f0c25dcca3b2112ad1"
uuid = "f62ebe17-55c5-4640-972f-b59c0dd11ccf"
version = "0.3.3"

[[deps.Showoff]]
deps = ["Dates", "Grisu"]
git-tree-sha1 = "91eddf657aca81df9ae6ceb20b959ae5653ad1de"
uuid = "992d4aef-0814-514b-bc4d-f2e9a6c4116f"
version = "1.0.3"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "b3363d7460f7d098ca0912c69b082f75625d7508"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.0.1"

[[deps.SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "Random", "Statistics"]
git-tree-sha1 = "4f6ec5d99a28e1a749559ef7dd518663c5eca3d5"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.4.3"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "c3d8ba7f3fa0625b062b82853a7d5229cb728b6b"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.2.1"

[[deps.StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "8977b17906b0a1cc74ab2e3a05faa16cf08a8291"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.33.16"

[[deps.StructArrays]]
deps = ["Adapt", "DataAPI", "StaticArrays", "Tables"]
git-tree-sha1 = "57617b34fa34f91d536eb265df67c2d4519b8b98"
uuid = "09ab397b-f2b6-538f-b94a-2f83cf4a842a"
version = "0.6.5"

[[deps.StructTypes]]
deps = ["Dates", "UUIDs"]
git-tree-sha1 = "d24a825a95a6d98c385001212dc9020d609f2d4f"
uuid = "856f2bd8-1eba-4b0a-8007-ebc267875bd4"
version = "1.8.1"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[deps.TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[deps.Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "OrderedCollections", "TableTraits", "Test"]
git-tree-sha1 = "5ce79ce186cc678bbb5c5681ca3379d1ddae11a1"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.7.0"

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

[[deps.UnicodeFun]]
deps = ["REPL"]
git-tree-sha1 = "53915e50200959667e78a92a418594b428dffddf"
uuid = "1cfade01-22cf-5700-b092-accc4b62d6e1"
version = "0.4.1"

[[deps.Unzip]]
git-tree-sha1 = "34db80951901073501137bdbc3d5a8e7bbd06670"
uuid = "41fe7b60-77ed-43a1-b4f0-825fd5a5650d"
version = "0.1.2"

[[deps.Wayland_jll]]
deps = ["Artifacts", "Expat_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "3e61f0b86f90dacb0bc0e73a0c5a83f6a8636e23"
uuid = "a2964d1f-97da-50d4-b82a-358c7fce9d89"
version = "1.19.0+0"

[[deps.Wayland_protocols_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4528479aa01ee1b3b4cd0e6faef0e04cf16466da"
uuid = "2381bf8a-dfd0-557d-9999-79630e7b1b91"
version = "1.25.0+0"

[[deps.XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "1acf5bdf07aa0907e0a37d3718bb88d4b687b74a"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.9.12+0"

[[deps.XSLT_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgcrypt_jll", "Libgpg_error_jll", "Libiconv_jll", "Pkg", "XML2_jll", "Zlib_jll"]
git-tree-sha1 = "91844873c4085240b95e795f692c4cec4d805f8a"
uuid = "aed1982a-8fda-507f-9586-7b0439959a61"
version = "1.1.34+0"

[[deps.Xorg_libX11_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll", "Xorg_xtrans_jll"]
git-tree-sha1 = "5be649d550f3f4b95308bf0183b82e2582876527"
uuid = "4f6342f7-b3d2-589e-9d20-edeb45f2b2bc"
version = "1.6.9+4"

[[deps.Xorg_libXau_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4e490d5c960c314f33885790ed410ff3a94ce67e"
uuid = "0c0b7dd1-d40b-584c-a123-a41640f87eec"
version = "1.0.9+4"

[[deps.Xorg_libXcursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXfixes_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "12e0eb3bc634fa2080c1c37fccf56f7c22989afd"
uuid = "935fb764-8cf2-53bf-bb30-45bb1f8bf724"
version = "1.2.0+4"

[[deps.Xorg_libXdmcp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fe47bd2247248125c428978740e18a681372dd4"
uuid = "a3789734-cfe1-5b06-b2d0-1dd0d9d62d05"
version = "1.1.3+4"

[[deps.Xorg_libXext_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "b7c0aa8c376b31e4852b360222848637f481f8c3"
uuid = "1082639a-0dae-5f34-9b06-72781eeb8cb3"
version = "1.3.4+4"

[[deps.Xorg_libXfixes_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "0e0dc7431e7a0587559f9294aeec269471c991a4"
uuid = "d091e8ba-531a-589c-9de9-94069b037ed8"
version = "5.0.3+4"

[[deps.Xorg_libXi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXfixes_jll"]
git-tree-sha1 = "89b52bc2160aadc84d707093930ef0bffa641246"
uuid = "a51aa0fd-4e3c-5386-b890-e753decda492"
version = "1.7.10+4"

[[deps.Xorg_libXinerama_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll"]
git-tree-sha1 = "26be8b1c342929259317d8b9f7b53bf2bb73b123"
uuid = "d1454406-59df-5ea1-beac-c340f2130bc3"
version = "1.1.4+4"

[[deps.Xorg_libXrandr_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "34cea83cb726fb58f325887bf0612c6b3fb17631"
uuid = "ec84b674-ba8e-5d96-8ba1-2a689ba10484"
version = "1.5.2+4"

[[deps.Xorg_libXrender_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "19560f30fd49f4d4efbe7002a1037f8c43d43b96"
uuid = "ea2f1a96-1ddc-540d-b46f-429655e07cfa"
version = "0.9.10+4"

[[deps.Xorg_libpthread_stubs_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "6783737e45d3c59a4a4c4091f5f88cdcf0908cbb"
uuid = "14d82f49-176c-5ed1-bb49-ad3f5cbd8c74"
version = "0.1.0+3"

[[deps.Xorg_libxcb_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "XSLT_jll", "Xorg_libXau_jll", "Xorg_libXdmcp_jll", "Xorg_libpthread_stubs_jll"]
git-tree-sha1 = "daf17f441228e7a3833846cd048892861cff16d6"
uuid = "c7cfdc94-dc32-55de-ac96-5a1b8d977c5b"
version = "1.13.0+3"

[[deps.Xorg_libxkbfile_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "926af861744212db0eb001d9e40b5d16292080b2"
uuid = "cc61e674-0454-545c-8b26-ed2c68acab7a"
version = "1.1.0+4"

[[deps.Xorg_xcb_util_image_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "0fab0a40349ba1cba2c1da699243396ff8e94b97"
uuid = "12413925-8142-5f55-bb0e-6d7ca50bb09b"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll"]
git-tree-sha1 = "e7fd7b2881fa2eaa72717420894d3938177862d1"
uuid = "2def613f-5ad1-5310-b15b-b15d46f528f5"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_keysyms_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "d1151e2c45a544f32441a567d1690e701ec89b00"
uuid = "975044d2-76e6-5fbe-bf08-97ce7c6574c7"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_renderutil_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "dfd7a8f38d4613b6a575253b3174dd991ca6183e"
uuid = "0d47668e-0667-5a69-a72c-f761630bfb7e"
version = "0.3.9+1"

[[deps.Xorg_xcb_util_wm_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "e78d10aab01a4a154142c5006ed44fd9e8e31b67"
uuid = "c22f9ab0-d5fe-5066-847c-f4bb1cd4e361"
version = "0.4.1+1"

[[deps.Xorg_xkbcomp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxkbfile_jll"]
git-tree-sha1 = "4bcbf660f6c2e714f87e960a171b119d06ee163b"
uuid = "35661453-b289-5fab-8a00-3d9160c6a3a4"
version = "1.4.2+4"

[[deps.Xorg_xkeyboard_config_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xkbcomp_jll"]
git-tree-sha1 = "5c8424f8a67c3f2209646d4425f3d415fee5931d"
uuid = "33bec58e-1273-512f-9401-5d533626f822"
version = "2.27.0+4"

[[deps.Xorg_xtrans_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "79c31e7844f6ecf779705fbc12146eb190b7d845"
uuid = "c5fb5394-a638-5e4d-96e5-b29de1b5cf10"
version = "1.4.0+3"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[deps.Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e45044cd873ded54b6a5bac0eb5c971392cf1927"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.2+0"

[[deps.libass_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "5982a94fcba20f02f42ace44b9894ee2b140fe47"
uuid = "0ac62f75-1d6f-5e53-bd7c-93b484bb37c0"
version = "0.15.1+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"

[[deps.libfdk_aac_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "daacc84a041563f965be61859a36e17c4e4fcd55"
uuid = "f638f0a6-7fb0-5443-88ba-1cc74229b280"
version = "2.0.2+0"

[[deps.libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "94d180a6d2b5e55e447e2d27a29ed04fe79eb30c"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.38+0"

[[deps.libvorbis_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Ogg_jll", "Pkg"]
git-tree-sha1 = "b910cb81ef3fe6e78bf6acee440bda86fd6ae00c"
uuid = "f27f6e37-5d2b-51aa-960f-b287f2bc3b7a"
version = "1.3.7+1"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"

[[deps.x264_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fea590b89e6ec504593146bf8b988b2c00922b2"
uuid = "1270edf5-f2f9-52d2-97e9-ab00b5d0237a"
version = "2021.5.5+0"

[[deps.x265_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "ee567a171cce03570d77ad3a43e90218e38937a9"
uuid = "dfaa095f-4041-5dcd-9319-2fabd8486b76"
version = "3.5.0+0"

[[deps.xkbcommon_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Wayland_jll", "Wayland_protocols_jll", "Xorg_libxcb_jll", "Xorg_xkeyboard_config_jll"]
git-tree-sha1 = "ece2350174195bb31de1a63bea3a41ae1aa593b6"
uuid = "d8fb68d0-12a3-5cfd-a85a-d49703b185fd"
version = "0.9.1+5"
"""

# ╔═╡ Cell order:
# ╟─3ea52ea4-5e8a-11eb-1b9a-135782cc1d1c
# ╟─4701a74e-5e8a-11eb-157c-cd77b97a6770
# ╠═526b4478-5e8a-11eb-3ec2-b1c78e073c6b
# ╟─4b5ba5a6-5cb7-42e0-9e7c-b7d382c2d74c
# ╟─7d1121dc-f06b-4d13-9156-d083818ab350
# ╟─4f262b28-0934-42a7-b683-4a15a2715678
# ╟─518820e4-86fa-40c0-b7d5-5c144b3f2e03
# ╟─5cb3ecaa-8e67-4f28-b8c1-d8dbf0584d97
# ╟─a68528a3-617d-4469-a001-b128c13be1f6
# ╟─20ee9b92-7741-4a20-9288-01d7c2e95ae5
# ╟─ceaf0668-2c42-4aac-8cf4-16cb91715d79
# ╟─8b38e0e4-264f-482c-b593-911c6ca82cff
# ╟─07fb8cd7-fe26-4769-8b01-31754961201d
# ╟─9bd6ed2d-c4d5-452b-83a5-775df84975ee
# ╟─0bea1fe1-7e61-4246-8b6f-0bc85492f2d2
# ╟─6c1d7257-d701-492a-9911-04793a194cfa
# ╟─e7d8329e-51f7-4e50-9a8d-2c4c5427eb25
# ╟─5c06e536-ad21-4759-a445-749bb6a32d35
# ╟─c852a425-2d0c-4405-9ca0-a2edbb9c201a
# ╠═5ae6dd99-3c25-4240-b545-abcde49005b4
# ╠═475c089a-0770-4147-95b6-58ed8cf4e2fe
# ╠═fd2758f7-2d24-4d22-b632-9d2fa2f4e2b9
# ╠═ddb80935-6a85-43a4-b501-200187b6f740
# ╠═271b5b1a-db01-4d5a-b98a-a5891302a23a
# ╠═0638a292-22d2-4c0a-8b21-93a88982dd52
# ╠═19456ff4-6d4c-4310-9fe5-1f35ad77ee56
# ╠═a23282bb-563b-4b6b-bb3d-8d45ff46e419
# ╠═1c0d86d1-1c00-404e-8644-23468b994b87
# ╠═d375ece7-745b-4f51-ac11-70d1f6e354bb
# ╠═de85b19e-e0d8-41bc-ace5-3eafa175d938
# ╠═c925b210-d434-4938-9850-3c38ea540f58
# ╠═d474a9b5-55d7-401d-a479-fce356cf5db6
# ╠═d2951d45-e898-4eaa-abe8-8f336e117813
# ╟─8cc4093e-f7f8-4338-900c-943edb540ec2
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
