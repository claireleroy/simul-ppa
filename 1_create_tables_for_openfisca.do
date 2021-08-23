
global path "C:\Users\clair\Documents\Github\simul-ppa"

* 1 table INDIVIDU : avec id_ind, id_fam, id_foy, id_log
* 1 table FAMILLE : avec id_fam
* 1 table FOYER FISCAL : avec id_foy (for now : table FOYER FISCAL = table FAMILLE)
* 1 table MENAGE : avec id_log (for now : table MENAGE = table FAMILLE)



use  "${path}\data\fideli_individu17_diff_1",clear
gen  id_ind_origin = id_in
gen  id_foy_origin = id_foy
gen  id_log = id_log_origin







