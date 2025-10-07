
            set terminal png size 600,400 truecolor
            set output "plots/coverage.png"
            set grid xtics ytics y2tics back lc rgb "#cccccc"
            set ylabel "Number of mapped bases"
            set xlabel "Coverage"
            set log y
            set style fill solid border -1
            set title "27_GRCm39_Test_Aligned.stats.txt" noenhanced
            set xrange [:3]
            plot '-' with lines notitle
        1	175530
2	5758
3	482
4	159
5	2
end
