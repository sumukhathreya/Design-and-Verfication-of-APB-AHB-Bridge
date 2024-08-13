module ahb_slave_interface(
    input hclk,hresetn,hwrite,hready_in, 
    input [1:0] htrans,
    input [31:0] haddr,hwdata, 
    output reg valid,hwritereg,hwritereg_1, 
    output [1:0] hresp,
    output reg [2:0] temp_selx,
    output reg [31:0] haddr_1,haddr_2,hwdata_1,hwdata_2, // this signals are not used in the controller
    output [31:0] hrdata, 
    input [31:0] prdata
);

    // Shifted versions of the Address 
    // used to mimic the wait state addition into AHB to mimic the APB 2 cycle non pipeline characteristic
    // direct assignment value dont make any change but just for the pseudo behaviour replication of AHB2APB bridge
    // check the direct assignment of the value to temp and see the changes // check it...
    always @(posedge hclk)
    begin 
        if(!hresetn)
        begin
            haddr_1<=0;
            haddr_2<=0;
        end
        else 
        begin
            haddr_1<=haddr;
            haddr_2<=haddr_1;
        end
    end

    // Shifted versions of Data
    // used to mimic the wait state addition into AHB to mimic the APB 2 cycle non pipeline characteristic
    // but never used in the controller if used they are changes // check it...
    always @(posedge hclk)
    begin 
        if(!hresetn)
            begin
                hwdata_1<=0;
                hwdata_2<=0;
            end
        else 
            begin
                hwdata_1<=hwdata;
                hwdata_2<=hwdata_1;
            end
    end

    // Shifted version for the HWRITE signal
    always @(posedge hclk)
    begin 
        if(!hresetn)
            begin
                hwritereg<=0;
                hwritereg_1<=0;
            end
        else 
            begin
                hwritereg<=hwrite;
                hwritereg_1<=hwritereg; 
            end
    end

    // Generation of valid signal - signal tht controllers the transition among the state_machine of Bridge
    always @(*)
    begin
        valid=1'b0;
        if(hready_in==1 && haddr>=32'h0000_0000 && haddr<32'h8c00_0000 && htrans==2'b10||htrans==2'b11)
            valid=1;
        else
            valid=0;
    end

    // HSELx signal mimic 
    // any of the SELx in the design driects to a sample sample created to test the Bridge 
    // comes into usuage at when we model teh Bridge using multi slaves
    always @(*)
    begin
        temp_selx=3'b000;
        if ( haddr>=32'h0000_0000 && haddr<32'h8400_0000)
            temp_selx=3'b001;
        if ( haddr>=32'h8400_0000 && haddr<32'h8800_0000)
            temp_selx=3'b010;
        if ( haddr>=32'h8800_0000 && haddr<=32'h8c00_0000)
            temp_selx=3'b000;
    end

    assign hrdata=prdata;

    // hresp in additon to hready_out used in the ahb slave as output is to generate the status of transfer
    // 10 always represent a  hready_out = 1 ie success transfer, hresp = 0 ie OKAY response
    // The error response and waited transfer status is not used just for the reduction of the complexity 
    assign hresp=2'b10;

endmodule
