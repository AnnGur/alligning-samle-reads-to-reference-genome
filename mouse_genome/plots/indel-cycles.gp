
        set terminal png size 600,400 truecolor
        set output "plots/indel-cycles.png"
        set grid xtics ytics y2tics back lc rgb "#cccccc"
        set style line 1 linetype 1  linecolor rgb "red"
        set style line 2 linetype 2  linecolor rgb "black"
        set style line 3 linetype 3  linecolor rgb "green"
        set style line 4 linetype 4  linecolor rgb "blue"
        set style increment user
        set ylabel "Indel count"
        set xlabel "Read Cycle"
        set title "27_GRCm39_Test_Aligned.stats.txt" noenhanced
    plot '-' w l ti 'Insertions (fwd)', '' w l ti 'Insertions (rev)', '' w l ti 'Deletions (fwd)', '' w l ti 'Deletions (rev)'
20	1
23	0
37	1
40	0
49	0
50	0
53	0
58	1
66	0
73	1
84	0
end
20	0
23	0
37	0
40	1
49	0
50	0
53	0
58	0
66	0
73	0
84	1
end
20	0
23	1
37	0
40	0
49	2
50	1
53	1
58	0
66	0
73	0
84	0
end
20	0
23	0
37	0
40	0
49	0
50	0
53	0
58	0
66	1
73	0
84	0
end
