### A Pluto.jl notebook ###
# v0.18.4

using Markdown
using InteractiveUtils

# ╔═╡ f04d8334-4e1f-11eb-3e82-0f7ff20f9873
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

# ╔═╡ bf66f085-ccc8-42ab-b293-564426954767
using LinearAlgebra

# ╔═╡ e1a4de2c-4e1f-11eb-1630-cfbc986703e6
html"<button onclick=present()>Present</button>"

# ╔═╡ f280c029-dcd2-40d8-814d-954edc903942
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

# ╔═╡ e5221c03-aab4-48c7-96e6-c4b248effa0f
PlutoUI.TableOfContents()

# ╔═╡ 4fa901ea-c7b2-483f-92bd-f491ff537d3d
md"""
#### Markov Processes
- Memoryless process: Markov Chain
- Transition probabilities
- Matrix representation theory
- Steady state of a random walk
- Example: Google PageRank
"""

# ╔═╡ a950e0e0-78e7-4ae0-aacc-b032c0a6df39
md"""
# Markov Chain background
The time evolution of random variables describing a physical system can be very complicated:
- a system may be correlated between different points in space, or in time.
- a useful idealization is known as a _Markov Process_.

**Markov Process**

A random process for which the probabilities of any outcomes only depend on the present state of the process and not at all of the process history: 

>**A Markov Process has perfect amnesia**.

A sequence of outcomes, each being the result of a Markov process, is called a **Markov Chain**. 
- Markov chains are of fundamental importance for modelling many equilibrium physical processes. 
- They are also used in Machine Learning algorithms to efficiently find model parameters. 

"""

# ╔═╡ 6d6baba9-24bd-4ffb-a3ab-b7ab2303e32a
md"""
## Sunny and Rainy days

A simple example of a Markov Process would be to build a model of Sunny (S) and Rainy (R) days. First we observe the weather over several days and get a sequence:

**SSSSSRRRRRRRRRRRRRSSSSSSRRRRRRRRRSSSSSSSSSSSSSRRRRRRRRRR...**

We could start by stating that ~half of the days are rainy so the probability of rain would be 50% (or 1/2). Now we make a model that produces rain with that probability:

**SSRRRSSSRSRSRSSSSRRRSRRRRSSRSSSRRSSSRSRSSSRSS...**  

Doesn't look quite right. In the observations if it rains one day, the following day seems to have a higher probability to also rain: 

_"If it rains today the probability that it also rains tomorrow is 0.9."_ 


Animation source: [Visual explanation of Markov Chains](http://setosa.io/blog/2014/07/26/markov-chains/index.html)


**Markov Process emulates this kind of dependece of the next state on the previous state.** It predicts what will happen next based on what just happened (or rather, what the current state is), without caring about what happened before that.
The consecutive steps determining the next states make the Markov Chain. 
"""

# ╔═╡ 84601d8b-6629-4b19-ae20-bb8441afa8e6
md"""
## Transition probabilities
We can describe the evolution of an ensemble of configurations in terms of the _transition probabilities_. 

Transition probabilities describe the probability that a system in one state, or with a given sequence of states, will make a transition to any of the other states in the system. 

Let's mark the system variable $x_i$ at $t_i$ by the number $i$. Then we introduce the notation

$$\begin{align}
T(1\;|\;2)&=\textrm{Prob. for finding 2, when state is 1}\\
T(1,2\;|\;3)&=\textrm{Prob. for finding 3, when state history was 1,2}\\
T(1,2,3\;|\;4)&=\textrm{Prob. for finding 4, when state history was 1,2,3}\\
\vdots
\end{align}$$

where the **history of the system is given to the left** of the vertical bar, and the **possible next state is given to the right**.

The joint probabilities for the sequence of states are related to the **transition probabilities** by

$\begin{align}
P(1,2)&=P(1)T(1\;|\;2)\\
P(1,2,3)&=P(1,2)T(1,2\;|\;3)\\
P(1,2,3,4)&=P(1,2,3)T(1,2,3\;|\;4)\\
\vdots
\end{align}$
"""

