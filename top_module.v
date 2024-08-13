`timescale 1ns/1ps

module top();

    reg hclk,hresetn;
    wire hreadyout,hwrite,hreadyin;
    wire [31:0] hrdata,haddr,hwdata,paddr,pwdata,paddr_out,pwdata_out,prdata;
    wire [1:0] hresp,htrans;
    wire penable,pwrite,pwrite_out,penable_out;
    wire [2:0] psel,psel_out;

    ahb_master ahb (hclk,hresetn,hreadyout,hrdata,hresp,haddr,hwdata,hwrite,hreadyin,htrans);

    bridge_top bridge (hclk,hresetn,hwrite,hreadyin,htrans,haddr,hwdata,prdata,penable,pwrite,hreadyout,psel,hresp,paddr,pwdata,hrdata);

    apb_interface apb (pwrite,penable,psel,paddr,pwdata,pwrite_out,penable_out,psel_out,paddr_out,pwdata_out,prdata);

    initial
    begin
        hclk=1'b0;
        forever #10 hclk=~hclk;
    end

    task reset();
        begin
            @(negedge hclk)
            hresetn=1'b0;
            @(negedge hclk)
            hresetn=1'b1;
        end
    endtask

    initial
    begin
        reset;
        ahb.single_read();
//        repeat(3) @(posedge hclk);
//        ahb.single_write();
//        repeat(4) @(posedge hclk);
//        ahb.read_burst_incr_8();
//        repeat(5) @ (posedge hclk);
//        ahb.read_burst_wrap_8();
//        repeat(6) @(posedge hclk);
//        ahb.write_burst_incr_8();
//        repeat(7) @ (posedge hclk);
//        ahb.write_burst_wrap_8();
    end

    initial begin
        apb.randnum = {$random}%1000;
        ahb.randdata = {$random}%1000;
        $display(apb.randnum);
        $display(paddr);
    end

    initial
    begin
        $dumpfile("ahb2apb.vcd");
        $dumpvars();
        #5000;
          $display("%h",ahb.wrap_addr_value);
          $display("%h",ahb.wrap_boun_value);
        $finish;
    end

endmodule
