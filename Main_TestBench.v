`timescale 1ns / 1ps

module tb_bottling_system();

    // ---------------------------------------------------------
    // 1. Signal Declarations
    // ---------------------------------------------------------
    reg clk;
    reg reset;
    reg sensor;
    reg [3:0] keypad_data;
    reg key_pressed;

    wire valve;
    wire [7:0] led_count;
    wire [7:0] target_display;

    // ---------------------------------------------------------
    // 2. Unit Under Test (UUT) Instance
    // ---------------------------------------------------------
    BottlingSystem uut (
        .clk(clk),
        .reset(reset),
        .sensor(sensor),
        .keypad_data(keypad_data),
        .key_pressed(key_pressed),
        .valve(valve),
        .led_count(led_count),
        .target_display(target_display)
    );

    // ---------------------------------------------------------
    // 3. Clock Generation (100MHz / 10ns period)
    // ---------------------------------------------------------
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // ---------------------------------------------------------
    // 4. Test Stimulus
    // ---------------------------------------------------------
    initial begin
        // Initialize Inputs
        reset = 1;
        sensor = 0;
        keypad_data = 0;
        key_pressed = 0;

        // System Reset
        #20 reset = 0;
        #20;

        // --- Action 1: Set Target to 03 ---
        $display("--- Step 1: Entering Target '03' ---");
        
        // Enter '0' (Tens)
        keypad_data = 4'd0;
        key_pressed = 1;
        #10;
        key_pressed = 0;
        #20;

        // Enter '3' (Units)
        keypad_data = 4'd3;
        key_pressed = 1;
        #10;
        key_pressed = 0;
        #20;

        $display("Target Set: %h BCD", target_display);

        // --- Action 2: Simulate Tablets Falling ---
        $display("--- Step 2: Simulating Tablet Sensor Pulses ---");
        
        // Tablet 1
        #10 sensor = 1; #10 sensor = 0;
        $display("Tablet 1 passed. Current count: %d", led_count);
        
        // Tablet 2
        #20 sensor = 1; #10 sensor = 0;
        $display("Tablet 2 passed. Current count: %d", led_count);
        
        // Tablet 3 (Target Reached)
        #20 sensor = 1; #10 sensor = 0;
        #5; // Wait for comparator
        $display("Tablet 3 passed. Final count: %d | Valve: %b (Should be 0)", led_count, valve);

        // Tablet 4 (Continuing past target as per requested logic)
        #20 sensor = 1; #10 sensor = 0;
        #5; // Wait for comparator
        $display("Tablet 4 passed. Current count: %d | Valve: %b (Should be 1)", led_count, valve);

        // --- Action 3: Verify Result ---
        #50;
        if (led_count == 4) begin
            $display("--- TEST PASSED: Accumulator continued to 4. ---");
        end else begin
            $display("--- TEST FAILED: Accumulator did not track pulse 4. ---");
        end

        // End Simulation
        #100;
        $finish;
    end

    // Monitor for the console output
    initial begin
        $monitor("Time=%0tns | Target=%h | Count=%d | Valve=%b", 
                 $time, target_display, led_count, valve);
    end

endmodule