# ╔═╡ 417530ed-48de-41a5-b239-b795a8c9a4d5
md"""
## Detailed Balance
The transition probabilities must be non-negative, and should satisfy the normalization

$\int_{-\infty}^\infty T(1\;|\;2) \, dx_2 =\int_{-\infty}^\infty T(x_1,t_1\;|\;x_2,t_2) \, dx_2 =1$

or: __for any initial state at $t_1$, the total probability of going to _any_ final state at $t_2$ is equal to 1__.

Since $P(2)=\int_{-\infty}^\infty P(1,2) \, dx_1$, we have 

$P(2)=\int_{-\infty}^\infty P(1)T(1\;|\;2) \, dx_1$

or: __the probability for the state $2$ is equal to the probability that the system made a transition to state $2$ from any possible state $1$__. 

Note that, unlike $P(1,2)$, $T(1\;|\;2)$ **is not symmetric in** $1,2$: A sunny day might follow a rainy day with a probability of 0.9, which is our $T(1\;|\;2)$. But rain might follow a sunny day with a probability of 0.3, $T(2\;|\;1)$. 

- $T(1\;|\;2) \ne T(2\;|\;1)$

However, for a process with symmetry of $P(1,2)=P(2,1)$ we have

$P(1)T(1\;|\;2)=P(2)T(2\;|\;1)\tag{Detailed Balance}$

>__If the joint probabilities are independent of the order of events, then the transition probabilities satisfy the *detailed balance* condition__. 

As we will see below, this turns out to be the condition for the existence of a steady state for a particular kind of random process called a _reversible Markov process_. 
"""

# ╔═╡ 4aafd419-b949-4e7a-9355-33354b8db8d3
md"""
# Markov Process
The **simplest stochastic process** is a _purely random_ process, in which at every time step, the process is completely uncorrelated with all other time steps. 

All distributions are then determined by $P(1)$:

$$\begin{align}
P(1,2)&=P(1)P(2)\\
P(1,2,3)&=P(1)P(2)P(3)\\
\vdots
\end{align}$$

an example would be successive tosses of a coin. 

The **next simplest process** is a _Markov process_, defined by the property

$$T(1,2,\dots,n-1\;|\;n)=T(n-1\;|\;n) \,\,\,\,\,\, \text{ for all }  t_n>t_{n-1}>\dots >t_1$$
    
or: __the system has no memory earlier than the last transition__. In other words, the transition probability to any next state only depends on the previous state of the system. All information about the process is contained in $T(1\;|\;2)$. 

For example 

$$\begin{align}
P(1,2,3)&=P(1,2)T(1,2\;|\;3)=P(1,2)T(2\;|\;3)\\
&=P(1)T(1\;|\;2)T(2\;|\;3)
\end{align}$$

There is a constraint on a Markov Process: the probability of $1\to2\to3$ must satisfy

$$T(1\;|\;3)=\int T(1\;|\;2)T(2\;|\;3)\, dx_2$$

"""

# ╔═╡ 91da80d7-0418-42fb-b396-d79293ae0622
md"""
## Markov Chain
A Markov chain is a sequence of states, connected by transition probabilities, so that the sequence takes the form of a _Markov process_.
"""

# ╔═╡ 1a126fe6-84b1-409f-80fb-8c9ddb685899
md"""
## Example: How Google works 
One of the most important Markov Chains in our modern forms the core of the Google **PageRank** algorithm. The algorithm provides a way of sorting websites based upon their relevance to particular key words or phrases entered into the search engine. 
"""

# ╔═╡ be40a1c9-8ca2-49e5-9fd2-10fdb7a3df7f
md"""
Let's consider a simplified version of this process represented by a directed graph that we can think of as a miniature world-wide web. 

Each node represents a website, and each arrow represents the transition probability form moving to another website in the network. 

To qualify to be part of the `www`, each site must be connected to at least one other site. Notice that the two blue links from A to E are equivalent to one link of higher probability.
$(Resource("https://i.imgur.com/WTRYz3O.png",:width=>400))
"""

