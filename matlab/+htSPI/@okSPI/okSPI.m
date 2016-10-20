classdef okSPI < handle


    properties (Access=public)

        debug_mode
        packet_len

    end % public properties


    properties (Access=protected)

        FPGA
        kill_ptr

    end % protected properties

    methods (Access=public)


        %% okSPI: constructor
        function [obj] = okSPI(debug_mode, packet_len)
        % REQUIRES:
        %   @okusbfrontpanel and @okPLL22150 libraries (in matlab's path or working directory)


            if ~libisloaded('okFrontPanel')
              loadlibrary('okFrontPanel', 'okFrontPanelDLL.h');
                % loadlibrary('okFrontPanel', 'okFrontPanelDLL.h','notempdir');
            end

            obj.debug_mode = debug_mode;
            obj.packet_len = packet_len;

            % stuff for OpalKelly
            % path(path, '.\FPGA test') % this folder has the code for talking with the FPGA
            Testing_top_dir = '.'; % the folder you run your testing from
            FPGA_bit_file = '.\@okSPI\fp_to_ok_top.bit'; % the location/name of the bitfile
           

            %  Get the FPGA ready for talking to the IC
            fprintf('Opening FrontPanel connection.\n\n')
            try
                [obj.FPGA obj.kill_ptr] = obj.setup_FPGA_CS(1, FPGA_bit_file);
            catch ME
                if (exist('obj.FPGA','var'))
                    fprintf('\n\nError found, closing FrontPanel connection \n\n');
                    cd('@okusbfrontpanel')
                    calllib('okFrontPanel', 'okFrontPanel_Destruct', kill_ptr);
                    cd(Testing_top_dir)
                else
                    fprintf('\n\nError found, can''t close FrontPanel connection,\n please cycle FPGA power\n\n');
                end
                str = sprintf('%s\n%s\n\n',ME.identifier, ME.message);
                fprintf(str)
                rethrow(ME);
            end %try/catch

        end % okSPI
        


        %% delete: deconstructor
        function delete(this)
        
            fprintf('Closing FrontPanel connection.\n\n')
            if(isopen(this.FPGA))
                calllib('okFrontPanel', 'okFrontPanel_Destruct', this.kill_ptr);
                clear this.FPGA this.kill_ptr
            end

        end



        function MISO = send_packet(this, binary_packet, ch_num)

            if (nargin==2)
                ch_num = 0;
            end

            % configuration registers
            rd = 1;         % Read/Write, NOT IMPLEMENTED in FPGA
            cpol = 0;       % (1)Positive: clock idle positive, first clock edge is negative
            cpha = 0;       % (1)Positive: data written on first clock edge, data is read on on second clock edge
            slave = ch_num; % INTEGER range 0 to 31, CH to talk to
            %this.packet_len = 52;  % INTEGER range 0 to 255;      -- Length of packet to send over SPI (number of SPI clocks)
            clk_div = 2000;    % INTEGER range 0 to 4095, Clock division ratio: 13 bits
            % clk_div = 4000;    % INTEGER range 0 to 4095, Clock division ratio: 13 bits

            configA = rd*2^0 + cpol*2^1 + cpha*2^2 + slave*2^3 + this.packet_len*2^8;
            configB = clk_div;

            binary_packet = fliplr(binary_packet); % OOPS......

            % ----------------- set configuration registers -----------------
            setwireinvalue(this.FPGA, 0, configA, 65535);
            setwireinvalue(this.FPGA, 1, configB, 65535);


            % ------------------- set MOSI data registers -------------------
            i_end = floor(this.packet_len/16) + (mod(this.packet_len,16) > 0);
            for i = 1:i_end;
                for j = 16:-1:1
                    data_reg(j) = binary_packet(end);
                    if(length(binary_packet) > 1)
                        binary_packet = binary_packet(1:end-1);
                    else
                        binary_packet = 0;
                    end
                end
                setwireinvalue(this.FPGA, 2+i-1, bin2dec(data_reg), 65535);
            end

            % ------------------ update registers to FPGA -------------------
            updatewireins(this.FPGA);

            % ------------------------ start SPI FSM ------------------------
            updatetriggerouts(this.FPGA); %clear any old unprocessed interrupts
            updatetriggerouts(this.FPGA); %clear any old unprocessed interrupts
            activatetriggerin(this.FPGA, hex2dec('40'), 1);

            % ------------------------ wait for MISO ------------------------
            MISO = [];
            for k=1:10
                trig = istriggered(this.FPGA, hex2dec('60'), 1);
                updatetriggerouts(this.FPGA)
                if (trig)
                    if(this.debug_mode)
                       fprintf('Trigger from FPGA caught, loading registers...\n'); 
                    end
                    updatewireouts(this.FPGA);
                    for i = 1:i_end
                        dec = getwireoutvalue(this.FPGA,hex2dec('20')+i-1);
                        MISO = [dec2bin(dec,16) MISO]; %#ok<AGROW>
                    end
                    break;
                end
                pause(0.1)
            end

            % MISO = MISO(end-this.packet_len+2:end); % round out the 16-bit padding
            % MISO = MISO(1:this.packet_len); % extract the data bits
            MISO = fliplr(MISO); % change from time-order to bit-order

        end % send_CS_SPI_Packet



        function [mlist,snlist] = ok_getdevicelist(this)

            %OK_GETDEVICELIST  Returns a list of attached XEM devices.
            %  [M,SN]=OK_GETDEVICELIST() looks for attached XEM devices.
            %  It returns the device models in M, serial numbers in SN.
            %  The serial number can then be used to open an attached XEM
            %  for use.
            %
            %  Copyright (c) 2005 Opal Kelly Incorporated
            %  $Rev: 972 $ $Date: 2011-05-27 11:03:26 -0500 (Fri, 27 May 2011) $


            % Try to construct an okUsbFrontPanel and open it (the board model doesn't matter).
            xptr = calllib('okFrontPanel', 'okFrontPanel_Construct');
            num = calllib('okFrontPanel', 'okFrontPanel_GetDeviceCount', xptr);
            for j=1:num
               m = calllib('okFrontPanel', 'okFrontPanel_GetDeviceListModel', xptr, j-1);
            %    sn = calllib('okFrontPanel', 'okFrontPanel_GetDeviceListSerial', xptr, j-1, '           ', 10);
               sn = calllib('okFrontPanel', 'okFrontPanel_GetSerialNumber', xptr, '           ');
               if ~exist('snlist', 'var')
                  mlist = m;
                  snlist = sn;
               else
                  mlist = [mlist;m];
                  snlist = char(snlist, sn);
               end
            end
            calllib('okFrontPanel', 'okFrontPanel_Destruct', xptr);

        end % ok_getdevicelist

    end % public methods




    methods (Access=protected)


        function [FPGA kill_ptr] = setup_FPGA_CS(this, isLoadBitfile, FPGA_bit_file)
        % Author: Fred Buhler
        % Purpose: Compressive Sensing chip (Jul 2015)
        % 
        % This sets up the XEM6001 FPGA, and passes a pointer to the device back to the caller


            % ----------------- setup pointers & objects -----------------
            % cd('C:\Users\johnlb\Desktop\OpalKelly_SPI\FPGA test\');
            [FPGA, kill_ptr] = this.okusbxem6001();
            FPGA = openbyserial(FPGA);
              
            % cd('C:\Users\johnlb\Desktop\OpalKelly_SPI\FPGA test\@okPLL22150');
            PLL = htSPI.okpll22150();

            % ------------------------ setup PLL ------------------------
            Q = 48;     % 2 < Q < 129
            P = 200;    % 8 < P < 2055
            DIV1 = 100;   % 4 < DIV1 < 127
            DIV2 = 100;   % 4 < DIV2 < 127
            % Turn FPGA clock to 48e3 / Q * P / 2  
            %   100 Mhz: Q = 48, P = 400, N = 4
            %   40 Mhz:  Q = 48, P = 200, N = 5
            %   25 Mhz:  Q = 48, P = 200, N = 8

            setvcoparameters(PLL, P, Q);
            setdiv1(PLL, 'ok_DivSrc_VCO', DIV1);
            setdiv2(PLL, 'ok_DivSrc_VCO', DIV2);

            setoutputsource(PLL, 0, 'ok_ClkSrc22150_Div1ByN');
            setoutputenable(PLL, 0, 1);

            % For testing external clk (#4)
            % setoutputsource(PLL, 3, 'ok_ClkSrc22150_Div1ByN');
            % setoutputenable(PLL, 3, 1);

            setpll22150configuration(FPGA,PLL);
            seteeprompll22150configuration(FPGA,PLL);

            % ----------------------- load bit file -----------------------
            if(isLoadBitfile)
                success = configurefpga(FPGA, FPGA_bit_file);
                if(~success)
                    error('OpalKellyFPGA:Initialization',...
                        'Error loading bitfile. Please check ''FPGA_bit_file'' points to correct file');
                end
            end

            % ---------------------- send logic reset ----------------------
            activatetriggerin(FPGA, hex2dec('40'), 0);

            % setpll22150configuration(FPGA_ptr, getobjptr(PLL))
            % seteeprompll22150configuration(FPGA_ptr, getobjptr(PLL))
            % configurefpga(FPGA_ptr, 'destop.bit');


        end % setup_FPGA_CS



        function [obj, kill_ptr] = okusbxem6001(this)

            % Fred's creation of an XEM6001 object


            % Try to construct an okUsbFrontPanel and open it (the board model doesn't matter).
            FPGA_ptr = calllib('okFrontPanel', 'okFrontPanel_Construct');
            num = calllib('okFrontPanel', 'okFrontPanel_GetDeviceCount', FPGA_ptr);
            if (num > 1)
                calllib('okFrontPanel', 'okFrontPanel_Destruct', FPGA_ptr);
                error('OpalKellyFPGA:Initialization',...
                    'Error: More than 1 OpalKelly connected to PC');
            end

            m = calllib('okFrontPanel', 'okFrontPanel_GetDeviceListModel', FPGA_ptr, 0);
            if (~strcmp(m,'ok_brdXEM6001'))
                calllib('okFrontPanel', 'okFrontPanel_Destruct', FPGA_ptr);
                error('OpalKellyFPGA:Initialization',...
                    'Error: Only OpalKelly XEM6001 supported, pluged in device: %s',m);
            end
            kill_ptr = FPGA_ptr;
            obj = okusbfrontpanel(FPGA_ptr);

        end % okusbxem6001


    end % protected methods




end % classdef