clear all; clc;

% Connect to AWG

% Rigol
awg1 = htAWG.RigolAWG('DG4E171501111');



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The rest of this testbench should work for any PS.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Start from reset state.
awg1.reset()


% Name each of the channels
vin = awg1.get_channel(2);
% clk = awg1.get_channel(2);


% % Run one of the channels through the ringer.



% % I guess I should make getters and assertions... For now, just check by eye.
vin.set_sine(10e6, 1.5, 0.1, 180)
pause(2)
vin.set_square(10e6, 1.5, 0.1, 180)
pause(2)




vin.turn_on()
assert(vin.is_on())

pause(1)

vin.turn_off()
assert(~vin.is_on())