# ╔═╡ 8872d67e-82ba-4bf1-9800-1a42853667b9
md"""
## Random walk: transition matrix
We can play a little game which is simply to take a _random walk_ around the WWW. 

Starting from site A, there is 1/8 probability of moving to site B. 

For each site, the sum of the transition probabilities is 1.

> **We can ask: where will the random walk take us after $n$ steps?**

We can form a matrix of the transition probabilities, called the **transition matrix**

$\textrm{from}$

$\mathbf{T}\equiv\textrm{to}\underbrace{\begin{bmatrix}
    0 & \dfrac{1}{2} & 0 & 0 &\dfrac{1}{5} \\
    \dfrac{1}{8} & 0 & \dfrac{1}{3} & 0 & \dfrac{4}{5} \\
    \dfrac{1}{4} & \dfrac{1}{2} & 0 & \dfrac{2}{3} & 0\\
    0 & 0 & \dfrac{1}{3} & 0 & 0\\
    \dfrac{5}{8} & 0 & \dfrac{1}{3} & \dfrac{1}{3} & 0
\end{bmatrix}}_{\textrm{columns sum to 1 = Prob. to go somewhere}}$

Each element then represents

$T_{ij}=\textrm{Probability of transitioning to state} \;i\; \textrm{given initial state} \;j\;$
"""

# ╔═╡ 83a392ff-ca0b-4d7c-8ac7-a10652ca42c9
# Construct the tansition matrix
T=[0  1/2 0   0   1/5;
  1/8 0   1/3 0   4/5;
  1/4 1/2 0   2/3 0;
  0   0   1/3 0   0;
  5/8 0   1/3 1/3 0]

# ╔═╡ f5339b5c-14ef-49ee-abbf-cccb8a2bdf3c
sum(T,dims=1) #sum down the columns of T

# ╔═╡ d400ce22-348b-4a10-972b-964a16b56ce2
sum(T,dims=2) #sum along the rows of T

# ╔═╡ 57bbb1ae-dcbd-4ff3-bb18-e3a96b4cfb8c
md"""
# Steady state Markov process
"""

# ╔═╡ 10bbee9c-7ef1-4671-bd20-e955535c7742
md"""
## Perron-Frobenius theorem
We need an important theorem from random matrix theory that applies to the transition matrix for a Markov chain. The Perron-Frobenius theorem applies to any $N\times N$ square matrix where all the entries are positive, and each column summing to $1$. 


The eigenvalues $(\lambda_j)$ and eigenvectors $(\mathbf{u}_j)$ of $\mathbf{T}$, defined by

$$\mathbf{T}\mathbf{u}_j=\lambda_j \mathbf{u}_j \text{ for } j=1,2,\dots ,N$$

have the property that all eigenvalues $|\lambda_n|\leq 1$, and furthermore, there is always (at least) one eigenvalue $\lambda\equiv1$.  

Here we assume that $\mathbf{T}$ is of _full rank_, i.e. `rank(T)=N`, so that the eigenvectors provide a complete orthonormal set that spans the domain of $\mathbf{T}$. 
That is: **the columns of $\mathbf{T}$ are linearly independent**. \[We ignore pathological networks for our purposes\].
"""

# ╔═╡ 2550294c-f9e4-4c6e-817d-047a4554fced
rank(T)

# ╔═╡ 9f5c31f2-4b96-42a2-8132-daef61027a0c
md"""
## Eigenvector representation
So, given the complete set of eigenvectors $\mathbf{u}_j$, we can write the matrix in the equivalent form

$$\mathbf{T}\equiv\sum_j\lambda_j\mathbf{u}_j\mathbf{u}_j^T$$

where $\mathbf{u}_j^T$ is the row vector found from the transpose of the column $\mathbf{u}_j$. 

More generally, if $\mathbf{T}$ is complex valued, and still has a complete set of eigenvectors, we would replace $\mathbf{u}_j^T\to\mathbf{u}_j^\dagger\equiv (\mathbf{u}_j^*)^T$, so that $\dagger$ representes the _complex-conjugate transpose_.

__Check:__ for any eigenvector $\mathbf{u}_k$

$$\mathbf{T}\mathbf{u}_k=\sum_j\lambda_j\mathbf{u}_j\underbrace{\mathbf{u}_j^T\mathbf{u}_k}_{=\delta_{jk}}=\lambda_k\mathbf{u}_k$$

and this expression for $\mathbf{T}$ is an equivalent restatement of the eigenproblem. 

Since the eigenvectors are a complete orthonormal set, for any vector $\mathbf{v}$ in the domain of $\mathbf{T}$, there is an equivalent representation (project onto each eigenvector - Fourier's trick!):

$$\mathbf{v}=\sum_j\mathbf{u}_j\;\underbrace{(\mathbf{u}_j^T\mathbf{v})}_{c_j\in\mathbb{R}}$$
"""

