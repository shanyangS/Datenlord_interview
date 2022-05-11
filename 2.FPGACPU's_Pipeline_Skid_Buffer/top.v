module top
#(
    parameter WORD_WIDTH  = 10
)
(
	input wire clock,
	input wire clear,
	input wire input_valid,
	input wire[WORD_WIDTH-1:0] input_data,
	input wire output_ready,
	output wire input_ready,
    	output wire output_valid_master,
    	output wire[WORD_WIDTH-1:0] output_data_master,

	input wire ready_in,
	output wire output_valid_slave,
	output wire[WORD_WIDTH-1:0] output_data_slave	
);

	
hs_update master
(.clock(clock),
.clear(clear),
.input_valid(input_valid),
.input_data(input_data),
.output_ready(output_ready),
.input_ready(input_ready),
.output_valid(output_valid_master),
.output_data(output_data_master)
);

hs_update slave
(.clock(clock),
.clear(clear),
.input_valid(output_valid),
.input_data(output_data),
.output_ready(ready_in),
.input_ready(output_ready),
.output_valid(output_valid_slave),
.output_data(output_data_slave)
);

endmodule

/*input   wire                        clock,
    input   wire                        clear,
    input   wire                        input_valid,
    output  wire                        input_ready,
    input   wire    [WORD_WIDTH-1:0]    input_data,
    output  wire                        output_valid,
    input   wire                        output_ready,
    output  wire    [WORD_WIDTH-1:0]    output_data*/