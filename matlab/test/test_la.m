clear all; clc;

mpath = mfilename('fullpath');
pos = strfind(mpath,'\');
datapath = [mpath(1:pos(end)) 'rawdata\'];
clear pos mpath

%% Tektronix
la = htLogicAnalyzers.TekLA(0,datapath,'charm');
% la = TekLA(0,datapath,'charm');

%% Agilent
% la = htLogicAnalyzers.Agilent16802A(1e3,'My Bus 1');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The rest of this testbench should work for any LA.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% [data_raw, header] = la.get_data();
[data_raw, header] = la.run_and_get_data();