# ╔═╡ 341c2ab8-43b7-4f3b-913b-6626039cbc2e
md"""
## Steady-state
So, where does our random walker browsing the internet go after a _looong_ time?

Given any initial state $\mathbf{p}_0$, the next state of the Markov chain is $\mathbf{p}_1=\mathbf{T}\mathbf{p}_0$. 

After the next step: $\mathbf{p}_2=\mathbf{T}\mathbf{p}_1 = \mathbf{T} (\mathbf{T}\mathbf{p}_0) = \mathbf{T}^2\mathbf{p}_0$.

After $n$ steps we have

$$\mathbf{p}_n=\mathbf{T}^n\mathbf{p}_0,$$

and after many steps

$$\mathbf{p}_\infty=\mathbf{\bar{T}}\mathbf{p}_0,$$

where we define the **steady-state transition matrix**

$$\mathbf{\bar{T}}\equiv\lim_{n\to\infty}\mathbf{T}^n$$ 

Formally, given the eigenvector decomposition, we find

$$\mathbf{\bar{T}}=\lim_{n\to\infty}\sum_{j=1}^N(\lambda_j)^n\mathbf{u}_j\mathbf{u}_j^T$$

Since all eigenvalues are $|\lambda_n|\leq 1$, only one survives this infinite product, namely the single eigenvector with eigenvalue 1, which we call $\pi$:

$$\mathbf{T}\pi=\pi$$

>**In fact, it turns out that every column of $\mathbf{\bar{T}}$ is simply $\pi$!**
"""

# ╔═╡ 85efc6c7-0694-47e2-93df-a966b586ce76
T2=T^2

# ╔═╡ 0ef6150d-0569-48fa-916f-bc50ead5e9ef
T̄=T^50

# ╔═╡ 4234a38e-dd9a-4727-a471-a06f44f71503
begin
	p0 = zeros(5); 
	p0 = rand(5);
	p0/=sum(p0) #Generate a normalised initial state
end

# ╔═╡ dbc3fa51-b2b0-4f95-b91e-06f80232b516
T̄*p0

# ╔═╡ 635c3c8b-4bc5-4f5a-9386-e20bb5835059
md"""
Hence $\mathbf{\bar{T}}$ is the __steady-state transition matrix__, that will always take any initial state immediately to the steady state. 
"""

# ╔═╡ 8b407596-4ed3-42e2-adb6-aaf854beb03a
md"""
# Reversible Markov Chain


A Markov process is called reversible, or a _reversible Markov chain_ if and only if it satisfies the detailed balance condition. Racall that this was given as

$P(1)T(1\;|\;2)=P(2)T(2\;|\;1)$

and this must hold for all possible states with steady-state probabilities $P(i)$.

This condition is equivalent to the existence of a stationary distribution $\pi$ that satisfies

!!! info "Stationary Distribution"

	$T_{ij}\pi_j=T_{ji}\pi_{i}$

	where 

	$T_{ij}=\textrm{Probability of transitioning to state} \;i\; \textrm{given initial 	   state} \;j.\;$

If we sum detailed balance over $j$, we then have

$\sum_jT_{ij}\pi_j=\sum_jT_{ji}\pi_{i}=\pi_{i}$

since each column of $\mathbf{T}$ sums to unity. It is clear then, that detailed 	balance immediately implies the existence of an eigenvector satisfying $\mathbf{T}\pi=\pi$.
"""

# ╔═╡ 5493d861-9dcd-45ad-a71e-1bcd5912aa71
U2=eigvals(T) #find all eigenvalues U

