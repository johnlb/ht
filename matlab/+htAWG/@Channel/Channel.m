classdef Channel < handle
% A single, generic AWG channel.

    properties
        ch_name     % String.
        awg          % awg class instance.
    end

    methods
        %% Channel: constructor
        function [this] = Channel(awg, ch_name)
            this.ch_name        = ch_name;
            this.awg            = awg;
        end % Channel





        function set_sine(this, freq, amp, offset, phase)
            this.awg.set_channel_sine(this.ch_name, freq, amp, offset, phase)
        end
        

        function set_square(this, freq, amp, offset, phase)
            this.awg.setup_square_channel(this.ch_name, freq, amp, offset, phase)
        end


        function turn_on(this)
            this.awg.turn_on_channel(this.ch_name)
        end
        

        function turn_off(this)
            this.awg.turn_off_channel(this.ch_name)
        end
        

        function set_output_impedance(this, impedance)
            this.awg.set_channel_output_impedance(this.ch_name, impedance)
        end
        

        function set_ref_clk(this, source)
            this.awg.set_ref_clk(source)
        end
        

        function [status] = is_on(this)
            status = this.awg.channel_is_on(this.ch_name);
        end

    end % methods


end % classdef