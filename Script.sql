select act_start,act_target, act_target_dtl,view_curr,count(distinct sid), count(*) 
from bdpview.l0ccl_f_ctc_config_tlo_log 
where p_basis_yyyy = 2020 and p_basis_mm = 5 --and p_basis_dd = 1
and act_target='VOD18'
group by 1,2,3,4
order by 1,2,3,4 ;