# ╔═╡ 0ac42c05-7494-4850-973b-81f7b33f0207
V2=eigvecs(T) #, eigenvectors V of matrix T

# ╔═╡ 475785dc-8463-4c60-ba46-81722ae6e4b8
real(U2)

# ╔═╡ dfb79499-77b3-443d-a2b4-37e2ef70591d
V2[:,5]/sum(V2[:,5]) # normalise

# ╔═╡ d8e047fc-175e-41be-8df9-03e4ed849e53
md"""

And hence there is an eigenvector with eigenvalue 1, which sums to 1. This is the steady state for the random walker. 

Evidently, for our baby WWW, the most likely state webpages are (in decreasing order) B, C, E, A, D. 

Do we believe it? This was our network:

$(Resource("https://i.imgur.com/h6dLAVA.png",:width=>400))
"""

# ╔═╡ 7338c9e6-fca0-4519-a84d-4b806777a833
md"""
Let's change our transition matrix to correspond to the new network

$(Resource("https://i.imgur.com/niLHhnK.png",:width=>400))
"""

# ╔═╡ e1ed8091-328c-40a7-a464-530a9d1b1c4e
T3=[0 1/2 0   0   1/5;
 1/8 0   1/3 0   4/5;
 1/4 1/2 0   1/6 0;
 0   0   1/3 2/3 0;
 5/8 0   1/3 1/6 0]

# ╔═╡ 7c07d6d4-b362-4242-90e7-c3bc5a0f66a1
sum(T3,dims=1)

# ╔═╡ f0a98e62-d1bd-421e-be77-4f565fa46ae2
begin
	U3=eigvals(T3)
	V3=eigvecs(T3) #find all eigenvalues U, eigenvectors V of matrix T
end

# ╔═╡ 93382f84-0535-4426-b247-b37b5290227d
real(U3)

# ╔═╡ 2a0f2ff8-e0d0-4629-9092-d7a1d77f71ba
V3[:,5]/sum(V3[:,5]) #normalize 

# ╔═╡ 725585f7-6612-45fc-b356-6ee15e1c3d99
T3^100*p0

# ╔═╡ b7af04d1-9bec-4b9a-9abe-8765ebb16997
md"""
Is it possible to beat Google at their own game? Let's imagine that site D has become a self-referential link-trap:
"""

# ╔═╡ cfa51ffd-6afc-4551-8530-74dffce54eeb
T4=[0 1/2 0   0    1/5;
 1/8 0   1/3 0    4/5;
 1/4 1/2 0   1/16 0;
 0   0   1/3 7/8  0;
 5/8 0   1/3 1/16 0]

# ╔═╡ 33f18ce3-edb3-4abc-8093-bcfccd4ee2a7
sum(T4,dims=1)

# ╔═╡ b17b917a-6dd7-483c-97b0-bb8bc15d02b2
begin
	U4=eigvals(T4)
	V4=eigvecs(T4) #find all eigenvalues U, eigenvectors V of matrix T
	real(U3)
end

# ╔═╡ 25e24554-9a61-47fa-88fe-8c2d632612cf
V4[:,5]/sum(V4[:,5]) #normalize 

# ╔═╡ 7c307e8d-9503-440d-afe5-3d20fd2fddf0
T4^100*p0

# ╔═╡ edf23188-5ea4-4f32-980a-639e6b5ab49e
md"""
The random walker can get stuck on D! This is the reason why PageRank ignores links from a site to itself.
"""

