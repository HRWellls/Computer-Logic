
# PlanAhead Launch Script for Post-Synthesis floorplanning, created by Project Navigator

create_project -name FINAL_PROJECT -dir "D:/FINAL_PROJECT/planAhead_run_3" -part xc7k160tfbg676-1
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "D:/FINAL_PROJECT/top.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {D:/FINAL_PROJECT} {ipcore_dir} }
add_files [list {ipcore_dir/background.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {ipcore_dir/door.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {ipcore_dir/loopy.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {ipcore_dir/mine.ncf}] -fileset [get_property constrset [current_run]]
set_property target_constrs_file "ucf.ucf" [current_fileset -constrset]
add_files [list {ucf.ucf}] -fileset [get_property constrset [current_run]]
link_design
