source("src/Functions2.R")

# Parameter
infile1 <- commandArgs(trailingOnly=TRUE)[1]
outfile <- commandArgs(trailingOnly=TRUE)[2]
method <- commandArgs(trailingOnly=TRUE)[3]

# Loading
load(infile1)

# HTML report
cmd <- paste0("g <- plot_deconvolution(list('", method,
    "' = out), 'bar', 'method', 'Spectral')")
eval(parse(text=cmd))
saveWidget(g, outfile)