# ╔═╡ e5d0dc7e-2851-466f-ab69-69580eb4262b
md"""
[Klein project - how Google works](http://blog.kleinproject.org/?p=280)

[Detailed Balance](https://en.wikipedia.org/wiki/Detailed_balance)

[Stochastic Matrix](https://en.wikipedia.org/wiki/Stochastic_matrix)

[Visual explanation of Markov Chains](http://setosa.io/blog/2014/07/26/markov-chains/index.html)
"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
LaTeXStrings = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
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
git-tree-sha1 = "ad368663a5e20dbb8d6dc2fddeefe4dae0781ae8"
uuid = "ea2cea3b-5b76-57ae-a6ef-0a8af62496e1"
version = "5.15.3+0"

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
# ╟─e1a4de2c-4e1f-11eb-1630-cfbc986703e6
# ╟─f280c029-dcd2-40d8-814d-954edc903942
# ╟─f04d8334-4e1f-11eb-3e82-0f7ff20f9873
# ╟─e5221c03-aab4-48c7-96e6-c4b248effa0f
# ╟─4fa901ea-c7b2-483f-92bd-f491ff537d3d
# ╟─a950e0e0-78e7-4ae0-aacc-b032c0a6df39
# ╟─6d6baba9-24bd-4ffb-a3ab-b7ab2303e32a
# ╟─84601d8b-6629-4b19-ae20-bb8441afa8e6
# ╟─417530ed-48de-41a5-b239-b795a8c9a4d5
# ╟─4aafd419-b949-4e7a-9355-33354b8db8d3
# ╟─91da80d7-0418-42fb-b396-d79293ae0622
# ╟─1a126fe6-84b1-409f-80fb-8c9ddb685899
# ╟─be40a1c9-8ca2-49e5-9fd2-10fdb7a3df7f
# ╟─8872d67e-82ba-4bf1-9800-1a42853667b9
# ╠═bf66f085-ccc8-42ab-b293-564426954767
# ╠═83a392ff-ca0b-4d7c-8ac7-a10652ca42c9
# ╠═f5339b5c-14ef-49ee-abbf-cccb8a2bdf3c
# ╠═d400ce22-348b-4a10-972b-964a16b56ce2
# ╟─57bbb1ae-dcbd-4ff3-bb18-e3a96b4cfb8c
# ╟─10bbee9c-7ef1-4671-bd20-e955535c7742
# ╠═2550294c-f9e4-4c6e-817d-047a4554fced
# ╟─9f5c31f2-4b96-42a2-8132-daef61027a0c
# ╟─341c2ab8-43b7-4f3b-913b-6626039cbc2e
# ╠═85efc6c7-0694-47e2-93df-a966b586ce76
# ╠═0ef6150d-0569-48fa-916f-bc50ead5e9ef
# ╠═4234a38e-dd9a-4727-a471-a06f44f71503
# ╠═dbc3fa51-b2b0-4f95-b91e-06f80232b516
# ╟─635c3c8b-4bc5-4f5a-9386-e20bb5835059
# ╟─8b407596-4ed3-42e2-adb6-aaf854beb03a
# ╠═5493d861-9dcd-45ad-a71e-1bcd5912aa71
# ╠═0ac42c05-7494-4850-973b-81f7b33f0207
# ╠═475785dc-8463-4c60-ba46-81722ae6e4b8
# ╠═dfb79499-77b3-443d-a2b4-37e2ef70591d
# ╟─d8e047fc-175e-41be-8df9-03e4ed849e53
# ╟─7338c9e6-fca0-4519-a84d-4b806777a833
# ╠═e1ed8091-328c-40a7-a464-530a9d1b1c4e
# ╠═7c07d6d4-b362-4242-90e7-c3bc5a0f66a1
# ╠═f0a98e62-d1bd-421e-be77-4f565fa46ae2
# ╠═93382f84-0535-4426-b247-b37b5290227d
# ╠═2a0f2ff8-e0d0-4629-9092-d7a1d77f71ba
# ╠═725585f7-6612-45fc-b356-6ee15e1c3d99
# ╟─b7af04d1-9bec-4b9a-9abe-8765ebb16997
# ╠═cfa51ffd-6afc-4551-8530-74dffce54eeb
# ╠═33f18ce3-edb3-4abc-8093-bcfccd4ee2a7
# ╠═b17b917a-6dd7-483c-97b0-bb8bc15d02b2
# ╠═25e24554-9a61-47fa-88fe-8c2d632612cf
# ╠═7c307e8d-9503-440d-afe5-3d20fd2fddf0
# ╟─edf23188-5ea4-4f32-980a-639e6b5ab49e
# ╟─e5d0dc7e-2851-466f-ab69-69580eb4262b
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
