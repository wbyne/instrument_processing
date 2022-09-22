#!/bin/bash
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

echo $0 

mypath="/mnt/space/workspace/instrument_processing/data/site/"
myscript="/mnt/space/workspace/instrument_processing/scripts/gnuplot/plot_rain_to_canvas_and_png.plt"
myscriptR2="/mnt/space/workspace/instrument_processing/scripts/gnuplot/plot_rain_to_canvas_and_png.3Dec21.Sav.plt"
myscript28R2="/mnt/space/workspace/instrument_processing/scripts/gnuplot/plot_rain_to_canvas_and_png.28.3Dec21.Sav.plt"
myscript84R2="/mnt/space/workspace/instrument_processing/scripts/gnuplot/plot_rain_to_canvas_and_png.84.3Dec21.Sav.plt"
myscript168R2="/mnt/space/workspace/instrument_processing/scripts/gnuplot/plot_rain_to_canvas_and_png.168.3Dec21.Sav.plt"
myscript252R2="/mnt/space/workspace/instrument_processing/scripts/gnuplot/plot_rain_to_canvas_and_png.252.3Dec21.Sav.plt"

for myfiles in 5000 5100 5200 5500

	       
#if [ $# -gt 0 ]; then
#    echo "Your command line contains $# arguments"
#else
#    echo "Your command line contains no arguments"
#fi

	       
do
if [ ! -d "$mypath/$myfiles/gnuplot" ]
then
    mkdir -p "$mypath/$myfiles/gnuplot"
fi

sed 's/9999/0000/g' "$mypath""$myfiles/COND/""$myfiles""_COND.txt" > "$mypath""$myfiles/COND/""$myfiles""_COND_no9999.txt" 
sed 's/9999/0000/g' "$mypath""$myfiles/WTR_TMP/""$myfiles""_WTR_TMP.txt" > "$mypath""$myfiles/WTR_TMP/""$myfiles""_WTR_TMP_no9999.txt" 
sed 's/9999/0000/g' "$mypath""$myfiles/TEMP_RTC/""$myfiles""_TEMP_RTC.txt" > "$mypath""$myfiles/TEMP_RTC/""$myfiles""_TEMP_RTC_no9999.txt"  
sed 's/9999/0000/g' "$mypath""$myfiles/TEMP/""$myfiles""_TEMP.txt" > "$mypath""$myfiles/TEMP/""$myfiles""_TEMP_no9999.txt" 


echo "plotting : "$myfiles
#4032 is the past 14 days in 5 minute increments
gnuplot -e "rain_name='< tail -n 4032 "$mypath""$myfiles"/RAIN/"$myfiles"_RAIN.txt'" -e "title='Weather_Data_at_Station_$myfiles'" -e "filename='"$mypath""$myfiles"/gnuplot/Rainfall_at_Station_$myfiles.png'" -e "htmlfilename='"$mypath""$myfiles"/gnuplot/Rainfall_at_Station_$myfiles.html'" -e "depth_name='"$mypath""$myfiles"/DEPTH/"$myfiles"_DEPTH.txt'" -e "temp_name='"$mypath""$myfiles"/TEMP/"$myfiles"_TEMP.txt'" -e "wtr_tmp_name='"$mypath""$myfiles"/WTR_TMP/"$myfiles"_WTR_TMP_no9999.txt'" -e "cond_name='"$mypath""$myfiles"/COND/"$myfiles"_COND_no9999.txt'" -e "tmp_rtc_name='"$mypath""$myfiles"/TEMP_RTC/"$myfiles"_TEMP_RTC_no9999.txt'" $myscript
echo "finished : " $myfiles " : R1"
gnuplot -e "rain_name='< tail -n 4032 "$mypath""$myfiles"/RAIN/"$myfiles"_RAIN.txt'" -e "title='Weather_Data_at_Station_$myfiles'" -e "filename='"$mypath""$myfiles"/gnuplot/Rainfall_at_Station_$myfiles.R2.png'" -e "htmlfilename='"$mypath""$myfiles"/gnuplot/Rainfall_at_Station_$myfiles.R2.html'" -e "depth_name='"$mypath""$myfiles"/DEPTH/"$myfiles"_DEPTH.txt'" -e "temp_name='"$mypath""$myfiles"/TEMP/"$myfiles"_TEMP_no9999.txt'" -e "wtr_tmp_name='"$mypath""$myfiles"/WTR_TMP/"$myfiles"_WTR_TMP_no9999.txt'" -e "cond_name='"$mypath""$myfiles"/COND/"$myfiles"_COND_no9999.txt'" -e "tmp_rtc_name='"$mypath""$myfiles"/TEMP_RTC/"$myfiles"_TEMP_RTC_no9999.txt'" $myscriptR2
echo "finished : " $myfiles " : R2"

