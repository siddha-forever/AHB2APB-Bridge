module top_tb();
reg hclk, hresetn;

wire hr_readyout;
wire [31:0] hr_data, hwdata, haddr;
wire [1:0] htrans;

ahb_master AHB(hclk, hresetn, hr_readyout, hr_data, haddr, hwdata,hwrite, hready_in,htrans);
bridge_top Bridge_top(hclk, hresetn,hwrite,hready_in,htrans,hwdata, haddr, pr_data,penable,pwrite, hr_readyout,psel,hres, paddr, pwdata, hr_data);
apb_interface APB(pwrite, penable,psel,paddr, pwdata,pwrite_out, penable_out,psel_out,paddr_out, pwdata_out,pr_data);

always
#10 hclk = ~hclk;

task reset;
begin
@(negedge hclk)
hresetn = 1'b0;
@(negedge hclk)
hresetn = 1'b1;
end
endtask

initial 
begin
hclk = 1'b0;
reset;
AHB.single_write;
//AHB.single_read; commenting as , only one can be used at a time.
end
endmodule