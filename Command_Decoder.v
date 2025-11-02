////////////////////////////////////
//  OPCODE  
// CALL
// EXECUTE
// RETURN
// JUMP
///////////////////////////////////

module Command_Decoder(

output reg [7:0]Data_out,
output reg[3:0]PC,
input [7:0]Instruction_packet,
input clk,rst,load_en
);

parameter EXECUTE = 4'b0000;
parameter JUMP  = 4'b0100;
parameter CALL = 4'b1000;
parameter RETURN = 4'b1100;

wire wr_en,rd_en;
reg pc_load;
reg [3:0]pc_inc;


PC p1(PC,pc_inc,Instruction_packet[3:0],clk,rst);
LIFO L1(PC,pc_inc,clk,rst,wr_en,rd_en);

//logic of program counter valid bit
always@(posedge clk or posedge rst)begin
    if(rst)begin
        pc_load<=0;
    end else begin
        if(Instruction_packet[3:0] == CALL) begin
            pc_load<=1;
        end else begin
            pc_load<=0;
        end
    end

//logic of LIFO valid bit


    // if(rst)begin
    //     pc_load<=0;
    // end else begin
        if(pc_load)begin
            wr_en<=1;
            rd_en<=0;
        end else begin
            rd_en<=1;
            wr_en<=0;

        end
    // end
end


endmodule


//LIFO

module LIFO(
    output reg[bits-1:0]data_out,
    input [bits-1:0]data_in,
    input clk,rst,wr_en,rd_en
);

parameter bits=4;

reg [bits-1:0]mem[0:bits-1];
reg [2:0]sp;

always@(posedge clk or posedge rst)begin
    if(rst)begin
        data_out<=4'b0000;
        sp<=3'b000;
    end else begin
        if(sp == bits )begin
            sp<=3'b000;
        end else begin
            //write logic
            if(wr_en)begin
                mem[sp]<=data_in;
                sp<=sp+1;
            end

            //read logic
            if(rd_en)begin
                sp<=sp-1;
                data_out<=mem[sp];
            end
        end

    end
end

endmodule

//program counter 
module PC(
    output reg [3:0]pc,
    output reg [3:0]pc_inc,
    input [7:0]pc_in,
    input pc_load,
    input clk,rst
);

always@(posedge clk or posedge rst)begin
    if(rst)begin
        pc<=4'b0000;
    end else begin
        if(pc_load)begin
            // if(pc == 4'b1100)begin
            //     pc<=
            // end else
            pc_inc<=pc+1;
            pc<=pc_in[7:4];
        end
        end else begin
            pc<=pc+1;
        end
    end 
end

endmodule