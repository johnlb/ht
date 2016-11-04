clear all; clc;

% Connect to AWG

% Rigol
vsg = htVSG.AgilentVSG('19');



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The rest of this testbench should work for any PS.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Start from reset state.
vsg.reset()


% Name each of the channels
clk = vsg.get_channel(1);


% % Run one of the channels through the ringer.



% % I guess I should make getters and assertions... For now, just check by eye.
clk.set_freq(1e9)
clk.set_ampl_dbm(-10)




clk.turn_on()
assert(clk.is_on())

pause(1)

clk.turn_off()
assert(~clk.is_on())