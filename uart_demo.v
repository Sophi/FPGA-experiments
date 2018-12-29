/*
 * Copyright 2015 Forest Crossman
 * Added in code from https://hackaday.com/2015/12/16/taking-the-pulse-width-modulation-of-an-fpga/
 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */

`include "cores/osdvu/uart.v" 

module top(        //
	input CLK,
	input RS232_Rx,
	output RS232_Tx,
	output LED0,
	output LED1,
	output LED2,
	output LED3,
	output LED4
	);

	wire reset = 0;
	reg transmit;
	reg [7:0] tx_byte;
	wire received;
	wire [7:0] rx_byte;
	wire is_receiving;
	wire is_transmitting;
	wire recv_error;

	assign LED4 = recv_error;
	assign {LED3, LED2, LED1, LED0} = rx_byte[7:4];

	uart #(
		.baud_rate(9600),                 // The baud rate in kilobits/s
		.sys_clk_freq(12000000)           // The master clock frequency
	)

	uart0(
		.clk(CLK),                        // The master clock for this module
		.rst(reset),                      // Synchronous reset
		.rx(RS232_Rx),                    // Incoming serial line
		.tx(RS232_Tx),                    // Outgoing serial line
		.transmit(transmit),              // Signal to transmit
		.tx_byte(tx_byte),                // Byte to transmit
		.received(received),              // Indicated that a byte has been received
		.rx_byte(rx_byte),                // Byte received
		.is_receiving(is_receiving),      // Low when receive line is idle
		.is_transmitting(is_transmitting),// Low when transmit line is idle
		.recv_error(recv_error)           // Indicates error in receiving packet.
	);

always @(posedge CLK) begin
    if (received) begin
        if (rx_byte >= 8'h61 && rx_byte <= 8'h7a)
            tx_byte <= rx_byte & 8'hDF;
        else begin
            tx_byte <= rx_byte;
            transmit <= 1;
        end 
        end
    else begin // else goes with if (received)
            transmit <= 0; 
    end
    end
endmodule