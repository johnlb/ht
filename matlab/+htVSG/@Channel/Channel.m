classdef Channel < handle
% A single, generic VSG channel.

    properties
        ch_name     % String.
        vsg          % vsg class instance.
    end

    methods
        %% Channel: constructor
        function [this] = Channel(vsg, ch_name)
            this.ch_name        = ch_name;
            this.vsg            = vsg;
        end % Channel





        function set_freq(this, freq)
            this.vsg.set_channel_freq(this.ch_name, freq)
        end

        function set_ampl_dbm(this, ampl)
            this.vsg.set_channel_ampl_dbm(this.ch_name, ampl)
        end

        function set_ampl_volts(this, ampl)
            this.vsg.set_channel_ampl_volts(this.ch_name, ampl)
        end
        

        function turn_on(this)
            this.vsg.turn_on_channel(this.ch_name)
        end
        

        function turn_off(this)
            this.vsg.turn_off_channel(this.ch_name)
        end


        function set_ref_clk(this, source)
            this.vsg.set_ref_clk(source)
        end
        

        function [status] = is_on(this)
            status = this.vsg.channel_is_on(this.ch_name);
        end

        %% get_name: returns name of this instance.
        function name = get_name(this)
            name = inputname(1);
        end
        
    end % methods


end % classdef