#:' multiline comments in bash, from: https://stackoverflow.com/questions/43158140/way-to-create-multiline-comments-in-bash
#8064 is 28 days of 5 minute increments (monthly)
#gnuplot -e "rain_name='< tail -n 8064 "$mypath""$myfiles"/RAIN/"$myfiles"_RAIN.txt'" -e "title='Weather_Data_at_Station_$myfiles'" -e "filename='"$mypath""$myfiles"/gnuplot/Rainfall_at_Station_$myfiles.28.png'" -e "htmlfilename='"$mypath""$myfiles"/gnuplot/Rainfall_at_Station_$myfiles.28.html'" -e "depth_name='"$mypath""$myfiles"/DEPTH/"$myfiles"_DEPTH.txt'" -e "temp_name='"$mypath""$myfiles"/TEMP/"$myfiles"_TEMP.txt'" $myscript
#echo "finished : " $myfiles " : R1 Monthly"
#gnuplot -e "rain_name='< tail -n 8064 "$mypath""$myfiles"/RAIN/"$myfiles"_RAIN.txt'" -e "title='Weather_Data_at_Station_$myfiles'" -e "filename='"$mypath""$myfiles"/gnuplot/Rainfall_at_Station_$myfiles.28.R2.png'" -e "htmlfilename='"$mypath""$myfiles"/gnuplot/Rainfall_at_Station_$myfiles.28.R2.html'" -e "depth_name='"$mypath""$myfiles"/DEPTH/"$myfiles"_DEPTH.txt'" -e "temp_name='"$mypath""$myfiles"/TEMP/"$myfiles"_TEMP.txt'" $myscript28R2
#echo "finished : " $myfiles " : R2 Monthly"
gnuplot -e "rain_name='< tail -n 8064 "$mypath""$myfiles"/RAIN/"$myfiles"_RAIN.txt'" -e "title='Weather_Data_at_Station_$myfiles'" -e "filename='"$mypath""$myfiles"/gnuplot/Rainfall_at_Station_$myfiles.28.png'" -e "htmlfilename='"$mypath""$myfiles"/gnuplot/Rainfall_at_Station_$myfiles.28.html'" -e "depth_name='"$mypath""$myfiles"/DEPTH/"$myfiles"_DEPTH.txt'" -e "temp_name='"$mypath""$myfiles"/TEMP/"$myfiles"_TEMP.txt'" -e "wtr_tmp_name='"$mypath""$myfiles"/WTR_TMP/"$myfiles"_WTR_TMP_no9999.txt'" -e "cond_name='"$mypath""$myfiles"/COND/"$myfiles"_COND_no9999.txt'" -e "tmp_rtc_name='"$mypath""$myfiles"/TEMP_RTC/"$myfiles"_TEMP_RTC_no9999.txt'" $myscript
echo "finished : " $myfiles " : R1"
gnuplot -e "rain_name='< tail -n 8064 "$mypath""$myfiles"/RAIN/"$myfiles"_RAIN.txt'" -e "title='Weather_Data_at_Station_$myfiles'" -e "filename='"$mypath""$myfiles"/gnuplot/Rainfall_at_Station_$myfiles.28.R2.png'" -e "htmlfilename='"$mypath""$myfiles"/gnuplot/Rainfall_at_Station_$myfiles.28.R2.html'" -e "depth_name='"$mypath""$myfiles"/DEPTH/"$myfiles"_DEPTH.txt'" -e "temp_name='"$mypath""$myfiles"/TEMP/"$myfiles"_TEMP.txt'" -e "wtr_tmp_name='"$mypath""$myfiles"/WTR_TMP/"$myfiles"_WTR_TMP_no9999.txt'" -e "cond_name='"$mypath""$myfiles"/COND/"$myfiles"_COND_no9999.txt'" -e "tmp_rtc_name='"$mypath""$myfiles"/TEMP_RTC/"$myfiles"_TEMP_RTC_no9999.txt'" $myscript28R2
echo "finished : " $myfiles " : R2 Monthly"

