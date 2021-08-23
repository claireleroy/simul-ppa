
global path "C:\Users\clair\Documents\Github\simul-ppa"


** Individual table

	import excel using "${path}\assets\varlist_fideli_2017.xlsx", firstrow sheet("fideli_individu17_diff_1") clear
	keep name label modalites
	save "${path}\assets\varlist_fideli_individu17_diff_1", replace

	local nb_var = _N
	forval i = 1/`nb_var'{
		local name = name[`i']
		gen `name' = runiform() *1000
		if substr("`name'", 1, 2) == "id"{
			drop `name'
		}
		if modalites[`i'] != "" {
			tostring(`name'), replace force
			replace `name' = subinstr(`name', ".", "", 1)
		}
	}
	drop name label modalites

	gen id_ind = _n
	local nb_men = int(_N / 3)

	gen id_log = runiformint(1,`nb_men')
	order id_ind id*
	sort id_log id_ind
	save "${path}\data\fideli_individu17_diff_1", replace


***

import excel using "${path}\assets\varlist_fideli_2017.xlsx", firstrow sheet("fideli_local17_diff_1") clear
keep name label modalites
save "${path}\assets\varlist_fideli_local17_diff_1", replace

local nb_var = _N
forval i = 1/`nb_var'{
	local name = name[`i']
	gen `name' = runiform() *1000
	if substr("`name'", 1, 2) == "id"{
		tostring(`name'), replace force
		replace `name' = subinstr(`name', ".", "", 1)
	}
	if modalites[`i'] != "" {
		tostring(`name'), replace force
		replace `name' = subinstr(`name', ".", "", 1)
	}
}
drop name label modalites
drop if _n >= 1

merge 
order id*
save "${path}\data\fideli_local17_diff_1", replace

***

import excel using "${path}\assets\varlist_fideli_2017.xlsx", firstrow sheet("fideli_revenus_filosofi17") clear
keep name label modalites
save "${path}\assets\varlist_fideli_revenus_filosofi17", replace

local nb_var = _N
forval i = 1/`nb_var'{
	local name = name[`i']
	gen `name' = runiform() *1000
	if substr("`name'", 1, 2) == "id"{
		tostring(`name'), replace force
		replace `name' = subinstr(`name', ".", "", 1)
	}
}
drop name label modalites
order id*
save "${path}\data\fideli_revenus_filosofi17", replace

