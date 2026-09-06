`timescale 1ns/1ps

module debouncing_fsm_tb ();
  
    reg clk;
    reg rst;
    reg sw_input;
    wire debouncing_output;


    debouncing_fsm uut (
        .clk(clk),
        .rst(rst),
        .sw_input(sw_input),
        .debouncing_output(debouncing_output)
    );

    always #5 clk = ~clk;


    initial begin

        clk = 1'b0;
        rst = 1'b0;     
        sw_input = 1'b1;
        #20;          
        

         $display("testcase1:initial output to be 1");
        rst = 1'b1;     
        #10;
        if (debouncing_output !== 1'b1) 
            $display("FAIL , got %b", debouncing_output);
        else 
            $display("PASS Output is 1 (State: one)");

       
       $display("testcase2: Debouncer output  1");
        sw_input = 1'b0; 
        #50;           
        sw_input = 1'b1; 
        #20;          
        if (debouncing_output !== 1'b1)
            $display(" FAIL Debouncer output  0 , got %b", debouncing_output );
        else 
            $display("PASS Output remained 1.");


        $display("testcase4:Stable press  Output shifted to 0");
        sw_input = 1'b0; 
        #400; 
        if (debouncing_output !== 1'b0)
            $display("FAIL, got %b", debouncing_output);
        else 
            $display("PASS Output shifted to 0 (State: zero)");


        $display("testcase6: Output remained 0");
        sw_input = 1'b1; 
        #50;         
        sw_input = 1'b0; 
        #20;
        if (debouncing_output !== 1'b0)
            $display("FAIL output 1 ,  got %b", debouncing_output );
        else 
            $display("PASS Output remained 0.");

        $display("testcase7:stable Output 1");
        sw_input = 1'b1; 
        #400;
        if (debouncing_output !== 1'b1)
            $display(" FAILExpected output 1 after , got %b", debouncing_output);
        else 
            $display("PASS  Output returned to 1 (State: one)");

        $finish;
    end

endmodule