#24192 is 84 days of 5 minute increments (quarterly)
#gnuplot -e "rain_name='< tail -n 24192 "$mypath""$myfiles"/RAIN/"$myfiles"_RAIN.txt'" -e "title='Weather_Data_at_Station_$myfiles'" -e "filename='"$mypath""$myfiles"/gnuplot/Rainfall_at_Station_$myfiles.84.R2.png'" -e "htmlfilename='"$mypath""$myfiles"/gnuplot/Rainfall_at_Station_$myfiles.84.R2.html'" -e "depth_name='"$mypath""$myfiles"/DEPTH/"$myfiles"_DEPTH.txt'" -e "temp_name='"$mypath""$myfiles"/TEMP/"$myfiles"_TEMP.txt'" $myscript84R2
#echo "finished : " $myfiles " : R2 Quarterly"
gnuplot -e "rain_name='< tail -n 24192 "$mypath""$myfiles"/RAIN/"$myfiles"_RAIN.txt'" -e "title='Weather_Data_at_Station_$myfiles'" -e "filename='"$mypath""$myfiles"/gnuplot/Rainfall_at_Station_$myfiles.84.R2.png'" -e "htmlfilename='"$mypath""$myfiles"/gnuplot/Rainfall_at_Station_$myfiles.84.R2.html'" -e "depth_name='"$mypath""$myfiles"/DEPTH/"$myfiles"_DEPTH.txt'" -e "temp_name='"$mypath""$myfiles"/TEMP/"$myfiles"_TEMP.txt'" -e "wtr_tmp_name='"$mypath""$myfiles"/WTR_TMP/"$myfiles"_WTR_TMP_no9999.txt'" -e "cond_name='"$mypath""$myfiles"/COND/"$myfiles"_COND_no9999.txt'" -e "tmp_rtc_name='"$mypath""$myfiles"/TEMP_RTC/"$myfiles"_TEMP_RTC_no9999.txt'" $myscript84R2
echo "finished : " $myfiles " : R2 Quarterly"

