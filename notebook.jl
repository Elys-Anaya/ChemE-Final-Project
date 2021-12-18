### A Pluto.jl notebook ###
# v0.17.3

using Markdown
using InteractiveUtils

# ╔═╡ 5458cafc-430a-4e2e-a3f9-d23023e6053b
begin

	# load some external packages 
	using PlutoUI
	using DataFrames
	using BSON
	using GLPK
	using PrettyTables
	using Plots
	
	# setup my paths (where are my files?)
	_PATH_TO_ROOT = pwd() 
	_PATH_TO_SRC = joinpath(_PATH_TO_ROOT,"src")
	_PATH_TO_MODEL = joinpath(_PATH_TO_ROOT,"model")
	_PATH_TO_FIGS = joinpath(_PATH_TO_ROOT,"figs")
	
	# load the ENGRI 1120 project code library -
	include(joinpath(_PATH_TO_SRC,"Include.jl"))

	# load the model -
	MODEL = BSON.load(joinpath(_PATH_TO_MODEL,"model_v2.bson"), @__MODULE__)

	# show -
	nothing
end

# ╔═╡ 6f9851d0-9573-4965-8456-92d2c57afa91
md"""
## ENGRI 1120: Design and Analysis of a Sustainable Cell-Free Production Process for Industrially Important Small Molecules- Maltose to Hydrazine
"""

# ╔═╡ 833d7250-f4ab-49a2-a43e-1b21def59ad4
html"""
<p style="font-size:20px;">Penicillin Bread: Elys Anaya, Madde Hart, Keegan Lewick, David Bascome</br>
Smith School of Chemical and Biomolecular Engineering, Cornell University, Ithaca NY 14850</p>
"""

# ╔═╡ 251363ad-1927-4b05-99f5-8c3f2508c0cb
md"""
### Introduction
Certain small molecules have recently become of great industrial importance. However, in a world where industry has already taken a heavy toll on the environment, these molecules must be produced in a sustainable way from sustainable starting materials. As a result, Olin Engineering has been contracted to design and analyze a sustainable bioprocess to manufacture one of these high-value small molecules using renewable sugar feedstocks and specially designed cell-free bioreactors. In particular, the goal is to manufacture hydrazine from maltose.
##### Hydrazine
The chemical properties of hydrazine, $$N_2H_4$$, make it extremely valuable in industry. The primary use of hydrazine is as a chemical blowing agent. Therefore, this molecule is an invaluable component of agricultural pesticides, water treatment processes, pharmaceuticals, and high-energy fuels such as rocket propellants. These industrial uses among others are what put this molecule in such high demand.
##### Maltose
![](data:image/png;base64,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)

Maltose is a sugar formed by two glucose molecules joined together. It is commonly produced by living organisms, but can also be produced by heating a strong acid in the laboratory. It is a very common disaccharide and is widely used in the food industry, for example, for its fundamental role in alcohol fermentation. Its abundance and harmlessness make it a great candidate for a sustainable bioprocess.
##### Other Starting Materials
However, other starting materials are necessary for these bioprocesses to occur. The two other reactants besides oxygen necessary for hydrazine production are ammonia and nitric oxide. Ammonia, $$NH_3$$, is a strongly-odored, colorless gas. While handling this substance poses some challenges, it is naturally abundant. Furthermore, ammonia emissions have been shown to negatively impact biodiversity, so using it up rather than emitting it contributes to this project's goal of sustainability. The other reactant, nitric oxide, $$NO$$, is also a colorless gas but is even more toxic than ammonia both via inhalation and skin contact. It is often manufactured by passing air through an electric arc, or through the oxidation of ammonia. Together, these reactants, maltose, oxygen, ammonia, and nitric oxide, should yield a sustainable production of hydrazine.
"""

# ╔═╡ 884a0a7d-e5d8-4417-b109-d00c37a01766
md"""
### Materials and Methods
"""

# ╔═╡ b45778d1-bf91-4ccc-a120-28439bcc051c
md"""
#### Technical Reasoning
##### Starting Reactants and Final Product 

The purpose of this reactor is to create the product Hydrazine. It is formed from nitric oxide and ammonia and NADH. Of these reactants, NADH is a product of the metabolism of sugars in a cell. The following reaction is used:

Nitric Oxide + Ammonia + 1.5 NADH --> Hydrazine + H20 + NAD+

Thus the reaction takes place within a modified E-coli cell which creates Hydrazine using the method listed above, of which the NADH and nitric oxide are formed from ceullar prcesses.

In this particular reactor, the feedstock used is maltose, which the cell uses as an energy source to create NADH. It is also important to give the cell a constant stream of Water and Oxygen to keep the reactions running, and the cells alive.
##### Pathways

Initially, the Maltose enters the modified cells and goes through the normal metabolic pathway of glycolosis, breaking down the Maltose into two glocuse molecules, and then breaking the glucose down further into Acetate.

The next pathway is the TCA cycle, in which the acetate previously created is combined with CoA to begin this metabolic process, in which the Acetyl-CoA is converted into (S)-Malate, whose breakdown into Oxaloacetate provides the energy for the formation of NADH from NAD+.

The Final Pathway is that which creates the Hydrazine itself. Nitrate is introduced to the cell, where it is broken down into Nitric Oxide. From there it reacts with the NADH produces from the TCA cycle, and Ammonia which must be provided to the cell directly. The primary product of this reaction is Hydrazine, our desired substance.
##### Substances needed to feed Reactor

Maltose: The sugar which provides energy for the cell reaction to run, and which allows for the creation of NADH one of the reactants of the final reaction of the sequence.
Nitrate: Breaks down into nitric oxide, one of the reactants of the final reaction of the seuence.
Ammonia: Not produced in any cellular reaction, must be introduced directly for hydrazine to form
Oxygen: Needed to power multiple reactions in the TCA and Glycolosis pathways
Water: Needed to power multiple reactions in the chemical pathways used.

##### Reactor Method Reasoning

To create the needed amount of hydrazine, over 1 gram per hour, many microreactors were needed. The final amount required turned out ot be 41. Having 41 microreactors of such small volume, meant it would be extremely cost-inefficient to set them up sepeartely with their own pumps, and parts. Thus they had to be arranged.

We chose to arrange them in parallel, as that way, the exact contents of each input and output stream could be known, as the products of one microreactor were not introduced into others. This simplifies tracking where the hydrazine is at any given moment, and allows an individual reactor to be worked on or maintenanced without having to shut the whole production stream down.
"""

# ╔═╡ ad5d595e-4dba-49cd-a446-e1df737fd75d
md"""
#### Step 1: Configure the Flux Balance Analysis (FBA) calculation for a _single_ chip
"""

