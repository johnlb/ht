clc;
clear all;

isVerbose 	= 1; % want matlab error & flow messages ?
isDebug 	= 1; % prints even more messages, for trouble shooting
packet_len 	= 33;


% Initialize SPI
spi 		= htSPI.okSPI(isDebug, packet_len);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The rest of this testbench should work for any LA.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Some useful packets
pkt_turn_off_clk 	= spi.make_packet(true, 1, 0);
pkt_turn_on_clk 	= spi.make_packet(true, 1, '1000');
pkt_read_from_clk 	= spi.make_packet(false, 1, '1000');




MISO = spi.send_packet(pkt_turn_off_clk);

pause(1)
MISO = spi.send_packet(pkt_turn_on_clk);

pause(1)
MISO = spi.send_packet(pkt_read_from_clk)