classdef Comms
% Communications object



	properties
		interfaces
		setter_fn
	end


	methods

        % Constructor.
        function [this] = Comms(interfaces, setter_fn)
            this.interfaces = interfaces;
            this.setter_fn = setter_fn;
        end



		%% set_state: set device to "state" via user-defined setter.
		function set_state(this, state)
			setter_fn(this.interfaces, state);
		end
		

	end



end % classdef