# ╔═╡ 5bfdf6f9-2927-4a9a-a386-8840c676329b
begin

	# setup the FBA calculation for the project -

	# === SELECT YOUR PRODUCT HERE ==================================================== #
	# What rate are trying to maximize? (select your product)
	# rn:R08199 = isoprene
	# rn:28235c0c-ec00-4a11-8acb-510b0f2e2687 = PGDN
	# rn:R09799 = Hydrazine
	# rn:R03119 = 3G
	idx_target_rate = find_reaction_index(MODEL,:reaction_number=>"rn:R09799")
	# ================================================================================= #

	# First, let's build the stoichiometric matrix from the model object -
	(cia,ria,S) = build_stoichiometric_matrix(MODEL);

	# Next, what is the size of the system? (ℳ = number of metabolites, ℛ = number of reactions)
	(ℳ,ℛ) = size(S)

	# Next, setup a default bounds array => update specific elements
	# We'll correct the directionality below -
	Vₘ = (13.7)*(3600)*(50e-9)*(1000) # units: mmol/hr
	flux_bounds = [-Vₘ*ones(ℛ,1) Vₘ*ones(ℛ,1)]

	# update the flux bounds -> which fluxes can can backwards? 
	# do determine this: sgn(v) = -1*sgn(ΔG)
	updated_flux_bounds = update_flux_bounds_directionality(MODEL,flux_bounds)

	# hard code some bounds that we know -
	updated_flux_bounds[44,1] = 0.0  # ATP synthesis can't run backwards 

	# What is the default mol flow input array => update specific elements
	# strategy: start with nothing in both streams, add material(s) back
	n_dot_input_stream_1 = zeros(ℳ,1)	# stream 1
	n_dot_input_stream_2 = zeros(ℳ,1)	# stream 2

	# === YOU NEED TO CHANGE BELOW HERE ====================================================== #
	# Let's lookup stuff that we want/need to supply to the chip to get the reactiont to go -
	# what you feed *depends upon your product*
	compounds_that_we_need_to_supply_feed_1 = [
		"oxygen", "maltose", "nitric oxide", "ammonia"
	]

	# what are the amounts that we need to supply to chip in feed stream 1 (units: mmol/hr)?
	mol_flow_values_feed_1 = [
		0.46    ; # oxygen mmol/hr
		0.62    ; # maltose mmol/hr
		2.47 	; # nitric oxide mmol/hr
		2.47 	; # ammonia mmol/hr
	]

	# what is coming into feed stream 2?
	compounds_that_we_need_to_supply_feed_2 = [
	]
	
	# === YOU NEED TO CHANGE ABOVE HERE ====================================================== #

	# stream 1:
	idx_supply_stream_1 = Array{Int64,1}()
	for compound in compounds_that_we_need_to_supply_feed_1
		idx = find_compound_index(MODEL,:compound_name=>compound)
		push!(idx_supply_stream_1,idx)
	end

	# supply for stream
	n_dot_input_stream_1[idx_supply_stream_1] .= mol_flow_values_feed_1
	
	# setup the species bounds array -
	species_bounds = [-1.0*(n_dot_input_stream_1.+n_dot_input_stream_2) 1000.0*ones(ℳ,1)]

	# Lastly, let's setup the objective function -
	c = zeros(ℛ)
	c[idx_target_rate] = -1.0

	# show -
	nothing
end

# ╔═╡ e8a4faf8-2285-4544-830c-f39d3847e8cc
md"""
#### Step 2: Method to compute the composition that is going into the downstream separation system 

In a parallel system of $N$ chips, each chip acts independently. Thus, to compute the output from the mixer operation we add up the components in each stream into the mixer (N inputs and a single output). Starting from the steady-state species mol balance: 

$$\sum_{s=1}^{N+1}v_{s}\dot{n}_{i,s} = 0\qquad{i=1,2,\dots,\mathcal{M}}$$

we can solve for the mixer output stream composition:

$$\dot{n}_{i,N+1} = -\sum_{s=1}^{N}v_{s}\dot{n}_{i,s}\qquad{i=1,2,\dots,\mathcal{M}}$$

However, since each chip is _identical_ we know that: $\dot{n}_{i,N+1} = N\times\dot{n}_{i,1}$. Alternatively, we could do the same thing with species mass balances (which is probably more useful in this case because our downstream separation units operate on a mass basis).

"""

# ╔═╡ 10424555-39cc-4ddf-8c22-db91cf102bfd
md"""
#### Step 3: Downstream separation using Magical Sepration Units (MSUs)

To separate the desired product from the unreacted starting materials and by-products, let's suppose the teaching team invented a magical separation unit or MSU. MSUs have one stream in, and two streams out (called the top, and bottom, respectively) and a fixed separation ratio for all products (that's what makes them magical), where the desired product is _always_ in the top stream at some ratio $\theta$. In particular, if we denote $i=\star$ as the index for the desired product (in this case 1,3 propanediol), then after one pass (stream 1 is the input, stream 2 is the top, and stream 3 is the bottom) we have:

$$\begin{eqnarray}
\dot{m}_{\star,2} &=& \theta_{\star}\dot{m}_{\star,1}\\
\dot{m}_{\star,3} &=& (1-\theta_{\star})\dot{m}_{\star,1}\\
\end{eqnarray}$$

for the product. In this case, we set $\theta_{\star}$ = 0.75. On the other hand, for _all_ other materials in the input, we have $\left(1-\theta_{\star}\right)$ in the top, and $\theta_{\star}$ in the bottom, i.e.,

$$\begin{eqnarray}
\dot{m}_{i,2} &=& (1-\theta_{\star})\dot{m}_{i,1}\qquad{\forall{i}\neq\star}\\
\dot{m}_{i,3} &=& \theta_{\star}\dot{m}_{i,1}\\
\end{eqnarray}$$

If we chain these units together we can achieve a desired degree of separation.
"""

# ╔═╡ a6ae99b6-ea8a-48f0-a7a3-4032c675c249
md"""
#### 2.5 Methods of Financial Analysis

"""

