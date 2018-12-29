
# From Dangerous Prototypes
# http://dangerousprototypes.com/docs/CPLD_Verilog_intro_2:_Toggle_a_LED_with_a_button

module button(
    output LED1,
	output LED2,
	output LED3,
	output LED4,
    output LED5,  //these are the connections to the module that we expose externally
    input BUTTON //
    );         
 
    reg LED5;					//a register to output LED
    reg LED1; 				    //a register to output LED_INV
 
    wire BUTTON; //input button is a wire
 
    always @ (BUTTON) 			//start of the action section
    begin
        LED5 = BUTTON; 			//Set reg LED to the value of wire button
        LED_INV = 1'b0; 		//Hold LED D2 off (low)
                    			//other states are
                    			//1'b1 HIGH 
                    			//1'b0 LOW
                    			//1'bz HiZ (input)
    end
 
endmodule