#48384 is 168 days of 5 minute increments (biannual)
#gnuplot -e "rain_name='< tail -n 48384 "$mypath""$myfiles"/RAIN/"$myfiles"_RAIN.txt'" -e "title='Weather_Data_at_Station_$myfiles'" -e "filename='"$mypath""$myfiles"/gnuplot/Rainfall_at_Station_$myfiles.168.R2.png'" -e "htmlfilename='"$mypath""$myfiles"/gnuplot/Rainfall_at_Station_$myfiles.168.R2.html'" -e "depth_name='"$mypath""$myfiles"/DEPTH/"$myfiles"_DEPTH.txt'" -e "temp_name='"$mypath""$myfiles"/TEMP/"$myfiles"_TEMP.txt'" $myscript168R2
#echo "finished : " $myfiles " : R2 Biannual"
gnuplot -e "rain_name='< tail -n 48384 "$mypath""$myfiles"/RAIN/"$myfiles"_RAIN.txt'" -e "title='Weather_Data_at_Station_$myfiles'" -e "filename='"$mypath""$myfiles"/gnuplot/Rainfall_at_Station_$myfiles.168.R2.png'" -e "htmlfilename='"$mypath""$myfiles"/gnuplot/Rainfall_at_Station_$myfiles.168.R2.html'" -e "depth_name='"$mypath""$myfiles"/DEPTH/"$myfiles"_DEPTH.txt'" -e "temp_name='"$mypath""$myfiles"/TEMP/"$myfiles"_TEMP.txt'" -e "wtr_tmp_name='"$mypath""$myfiles"/WTR_TMP/"$myfiles"_WTR_TMP_no9999.txt'" -e "cond_name='"$mypath""$myfiles"/COND/"$myfiles"_COND_no9999.txt'" -e "tmp_rtc_name='"$mypath""$myfiles"/TEMP_RTC/"$myfiles"_TEMP_RTC_no9999.txt'" $myscript168R2
echo "finished : " $myfiles " : R2 Biannual"

#58464 is 203 days of 5 minute increments (long enough to capture july as of today)
#gnuplot -e "rain_name='< tail -n 58464 "$mypath""$myfiles"/RAIN/"$myfiles"_RAIN.txt'" -e "title='Weather_Data_at_Station_$myfiles'" -e "filename='"$mypath""$myfiles"/gnuplot/Rainfall_at_Station_$myfiles.252.R2.png'" -e "htmlfilename='"$mypath""$myfiles"/gnuplot/Rainfall_at_Station_$myfiles.252.R2.html'" -e "depth_name='"$mypath""$myfiles"/DEPTH/"$myfiles"_DEPTH.txt'" -e "temp_name='"$mypath""$myfiles"/TEMP/"$myfiles"_TEMP.txt'" $myscript252R2
#echo "finished : " $myfiles " : R2 9Months"
gnuplot -e "rain_name='< tail -n 58464 "$mypath""$myfiles"/RAIN/"$myfiles"_RAIN.txt'" -e "title='Weather_Data_at_Station_$myfiles'" -e "filename='"$mypath""$myfiles"/gnuplot/Rainfall_at_Station_$myfiles.252.R2.png'" -e "htmlfilename='"$mypath""$myfiles"/gnuplot/Rainfall_at_Station_$myfiles.252.R2.html'" -e "depth_name='"$mypath""$myfiles"/DEPTH/"$myfiles"_DEPTH.txt'" -e "temp_name='"$mypath""$myfiles"/TEMP/"$myfiles"_TEMP.txt'" -e "wtr_tmp_name='"$mypath""$myfiles"/WTR_TMP/"$myfiles"_WTR_TMP_no9999.txt'" -e "cond_name='"$mypath""$myfiles"/COND/"$myfiles"_COND_no9999.txt'" -e "tmp_rtc_name='"$mypath""$myfiles"/TEMP_RTC/"$myfiles"_TEMP_RTC_no9999.txt'" $myscript252R2
echo "finished : " $myfiles " : R2 9Months"

done

#bash doesn't like a variable assignment inside the for loop...dont know and its getting late -fwb-6feb22-2220
myscriptV="/mnt/space/workspace/instrument_processing/scripts/gnuplot/plot_rain_to_canvas_and_png.vel.plt"
myscriptR2V="/mnt/space/workspace/instrument_processing/scripts/gnuplot/plot_rain_to_canvas_and_png.3Dec21.Sav.vel.plt"

for myfiles in 5900 

do
if [ ! -d "$mypath/$myfiles/gnuplot" ]
then
    mkdir -p "$mypath/$myfiles/gnuplot"
fi
sed 's/9999/0000/g' "$mypath""$myfiles/VELO/""$myfiles""_VELO.txt" > "$mypath""$myfiles/VELO/""$myfiles""_VELO_no9999.txt" 
sed 's/9999/0000/g' "$mypath""$myfiles/TEMP/""$myfiles""_TEMP.txt" > "$mypath""$myfiles/TEMP/""$myfiles""_TEMP_no9999.txt" 