# ╔═╡ 189f8301-3185-4ba6-b644-b2ddae70768d
md"
[![Screen-Shot-2021-12-18-at-10-21-15-AM.png](https://i.postimg.cc/bNL4bd5b/Screen-Shot-2021-12-18-at-10-21-15-AM.png)](https://postimg.cc/BXLhfZ4Q)

The first section table shows which compenents were utilized, and how much they cost.This gave the full reactor a cost of 5,200$, though the cost of the actual pipes was assumed to be zero.

[![Screen-Shot-2021-12-18-at-10-21-34-AM.png](https://i.postimg.cc/bwBMCWpw/Screen-Shot-2021-12-18-at-10-21-34-AM.png)](https://postimg.cc/xXLtqsXw)

Here the cost of the reactor feeds was calucated, and the selling price of our final product added in. As can be seen the reactor is not profitable, because hydrazine is worth much less than 2 of the necessary compenents to produce it, nitric oxide and ammonia. Thus the reactor loses money per hour and per year.

[![Screen-Shot-2021-12-18-at-10-21-49-AM.png](https://i.postimg.cc/8CfYq4zB/Screen-Shot-2021-12-18-at-10-21-49-AM.png)](https://postimg.cc/67wzZdRy)

This final table shows good of an investment the reactor is compared to some static ones with year over year growt, over a 10 year period. The final results show that the reactor will lose between 7-12 million dollars in opportunity costs compared to other investments.
"


# ╔═╡ a3632011-833e-431b-b08f-f2896ad0a82a
md"""
### Results and Discussion
"""

# ╔═╡ 39f3633e-b9df-4d01-946f-ba2d6c8ba6b7
begin

	# compute the optimal flux -
	result = calculate_optimal_flux_distribution(S, updated_flux_bounds, species_bounds, c);

	# get the open extent vector -
	ϵ_dot = result.calculated_flux_array

	# what is the composition coming out of the first chip?
	n_dot_out_chip_1 = (n_dot_input_stream_1 + n_dot_input_stream_2 + S*ϵ_dot);

	# did this converge?
	with_terminal() do

		# get exit/status information from the solver -
		exit_flag = result.exit_flag
		status_flag = result.status_flag

		# display -
		println("Computed optimal flux distribution w/exit_flag = 0: $(exit_flag==0) and status_flag = 5: $(status_flag == 5)")
	end
end

# ╔═╡ 4b3ef98c-d304-4ef4-95ef-f1d1ce562e36
md"""
###### Table 1: State table from a single chip (species mol flow rate mmol/hr at exit)
"""

# ╔═╡ 7166a917-b676-465c-a441-4ff0530faf92
begin

	# compute the mol flow rate out of the device -
	n_dot_output = (n_dot_input_stream_1 + n_dot_input_stream_2 + S*ϵ_dot);

	# get the array of MW -
	MW_array = MODEL[:compounds][!,:compound_mw]

	# convert the output mol stream to a mass stream -
	mass_dot_output = (n_dot_output.*MW_array)*(1/1000)

	# what is the total coming out?
	total_mass_out = sum(mass_dot_output)
	
	# display -
	with_terminal() do

		# what are the compound names and code strings? -> we can get these from the MODEL object 
		compound_name_strings = MODEL[:compounds][!,:compound_name]
		compound_id_strings = MODEL[:compounds][!,:compound_id]
		
		# how many molecules are in the state array?
		ℳ_local = length(compound_id_strings)
	
		# initialize some storage -
		state_table = Array{Any,2}(undef,ℳ_local,9)

		# get the uptake array from the result -
		uptake_array = result.uptake_array

		# populate the state table -
		for compound_index = 1:ℳ_local
			state_table[compound_index,1] = compound_index
			state_table[compound_index,2] = compound_name_strings[compound_index]
			state_table[compound_index,3] = compound_id_strings[compound_index]
			state_table[compound_index,4] = n_dot_input_stream_1[compound_index]
			state_table[compound_index,5] = n_dot_input_stream_2[compound_index]
			

			# for display -
			tmp_value = abs(n_dot_output[compound_index])
			state_table[compound_index,6] = (tmp_value) <= 1e-6 ? 0.0 : n_dot_output[compound_index]

			# show the Δ -
			tmp_value = abs(uptake_array[compound_index])
			state_table[compound_index,7] = (tmp_value) <= 1e-6 ? 0.0 : uptake_array[compound_index]

			# show the mass -
			tmp_value = abs(mass_dot_output[compound_index])
			state_table[compound_index,8] = (tmp_value) <= 1e-6 ? 0.0 : mass_dot_output[compound_index]

			# show the mass fraction -
			# show the mass -
			tmp_value = abs(mass_dot_output[compound_index])
			state_table[compound_index,9] = (tmp_value) <= 1e-6 ? 0.0 : (1/total_mass_out)*mass_dot_output[compound_index]
		end

		# header row -
		state_table_header_row = (["i","name","id","n₁_dot", "n₂_dot", "n₃_dot","Δn_dot", "m₃_dot", "ωᵢ_output"],
			["","","","mmol/hr", "mmol/hr", "mmol/hr", "mmol/hr", "g/hr", ""]);
		
		# write the table -
		pretty_table(state_table; header=state_table_header_row)
	end
end

# ╔═╡ 80205dc2-0cd9-4543-be6c-2b3a7a5010d5
# How many chips do we want to operate in parallel?
number_of_chips = 41;

# ╔═╡ eb091c37-29f6-45e8-8716-126c2df7f125
# how many levels are we going to have in the separation tree?
number_of_levels = 5;

# ╔═╡ 65c26314-f7de-42c7-978c-5fe18ef45850
# what compound are we trying to separate?
idx_target_compound = find_compound_index(MODEL,:compound_name=>"hydrazine");

# ╔═╡ fe1a84e2-0a44-4341-9add-35f8bb296454
begin

	# alias the mass flow into the sep-units
	# mass flow coming out of the mixer -
	mass_flow_into_seps = (number_of_chips)*mass_dot_output
	
	# define the split -
	θ = 0.75

	# most of the "stuff" has a 1 - θ in the up, and a θ in the down
	u = (1-θ)*ones(ℳ,1)
	d = θ*ones(ℳ,1)

	# correct defaults -
	u[idx_target_compound] = θ
	d[idx_target_compound] = 1 - θ

	# let's compute the composition of the *always up* stream -
	
	# initialize some storage -
	species_mass_flow_array_top = zeros(ℳ,number_of_levels)
	species_mass_flow_array_bottom = zeros(ℳ,number_of_levels)

	for species_index = 1:ℳ
		value = mass_flow_into_seps[species_index]
		species_mass_flow_array_top[species_index,1] = value
		species_mass_flow_array_bottom[species_index,1] = value
	end
	
	for level = 2:number_of_levels

		# compute the mass flows coming out of the top -
		m_dot_top = mass_flow_into_seps.*(u.^(level-1))
		m_dot_bottom = mass_flow_into_seps.*(d.^(level-1))

		# update my storage array -
		for species_index = 1:ℳ
			species_mass_flow_array_top[species_index,level] = m_dot_top[species_index]
			species_mass_flow_array_bottom[species_index,level] = m_dot_bottom[species_index]
		end
	end
	
	# what is the mass fraction in the top stream -
	species_mass_fraction_array_top = zeros(ℳ,number_of_levels)
	species_mass_fraction_array_bottom = zeros(ℳ,number_of_levels)

	# array to hold the *total* mass flow rate -
	total_mdot_top_array = zeros(number_of_levels)
	total_mdot_bottom_array = zeros(number_of_levels)
	
	# this is a dumb way to do this ... you're better than that JV come on ...
	T_top = sum(species_mass_flow_array_top,dims=1)
	T_bottom = sum(species_mass_flow_array_bottom,dims=1)
	for level = 1:number_of_levels

		# get the total for this level -
		T_level_top = T_top[level]
		T_level_bottom = T_bottom[level]

		# grab -
		total_mdot_top_array[level] = T_level_top
		total_mdot_bottom_array[level] = T_level_bottom

		for species_index = 1:ℳ
			species_mass_fraction_array_top[species_index,level] = (1/T_level_top)*
				(species_mass_flow_array_top[species_index,level])
			species_mass_fraction_array_bottom[species_index,level] = (1/T_level_bottom)*
				(species_mass_flow_array_bottom[species_index,level])
		end
	end
end

# ╔═╡ efe968b6-4914-4c4c-a2fb-50d7e71f582b
begin

	stages = (1:number_of_levels) |> collect
	plot(stages,species_mass_fraction_array_top[idx_target_compound,:], linetype=:steppre,lw=2,legend=:bottomright, 
		label="Mass fraction i = PDO Tops")
	xlabel!("Stage index l",fontsize=18)
	ylabel!("Tops mass fraction ωᵢ (dimensionless)",fontsize=18)

	# make a 0.95 line target line -
	target_line = 0.95*ones(number_of_levels)
	plot!(stages, target_line, color="red", lw=2,linestyle=:dash, label="Target 95% purity")
end

# ╔═╡ 4a308e7a-0149-4816-a24e-ecf23c0a759c
with_terminal() do

	# initialize some space -
	state_table = Array{Any,2}(undef, number_of_levels, 3)
	for level_index = 1:number_of_levels
		state_table[level_index,1] = level_index
		state_table[level_index,2] = species_mass_fraction_array_top[idx_target_compound, level_index]
		state_table[level_index,3] = total_mdot_top_array[level_index]
	end
	
	# header -
	state_table_header_row = (["stage","ωᵢ i=⋆ top","mdot"],
			["","","g/hr"]);

	# write the table -
	pretty_table(state_table; header=state_table_header_row)
end

# ╔═╡ 2b28a12e-c880-4cf0-ba31-c04cc11ef3ed
md"""
#### Technical Analysis
As demonstrated by the data, we were able to efficiently meet the minimum specifications for our project sponsor. The output stream, after being passed through 5 levels of separation, is 95.98% purely hydrazine. However, with each separation level, the mass flow rate of the output stream decreases substantially. For example, after the first level of separation, the output steam mass flow rate drops by 64%. As a result, 41 reactors are needed to achieve this 1 gram per hour target.

In order to avoid unnecessary separation, as more separation necessitates a greater number of reactors, we aimed to minimize unreacted starting material in the output stream. Through experimentation with different quantities, we were able to achieve negligible unreacted starting material in the output stream. This ensures that the number of levels of separation is minimized.

As efficient as the performance of the project is, one alternative is instead arranging the 41 reactors in series and feeding in all the starting material at the beginning. While this may seem more beneficial by eliminating the need to separate the reactants stream into 41 individual input streams for the reactors in parallel, the actual advantages are virtually negligible. If these reactors were arranged in series the output stream would be 0.0154% more pure, but the mass flow rate of the output stream would be 0.00024 grams per hour fewer than the parallel output stream. Given the minimal nature of these changes to the project's performance and the added complexity of arranging and analyzing the reactors in series, this alternative approach would not improve the performance of this project.
"""

# ╔═╡ fd339470-ffef-49fa-8636-dce7924e6405
md"""
### 4. Conclusions

In the end, the reactor meets the needed specifications, producing slightly over 1 gram of Hydrazine per hour, while utilizing a feestock of Maltose. The reactor does contain many microreacters but that is necessary to achieve the scale of production required. 

The largest concern is the unprofibility of the entire operation, but given the parameters, that was unavoidable. Following the chemical reaction taking place it would take at least 1 mole of nitric oxide, 1 mole of ammonia, and 1.5 moles of Maltose to produce 1 mole of Hydrazine. 

In a perfectly efficient world, the reaction would occur in the above ratios, and the full mole of hydrazine could be extracted. Even then, 1 mole of Hydrazine costs less than the components needed to produce it, thus the reactor is necessarily deepply unprofitable. 

To make the reactor more cost efficient, gathering some of the by-products, like isoprene, for secondary sale would help. 

"""

# ╔═╡ 4e1df815-76bd-4ad2-82cd-78dbe98c0d39
md"
### Video

"

# ╔═╡ ac48145b-0bdd-4f8e-a357-c62d26d0f8be
html"""

<iframe width="950" height="534" src="https://www.youtube.com/embed/I1ol6SsNs84" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

"""

# ╔═╡ 2f2713eb-a958-4d1a-a1cc-2723ea13c38c
md"""
### References

[Guthrie, S., Giles, S., Dunkerley, F., & Tabaqchali, H. (n.d.). The impact of ammonia emissions from agriculture on biodiversity. 76.
](https://royalsociety.org/~/media/policy/projects/evidence-synthesis/Ammonia/Ammonia-report.pdf)

[Maltose. (n.d.). New World Encyclopedia. Retrieved December 15, 2021, from https://www.newworldencyclopedia.org/entry/Maltose.](https://www.newworldencyclopedia.org/entry/Maltose)

[National Center for Biotechnology Information (2021). PubChem Compound Summary for CID 222, Ammonia. Retrieved December 15, 2021 from 		https://pubchem.ncbi.nlm.nih.gov/compound/Ammonia.](https://pubchem.ncbi.nlm.nih.gov/compound/Ammonia)

[National Center for Biotechnology Information (2021). PubChem Compound Summary for CID 9321, Hydrazine. Retrieved December 15, 2021 from https://pubchem.ncbi.nlm.nih.gov/compound/Hydrazine.](https://pubchem.ncbi.nlm.nih.gov/compound/Hydrazine)
"""

# ╔═╡ cef22b5d-be5d-49f2-987f-77cf1b9379b9
html"""
<style>

main {
    max-width: 1200px;
    width: 75%;
    margin: auto;
    font-family: "Roboto, monospace";
}

a {
    color: blue;
    text-decoration: none;
}

.H1 {
    padding: 0px 30px;
}
</style>"""

# ╔═╡ 213d4486-584f-11ec-2373-5d05e90dc5f8
html"""
<script>

	// initialize -
	var section = 0;
	var subsection = 0;
	var headers = document.querySelectorAll('h3, h4');
	
	// main loop -
	for (var i=0; i < headers.length; i++) {
	    
		var header = headers[i];
	    var text = header.innerText;
	    var original = header.getAttribute("text-original");
	    if (original === null) {
	        
			// Save original header text
	        header.setAttribute("text-original", text);
	    } else {
	        
			// Replace with original text before adding section number
	        text = header.getAttribute("text-original");
	    }
	
	    var numbering = "";
	    switch (header.tagName) {
	        case 'H3':
	            section += 1;
	            numbering = section + ".";
	            subsection = 0;
	            break;
	        case 'H4':
	            subsection += 1;
	            numbering = section + "." + subsection;
	            break;
	    }

		// update the header text 
		header.innerText = numbering + " " + text;
	};
</script>
"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
BSON = "fbb218c0-5317-5bc6-957e-2ee96dd4b1f0"
DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
GLPK = "60bf3e95-4087-53dc-ae20-288a0d20c6a6"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
PrettyTables = "08abe8d2-0d0c-5749-adfa-8a2ac140af0d"

[compat]
BSON = "~0.3.4"
DataFrames = "~1.3.0"
GLPK = "~0.15.2"
Plots = "~1.25.2"
PlutoUI = "~0.7.22"
PrettyTables = "~1.2.3"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

[[AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "abb72771fd8895a7ebd83d5632dc4b989b022b5b"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.2"

[[Adapt]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "84918055d15b3114ede17ac6a7182f68870c16f7"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "3.3.1"

[[ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[BSON]]
git-tree-sha1 = "ebcd6e22d69f21249b7b8668351ebf42d6dc87a1"
uuid = "fbb218c0-5317-5bc6-957e-2ee96dd4b1f0"
version = "0.3.4"

[[Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[BenchmarkTools]]
deps = ["JSON", "Logging", "Printf", "Profile", "Statistics", "UUIDs"]
git-tree-sha1 = "940001114a0147b6e4d10624276d56d531dd9b49"
uuid = "6e4b80f9-dd63-53aa-95a3-0cdb28fa8baf"
version = "1.2.2"

[[BinaryProvider]]
deps = ["Libdl", "Logging", "SHA"]
git-tree-sha1 = "ecdec412a9abc8db54c0efc5548c64dfce072058"
uuid = "b99e7846-7c00-51b0-8f62-c81ae34c0232"
version = "0.5.10"

[[Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "19a35467a82e236ff51bc17a3a44b69ef35185a2"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.8+0"

[[CEnum]]
git-tree-sha1 = "215a9aa4a1f23fbd05b92769fdd62559488d70e9"
uuid = "fa961155-64e5-5f13-b03f-caf6b980ea82"
version = "0.4.1"

[[Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "f2202b55d816427cd385a9a4f3ffb226bee80f99"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.16.1+0"

[[ChainRulesCore]]
deps = ["Compat", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "4c26b4e9e91ca528ea212927326ece5918a04b47"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.11.2"

[[ChangesOfVariables]]
deps = ["ChainRulesCore", "LinearAlgebra", "Test"]
git-tree-sha1 = "bf98fa45a0a4cee295de98d4c1462be26345b9a1"
uuid = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
version = "0.1.2"

[[CodecBzip2]]
deps = ["Bzip2_jll", "Libdl", "TranscodingStreams"]
git-tree-sha1 = "2e62a725210ce3c3c2e1a3080190e7ca491f18d7"
uuid = "523fee87-0ab8-5b00-afb7-3ecf72e48cfd"
version = "0.7.2"

[[CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "ded953804d019afa9a3f98981d99b33e3db7b6da"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.0"

[[ColorSchemes]]
deps = ["ColorTypes", "Colors", "FixedPointNumbers", "Random"]
git-tree-sha1 = "a851fec56cb73cfdf43762999ec72eff5b86882a"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.15.0"

[[ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "024fe24d83e4a5bf5fc80501a314ce0d1aa35597"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.0"

[[Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "417b0ed7b8b838aa6ca0a87aadf1bb9eb111ce40"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.8"

[[Compat]]
deps = ["Base64", "Dates", "DelimitedFiles", "Distributed", "InteractiveUtils", "LibGit2", "Libdl", "LinearAlgebra", "Markdown", "Mmap", "Pkg", "Printf", "REPL", "Random", "SHA", "Serialization", "SharedArrays", "Sockets", "SparseArrays", "Statistics", "Test", "UUIDs", "Unicode"]
git-tree-sha1 = "dce3e3fea680869eaa0b774b2e8343e9ff442313"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "3.40.0"

[[CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[Contour]]
deps = ["StaticArrays"]
git-tree-sha1 = "9f02045d934dc030edad45944ea80dbd1f0ebea7"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.5.7"

[[Crayons]]
git-tree-sha1 = "3f71217b538d7aaee0b69ab47d9b7724ca8afa0d"
uuid = "a8cc5b0e-0ffa-5ad4-8c14-923d3ee1735f"
version = "4.0.4"

[[DataAPI]]
git-tree-sha1 = "cc70b17275652eb47bc9e5f81635981f13cea5c8"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.9.0"

[[DataFrames]]
deps = ["Compat", "DataAPI", "Future", "InvertedIndices", "IteratorInterfaceExtensions", "LinearAlgebra", "Markdown", "Missings", "PooledArrays", "PrettyTables", "Printf", "REPL", "Reexport", "SortingAlgorithms", "Statistics", "TableTraits", "Tables", "Unicode"]
git-tree-sha1 = "2e993336a3f68216be91eb8ee4625ebbaba19147"
uuid = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
version = "1.3.0"

[[DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "3daef5523dd2e769dad2365274f760ff5f282c7d"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.11"

[[DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[DelimitedFiles]]
deps = ["Mmap"]
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"

[[Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "b19534d1895d702889b219c382a6e18010797f0b"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.8.6"

[[Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[EarCut_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "3f3a2501fa7236e9b911e0f7a588c657e822bb6d"
uuid = "5ae413db-bbd1-5e63-b57d-d24a61df00f5"
version = "2.2.3+0"

[[Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b3bfd02e98aedfa5cf885665493c5598c350cd2f"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.2.10+0"

[[FFMPEG]]
deps = ["FFMPEG_jll"]
git-tree-sha1 = "b57e3acbe22f8484b4b5ff66a7499717fe1a9cc8"
uuid = "c87230d0-a227-11e9-1b43-d7ebe4e7570a"
version = "0.4.1"

[[FFMPEG_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "Pkg", "Zlib_jll", "libass_jll", "libfdk_aac_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "d8a578692e3077ac998b50c0217dfd67f21d1e5f"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "4.4.0+0"

[[FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[Fontconfig_jll]]
deps = ["Artifacts", "Bzip2_jll", "Expat_jll", "FreeType2_jll", "JLLWrappers", "Libdl", "Libuuid_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "21efd19106a55620a188615da6d3d06cd7f6ee03"
uuid = "a3f928ae-7b40-5064-980b-68af3947d34b"
version = "2.13.93+0"

[[Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

[[FreeType2_jll]]
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "87eb71354d8ec1a96d4a7636bd57a7347dde3ef9"
uuid = "d7e528f0-a631-5988-bf34-fe36492bcfd7"
version = "2.10.4+0"

[[FriBidi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "aa31987c2ba8704e23c6c8ba8a4f769d5d7e4f91"
uuid = "559328eb-81f9-559d-9380-de523a88c83c"
version = "1.0.10+0"

[[Future]]
deps = ["Random"]
uuid = "9fa8497b-333b-5362-9e8d-4d0656e87820"

[[GLFW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libglvnd_jll", "Pkg", "Xorg_libXcursor_jll", "Xorg_libXi_jll", "Xorg_libXinerama_jll", "Xorg_libXrandr_jll"]
git-tree-sha1 = "0c603255764a1fa0b61752d2bec14cfbd18f7fe8"
uuid = "0656b61e-2033-5cc2-a64a-77c0f6c09b89"
version = "3.3.5+1"

[[GLPK]]
deps = ["BinaryProvider", "CEnum", "GLPK_jll", "Libdl", "MathOptInterface"]
git-tree-sha1 = "ab6d06aa06ce3de20a82de5f7373b40796260f72"
uuid = "60bf3e95-4087-53dc-ae20-288a0d20c6a6"
version = "0.15.2"

[[GLPK_jll]]
deps = ["Artifacts", "GMP_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "fe68622f32828aa92275895fdb324a85894a5b1b"
uuid = "e8aa6df9-e6ca-548a-97ff-1f85fc5b8b98"
version = "5.0.1+0"

[[GMP_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "781609d7-10c4-51f6-84f2-b8444358ff6d"

[[GR]]
deps = ["Base64", "DelimitedFiles", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Pkg", "Printf", "Random", "Serialization", "Sockets", "Test", "UUIDs"]
git-tree-sha1 = "30f2b340c2fff8410d89bfcdc9c0a6dd661ac5f7"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.62.1"

[[GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Pkg", "Qt5Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "fd75fa3a2080109a2c0ec9864a6e14c60cca3866"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.62.0+0"

[[GeometryBasics]]
deps = ["EarCut_jll", "IterTools", "LinearAlgebra", "StaticArrays", "StructArrays", "Tables"]
git-tree-sha1 = "58bcdf5ebc057b085e58d95c138725628dd7453c"
uuid = "5c1252a2-5f33-56bf-86c9-59e7332b4326"
version = "0.4.1"

[[Gettext_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "9b02998aba7bf074d14de89f9d37ca24a1a0b046"
uuid = "78b55507-aeef-58d4-861c-77aaff3498b1"
version = "0.21.0+0"

[[Glib_jll]]
deps = ["Artifacts", "Gettext_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "74ef6288d071f58033d54fd6708d4bc23a8b8972"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.68.3+1"

[[Graphite2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "344bf40dcab1073aca04aa0df4fb092f920e4011"
uuid = "3b182d85-2403-5c21-9c21-1e1f0cc25472"
version = "1.3.14+0"

[[Grisu]]
git-tree-sha1 = "53bb909d1151e57e2484c3d1b53e19552b887fb2"
uuid = "42e2da0e-8278-4e71-bc24-59509adca0fe"
version = "1.0.2"

[[HTTP]]
deps = ["Base64", "Dates", "IniFile", "Logging", "MbedTLS", "NetworkOptions", "Sockets", "URIs"]
git-tree-sha1 = "0fa77022fe4b511826b39c894c90daf5fce3334a"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "0.9.17"

[[HarfBuzz_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "Graphite2_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg"]
git-tree-sha1 = "129acf094d168394e80ee1dc4bc06ec835e510a3"
uuid = "2e76f6c2-a576-52d4-95c1-20adfe4de566"
version = "2.8.1+1"

[[Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[HypertextLiteral]]
git-tree-sha1 = "2b078b5a615c6c0396c77810d92ee8c6f470d238"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.3"

[[IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "f7be53659ab06ddc986428d3a9dcc95f6fa6705a"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.2"

[[IniFile]]
deps = ["Test"]
git-tree-sha1 = "098e4d2c533924c921f9f9847274f2ad89e018b8"
uuid = "83e8ac13-25f8-5344-8a64-a9f2b223428f"
version = "0.5.0"

[[InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[InverseFunctions]]
deps = ["Test"]
git-tree-sha1 = "a7254c0acd8e62f1ac75ad24d5db43f5f19f3c65"
uuid = "3587e190-3f89-42d0-90ee-14403ec27112"
version = "0.1.2"

[[InvertedIndices]]
git-tree-sha1 = "bee5f1ef5bf65df56bdd2e40447590b272a5471f"
uuid = "41ab1584-1d38-5bbf-9106-f11c6c58b48f"
version = "1.1.0"

[[IrrationalConstants]]
git-tree-sha1 = "7fd44fd4ff43fc60815f8e764c0f352b83c49151"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.1.1"

[[IterTools]]
git-tree-sha1 = "fa6287a4469f5e048d763df38279ee729fbd44e5"
uuid = "c8e1da08-722c-5040-9ed9-7db0dc04731e"
version = "1.4.0"

[[IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[JLLWrappers]]
deps = ["Preferences"]
git-tree-sha1 = "642a199af8b68253517b80bd3bfd17eb4e84df6e"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.3.0"

[[JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "8076680b162ada2a031f707ac7b4953e30667a37"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.2"

[[JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "d735490ac75c5cb9f1b00d8b5509c11984dc6943"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "2.1.0+0"

[[LAME_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f6250b16881adf048549549fba48b1161acdac8c"
uuid = "c1c5ebd0-6772-5130-a774-d5fcae4a789d"
version = "3.100.1+0"

[[LZO_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e5b909bcf985c5e2605737d2ce278ed791b89be6"
uuid = "dd4b983a-f0e5-5f8d-a1b7-129d4a5fb1ac"
version = "2.10.1+0"

[[LaTeXStrings]]
git-tree-sha1 = "f2355693d6778a178ade15952b7ac47a4ff97996"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.0"

[[Latexify]]
deps = ["Formatting", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "Printf", "Requires"]
git-tree-sha1 = "a8f4f279b6fa3c3c4f1adadd78a621b13a506bce"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.15.9"

[[LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"

[[LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"

[[LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"

[[Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[Libffi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "0b4a5d71f3e5200a7dff793393e09dfc2d874290"
uuid = "e9f186c6-92d2-5b65-8a66-fee21dc1b490"
version = "3.2.2+1"

[[Libgcrypt_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgpg_error_jll", "Pkg"]
git-tree-sha1 = "64613c82a59c120435c067c2b809fc61cf5166ae"
uuid = "d4300ac3-e22c-5743-9152-c294e39db1e4"
version = "1.8.7+0"

[[Libglvnd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll", "Xorg_libXext_jll"]
git-tree-sha1 = "7739f837d6447403596a75d19ed01fd08d6f56bf"
uuid = "7e76a0d4-f3c7-5321-8279-8d96eeed0f29"
version = "1.3.0+3"

[[Libgpg_error_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c333716e46366857753e273ce6a69ee0945a6db9"
uuid = "7add5ba3-2f88-524e-9cd5-f83b8a55f7b8"
version = "1.42.0+0"

[[Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "42b62845d70a619f063a7da093d995ec8e15e778"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.16.1+1"

[[Libmount_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9c30530bf0effd46e15e0fdcf2b8636e78cbbd73"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.35.0+0"

[[Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Pkg", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "340e257aada13f95f98ee352d316c3bed37c8ab9"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.3.0+0"

[[Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7f3efec06033682db852f8b3bc3c1d2b0a0ab066"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.36.0+0"

[[LinearAlgebra]]
deps = ["Libdl"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[LogExpFunctions]]
deps = ["ChainRulesCore", "ChangesOfVariables", "DocStringExtensions", "InverseFunctions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "be9eef9f9d78cecb6f262f3c10da151a6c5ab827"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.5"

[[Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "3d3e902b31198a27340d0bf00d6ac452866021cf"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.9"

[[Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[MathOptInterface]]
deps = ["BenchmarkTools", "CodecBzip2", "CodecZlib", "JSON", "LinearAlgebra", "MutableArithmetics", "OrderedCollections", "Printf", "SparseArrays", "Test", "Unicode"]
git-tree-sha1 = "92b7de61ecb616562fd2501334f729cc9db2a9a6"
uuid = "b8f27783-ece8-5eb3-8dc8-9495eed66fee"
version = "0.10.6"

[[MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "Random", "Sockets"]
git-tree-sha1 = "1c38e51c3d08ef2278062ebceade0e46cefc96fe"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.0.3"

[[MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[Measures]]
git-tree-sha1 = "e498ddeee6f9fdb4551ce855a46f54dbd900245f"
uuid = "442fdcdd-2543-5da2-b0f3-8c86c306513e"
version = "0.3.1"

[[Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "bf210ce90b6c9eed32d25dbcae1ebc565df2687f"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.0.2"

[[Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[MutableArithmetics]]
deps = ["LinearAlgebra", "SparseArrays", "Test"]
git-tree-sha1 = "7bb6853d9afec54019c1397c6eb610b9b9a19525"
uuid = "d8a4904e-b15c-11e9-3269-09a3773c0cb0"
version = "0.3.1"

[[NaNMath]]
git-tree-sha1 = "bfe47e760d60b82b66b61d2d44128b62e3a369fb"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "0.3.5"

[[NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7937eda4681660b4d6aeeecc2f7e1c81c8ee4e2f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+0"

[[OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "15003dcb7d8db3c6c857fda14891a539a8f2705a"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "1.1.10+0"

[[Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "51a08fb14ec28da2ec7a927c4337e4332c2a4720"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.3.2+0"

[[OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[PCRE_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b2a7af664e098055a7529ad1a900ded962bca488"
uuid = "2f80f16e-611a-54ab-bc61-aa92de5b98fc"
version = "8.44.0+0"

[[Parsers]]
deps = ["Dates"]
git-tree-sha1 = "ae4bbcadb2906ccc085cf52ac286dc1377dceccc"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.1.2"

[[Pixman_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b4f5d02549a10e20780a24fce72bea96b6329e29"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.40.1+0"

[[Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[PlotThemes]]
deps = ["PlotUtils", "Requires", "Statistics"]
git-tree-sha1 = "a3a964ce9dc7898193536002a6dd892b1b5a6f1d"
uuid = "ccf2f8ad-2431-5c83-bf29-c5338b663b6a"
version = "2.0.1"

[[PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "Printf", "Random", "Reexport", "Statistics"]
git-tree-sha1 = "b084324b4af5a438cd63619fd006614b3b20b87b"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.0.15"

[[Plots]]
deps = ["Base64", "Contour", "Dates", "Downloads", "FFMPEG", "FixedPointNumbers", "GR", "GeometryBasics", "JSON", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "PlotThemes", "PlotUtils", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "Requires", "Scratch", "Showoff", "SparseArrays", "Statistics", "StatsBase", "UUIDs", "UnicodeFun"]
git-tree-sha1 = "65ebc27d8c00c84276f14aaf4ff63cbe12016c70"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.25.2"

[[PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "565564f615ba8c4e4f40f5d29784aa50a8f7bbaf"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.22"

[[PooledArrays]]
deps = ["DataAPI", "Future"]
git-tree-sha1 = "db3a23166af8aebf4db5ef87ac5b00d36eb771e2"
uuid = "2dfb63ee-cc39-5dd5-95bd-886bf059d720"
version = "1.4.0"

[[Preferences]]
deps = ["TOML"]
git-tree-sha1 = "00cfd92944ca9c760982747e9a1d0d5d86ab1e5a"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.2.2"

[[PrettyTables]]
deps = ["Crayons", "Formatting", "Markdown", "Reexport", "Tables"]
git-tree-sha1 = "d940010be611ee9d67064fe559edbb305f8cc0eb"
uuid = "08abe8d2-0d0c-5749-adfa-8a2ac140af0d"
version = "1.2.3"

[[Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[Profile]]
deps = ["Printf"]
uuid = "9abbd945-dff8-562f-b5e8-e1ebf5ef1b79"

[[Qt5Base_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Fontconfig_jll", "Glib_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "OpenSSL_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libxcb_jll", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_keysyms_jll", "Xorg_xcb_util_renderutil_jll", "Xorg_xcb_util_wm_jll", "Zlib_jll", "xkbcommon_jll"]
git-tree-sha1 = "ad368663a5e20dbb8d6dc2fddeefe4dae0781ae8"
uuid = "ea2cea3b-5b76-57ae-a6ef-0a8af62496e1"
version = "5.15.3+0"

[[REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[Random]]
deps = ["Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[RecipesBase]]
git-tree-sha1 = "6bf3f380ff52ce0832ddd3a2a7b9538ed1bcca7d"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.2.1"

[[RecipesPipeline]]
deps = ["Dates", "NaNMath", "PlotUtils", "RecipesBase"]
git-tree-sha1 = "7ad0dfa8d03b7bcf8c597f59f5292801730c55b8"
uuid = "01d81517-befc-4cb6-b9ec-a95719d0359c"
version = "0.4.1"

[[Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "4036a3bd08ac7e968e27c203d45f5fff15020621"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.1.3"

[[SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[Scratch]]
deps = ["Dates"]
git-tree-sha1 = "0b4b7f1393cff97c33891da2a0bf69c6ed241fda"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.1.0"

[[Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"

[[Showoff]]
deps = ["Dates", "Grisu"]
git-tree-sha1 = "91eddf657aca81df9ae6ceb20b959ae5653ad1de"
uuid = "992d4aef-0814-514b-bc4d-f2e9a6c4116f"
version = "1.0.3"

[[Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "b3363d7460f7d098ca0912c69b082f75625d7508"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.0.1"

[[SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[StaticArrays]]
deps = ["LinearAlgebra", "Random", "Statistics"]
git-tree-sha1 = "3c76dde64d03699e074ac02eb2e8ba8254d428da"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.2.13"

[[Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[StatsAPI]]
git-tree-sha1 = "0f2aa8e32d511f758a2ce49208181f7733a0936a"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.1.0"

[[StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "2bb0cb32026a66037360606510fca5984ccc6b75"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.33.13"

[[StructArrays]]
deps = ["Adapt", "DataAPI", "StaticArrays", "Tables"]
git-tree-sha1 = "2ce41e0d042c60ecd131e9fb7154a3bfadbf50d3"
uuid = "09ab397b-f2b6-538f-b94a-2f83cf4a842a"
version = "0.6.3"

[[TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "TableTraits", "Test"]
git-tree-sha1 = "fed34d0e71b91734bf0a7e10eb1bb05296ddbcd0"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.6.0"

[[Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[TranscodingStreams]]
deps = ["Random", "Test"]
git-tree-sha1 = "216b95ea110b5972db65aa90f88d8d89dcb8851c"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.9.6"

[[URIs]]
git-tree-sha1 = "97bbe755a53fe859669cd907f2d96aee8d2c1355"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.3.0"

[[UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[UnicodeFun]]
deps = ["REPL"]
git-tree-sha1 = "53915e50200959667e78a92a418594b428dffddf"
uuid = "1cfade01-22cf-5700-b092-accc4b62d6e1"
version = "0.4.1"

[[Wayland_jll]]
deps = ["Artifacts", "Expat_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "3e61f0b86f90dacb0bc0e73a0c5a83f6a8636e23"
uuid = "a2964d1f-97da-50d4-b82a-358c7fce9d89"
version = "1.19.0+0"

[[Wayland_protocols_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "66d72dc6fcc86352f01676e8f0f698562e60510f"
uuid = "2381bf8a-dfd0-557d-9999-79630e7b1b91"
version = "1.23.0+0"

[[XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "1acf5bdf07aa0907e0a37d3718bb88d4b687b74a"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.9.12+0"

[[XSLT_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgcrypt_jll", "Libgpg_error_jll", "Libiconv_jll", "Pkg", "XML2_jll", "Zlib_jll"]
git-tree-sha1 = "91844873c4085240b95e795f692c4cec4d805f8a"
uuid = "aed1982a-8fda-507f-9586-7b0439959a61"
version = "1.1.34+0"

[[Xorg_libX11_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll", "Xorg_xtrans_jll"]
git-tree-sha1 = "5be649d550f3f4b95308bf0183b82e2582876527"
uuid = "4f6342f7-b3d2-589e-9d20-edeb45f2b2bc"
version = "1.6.9+4"

[[Xorg_libXau_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4e490d5c960c314f33885790ed410ff3a94ce67e"
uuid = "0c0b7dd1-d40b-584c-a123-a41640f87eec"
version = "1.0.9+4"

[[Xorg_libXcursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXfixes_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "12e0eb3bc634fa2080c1c37fccf56f7c22989afd"
uuid = "935fb764-8cf2-53bf-bb30-45bb1f8bf724"
version = "1.2.0+4"

[[Xorg_libXdmcp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fe47bd2247248125c428978740e18a681372dd4"
uuid = "a3789734-cfe1-5b06-b2d0-1dd0d9d62d05"
version = "1.1.3+4"

[[Xorg_libXext_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "b7c0aa8c376b31e4852b360222848637f481f8c3"
uuid = "1082639a-0dae-5f34-9b06-72781eeb8cb3"
version = "1.3.4+4"

[[Xorg_libXfixes_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "0e0dc7431e7a0587559f9294aeec269471c991a4"
uuid = "d091e8ba-531a-589c-9de9-94069b037ed8"
version = "5.0.3+4"

[[Xorg_libXi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXfixes_jll"]
git-tree-sha1 = "89b52bc2160aadc84d707093930ef0bffa641246"
uuid = "a51aa0fd-4e3c-5386-b890-e753decda492"
version = "1.7.10+4"

[[Xorg_libXinerama_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll"]
git-tree-sha1 = "26be8b1c342929259317d8b9f7b53bf2bb73b123"
uuid = "d1454406-59df-5ea1-beac-c340f2130bc3"
version = "1.1.4+4"

[[Xorg_libXrandr_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "34cea83cb726fb58f325887bf0612c6b3fb17631"
uuid = "ec84b674-ba8e-5d96-8ba1-2a689ba10484"
version = "1.5.2+4"

[[Xorg_libXrender_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "19560f30fd49f4d4efbe7002a1037f8c43d43b96"
uuid = "ea2f1a96-1ddc-540d-b46f-429655e07cfa"
version = "0.9.10+4"

[[Xorg_libpthread_stubs_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "6783737e45d3c59a4a4c4091f5f88cdcf0908cbb"
uuid = "14d82f49-176c-5ed1-bb49-ad3f5cbd8c74"
version = "0.1.0+3"

[[Xorg_libxcb_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "XSLT_jll", "Xorg_libXau_jll", "Xorg_libXdmcp_jll", "Xorg_libpthread_stubs_jll"]
git-tree-sha1 = "daf17f441228e7a3833846cd048892861cff16d6"
uuid = "c7cfdc94-dc32-55de-ac96-5a1b8d977c5b"
version = "1.13.0+3"

[[Xorg_libxkbfile_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "926af861744212db0eb001d9e40b5d16292080b2"
uuid = "cc61e674-0454-545c-8b26-ed2c68acab7a"
version = "1.1.0+4"

[[Xorg_xcb_util_image_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "0fab0a40349ba1cba2c1da699243396ff8e94b97"
uuid = "12413925-8142-5f55-bb0e-6d7ca50bb09b"
version = "0.4.0+1"

[[Xorg_xcb_util_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll"]
git-tree-sha1 = "e7fd7b2881fa2eaa72717420894d3938177862d1"
uuid = "2def613f-5ad1-5310-b15b-b15d46f528f5"
version = "0.4.0+1"

[[Xorg_xcb_util_keysyms_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "d1151e2c45a544f32441a567d1690e701ec89b00"
uuid = "975044d2-76e6-5fbe-bf08-97ce7c6574c7"
version = "0.4.0+1"

[[Xorg_xcb_util_renderutil_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "dfd7a8f38d4613b6a575253b3174dd991ca6183e"
uuid = "0d47668e-0667-5a69-a72c-f761630bfb7e"
version = "0.3.9+1"

[[Xorg_xcb_util_wm_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "e78d10aab01a4a154142c5006ed44fd9e8e31b67"
uuid = "c22f9ab0-d5fe-5066-847c-f4bb1cd4e361"
version = "0.4.1+1"

[[Xorg_xkbcomp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxkbfile_jll"]
git-tree-sha1 = "4bcbf660f6c2e714f87e960a171b119d06ee163b"
uuid = "35661453-b289-5fab-8a00-3d9160c6a3a4"
version = "1.4.2+4"

[[Xorg_xkeyboard_config_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xkbcomp_jll"]
git-tree-sha1 = "5c8424f8a67c3f2209646d4425f3d415fee5931d"
uuid = "33bec58e-1273-512f-9401-5d533626f822"
version = "2.27.0+4"

[[Xorg_xtrans_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "79c31e7844f6ecf779705fbc12146eb190b7d845"
uuid = "c5fb5394-a638-5e4d-96e5-b29de1b5cf10"
version = "1.4.0+3"

[[Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "cc4bf3fdde8b7e3e9fa0351bdeedba1cf3b7f6e6"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.0+0"

[[libass_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "5982a94fcba20f02f42ace44b9894ee2b140fe47"
uuid = "0ac62f75-1d6f-5e53-bd7c-93b484bb37c0"
version = "0.15.1+0"

[[libfdk_aac_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "daacc84a041563f965be61859a36e17c4e4fcd55"
uuid = "f638f0a6-7fb0-5443-88ba-1cc74229b280"
version = "2.0.2+0"

[[libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "94d180a6d2b5e55e447e2d27a29ed04fe79eb30c"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.38+0"

[[libvorbis_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Ogg_jll", "Pkg"]
git-tree-sha1 = "c45f4e40e7aafe9d086379e5578947ec8b95a8fb"
uuid = "f27f6e37-5d2b-51aa-960f-b287f2bc3b7a"
version = "1.3.7+0"

[[nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"

[[x264_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fea590b89e6ec504593146bf8b988b2c00922b2"
uuid = "1270edf5-f2f9-52d2-97e9-ab00b5d0237a"
version = "2021.5.5+0"

[[x265_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "ee567a171cce03570d77ad3a43e90218e38937a9"
uuid = "dfaa095f-4041-5dcd-9319-2fabd8486b76"
version = "3.5.0+0"

[[xkbcommon_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Wayland_jll", "Wayland_protocols_jll", "Xorg_libxcb_jll", "Xorg_xkeyboard_config_jll"]
git-tree-sha1 = "ece2350174195bb31de1a63bea3a41ae1aa593b6"
uuid = "d8fb68d0-12a3-5cfd-a85a-d49703b185fd"
version = "0.9.1+5"
"""

# ╔═╡ Cell order:
# ╟─6f9851d0-9573-4965-8456-92d2c57afa91
# ╟─833d7250-f4ab-49a2-a43e-1b21def59ad4
# ╟─251363ad-1927-4b05-99f5-8c3f2508c0cb
# ╟─884a0a7d-e5d8-4417-b109-d00c37a01766
# ╟─b45778d1-bf91-4ccc-a120-28439bcc051c
# ╟─ad5d595e-4dba-49cd-a446-e1df737fd75d
# ╠═5bfdf6f9-2927-4a9a-a386-8840c676329b
# ╟─e8a4faf8-2285-4544-830c-f39d3847e8cc
# ╟─10424555-39cc-4ddf-8c22-db91cf102bfd
# ╟─a6ae99b6-ea8a-48f0-a7a3-4032c675c249
# ╟─189f8301-3185-4ba6-b644-b2ddae70768d
# ╟─a3632011-833e-431b-b08f-f2896ad0a82a
# ╠═39f3633e-b9df-4d01-946f-ba2d6c8ba6b7
# ╟─4b3ef98c-d304-4ef4-95ef-f1d1ce562e36
# ╠═7166a917-b676-465c-a441-4ff0530faf92
# ╠═80205dc2-0cd9-4543-be6c-2b3a7a5010d5
# ╠═eb091c37-29f6-45e8-8716-126c2df7f125
# ╠═65c26314-f7de-42c7-978c-5fe18ef45850
# ╠═fe1a84e2-0a44-4341-9add-35f8bb296454
# ╠═efe968b6-4914-4c4c-a2fb-50d7e71f582b
# ╠═4a308e7a-0149-4816-a24e-ecf23c0a759c
# ╟─2b28a12e-c880-4cf0-ba31-c04cc11ef3ed
# ╟─fd339470-ffef-49fa-8636-dce7924e6405
# ╟─4e1df815-76bd-4ad2-82cd-78dbe98c0d39
# ╟─ac48145b-0bdd-4f8e-a357-c62d26d0f8be
# ╟─2f2713eb-a958-4d1a-a1cc-2723ea13c38c
# ╟─5458cafc-430a-4e2e-a3f9-d23023e6053b
# ╟─cef22b5d-be5d-49f2-987f-77cf1b9379b9
# ╟─213d4486-584f-11ec-2373-5d05e90dc5f8
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
