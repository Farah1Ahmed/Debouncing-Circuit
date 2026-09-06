module debouncing_fsm(
   input wire clk,
    input wire rst,
    input wire sw_input,
    //input wire m_tick,
    output reg debouncing_output
    
);

  
    localparam one = 4'b0000;
    localparam wait0_1 = 4'b0001;
    localparam wait0_2 = 4'b0010;
    localparam wait0_3 = 4'b0011; 
    localparam zero    = 4'b0100;
    localparam wait1_1 = 4'b0101;
    localparam wait1_2 = 4'b0110;
    localparam wait1_3 = 4'b0111;

    reg [2:0] next_state ,current_state;
    reg [3:0] count;
     wire m_tick;


     assign m_tick = (count == 4'd9);

  //counter 
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            count  <= 4'd0;
        end else if (count == 4'd9) begin   // 0to9 = 10 cycles
            count  <= 4'd0;                // 1-cycle pulse
        end else begin
            count  <= count + 1'b1;
        end
    end
//memory
always @(posedge clk or negedge rst) begin
        if (!rst)
            current_state <= one;
        else
            current_state <= next_state;
    end

//cs_ns & cs_o/p logic 
 always @(*) begin
        next_state = current_state;
       debouncing_output = 1'b0;
        
        case (current_state)
            one: begin
                if (sw_input) begin
                next_state = one;
                debouncing_output = 1'b1;
                end
                else  begin
                   next_state =  wait0_1;
                  debouncing_output = 1'b1;
                end
                
            end
            
           wait0_1 : begin
                if (sw_input) begin
                next_state = one;
                debouncing_output = 1'b1;
                end
                else if (!sw_input && !m_tick ) begin
                   next_state =  wait0_1;
                  debouncing_output = 1'b1;
                end
                 else if (!sw_input && m_tick ) begin
                   next_state =  wait0_2;
                  debouncing_output = 1'b1;
                end
                else begin   
             next_state = one;
             debouncing_output = 1'b0;
            end
            end 
           wait0_2 : begin
                if (sw_input) begin
                next_state = one;
                debouncing_output = 1'b1;
                end
                  else if (!sw_input && !m_tick ) begin
                   next_state =  wait0_2;
                  debouncing_output = 1'b1;
                end
                 else if (!sw_input && m_tick ) begin
                   next_state =  wait0_3;
                  debouncing_output = 1'b1;
                end
                else begin   
             next_state = one;
             debouncing_output = 1'b0;
            end
                
            end
            
             wait0_3 : begin
                if (sw_input) begin
                next_state = one;
                debouncing_output = 1'b1;
                end
                  else if (!sw_input && !m_tick ) begin
                   next_state =  wait0_3;
                  debouncing_output = 1'b1;
                end
                 else if (!sw_input && m_tick ) begin
                   next_state =  zero;
                  debouncing_output = 1'b0;
                end
                else begin   
             next_state = one;
             debouncing_output = 1'b0;
            end
                
            end 
                  zero : begin
                if (sw_input) begin
                next_state = wait1_1;
                debouncing_output = 1'b0;
                end
                  else begin
                   next_state =  zero;
                  debouncing_output = 1'b0;
                end
                  end

               wait1_1 : begin
                if (!sw_input) begin
                next_state = zero;
                debouncing_output = 1'b0;
                end
                  else if (sw_input && !m_tick ) begin
                   next_state =  wait1_1;
                  debouncing_output = 1'b0;
                end
                 else if (sw_input && m_tick ) begin
                   next_state =  wait1_2;
                  debouncing_output = 1'b0;
                end
                else begin   
             next_state = one;
             debouncing_output = 1'b0;
            end  
               end
                
                 wait1_2 : begin
                if (!sw_input) begin
                next_state = zero;
                debouncing_output = 1'b0;
                end
                  else if (sw_input && !m_tick ) begin
                   next_state =  wait1_2;
                  debouncing_output = 1'b0;
                end
                 else if (sw_input && m_tick ) begin
                   next_state =  wait1_3;
                  debouncing_output = 1'b0;
                end
                else begin   
             next_state = one;
             debouncing_output = 1'b0;
            end
            end

             wait1_3 : begin
                if (!sw_input) begin
                next_state = zero;
                debouncing_output = 1'b0;
                end
                  else if (sw_input && !m_tick ) begin
                   next_state =  wait1_3;
                  debouncing_output = 1'b0;
                end
                 else if (sw_input && m_tick ) begin
                   next_state =  one;
                  debouncing_output = 1'b0;
                end
                else begin   
             next_state = one;
             debouncing_output = 1'b0;
            end
             end

            default: begin   
             next_state = one;
             debouncing_output = 1'b0;
            end

        endcase
    end

   
endmodule
