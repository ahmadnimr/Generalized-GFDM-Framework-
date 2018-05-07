function alpha = CreateLTEInterleaver( K )
% CreateLTEInterleaver produces an interleaver according to the UMTS-LTE spec.
%
% The calling syntax is:
%     [alpha] = CreateLTEInterleaver( K )
%
%     alpha  = the interleaver in a length K vector 
%
%     K  = the size of the interleaver.  Must be one of the 188 values 
%          listed on table 5.1.3-3 of TS 36.212.
%
% Copyright (C) 2007, Matthew C. Valenti
%
% Last updated on Nov. 23, 2007
%
% Function CreateLTEInterleaver is part of the Iterative Solutions 
% Coded Modulation Library. The Iterative Solutions Coded Modulation 
% Library is free software; you can redistribute it and/or modify it 
% under the terms of the GNU Lesser General Public License as published 
% by the Free Software Foundation; either version 2.1 of the License, 
% or (at your option) any later version.
%
% This library is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
% Lesser General Public License for more details.
%  
% You should have received a copy of the GNU Lesser General Public
% License along with this library; if not, write to the Free Software
% Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301
% USA

% table 5.1.3-3 from 36.212
param_table = [40	3	10
48	7	12
56	19	42
64	7	16
72	7	18
80	11	20
88	5	22
96	11	24
104	7	26
112	41	84
120	103	90
128	15	32
136	9	34
144	17	108
152	9	38
160	21	120
168	101	84
176	21	44
184	57	46
192	23	48
200	13	50
208	27	52
216	11	36
224	27	56
232	85	58
240	29	60
248	33	62
256	15	32
264	17	198
272	33	68
280	103	210
288	19	36
296	19	74
304	37	76
312	19	78
320	21	120
328	21	82
336	115	84
344	193	86
352	21	44
360	133	90
368	81	46
376	45	94
384	23	48
392	243	98
400	151	40
408	155	102
416	25	52
424	51	106
432	47	72
440	91	110
448	29	168
456	29	114
464	247	58
472	29	118
480	89	180
488	91	122
496	157	62
504	55	84
512	31	64
528	17	66
544	35	68
560	227	420
576	65	96
592	19	74
608	37	76
624	41	234
640	39	80
656	185	82
672	43	252
688	21	86
704	155	44
720	79	120
736	139	92
752	23	94
768	217	48
784	25	98
800	17	80
816	127	102
832	25	52
848	239	106
864	17	48
880	137	110
896	215	112
912	29	114
928	15	58
944	147	118
960	29	60
976	59	122
992	65	124
1008	55	84
1024	31	64
1056	17	66
1088	171	204
1120	67	140
1152	35	72
1184	19	74
1216	39	76
1248	19	78
1280	199	240
1312	21	82
1344	211	252
1376	21	86
1408	43	88
1440	149	60
1472	45	92
1504	49	846
1536	71	48
1568	13	28
1600	17	80
1632	25	102
1664	183	104
1696	55	954
1728	127	96
1760	27	110
1792	29	112
1824	29	114
1856	57	116
1888	45	354
1920	31	120
1952	59	610
1984	185	124
2016	113	420
2048	31	64
2112	17	66
2176	171	136
2240	209	420
2304	253	216
2368	367	444
2432	265	456
2496	181	468
2560	39	80
2624	27	164
2688	127	504
2752	143	172
2816	43	88
2880	29	300
2944	45	92
3008	157	188
3072	47	96
3136	13	28
3200	111	240
3264	443	204
3328	51	104
3392	51	212
3456	451	192
3520	257	220
3584	57	336
3648	313	228
3712	271	232
3776	179	236
3840	331	120
3904	363	244
3968	375	248
4032	127	168
4096	31	64
4160	33	130
4224	43	264
4288	33	134
4352	477	408
4416	35	138
4480	233	280
4544	357	142
4608	337	480
4672	37	146
4736	71	444
4800	71	120
4864	37	152
4928	39	462
4992	127	234
5056	39	158
5120	39	80
5184	31	96
5248	113	902
5312	41	166
5376	251	336
5440	43	170
5504	21	86
5568	43	174
5632	45	176
5696	45	178
5760	161	120
5824	89	182
5888	323	184
5952	47	186
6016	23	94
6080	47	190
6144	263	480];

% find K in the table
index = find( param_table(:,1) == K );
if ( length(index) ~= 1 )
    error( 'CreateLTEInterleaver: input K is invalid\n' );
end
f1 = param_table( index, 2 );
f2 = param_table( index, 3 );

% create the interleaver
for i=0:K-1
    % the alpha(i+1) is needed since matlab indexing starts at 1.
    % for a c-translation change to alpha(i) since c starts at 0.
    alpha(i+1) = mod( f1*i+f2*i*i, K );
end
