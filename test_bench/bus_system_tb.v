`timescale 1ns/1ps

module bus_system_tb;

reg clk,reset;
reg load_acc,drive_acc,load_b,drive_b;
reg [1:0]op;
reg alu_drive;

wire [7:0]bus;
wire [7:0]ALU_out;

reg [7:0]bus_tb; //bus is also used as a tristate system as it was inout in deceleration
reg bus_drive;

    assign bus = (bus_drive) ? bus_tb : 8'bz;

    bus_system b1(.bus(bus),.clk(clk),.reset(reset),.load_acc(load_acc),.drive_acc(drive_acc),
    .load_b(load_b),.drive_b(drive_b),.alu_drive(alu_drive),.op(op),.ALU_out(ALU_out));

    
    initial
        begin
            clk=0;      //clock initialisation
            forever #5 clk = ~clk;
        end
    
    
    initial
        begin 
            #1;
            reset = 1'b1;
            bus_drive = 1'b0;
            drive_acc = 1'b0;
            load_acc = 1'b0;   
            drive_b = 1'b0;
            load_b = 1'b0;
            alu_drive = 1'b0;
            op = 2'b00;

            @(posedge clk);

            #1;

            bus_tb = 4'b0101;   //bus loads input into ACC
            reset = 1'b0;
            bus_drive = 1'b1;
            drive_acc = 1'b0;
            load_acc = 1'b1;    //register B is undefined rn
            drive_b = 1'b0;
            load_b = 1'b0;
            alu_drive = 1'b0;
            op = 2'b00;

            @(posedge clk);

            bus_drive = 1'b0;
            drive_acc = 1'b1;   // register ACC loads value to register B
            load_acc = 1'b0;    // now both ACC and B have same value
            load_b = 1'b1;

            @(posedge clk);

            bus_tb = 4'b1010;
            bus_drive = 1'b1;   // bus loads some other input in ACC
            drive_acc = 1'b0;   // B is still holding onto last value
            load_acc = 1'b1;
            drive_b = 1'b0;
            load_b = 1'b0;

            repeat(2)@(posedge clk);

            bus_drive = 1'b0;
            drive_acc = 1'b0;   // ACC is still holding onto last value
            load_acc = 1'b0;    // B is also still holding onto last value
            drive_b = 1'b0;     //hence ALU completes its task
            load_b = 1'b0;

            @(posedge clk);

            alu_drive = 1'b1;
            bus_drive = 1'b0;   // ACC loads value from bus that was passed on by ALU
            drive_acc = 1'b0;   // B is still holding onto last value
            load_acc = 1'b1;
            drive_b = 1'b0;
            load_b = 1'b0;

            @(posedge clk);

            load_acc = 1'b0;
            alu_drive= 1'b0;

             @(posedge clk);

        end
endmodule





