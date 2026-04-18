module BottlingSystem (
    input wire clk,
    input wire reset,
    
    // Inputs from your Proteus setup
    input wire sensor,              // Count input (Tablet Sensor)
    input wire [3:0] keypad_data,   // 4-bit data from Keypad Encoder
    input wire key_pressed,         // Keypad latch signal
    
    // Outputs
    output reg valve,               // Control for the solenoid/valve
    output wire [7:0] led_count     // Binary count for LEDs (Register B)
);

    // Internal Storage (Registers)
    reg [7:0] count_val;     // Register B: Accumulates tablet count
    reg [3:0] tens_digit;    // Register A (Upper): Target tens
    reg [3:0] units_digit;   // Register A (Lower): Target units
    
    // Signal for the math conversion (BCD to Binary)
    wire [7:0] target_binary;
    
    // Helpers for pulse detection
    reg sensor_prev;
    reg key_prev;

    // TARGET SETTING (Top Path of Diagram) 
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            tens_digit <= 4'd0;
            units_digit <= 4'd0;
            key_prev <= 1'b0;
        end else begin
            // Shift digits on keypad press (Enter Tens then Units)
            if (key_pressed == 1'b1 && key_prev == 1'b0) begin
                tens_digit <= units_digit;
                units_digit <= keypad_data;
            end
            key_prev <= key_pressed;
        end
    end

    //  CODE CONVERTER (BCD to Binary) 
    assign target_binary = (tens_digit * 10) + units_digit;

    // COUNTING LOGIC (Bottom Path of Diagram)
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count_val <= 8'd0;
            sensor_prev <= 1'b0;
        end else begin
            // Pulse detection for the sensor
            if (sensor == 1'b1 && sensor_prev == 1'b0) begin
                // Accumulates into the original value continuously
                count_val <= count_val + 1; 
            end
            sensor_prev <= sensor;
        end
    end

    // OUTPUT MAPPING & COMPARATOR
    assign led_count = count_val;
    
    always @(*) begin
        // Comparator: Use exact equality (A=B).
        // Valve closes only when count matches target exactly.
        if (count_val == target_binary && target_binary > 0) begin
            valve = 1'b0; // Valve CLOSED
        end else begin
            valve = 1'b1; // Valve OPEN
        end
    end

endmodule