module hs_update
#(
    parameter WORD_WIDTH = 10//Define the wide.
)
(
    input clock,
    input clear,
    input input_valid, //from pre-stage
    output input_ready, //This stage's ready to post-stage
    input[WORD_WIDTH-1:0] input_data, //BUS_DATA
    output output_valid, //from this stage
    input output_ready, //from post-stage
    output[WORD_WIDTH-1:0] output_data //from this stage
);

    localparam WORD_ZERO = {WORD_WIDTH{1'b0}}; //
    reg data_buffer_wren = 1'b0; // EMPTY at start, so don't load.
    wire [WORD_WIDTH-1:0]   data_buffer_out; //the buffer's data_out

    Register //the first register data_buffer
    #(
        .WORD_WIDTH     (WORD_WIDTH),
        .RESET_VALUE    (WORD_ZERO) //the default value is 1'b0
    )
    data_buffer_reg //when the data_out is full. use this reg as a buffer
    (
        .clock          (clock),
        .clock_enable   (data_buffer_wren),
        .clear          (clear),
        .data_in        (input_data),
        .data_out       (data_buffer_out)
    );

    reg                     data_out_wren       = 1'b1; //(allow the data_in)EMPTY at start, so accept data.
    reg                     use_buffered_data   = 1'b0; //default state:we don't need to use buffer
    reg [WORD_WIDTH-1:0]    selected_data       = WORD_ZERO;

    always @(*) begin
        selected_data = (use_buffered_data == 1'b1) ? data_buffer_out : input_data; //when we need to use buffer, then use buffer.
    end

    Register //the second register data_out
    #(
        .WORD_WIDTH     (WORD_WIDTH),
        .RESET_VALUE    (WORD_ZERO)
    )
    data_out_reg
    (
        .clock          (clock),
        .clock_enable   (data_out_wren),
        .clear          (clear),
        .data_in        (selected_data),
        .data_out       (output_data)
    );
 
    localparam STATE_BITS = 2; //A FSM!
    localparam [STATE_BITS-1:0] EMPTY = 'd0; // Output and buffer registers empty
    localparam [STATE_BITS-1:0] BUSY  = 'd1; // Output register holds data
    localparam [STATE_BITS-1:0] FULL  = 'd2; // Both output and buffer registers hold data
    // There is no case where only the buffer register would hold data.

    // No handling of erroneous and unreachable state 3.
    // We could check and raise an error flag.

    wire [STATE_BITS-1:0] state;
    reg  [STATE_BITS-1:0] state_next = EMPTY;

Register
    #(
        .WORD_WIDTH     (1),
        .RESET_VALUE    (1'b1) // EMPTY at start, so accept data
    )
    input_ready_reg
    (
        .clock          (clock),
        .clock_enable   (1'b1),
        .clear          (clear),
        .data_in        (state_next != FULL),
        .data_out       (input_ready)
    );

 Register //This a rule that we can't insert data when the buffer is full
    #(
        .WORD_WIDTH     (1),
        .RESET_VALUE    (1'b0)
    )
    output_valid_reg
    (
        .clock          (clock),
        .clock_enable   (1'b1),
        .clear          (clear),
        .data_in        (state_next != EMPTY),
        .data_out       (output_valid)
    );

reg insert = 1'b0;
    reg remove = 1'b0;

    always @(*) begin
        insert = (input_valid  == 1'b1) && (input_ready  == 1'b1);
        remove = (output_valid == 1'b1) && (output_ready == 1'b1);
    end

    reg load    = 1'b0; // Empty datapath inserts data into output register.
    reg flow    = 1'b0; // New inserted data into output register as the old data is removed.
    reg fill    = 1'b0; // New inserted data into buffer register. Data not removed from output register.
    reg flush   = 1'b0; // Move data from buffer register into output register. Remove old data. No new data inserted.
    reg unload  = 1'b0; // Remove data from output register, leaving the datapath empty.

    always @(*) begin
        load    = (state == EMPTY) && (insert == 1'b1) && (remove == 1'b0);
        flow    = (state == BUSY)  && (insert == 1'b1) && (remove == 1'b1);
        fill    = (state == BUSY)  && (insert == 1'b1) && (remove == 1'b0);
        flush   = (state == FULL)  && (insert == 1'b0) && (remove == 1'b1);
        unload  = (state == BUSY)  && (insert == 1'b0) && (remove == 1'b1);
    end

always @(*) begin
        state_next = (load   == 1'b1) ? BUSY  : state;
        state_next = (flow   == 1'b1) ? BUSY  : state_next;
        state_next = (fill   == 1'b1) ? FULL  : state_next;
        state_next = (flush  == 1'b1) ? BUSY  : state_next;
        state_next = (unload == 1'b1) ? EMPTY : state_next;
    end

    Register
    #(
        .WORD_WIDTH     (STATE_BITS),
        .RESET_VALUE    (EMPTY)         // Initial state
    )
    state_reg
    (
        .clock          (clock),
        .clock_enable   (1'b1),
        .clear          (clear),
        .data_in        (state_next),
        .data_out       (state)
    );

 always @(*) begin
        data_out_wren     = (load  == 1'b1) || (flow == 1'b1) || (flush == 1'b1);
        data_buffer_wren  = (fill  == 1'b1);
        use_buffered_data = (flush == 1'b1);
    end

endmodule