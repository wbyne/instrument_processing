#from : http://stackoverflow.com/questions/12328603/how-to-pass-command-line-argument-to-gnuplot
#also, same page:
#if (!exists("filename") instead of if ! exists("filename")
#You can input variables via switch -e
#$ gnuplot -e "filename='foo.data'" foo.plg
#In foo.plg you can then use that variable
#$ cat foo.plg 
#plot filename
#pause -1
#!/bin/bash
#11000: RAIN, TEMP_RTC
gnuplot -e "rain_name='/home/fbyne/workspace/instrument_processing/data/site/11000/RAIN/11000_RAIN.txt'" -e "title='Weather_Data_at_Station_11000'" -e "filename='/home/fbyne/workspace/instrument_processing/data/site/11000/gnuplot/Rainfall_at_Station_11000.png'" -e "htmlfilename='/home/fbyne/workspace/instrument_processing/data/site/11000/gnuplot/Rainfall_at_Station_11000.html'" -e "depth_name='/home/fbyne/workspace/instrument_processing/data/site/11000/DEPTH/11000_DEPTH.txt'" -e "temp_name='/home/fbyne/workspace/instrument_processing/data/site/11000/TEMP/11000_TEMP.txt'" /home/fbyne/workspace/instrument_processing/scripts/gnuplot/plot_rain_to_canvas_and_png.plt
