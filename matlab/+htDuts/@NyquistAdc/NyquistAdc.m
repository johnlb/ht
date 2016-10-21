classdef NyquistAdc < htDuts.OversampledAdc
% A Nyquist ADC.


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
        function [this] = GenericDut(supplies, vin, clk, dout, comms)
            this@htDuts.OversampledAdc(supplies, vin, clk, dout, comms, 1)

        end

        % Destructor. Cleans up when class is destroyed.
        function delete(this)
            
        end % delete


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Standard Interface.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


		%% power_consumption: measures the total power consumed by the DUT.
		function [pwr] = power_consumption(this)
			pwr = 0;
			for ii = 1:length(this.supplies)
				[v i] = this.supplies{ii}.measure();
				pwr = pwr + v*i;
			end
		end


		%% power_breakdown: returns cell array of power consumed by each supply
		%%					pwr{ii} = {'supply', pwr (watts)}
		function [pwr] = power_breakdown(this)
			% Returns name of variable passed to it.
			vname = @(x) inputname(1);

			pwr = {};
			for ii = 1:length(this.supplies)
				[v i] = this.supplies{ii}.measure();
				pwr{ii} = {vname(this.supplies{ii}), v*i};
			end
		end



    end % methods






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Local Methods
%       Helpers for the GenericPS class itself. Not for use in subclass.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    methods(Access=private, Hidden=true)

        %% not_implemented: displays a warning about non-implemented methods.
        function not_implemented(this, func_name)
            mc = metaclass(this);
            disp(['Inside ' mc.Name ':'])
            disp(['"' func_name '" hasn''t been implemented yet.'])
        end


    end % private methods

end % classdef
