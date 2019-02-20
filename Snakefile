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
#        figures = expand(config["out_figures"] + "plot.pdf",
#        tab01 = config["out_tables"] + "plot.tex"
#
# rule plot:
#      input:
#        script = config["src_figures"] + "plot.R",
#        data   = config["out_data"] + "data_merged.csv",
#      output:
#        fig = Path(config["out_figures"] + "plot.pdf")
#      log:
#        config["log"] + "plot.Rout"
#      shell:
#        "Rscript {input.script} \
#        --data {input.data} \
#        --out {output.fig}"
#
# rule analysis:
#     input:
#       script = config["src_data_mgt"] + "analysis.R",
#       data   = config["out_data"] + "data_merged.csv"
#     output:
#       estimates = Path(config["out_analysis"] + "estimates.rds")
#       tex = config["out_tables"] + "tab01.tex"
#     log:
#       config["log"] + "estimates.Rout"
#     shell:
#       "Rscript {input.script} \
#       --data {input.data} \
#       --out {output.estimates} > {log} {LOG_ALL},
#       {output.tex} > {log} {LOG_ALL}"

rule merge:
    input:
      script = config["src_data_mgt"] + "merge.R",
      data_players = config["src_data"] + "player_data.csv",
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
