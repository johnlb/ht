classdef RigolAWG < htAWG.VisaAWG
% Initially built for Rigol DG4162.


    properties

        % device
        % channels

    end



    methods


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Class setup/teardown
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        % Contstructor. Returns new instance of this class.
        function [this] = RigolAWG(unique_id)
            % You can find the DP8xx's unique_id by pressing 'utility'.
            % On the bottom of the screen, you will see something like:
            %
            % USB0::0x1AB1::0x0E11::DP8C161650549::INSTR
            %
            % In this case, the unique_id would be 'DP8C161650549'

            channels = {
                % Left-to-Right,
                % as you see it from the front.
                    '1',
                    '2'
                };
            this@htAWG.VisaAWG('USB', unique_id, channels)


        end % RigolAWG


        % Deconstructor. Cleans up when class is destroyed.
        % (inherited from htAWG.VisaAWG)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Standard Interface.
%       Overloaded functions inherited from GenericPS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        %% sine: setup sinewave function.
        function set_channel_sine(this, ch_name, freq, amp, offset, phase)
            this.select_channel(ch_name)
            cmd_str = sprintf(':SOURce%s:APPLy:SINusoid %f,%f,%f,%f',...
                                ch_name,freq,amp,offset,phase);
            fprintf(this.device, cmd_str)
        end


        %% square: setup squarewave function.
        function set_channel_square(this, ch_name, freq, amp, offset, phase)
            this.select_channel(ch_name)
            cmd_str = sprintf(':SOURce%s:APPLy:SQUare %f,%f,%f,%f',...
                                ch_name,freq,amp,offset,phase);
            fprintf(this.device, cmd_str)
        end
        

        %% set_channel_output_impedance: sets output impedance
        function set_channel_output_impedance(this, ch_name, impedance)
            this.select_channel(ch_name)
            cmd_str = sprintf(':OUTPut%s:IMPedance %d', ch_name,impedance);
            fprintf(this.device, cmd_str)
        end
        

        %% set_ref_clk: sets output impedance
        %%              "source" can be "INT" or "EXT"
        function set_ref_clk(this, source)
            this.select_channel(ch_name)
            cmd_str = [':SYSTem:ROSCillator:SOURce ' source];
            fprintf(this.device, cmd_str)
        end
        


        function turn_on_channel(this, ch_name)
            this.select_channel(ch_name)
            cmd_str = [':OUTP' ch_name ':STAT ON'];
            fprintf(this.device, cmd_str)
        end
        

        function turn_off_channel(this, ch_name)
            this.select_channel(ch_name)
            cmd_str = [':OUTP' ch_name ':STAT OFF'];
            fprintf(this.device, cmd_str)
        end
        

        function [state] = channel_is_on(this, ch_name)
            this.select_channel(ch_name)
            cmd_str = [':OUTP' ch_name ':STAT?'];
            fprintf(this.device, cmd_str)
            state = fscanf(this.device);
            state = strcmp(state(1:2),'ON');
        end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Non-Standard Interface.
%       Functions not in Standard Interface.
%       Be careful! These functions are not resuable b/w Power Supplies!
%
%       When adding features, prefer to build into standard interface
%       rather than add non-standard features when it makes sense.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        % Try not to add things here. 


    end % methods

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Device-Specific Methods.
%       Only use these within other methods. Not part of the interface.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    methods(Access=protected, Hidden=true)

        function select_channel(this, ch_name)
            %% do nothing.
        end

    end % hidden methods

end % classdef
