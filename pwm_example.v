module tutorial_led_blink // define the inputs and outputs
  (
   input CLK,
   input EN,
   input SW1,
   input SW2,
   output LED0,
   output LED1,
   output LED2,
   output LED3,
   output LED4 			//green yeahhhh
   );
     
  // Constants (parameters) to create the frequencies needed:
  // Icestick clock is 12 MHz, so (12 MHz/ 100 Hz * x% duty cycle)
  // Formula is: (12 MHz / 100 Hz * 50% duty cycle)
  // So for 100 Hz: 12000000 / 100 * 0.5 = 6000
  // Parameters can have data type, range and sign identifiers, and are defined before compiling
  parameter c_CNT_100HZ = 60000; 
  parameter c_CNT_50HZ  = 120000;
  parameter c_CNT_10HZ  = 2400000;
  parameter c_CNT_1HZ   = 4800000;
 
  // These signals will be the counters:
  // registers with 4 Bytes/ 32 bits
  reg [31:0] r_CNT_100HZ = 0; 
  reg [31:0] r_CNT_50HZ = 0;
  reg [31:0] r_CNT_10HZ = 0;
  reg [31:0] r_CNT_1HZ = 0;
   
  // These signals will toggle at the frequencies needed:
  reg        r_TOGGLE_100HZ = 1'b0; // 1 bit number expressed in binary format with a value of zero. 
                                    // A bit value of one would be expressed as 1'b1
  reg        r_TOGGLE_50HZ  = 1'b0;
  reg        r_TOGGLE_10HZ  = 1'b0;
  reg        r_TOGGLE_1HZ   = 1'b0;
   
  // One bit select
  reg        r_LED_SELECT;
  wire       w_LED_SELECT;
   
     
begin
 
  // All always blocks toggle a specific signal at a different frequency.
  // They all run continuously even if the switches are
  // not selecting their particular output.
 
  always @ (posedge CLK)
    begin
      if (r_CNT_100HZ == c_CNT_100HZ-1)         // if register 100 Hz is equal to counter 100 Hz, then 
                                                // don't toggle (?)r_TOGGLE gets !r_TOGGLE. And put 0 into the register
        begin        
          r_TOGGLE_100HZ <= !r_TOGGLE_100HZ;
          r_CNT_100HZ    <= 0;
        end
      else
        r_CNT_100HZ <= r_CNT_100HZ + 1;
    end
 
   
  always @ (posedge CLK)
    begin
      if (r_CNT_50HZ == c_CNT_50HZ-1)            // -1, since counter starts at 0
        begin        
          r_TOGGLE_50HZ <= !r_TOGGLE_50HZ;
          r_CNT_50HZ    <= 0;
        end
      else
        r_CNT_50HZ <= r_CNT_50HZ + 1;
    end
 
 
  always @ (posedge CLK)
    begin
      if (r_CNT_10HZ == c_CNT_10HZ-1)             // -1, since counter starts at 0
        begin        
          r_TOGGLE_10HZ <= !r_TOGGLE_10HZ;
          r_CNT_10HZ    <= 0;
        end
      else
        r_CNT_10HZ <= r_CNT_10HZ + 1;
    end
 
   
  always @ (posedge CLK)
    begin
      if (r_CNT_1HZ == c_CNT_1HZ-1)               // -1, since counter starts at 0
        begin        
          r_TOGGLE_1HZ <= !r_TOGGLE_1HZ;
          r_CNT_1HZ    <= 0;
        end
      else
        r_CNT_1HZ <= r_CNT_1HZ + 1;
    end
 
  // Create a multiplexer based on switch inputs
  always @ (*)
  begin
    case ({SW1, SW2})                // Concatenation Operator { }
      2'b11 : r_LED_SELECT <= r_TOGGLE_1HZ;
      2'b10 : r_LED_SELECT <= r_TOGGLE_10HZ;
      2'b01 : r_LED_SELECT <= r_TOGGLE_50HZ;
      2'b00 : r_LED_SELECT <= r_TOGGLE_100HZ;
    endcase     
  end

  assign LED0 = 0;
  assign LED1 = 0;
  assign LED2 = 0;
  assign LED3 = 0;
  assign LED4 = r_LED_SELECT & EN;
        
end
endmodule