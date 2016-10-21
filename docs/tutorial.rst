Tutorial
========

Once you have ht :doc:`installed </installation>`, you should have ht's packages available on matlab's path. Using it can be as simple as this:

.. code-block:: matlab
	:linenos:

	%% Connect to supplies

	% Rigol
	ps = htPowerSupplies.RigolPS('DP8C161650549');

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% All other commands work for any connected supply.
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	% Name each of the channels
	vdda  = ps.get_channel(1);
	vddd  = ps.get_channel(2);
	vddio = ps.get_channel(2);


	% set voltages
	vdda.set_ilimit(0.05)
	vdda.set_voltage(1.5)


	% turn on the channel
	vdda.turn_on()


	% measure the load on the supply
	[v i] = vdda.measure();
	disp('Voltage:')
	disp(v)
	disp('Current:')
	disp(i)