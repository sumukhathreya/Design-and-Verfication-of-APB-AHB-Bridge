// apb_interface should be the master for the slaves in the APB side
// but in the project it is used to also mimic the slave behaviour and driving the values whic are fixed 
// as a response to the read transfer

module apb_interface (
    input pwrite,penable,
    input [2:0] pselx, 
    input [31:0] paddr,pwdata,
    output pwrite_out,penable_out,
    output [2:0] psel_out,
    output [31:0] paddr_out,pwdata_out,
    output reg [31:0] prdata
);

    reg [31:0] randnum;
    assign pwrite_out=pwrite;
    assign penable_out=penable;
    assign psel_out=pselx;
    assign pwdata_out=pwdata;
    assign paddr_out=paddr;

    always @(*)
    begin
        $display("enetering the rannum assignment");
        $display(pwrite,penable);
        if(!pwrite==1 &&penable) begin
            randnum = randnum + 32'h25;
            prdata= randnum;
            $display(prdata);
        end
    end

endmodule
