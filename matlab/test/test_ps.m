clear all; clc;

% Connect to supplies

% Rigol
% ps1 = htPowerSupplies.RigolPS('DP8C161650549');
% ps2 = htPowerSupplies.RigolPS('DP8C161750621');

% Agilent
% ps1 = htPowerSupplies.AgilentPS('6');

% Keithley
ps1 = htPowerSupplies.KeithleyPS('26');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The rest of this testbench should work for any PS.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Name each of the channels
vdda = ps1.get_channel(1);
% vddd = ps1.get_channel(2);

% % Run one of the channels through the ringer.
[v i] = vdda.measure();
disp('Voltage:')
disp(v)
disp('Current:')
disp(i)

disp('Status:')
disp( vdda.status() )


% % I guess I should make getters and assertions... For now, just check by eye.
vdda.set_vlimit(5)
vdda.set_ilimit(0.05)
vdda.set_voltage(1.5)
vdda.set_current(1e-3)


% vdda.turn_off()
% pause(1)
% vdda.turn_on()
% pause(1)
% vdda.turn_off()
% pause(1)


vdda.turn_on()
assert(vdda.is_on())
vdda.turn_off()
assert(~vdda.is_on())