`timescale 1ns/1ps
module ahb_master(
    input hclk,hresetn, hreadyout, 
    input [31:0] hrdata, 
    input [1:0] hresp, // considering the readyout and resp signals from slave
    output reg [31:0] haddr, hwdata, 
    output reg hwrite,hreadyin, 
    output reg [1:0] htrans
);

    reg [2:0] hburst; // this are internal signals to the master
    reg [2:0] hsize;
    reg [31:0] haddr_int = 32'h38;
    reg [31:0] wrap_addr_value,wrap_boun_value;
    reg [31:0] randdata;

    task single_write();
        begin 
        
        // Address Phase
        begin
        @(posedge hclk);
        #1; 
        begin
         
            hwrite=1;
            htrans=2'b10;
            hsize=0;
            hburst=0;
            hreadyin=1;
            haddr=haddr_int;
            
        end
        

        // data phase of write cycle
        @(posedge hclk);
        #1;
            begin
            htrans=2'b00;
            hwdata=8'h80;
            end
        end
       
        
        end
    endtask

    task single_read();
        begin
            @(posedge hclk);
            #1;
            // Address Phase
            begin
                hwrite=0;
                htrans=2'b10;
                hsize=0;
                hburst=0;
                hreadyin=1;
                haddr=haddr_int;
            end

            @(posedge hclk);
            #1;
            // Data Phase
            begin
                htrans=2'b00;
            end
        end

    endtask

    task read_burst_incr_8();
        begin
            @(posedge hclk);
            #1;
            // Address Phase
            begin
                hwrite=0;
                htrans=2'b10;
                hsize=0;
                hburst=0;
                hreadyin=1;
                haddr=haddr_int;
            end
            
            @(posedge hclk);
            #1;
            // Data Phase
            begin
                htrans=2'b11;
            end

            repeat(7) begin
                @(posedge hclk);
                #1;
                // Address Phase
                begin
                    hwrite=0;
                    htrans=2'b11;
                    hsize=0;
                    hburst=0;
                    hreadyin=1;
                    haddr= haddr+8;
                end
                
                @(posedge hclk);
                #1;
                // Data Phase
                begin
                    htrans=2'b11;
                end
            end

            htrans = 2'b00;

        end

    endtask


    task write_burst_incr_8();
        begin
            @(posedge hclk);
            #1;
            // Address Phase
            begin
                hwrite=1;
                htrans=2'b10;
                hsize=0;
                hburst=0;
                hreadyin=1;
                haddr=haddr_int;
            end
            
            @(posedge hclk);
            #1;
            // Data Phase
            begin
                htrans=2'b11;
                randdata= randdata+32'h80;
                hwdata = randdata;
            end

            repeat(7) begin
                @(posedge hclk);
                #1;
                // Address Phase
                begin
                    hwrite=1;
                    htrans=2'b11;
                    hsize=0;
                    hburst=0;
                    hreadyin=1;
                    haddr= haddr+8;
                end
                
                @(posedge hclk);
                #1;
                // Data Phase
                begin
                    htrans=2'b11;
                    randdata= randdata+32'h80;
                    hwdata = randdata;
                end
            end
            htrans = 2'b00;
        end

    endtask

    task wrap_addr();
            begin   
                wrap_addr_value = (haddr_int/8) * 8;
            end
    endtask
    task wrap_boundary();
            begin   
                wrap_boun_value = haddr_int + 8;
            end
    endtask

    task read_burst_wrap_8();
    begin
        @(posedge hclk);
        #1;
        // Address Phase
        begin
            hwrite=0;
            htrans=2'b10;
            hsize=0;
            hburst=0;
            hreadyin=1;
            haddr=haddr_int;
            wrap_addr;
            wrap_boundary;
        end
        
        @(posedge hclk);
        #1;
        // Data Phase
        begin
            htrans=2'b11;
        end

        repeat(7) begin
            @(posedge hclk);
            #1;
            // Address Phase
            begin
                hwrite=0;
                htrans=2'b11;
                hsize=0;
                hburst=0;
                hreadyin=1;
                
                
            if (haddr == wrap_boun_value)
                haddr = wrap_addr_value;
            else
                haddr= haddr+8;
            end
            
            @(posedge hclk);
            #1;
            // Data Phase
            begin
                htrans=2'b11;
            end
        end
        htrans = 2'b00;
    end
endtask


task write_burst_wrap_8();
    begin
        @(posedge hclk);
        #1;
        // Address Phase
        begin
            hwrite=1;
            htrans=2'b10;
            hsize=0;
            hburst=0;
            hreadyin=1;
            haddr=haddr_int;
        end
        
        @(posedge hclk);
        #1;
        // Data Phase
        begin
            htrans=2'b11;
            randdata= randdata+32'h80;
            hwdata = randdata;
        end

        repeat(7) begin
            @(posedge hclk);
            #1;
            // Address Phase
            begin
                hwrite=1;
                htrans=2'b11;
                hsize=0;
                hburst=0;
                hreadyin=1;
                if (haddr == wrap_boun_value)
                haddr = wrap_addr_value;
                else
                haddr= haddr+8;
            end
              
            
            @(posedge hclk);
            #1;
            // Data Phase
            begin
                htrans=2'b11;
                randdata= randdata+32'h80;
                hwdata = randdata;
            end
            
        end
        htrans = 2'b00;
    end
        
endtask



endmodule
