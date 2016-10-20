classdef Channel < handle
% A single, generic channel.

    properties
        ch_name     % String.
        ps          % PS class instance.
    end

    methods
        %% Channel: constructor
        function [this] = Channel(ps, ch_name)
            this.ch_name        = ch_name;
            this.ps             = ps;
        end % Channel


        % measure: Returns [voltage, current] measured on this channel.
        function [voltage, current] = measure(this)
            [voltage, current] = this.ps.measure_channel(this.ch_name);
        end % measure


        %% status: Return current status for this channel.
        function [status] = status(this)
            status = this.ps.status_channel(this.ch_name);
        end % status
        

        function set_voltage(this, volts)
            this.ps.set_channel_voltage(this.ch_name, volts)
        end
        

        function set_current(this, amps)
            this.ps.set_channel_current(this.ch_name, amps)
        end
        

        function set_vlimit(this, volts)
            this.ps.set_channel_vlimit(this.ch_name, volts)
        end
        

        function set_ilimit(this, amps)
            this.ps.set_channel_ilimit(this.ch_name, amps)
        end
        

        function turn_on(this)
            this.ps.turn_on_channel(this.ch_name)
        end
        

        function turn_off(this)
            this.ps.turn_off_channel(this.ch_name)
        end
        

        function [status] = is_on(this)
            status = this.ps.channel_is_on(this.ch_name);
        end

    end % methods


end % classdef