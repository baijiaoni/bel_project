target = "altera"
action = "synthesis"

fetchto = "../../../ip_cores"

syn_device = "5agxma3d4f"
syn_grade = "c5"
syn_package = "27"
syn_top = "pexaria"
syn_project = "pexaria"

quartus_preflow = "pexaria.tcl"

modules = {
  "local" : [ 
    "../../../top/gsi_pexarria5/example", 
  ]
}
