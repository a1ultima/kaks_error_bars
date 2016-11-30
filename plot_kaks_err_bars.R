###############################
# Author: You ;) 
# Language: R
###############################

#############################
# Requirements / How to use #
#############################

# You WILL need: 
#   (i) a pair of DNA sequences in a format that KaKs calculator accepts (e.g. ./example_kaks_calc_output.txt) 
#   (ii) the KaKs calculator (https://code.google.com/archive/p/kaks-calculator/), it's output data is what this R script needs for error bars

# You MIGHT need:
#   (i) Windows (OR ubuntu)
#   (ii) RStudio IDE (I have not used on any other IDE, maybe you don't need)
#   (iii) Latest version of R (Only tested on 2014+ versions)

# You need to then follow these steps: 
#   (i) Run the KaKs calculator (https://code.google.com/archive/p/kaks-calculator/), read the instructions and give the DNA sequences it needs
#   (ii) Run this R script, it will then prompt you for a data file (next step)
#   (iii) Browse for your KaKs calculator output file, select it then click. There might be several output files, so here I have an example data file that you can use as a reference, it SHOULD work: ./example_kaks_calc_output.txt
#   (iv) All done! The plot can be shown interactively, or uncomment CTRL+F: "@PLOT" line below to save to .PNG file

#===========#
# FUNCTIONS #
#===========#

"FUN: ci calc for estimations that are ratios"
# p = c(0.1,0.2,0.005) // vector of p-values
# est = c(...) // vector of kaks ratios
get.ci = function(p,est) {
  z           <- -0.862 + sqrt(0.743-2.404*log(p))
  est         <- log(est)
  se          <- abs(est/z)
  ci_log_low  <- est-se
  ci_log_up   <- est+se
  ci_low      <- exp(ci_log_low)
  ci_up       <- exp(ci_log_up)
  #ci_low_d    <- est - ci_low
  #ci_up_d     <- ci_up - est
  return(cbind(ci_low,ci_up))
}
"FUN: confidence interval lines"
ci.bar <- function(x, y, upper, lower=upper, length=0.1,...){
  if(length(x) != length(y) | length(y) !=length(lower) | length(lower) != length(upper))
    stop("vectors must be same length")
  arrows(x,upper, x, lower, angle=90, code=3, length=length, ...)
}
"FUN: barplot the kaks for a given method"
# d = d.s // list of dataframes split by method
# m = 'NG' // name of method to focus on as string
kaks.method = function(d,m) {
  # Import
  print(m)
  d.m   <- d[m]
  d.m   <- data.frame(d.m)
  # Analyse
  genes <- d.m[,paste(m,'.Sequence',sep='')]         # list of genes
  genes <- as.vector(genes)                          # as vec
  
  gl <- vector() # initials of gene names
  for (g in 1:length(genes)) {
    gl[g] <- substr(genes[g],1,1)
    print(gl)
  }
  
  kaks  <- d.m[,paste(m,'.Ka.Ks',sep='')]            # list of kaks
  kaks  <- as.numeric(as.vector(kaks))               # as num vec
  p     <- d.m[,paste(m,'.P.Value.Fisher.',sep='')]  # pvals for ci
  p     <- as.numeric(as.vector(p))                  # as num vec
  ci    <- get.ci(p,kaks)                            # ci intervals
  print(ci)
  # Plot
  bp    <- barplot(kaks,xlab='gene',ylab='ka/ks',names.arg=gl,width=rep(0.1,length(genes)),xlim=c(0,1),ylim=c(0,3),main=m)  
  xPos  <- as.vector(t(bp))                             # coords of bars for ci arrows
  ci.bar(xPos,kaks,upper=ci[,'ci_up'],lower=ci[,'ci_low'],length=0.1) # ci intervals draw
}

########
# MAIN #
########

#===========================================================================
# 1) Data Import:
#===========================================================================

## Initate & Read:

cat("\n","Please Select the data file","\n")  # PROMPT to select "GSM469176.txt" from file browser
fname           <- file.choose()              # select file

#fname <- 'data/kaks_out'

setwd(dirname(fname))                         # set pwd to where file is

dir.create("plots")                           # directory for png files
data            <- read.table( fname )        # data
colnames(data)  <- as.matrix(data[1,])        # set column headers using first row
data            <- data[2:nrow(data),]        # rid of the headers row leaving only data

#===========================================================================
# 2) BarPlots:
#===========================================================================


"split data by methods"
data$Method     <- sub('-','',data$Method)      # remove hyphens from headers which cause err
d.s             <- split(data,data$Method)      # split data by method
d.s['Method']   <- NULL                         # remove useless element from list
m.list          <- attributes(d.s)              # list of methods
m.list          <- as.vector((unlist(m.list)))

########
# MAIN #
########

"make barplots for every method, save to file UNCOMMENT BELOW TO SAVE TO current working dir, which is where your input data file is"
# @INTERACTIVE
par(mfrow=c(3,4))
for(i in 1:length(m.list)){
  kaks.method(d.s,m.list[i])
}

# #@PLOT: uncomment the following lines then re-run to save the PNG, BUT: YOU MUST ALSO COMMENT the lines following CTRL+F:"@interactive" 
# png(filename=paste('plots/','kaks','.png',sep=''), width=800, height=600) # <-- Change size of the PNG
# par(mfrow=c(3,4))
# for(i in 1:length(m.list)){
#   kaks.method(d.s,m.list[i])
# }
# dev.off()


