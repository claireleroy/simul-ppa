
global path "W:\Documents\Github\simul-ppa"


** Individual table
	
	* Load the variable list of the individual FIDELI data table
	import excel using "${path}\assets\varlist_fideli_2017.xlsx", firstrow sheet("fideli_individu17_diff_1") clear
	keep name label modalites
	save "${path}\assets\varlist_fideli_individu17_diff_1", replace
	
	* Create a new variable with each variable name
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
	
	* Create the individual ID variable
	gen id_ind = _n
	
	* Allocate individual to households
	local nb_men = int(_N / 3)
	gen id_log = runiformint(1,`nb_men')
	
	* Simulate more precisely some variables
		
		* LIEN_FAMILIAL : one head of household (lien_familial = 10) and at most one spouse of the household's head (lien_familial == 21 or 22)
		drop lien_familial
		gen lien_familial1 = runiformint(1,8)
		recode lien_familial1 (1 = 10) (2 = 21) (3 = 22) (4 = 31) (5 = 50) (6 = 60) (7 = 70) (8 = 80), gen(lien_familial)
		drop lien_familial1
		bys id_log (lien_familial): replace lien_familial = 10 if _n == 1 & lien_familial > 10
		bys id_log lien_familial: replace lien_familial = 31 if _n > 1 & lien_familial == 10
		tostring lien_familial, replace
		gen is_conj = (lien_familial == "21" | lien_familial == "22")
		bys id_log is_conj (anais): gen is_older_conj = (_n == 1)
		bys id_log : replace lien_familial = "31" if is_conj == 1 & is_older_conj == 0
		*
		bys id_log: egen tot_decl = total((lien_familial == "10"))
		assert tot_decl == 1
		bys id_log: egen tot_conj = total((lien_familial == "21" | lien_familial == "22"))
		assert tot_conj < 2
		drop tot_conj tot_decl is_conj is_older_conj
		
		* ANAIS
		drop anais
		gen anais = runiformint(1920,2017)
		order id_ind id* lien_familial
		sort id_log id_ind
	
	save "${path}\data\fideli_individu17_diff_1", replace

*** Buildings ("local") table

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

*** Income table

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

