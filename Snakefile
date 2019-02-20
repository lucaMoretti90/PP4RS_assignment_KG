## Snakefile - Assignment
##
## @krishnasini @mangianteg

from pathlib import Path

# --- Import a confi file ---#

configfile: "config.yaml"

LOG_ALL = "2>&1"

# --- Build rules ---#

rule all:
     input:
        graph = config["out_graphs"] + "graph.pdf",
        tab01 = config["out_tables"] + "tab01.tex"

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

rule clean:
    shell:
      "rm -rf.out/*"
