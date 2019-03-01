## Snakefile - Assignment
##
## @krishnasini @mangianteg

from pathlib import Path

# --- Import a confi file ---#

configfile: "config.yaml"

LOG_ALL = "2>&1"

# --- Build rules ---#

#
# rule all:
#      input:
#         graph_pdf = config["out_graphs"] + "graph.pdf",
#         tab01_tex = config["out_tables"] + "tab01.tex"

# rule install_packages:
#     input:
#         script = "install_r_packages.R",
#         requirements = "REQUIREMENTS.txt"
#     shell:
#         "Rscript {input.script}"
# rule find_packages:
#     output:
#         "REQUIREMENTS.txt"
#     shell:
#         "bash find_r_packages.sh"

rule plot:
     input:
       script = config["src_graphs"] + "graph.R",
       data   = config["out_data"] + "data_merged.csv"
     output:
       graph = Path(config["out_graphs"] + "graph.pdf")
     log:
       config["log"] + "plot.Rout"
     shell:
       "Rscript {input.script} \
       --data {input.data} \
       --out {output.graph} > {log} {LOG_ALL}"

rule analysis:
     input:
       script = config["src_analysis"] + "analysis.R",
       data   = config["out_data"] + "data_merged.csv"
     output:
       estimates = Path(config["out_analysis"] + "estimates.rds"),
       tex = Path(config["out_tables"] + "tab01.tex")
     log:
       config["log"] + "estimates.Rout"
     shell:
       "Rscript {input.script} \
       --data {input.data} \
       --out {output.estimates} > {log} {LOG_ALL} \
       --out2 {output.tex} > {log} {LOG_ALL}"

rule merge:
    input:
      script = config["src_data_mgt"] + "merge.R",
      data_players = config["src_data"] + "Players.csv",
      data_seasons = config["src_data"] + "Seasons_Stats.csv"
    output:
      data   = config["out_data"] + "data_merged.csv"
    log:
      config["log"] + "merge.Rout"
    shell:
      "Rscript {input.script} \
      --data_seasons {input.data_seasons}  \
      --data_players {input.data_players}  \
      --out {output.data} > {log} {LOG_ALL}"

#  #--- Packrat Rules --- #
#
# ## packrat_install: installs packrat onto machine
# rule packrat_install:
#     input:
#         script = config["src_lib"] + "install_packrat.R"
#     log:
#         config["log"] + "packrat/install_packrat.Rout"
#     shell:
#         "Rscript {input.script} > {log} 2>&1"
#
#
# ## packrat_init: initialize a packrat environment for this project
# rule packrat_init:
#     input:
#         script = config["src_lib"] + "init_packrat.R"
#     log:
#         config["log"] + "packrat/init_packrat.Rout"
#     shell:
#         "Rscript {input.script} > {log} 2>&1"
#
# ## packrat_snap   : Look for new R packages in files & archives them
# rule packrat_snap:
#     input:
#         script = config["src_lib"] + "snapshot_packrat.R"
#     log:
#         config["log"] + "packrat/snapshot_packrat.Rout"
#     shell:
#         "Rscript {input.script} > {log} 2>&1"
#
# ## packrat_restore: Installs archived packages onto a new machine
# rule packrat_restore:
#     input:
#         script = config["src_lib"] + "restore_packrat.R"
#     log:
#         config["log"] + "packrat/restore_packrat.Rout"
#     shell:
#         "Rscript {input.script} > {log} 2>&1"

rule clean:
    shell:
      "rm -rf.out/*"
