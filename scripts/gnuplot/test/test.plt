#from http://stackoverflow.com/questions/38704617/gnuplot-variable-xrange-to-plot-only-last-weeks-worth-of-captured-data
reset
set xdata time
set timefmt "%m-%d-%Y %H:%M"
set xrange [time(0) - 60*24*60*60:]
set format x "%m-%d\n%H:%M"
set style data linespoints

plot "output.dat" using 1:4 skip 1 t "Exits", \
"" using 1:3 skip 1 t "Entrances"
pause(15)