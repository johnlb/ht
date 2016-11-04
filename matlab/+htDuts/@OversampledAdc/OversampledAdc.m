classdef OversampledAdc < htDuts.GenericDut
% An Oversampled ADC.

    properties
    % Interfaces
    	% supplies = {}
        vin
        clk
        dout
        comms

    % Properties
        osr
    end

    % properties(Access=private)
        
    % end

    methods

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Class setup/teardown
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        % Constructor.
        function [this] = GenericDut(supplies, vin, clk, dout, comms, osr)
            this@htDuts.GenericDut(supplies);
            this.vin        = vin;
            this.clk        = clk;
            this.dout       = dout;
            this.comms      = comms;

            this.osr        = osr;
        end

        % Destructor. Cleans up when class is destroyed.
        function delete(this)
            
        end % delete


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Standard Interface.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


        %% run_single_freq: run single freq test
        function [data] = run_single_freq(this, fin, ampl, fignum)
            this.vin.set_sine(fin, ampl, 0, 0);
            data = ;
        


    end % methods





end % classdef