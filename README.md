**Requirements / How to use**

For this delicious dish, You WILL need the following ingredients: 
   (i) a pair of DNA sequences in a format that KaKs calculator accepts (e.g. ./example_kaks_calc_output.txt) 
   (ii) the KaKs calculator (read installation instructions: https://code.google.com/archive/p/kaks-calculator/), it's output data is what this R script needs for error bars

You MIGHT also need:
	(i) Windows (OR ubuntu)
	(ii) RStudio IDE (I have not used on any other IDE, maybe you don't need)
	(iii) Latest version of R (Only tested on 2014+ versions)

You need to then follow this recipe: 
	(i) Run the KaKs calculator (https://code.google.com/archive/p/kaks-calculator/), read the instructions and give the DNA sequences it needs
	(ii) Run this R script, it will then prompt you for a data file (next step)
	(iii) Browse for your KaKs calculator output file, select it then click. There might be several output files, so here I have an example data file that you can use as a reference, it SHOULD work: ./example_kaks_calc_output.txt
	(iv) All done! The plot can be shown interactively, or uncomment CTRL+F: "@PLOT" line in the script to save to .PNG file kaks_error_bars