echo "plotting : "$myfiles
#4032 is the past 14 days in 5 minute increments
gnuplot -e "rain_name='/mnt/space/workspace/instrument_processing/data/site/5000/RAIN/5000_RAIN.txt'" -e "title='Weather_Data_at_Station_$myfiles'" -e "filename='"$mypath""$myfiles"/gnuplot/Rainfall_at_Station_$myfiles.png'" -e "htmlfilename='"$mypath""$myfiles"/gnuplot/Rainfall_at_Station_$myfiles.html'" -e "depth_name='"$mypath""$myfiles"/DEPTH/"$myfiles"_DEPTH.txt'" -e "temp_name='"$mypath""$myfiles"/TEMP/"$myfiles"_TEMP_no9999.txt'" -e "wtr_tmp_name='"$mypath""$myfiles"/WTR_TMP/"$myfiles"_WTR_TMP_no9999.txt'" -e "cond_name='"$mypath""$myfiles"/COND/"$myfiles"_COND_no9999.txt'" -e "tmp_rtc_name='"$mypath""$myfiles"/TEMP_RTC/"$myfiles"_TEMP_RTC_no9999.txt'" -e "velo_name='"$mypath""$myfiles"/VELO/"$myfiles"_VELO_no9999.txt'" $myscriptV
#echo "finished : " $myfiles " : R1"
#gnuplot -e "rain_name='< tail -n 4032 "$mypath""$myfiles"/RAIN/"$myfiles"_RAIN.txt'" -e "title='Weather_Data_at_Station_$myfiles'" -e "filename='"$mypath""$myfiles"/gnuplot/Rainfall_at_Station_$myfiles.R2.png'" -e "htmlfilename='"$mypath""$myfiles"/gnuplot/Rainfall_at_Station_$myfiles.R2.html'" -e "depth_name='"$mypath""$myfiles"/DEPTH/"$myfiles"_DEPTH.txt'" -e "temp_name='"$mypath""$myfiles"/TEMP/"$myfiles"_TEMP.txt'" -e "wtr_tmp_name='"$mypath""$myfiles"/WTR_TMP/"$myfiles"_WTR_TMP_no9999.txt'" -e "cond_name='"$mypath""$myfiles"/COND/"$myfiles"_COND_no9999.txt'" -e "tmp_rtc_name='"$mypath""$myfiles"/TEMP_RTC/"$myfiles"_TEMP_RTC_no9999.txt'" $myscriptR2
echo "finished : " $myfiles " : R2"
gnuplot -e "rain_name='/mnt/space/workspace/instrument_processing/data/site/5000/RAIN/5000_RAIN.txt'" -e "title='Weather Data at Station $myfiles'" -e "filename='"$mypath""$myfiles"/gnuplot/Rainfall_at_Station_$myfiles.R2.png'" -e "htmlfilename='"$mypath""$myfiles"/gnuplot/Rainfall_at_Station_$myfiles.R2.html'" -e "depth_name='"$mypath""$myfiles"/DEPTH/"$myfiles"_DEPTH.txt'" -e "temp_name='"$mypath""$myfiles"/TEMP/"$myfiles"_TEMP_no9999.txt'" -e "wtr_tmp_name='"$mypath""$myfiles"/WTR_TMP/"$myfiles"_WTR_TMP_no9999.txt'" -e "cond_name='"$mypath""$myfiles"/COND/"$myfiles"_COND_no9999.txt'" -e "tmp_rtc_name='"$mypath""$myfiles"/TEMP_RTC/"$myfiles"_TEMP_RTC_no9999.txt'" -e "velo_name='"$mypath""$myfiles"/VELO/"$myfiles"_VELO_no9999.txt'" $myscriptR2V
echo "finished : " $myfiles " : R2"

done
