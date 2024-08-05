module ahb_slave_interface(input hclk,hresetn,hwrite,hready_in,
input [1:0]htrans, input [31:0]hwdata, haddr,pr_data,
output reg hwrite_reg,hwrite_reg1,valid,
output reg [31:0]hwdata1,hwdata2,haddr1, haddr2,
output [31:0]hr_data, output reg [2:0]temp_sel);


//pipeline logic 

always@(posedge hclk)
begin
if(!hresetn)
begin
haddr1 <=0;
haddr2 <=0;
end
else
begin
haddr1<=haddr;
haddr2<=haddr1;
end
end

//hwdata and hwrite (hwrite_reg, hwrite_reg1)
always@(posedge hclk)
begin
if(!hresetn)
begin
hwdata1<=0;
hwdata2<=0;
end
else
begin
hwdata1<=hwdata;
hwdata2<=hwdata1;
end
end

always@(posedge hclk)
begin
if(!hresetn)
begin
hwrite_reg<=0;
hwrite_reg1<=0;
end
else
begin
hwrite_reg <= hwrite;
hwrite_reg1 <= hwrite_reg;
end
end


//valid signal
//1.hready_in == 1 2. htrans 2'b10 or 2'b11 3. haddr range

always@(*)
begin
valid = 1'b0;
if(hready_in == 1  && htrans == 2'b10 || htrans == 2'b11 && haddr >= 8'h0000_0000 && haddr <= 8'h8c00_0000)
valid = 1'b1;
else
valid = 1'b0;
end

//Temp selection

always@(*)
begin
//temp_sel = 3'b000;
if(haddr >= 32'h8000_0000 && haddr < 32'h8400_0000)
temp_sel = 3'b001;
else if(haddr >= 32'h8400_0000 && haddr < 32'h8c00_0000)
temp_sel = 3'b010;
else
temp_sel = 0;
end

assign hr_data = pr_data;
endmodule
