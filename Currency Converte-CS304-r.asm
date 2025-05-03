# Currency Converter in MIPS Assembly for MARS 4.5
# Using BAM (Bosnian Mark) as base currency
# Using numeric codes for currencies: BAM=1, USD=2, EUR=3, CHF=4, AUD=5, GBP=6, TRY=7, BTC=8

.data
    one_float: .float 1.0
    zero_float: .float 0.0
    # Program title and menu options
    welcome:        .asciiz "\n\n===== Currency Converter (BAM Base) =====\n\n"
    menu:           .asciiz "\nOptions:\n1. Convert currency\n2. View exchange rates\n3. Add/Update exchange rate\n4. Currency prediction\n5. Exit\n"
    prompt:         .asciiz "\nEnter your choice (1-5): "
    continue_msg:   .asciiz "\nPress Enter to continue..."
    goodbye:        .asciiz "\nThank you for using the Currency Converter. Goodbye!\n"
    invalid_choice: .asciiz "\nInvalid choice. Please try again.\n"
    
    # Enhanced loading animation with inline progress bars
    loading_banner: .asciiz "\n************************************************\n*        CURRENCY EXCHANGE SYSTEM v2.0           *\n*              INITIALIZING...                   *\n************************************************\n\n"
    loading_module1: .asciiz "Loading core system modules... "
    loading_module2: .asciiz "Loading currency database... "
    loading_module3: .asciiz "Initializing exchange rate algorithms... "
    loading_module4: .asciiz "Connecting to prediction modules... "
    
    # Inline progress bars (no newlines)
    progress_bar1:   .asciiz "          [                    ] 0%"
    progress_bar2:   .asciiz "            [=====               ] 25%"
    progress_bar3:   .asciiz "[==========          ] 50%"
    progress_bar4:   .asciiz "     [===============     ] 75%"
    progress_bar5:   .asciiz "[====================] 100%"
    progress_complete: .asciiz "\nLoading successful! Starting the program...\n\n\n"
    
    loading_success: .asciiz "\nThank you for waiting ! \n"
    
    # Available currencies message
    available_curr: .asciiz "\nAvailable currencies:\n1=BAM, 2=USD, 3=EUR, 4=CHF, 5=AUD, 6=GBP, 7=TRY, 8=BTC\n"
    
    # Conversion prompts
    from_prompt:    .asciiz "From currency (enter number 1-8): "
    to_prompt:      .asciiz "To currency (enter number 1-8): "
    amount_prompt:  .asciiz "Enter amount: "
    result_msg1:    .asciiz "\n"
    result_msg2:    .asciiz " "
    result_msg3:    .asciiz " = "
    result_msg4:    .asciiz " "
    newline:        .asciiz "\n"
    
    # Exchange rate display
    rates_header:   .asciiz "\n===== Exchange Rates (relative to 1 BAM) =====\n"
    rate_msg1:      .asciiz "1 BAM = "
    rate_msg2:      .asciiz " "
    rate_msg3:      .asciiz " | 1 "
    rate_msg4:      .asciiz " = "
    rate_msg5:      .asciiz " BAM\n"
    
    # Add/Update rate prompts
    code_prompt:    .asciiz "Enter currency number (1-8): "
    rate_prompt1:   .asciiz "Enter exchange rate (1 BAM to "
    rate_prompt2:   .asciiz "): "
    updated_msg1:   .asciiz "Updated: "
    updated_msg2:   .asciiz " rate changed from "
    updated_msg3:   .asciiz " to "
    added_msg1:     .asciiz "Added new currency: "
    added_msg2:     .asciiz " with rate "
    error_rate:     .asciiz "\nError: Rate must be positive\n"
    
    # Error messages
    error_curr:     .asciiz "\nError: Invalid currency number. Please enter a value between 1 and 8.\n"
    error_amount:   .asciiz "\nError: Please enter a valid number\n"
    
    # Currency prediction messages
    pred_header:    .asciiz "\n===== Currency Prediction =====\n"
    pred_prompt:    .asciiz "Which currency would you like to predict (enter number 1-8): "
    pred_time:      .asciiz "Prediction timeframe (1=1 week, 2=1 month, 3=3 months): "
    pred_result1:   .asciiz "\nCurrency: "
    pred_result2:   .asciiz "\nPrediction period: "
    pred_time1:     .asciiz "1 week"
    pred_time2:     .asciiz "1 month"
    pred_time3:     .asciiz "3 months"
    pred_trend_up:  .asciiz "\nTrend: RISING by "
    pred_trend_down: .asciiz "\nTrend: FALLING by "
    pred_trend_neutral: .asciiz "\nTrend: STABLE "
    pred_percent:   .asciiz "%"
    pred_from:      .asciiz "\nCurrent rate: "
    pred_to:        .asciiz "\nPredicted rate: "
    pred_meaning_up: .asciiz "\nMeaning: The value will increase, so holding this currency is beneficial."
    pred_meaning_down: .asciiz "\nMeaning: The value will decrease, consider converting to a more stable currency."
    pred_meaning_neutral: .asciiz "\nMeaning: No significant change expected, the currency is stable."
    pred_divider:   .asciiz "\n--------------------------------------------------\n"
    
    # Currency names/codes
    curr_name_1:    .asciiz "BAM"
    curr_name_2:    .asciiz "USD"
    curr_name_3:    .asciiz "EUR"
    curr_name_4:    .asciiz "CHF"
    curr_name_5:    .asciiz "AUD"
    curr_name_6:    .asciiz "GBP" 
    curr_name_7:    .asciiz "TRY"
    curr_name_8:    .asciiz "BTC"
    
    # Array of pointers to currency names
    currencies:     .word curr_name_1, curr_name_2, curr_name_3, curr_name_4, curr_name_5, curr_name_6, curr_name_7, curr_name_8
    
    # Exchange rates (relative to BAM)
    rates:          .float 1.0, 0.56, 0.51, 0.49, 0.85, 0.44, 18.17, 0.0000089
    
    # Prediction trends (% change - positive means value will increase)
    pred_week:      .float 0.0, 0.5, -0.2, 0.3, 1.2, -0.4, 2.5, 5.0
    pred_month:     .float 0.0, 1.2, -0.7, 0.9, 2.5, -1.0, 5.7, 12.0
    pred_quarter:   .float 0.0, 2.5, -1.5, 1.7, 4.2, -2.3, 10.5, 20.0
    
    # Number of currencies
    num_currencies: .word 8
    
    # Input buffers
    input_buffer:   .space 100  # General input buffer
    
.text
.globl main

main:
    # Start with loading animation
    jal loading_animation
    
    # Display welcome message
    li $v0, 4
    la $a0, welcome
    syscall
    
main_loop:
    # Display menu
    li $v0, 4
    la $a0, menu
    syscall
    
    # Prompt for user choice
    li $v0, 4
    la $a0, prompt
    syscall
    
    # Read choice
    li $v0, 5
    syscall
    move $t0, $v0  # Store choice in $t0
    
    # Branch based on choice
    beq $t0, 1, convert_currency
    beq $t0, 2, view_rates
    beq $t0, 3, add_update_rate
    beq $t0, 4, predict_currency
    beq $t0, 5, exit_program
    
    # Invalid choice
    li $v0, 4
    la $a0, invalid_choice
    syscall
    j continue_prompt

# Improved loading animation with inline progress bars
loading_animation:
    # Save return address
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    # Display loading banner
    li $v0, 4
    la $a0, loading_banner
    syscall
    
    # Display loading module 1 message
    li $v0, 4
    la $a0, loading_module1
    syscall
    
    # Display initial loading bar (same line)
    li $v0, 4
    la $a0, progress_bar1
    syscall
    
    # Print a newline for next stage
    li $v0, 4
    la $a0, newline
    syscall
    
    # Delay for visual effect (approximately 0.6 seconds)
    li $t3, 0
    li $t4, 18000000  # Delay duration
delay1:
    addi $t3, $t3, 1
    bne $t3, $t4, delay1
    
    # Display loading module 2 message
    li $v0, 4
    la $a0, loading_module2
    syscall
    
    # Display progress 25% (same line)
    li $v0, 4
    la $a0, progress_bar2
    syscall
    
    # Print a newline for next stage
    li $v0, 4
    la $a0, newline
    syscall
    
    # Delay for visual effect (approximately 0.6 seconds)
    li $t3, 0
    li $t4, 18000000  # Delay duration
delay2:
    addi $t3, $t3, 1
    bne $t3, $t4, delay2
    
    # Display loading module 3 message
    li $v0, 4
    la $a0, loading_module3
    syscall
    
    # Display progress 50% (same line)
    li $v0, 4
    la $a0, progress_bar3
    syscall
    
    # Print a newline for next stage
    li $v0, 4
    la $a0, newline
    syscall
    
    # Delay for visual effect (approximately 0.6 seconds)
    li $t3, 0
    li $t4, 18000000  # Delay duration
delay3:
    addi $t3, $t3, 1
    bne $t3, $t4, delay3
    
    # Display loading module 4 message
    li $v0, 4
    la $a0, loading_module4
    syscall
    
    # Display progress 75% (same line)
    li $v0, 4
    la $a0, progress_bar4
    syscall
    
    # Print a newline for next stage
    li $v0, 4
    la $a0, newline
    syscall
    
    # Delay for visual effect (approximately 0.6 seconds)
    li $t3, 0
    li $t4, 18000000  # Delay duration
delay4:
    addi $t3, $t3, 1
    bne $t3, $t4, delay4
    
    # Display progress 100% message (with newline already included)
    li $v0, 4
    la $a0, progress_complete
    syscall
    
    # Delay for a moment after reaching 100%
    li $t3, 0
    li $t4, 12000000  # Slightly shorter delay
delay_complete:
    addi $t3, $t3, 1
    bne $t3, $t4, delay_complete
    
    # Display loading successful message
    li $v0, 4
    la $a0, loading_success
    syscall
    
    # Return
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

convert_currency:
    # Show available currencies
    li $v0, 4
    la $a0, available_curr
    syscall
    
get_from_currency:
    # Get source currency
    li $v0, 4
    la $a0, from_prompt
    syscall
    
    # Read source currency number
    li $v0, 5
    syscall
    move $t1, $v0  # Store source currency number in $t1
    
    # Validate currency number (1-8)
    li $t9, 1
    blt $t1, $t9, from_currency_error
    lw $t9, num_currencies
    bgt $t1, $t9, from_currency_error
    
    # Adjust to 0-based index
    addi $t1, $t1, -1
    
get_to_currency:
    # Get target currency
    li $v0, 4
    la $a0, to_prompt
    syscall
    
    # Read target currency number
    li $v0, 5
    syscall
    move $t2, $v0  # Store target currency number in $t2
    
    # Validate currency number (1-8)
    li $t9, 1
    blt $t2, $t9, to_currency_error
    lw $t9, num_currencies
    bgt $t2, $t9, to_currency_error
    
    # Adjust to 0-based index
    addi $t2, $t2, -1
    
get_amount:
    # Get amount to convert
    li $v0, 4
    la $a0, amount_prompt
    syscall
    
    # Read amount as float
    li $v0, 6
    syscall
    mov.s $f1, $f0  # Store amount in $f1
    
    # Check if amount is positive
    l.s $f2, zero_float 
    c.le.s $f1, $f2
    bc1t amount_error
    
    # Get source currency rate
    la $t3, rates
    sll $t4, $t1, 2  # Multiply index by 4 for byte offset
    add $t3, $t3, $t4
    l.s $f2, ($t3)   # Load source rate into $f2
    
    # Get target currency rate
    la $t3, rates
    sll $t4, $t2, 2  # Multiply index by 4 for byte offset
    add $t3, $t3, $t4
    l.s $f3, ($t3)   # Load target rate into $f3
    
    # Perform conversion: amount * target_rate / source_rate
    div.s $f4, $f3, $f2  # Target rate / source rate
    mul.s $f5, $f1, $f4  # Amount * conversion factor
    
    # Display result
    li $v0, 4
    la $a0, result_msg1
    syscall
    
    # Display amount
    li $v0, 2
    mov.s $f12, $f1
    syscall
    
    # Display source currency
    li $v0, 4
    la $a0, result_msg2
    syscall
    
    # Get source currency string address
    la $t3, currencies
    sll $t4, $t1, 2
    add $t3, $t3, $t4
    lw $a0, ($t3)
    
    # Print source currency code
    li $v0, 4
    syscall
    
    # Display equals sign
    li $v0, 4
    la $a0, result_msg3
    syscall
    
    # Display result amount
    li $v0, 2
    mov.s $f12, $f5
    syscall
    
    # Display target currency
    li $v0, 4
    la $a0, result_msg4
    syscall
    
    # Get target currency string address
    la $t3, currencies
    sll $t4, $t2, 2
    add $t3, $t3, $t4
    lw $a0, ($t3)
    
    # Print target currency code
    li $v0, 4
    syscall
    
    # Print newline
    li $v0, 4
    la $a0, newline
    syscall
    
    j continue_prompt
    
amount_error:
    # Display amount error
    li $v0, 4
    la $a0, error_amount
    syscall
    j get_amount
    
from_currency_error:
    # Display currency not found error
    li $v0, 4
    la $a0, error_curr
    syscall
    j get_from_currency
    
to_currency_error:
    # Display currency not found error
    li $v0, 4
    la $a0, error_curr
    syscall
    j get_to_currency
    
view_rates:
    # Display rates header
    li $v0, 4
    la $a0, rates_header
    syscall
    
    # Initialize loop counter
    li $t0, 0
    lw $t1, num_currencies
    
rates_loop:
    # Check if we've displayed all currencies
    beq $t0, $t1, continue_prompt
    
    # Skip BAM (index 0)
    beqz $t0, rates_loop_increment
    
    # Display "1 BAM = "
    li $v0, 4
    la $a0, rate_msg1
    syscall
    
    # Get and display exchange rate
    la $t2, rates
    sll $t3, $t0, 2  # Multiply index by 4 for byte offset
    add $t2, $t2, $t3
    l.s $f12, ($t2)  # Load rate into $f12
    li $v0, 2        # Print float
    syscall
    
    # Display " "
    li $v0, 4
    la $a0, rate_msg2
    syscall
    
    # Get and display currency code
    la $t2, currencies
    sll $t3, $t0, 2
    add $t2, $t2, $t3
    lw $a0, ($t2)
    li $v0, 4
    syscall
    
    # Display " | 1 "
    li $v0, 4
    la $a0, rate_msg3
    syscall
    
    # Get and display currency code again
    la $t2, currencies
    sll $t3, $t0, 2
    add $t2, $t2, $t3
    lw $a0, ($t2)
    li $v0, 4
    syscall
    
    # Display " = "
    li $v0, 4
    la $a0, rate_msg4
    syscall
    
    # Calculate and display inverse rate (1/rate)
    la $t2, rates
    sll $t3, $t0, 2  # Multiply index by 4 for byte offset
    add $t2, $t2, $t3
    l.s $f1, ($t2)   # Load rate into $f1
    
    l.s $f2, one_float   # Load 1.0
    div.s $f12, $f2, $f1  # Calculate 1/rate
    li $v0, 2        # Print float
    syscall
    
    # Display " BAM\n"
    li $v0, 4
    la $a0, rate_msg5
    syscall
    
rates_loop_increment:
    # Increment counter and continue loop
    addi $t0, $t0, 1
    j rates_loop
    
add_update_rate:
    # Show available currencies
    li $v0, 4
    la $a0, available_curr
    syscall
    
get_currency_code:
    # Get currency number
    li $v0, 4
    la $a0, code_prompt
    syscall
    
    # Read currency number
    li $v0, 5
    syscall
    move $t1, $v0  # Store currency number in $t1
    
    # Validate currency number (1-8)
    li $t9, 1
    blt $t1, $t9, currency_code_error
    lw $t9, num_currencies
    bgt $t1, $t9, currency_code_error
    
    # Adjust to 0-based index
    addi $t1, $t1, -1
    
get_exchange_rate:
    # Display rate prompt
    li $v0, 4
    la $a0, rate_prompt1
    syscall
    
    # Get and display currency code
    la $t2, currencies
    sll $t3, $t1, 2
    add $t2, $t2, $t3
    lw $a0, ($t2)
    li $v0, 4
    syscall
    
    li $v0, 4
    la $a0, rate_prompt2
    syscall
    
    # Read rate as float
    li $v0, 6
    syscall
    mov.s $f1, $f0  # Store rate in $f1
    
    # Check if rate is positive
    l.s $f2, zero_float 
    c.le.s $f1, $f2
    bc1t rate_error
    
    # Update existing currency rate
    # Display update message
    li $v0, 4
    la $a0, updated_msg1
    syscall
    
    # Get and display currency code
    la $t2, currencies
    sll $t3, $t1, 2
    add $t2, $t2, $t3
    lw $a0, ($t2)
    li $v0, 4
    syscall
    
    li $v0, 4
    la $a0, updated_msg2
    syscall
    
    # Get old rate
    la $t2, rates
    sll $t3, $t1, 2  # Multiply index by 4 for byte offset
    add $t2, $t2, $t3
    l.s $f12, ($t2)  # Load old rate into $f12
    li $v0, 2        # Print float
    syscall
    
    li $v0, 4
    la $a0, updated_msg3
    syscall
    
    li $v0, 2
    mov.s $f12, $f1  # Print new rate
    syscall
    
    # Update rate in array
    la $t2, rates
    sll $t3, $t1, 2  # Multiply index by 4 for byte offset
    add $t2, $t2, $t3
    s.s $f1, ($t2)   # Store new rate
    
    # Print newline
    li $v0, 4
    la $a0, newline
    syscall
    
    j continue_prompt
    
currency_code_error:
    # Display currency invalid error
    li $v0, 4
    la $a0, error_curr
    syscall
    j get_currency_code
    
rate_error:
    # Display rate error
    li $v0, 4
    la $a0, error_rate
    syscall
    j get_exchange_rate
    
predict_currency:
    # Display prediction header
    li $v0, 4
    la $a0, pred_header
    syscall
    
    # Show available currencies
    li $v0, 4
    la $a0, available_curr
    syscall
    
get_predict_currency:
    # Get currency to predict
    li $v0, 4
    la $a0, pred_prompt
    syscall
    
    # Read currency number
    li $v0, 5
    syscall
    move $t1, $v0  # Store currency number in $t1
    
    # Validate currency number (1-8)
    li $t9, 1
    blt $t1, $t9, pred_currency_error
    lw $t9, num_currencies
    bgt $t1, $t9, pred_currency_error
    
    # Adjust to 0-based index
    addi $t1, $t1, -1
    
get_timeframe:
    # Get timeframe
    li $v0, 4
    la $a0, pred_time
    syscall
    
    # Read timeframe
    li $v0, 5
    syscall
    move $t2, $v0  # Store timeframe option in $t2
    
    # Validate timeframe
    li $t3, 1
    blt $t2, $t3, invalid_timeframe
    li $t3, 3
    bgt $t2, $t3, invalid_timeframe
    
    # Get current rate for the currency
    la $t3, rates
    sll $t4, $t1, 2  # Multiply index by 4 for byte offset
    add $t3, $t3, $t4
    l.s $f1, ($t3)   # Load current rate into $f1
    
    # Determine which prediction array to use
    beq $t2, 1, use_week_pred
    beq $t2, 2, use_month_pred
    beq $t2, 3, use_quarter_pred
    j continue_prompt  # Shouldn't get here
    
pred_currency_error:
    # Display currency not found error
    li $v0, 4
    la $a0, error_curr
    syscall
    j get_predict_currency
    
invalid_timeframe:
    # Display invalid timeframe error
    li $v0, 4
    la $a0, invalid_choice
    syscall
    j get_timeframe
    
use_week_pred:
    # Get weekly prediction percentage
    la $t3, pred_week
    sll $t4, $t1, 2
    add $t3, $t3, $t4
    l.s $f2, ($t3)   # Load prediction % into $f2
    
    # Calculate predicted rate: current_rate * (1 + prediction/100)
    l.s $f3, one_float  # Load 1.0
    li $t5, 100
    mtc1 $t5, $f4
    cvt.s.w $f4, $f4  # Convert 100 to float
    div.s $f5, $f2, $f4  # prediction/100
    add.s $f6, $f3, $f5  # 1 + prediction/100
    mul.s $f7, $f1, $f6  # current_rate * (1 + prediction/100)
    
    # Display prediction result - starting with divider
    li $v0, 4
    la $a0, pred_divider
    syscall
    
    # Display "Currency: "
    li $v0, 4
    la $a0, pred_result1
    syscall
    
    # Get and display currency code
    la $t3, currencies
    sll $t4, $t1, 2
    add $t3, $t3, $t4
    lw $a0, ($t3)
    li $v0, 4
    syscall
    
    # Display prediction timeframe
    li $v0, 4
    la $a0, pred_result2
    syscall
    
    li $v0, 4
    la $a0, pred_time1
    syscall
    
    # Display current rate
    li $v0, 4
    la $a0, pred_from
    syscall
    
    li $v0, 2
    mov.s $f12, $f1  # Print current rate
    syscall
    
    # Display predicted rate
    li $v0, 4
    la $a0, pred_to
    syscall
    
    li $v0, 2
    mov.s $f12, $f7  # Print predicted rate
    syscall
    
    # Display trend direction and percentage
    l.s $f9, zero_float
    c.eq.s $f2, $f9
    bc1t pred_show_neutral
    c.lt.s $f2, $f9
    bc1t pred_show_down
    
    # Show rising trend
    li $v0, 4
    la $a0, pred_trend_up
    syscall
    
    # Display percentage (absolute value)
    li $v0, 2
    mov.s $f12, $f2  # Print percentage
    syscall
    
    li $v0, 4
    la $a0, pred_percent
    syscall
    
    # Display meaning
    li $v0, 4
    la $a0, pred_meaning_up
    syscall
    
    j pred_complete
    
pred_show_down:
    # Show falling trend
    li $v0, 4
    la $a0, pred_trend_down
    syscall
    
    # Display percentage (absolute value)
    li $v0, 2
    abs.s $f12, $f2  # Take absolute value of percentage
    syscall
    
    li $v0, 4
    la $a0, pred_percent
    syscall
    
    # Display meaning
    li $v0, 4
    la $a0, pred_meaning_down
    syscall
    
    j pred_complete
    
pred_show_neutral:
    # Show neutral trend
    li $v0, 4
    la $a0, pred_trend_neutral
    syscall
    
    # Display meaning
    li $v0, 4
    la $a0, pred_meaning_neutral
    syscall
    
    j pred_complete
    
pred_complete:
    # Display ending divider
    li $v0, 4
    la $a0, pred_divider
    syscall
    
    j continue_prompt
    
use_month_pred:
    # Get monthly prediction percentage
    la $t3, pred_month
    sll $t4, $t1, 2
    add $t3, $t3, $t4
    l.s $f2, ($t3)   # Load prediction % into $f2
    
    # Calculate predicted rate: current_rate * (1 + prediction/100)
    l.s $f3, one_float  # Load 1.0
    li $t5, 100
    mtc1 $t5, $f4
    cvt.s.w $f4, $f4  # Convert 100 to float
    div.s $f5, $f2, $f4  # prediction/100
    add.s $f6, $f3, $f5  # 1 + prediction/100
    mul.s $f7, $f1, $f6  # current_rate * (1 + prediction/100)
    
    # Display prediction result - starting with divider
    li $v0, 4
    la $a0, pred_divider
    syscall
    
    # Display "Currency: "
    li $v0, 4
    la $a0, pred_result1
    syscall
    
    # Get and display currency code
    la $t3, currencies
    sll $t4, $t1, 2
    add $t3, $t3, $t4
    lw $a0, ($t3)
    li $v0, 4
    syscall
    
    # Display prediction timeframe
    li $v0, 4
    la $a0, pred_result2
    syscall
    
    li $v0, 4
    la $a0, pred_time2  # Use month timeframe
    syscall
    
    # Display current rate
    li $v0, 4
    la $a0, pred_from
    syscall
    
    li $v0, 2
    mov.s $f12, $f1  # Print current rate
    syscall
    
    # Display predicted rate
    li $v0, 4
    la $a0, pred_to
    syscall
    
    li $v0, 2
    mov.s $f12, $f7  # Print predicted rate
    syscall
    
    # Display trend direction and percentage
    l.s $f9, zero_float
    c.eq.s $f2, $f9
    bc1t pred_show_neutral_month
    c.lt.s $f2, $f9
    bc1t pred_show_down_month
    
    # Show rising trend
    li $v0, 4
    la $a0, pred_trend_up
    syscall
    
    # Display percentage (absolute value)
    li $v0, 2
    mov.s $f12, $f2  # Print percentage
    syscall
    
    li $v0, 4
    la $a0, pred_percent
    syscall
    
    # Display meaning
    li $v0, 4
    la $a0, pred_meaning_up
    syscall
    
    j pred_complete
    
pred_show_down_month:
    # Show falling trend
    li $v0, 4
    la $a0, pred_trend_down
    syscall
    
    # Display percentage (absolute value)
    li $v0, 2
    abs.s $f12, $f2  # Take absolute value of percentage
    syscall
    
    li $v0, 4
    la $a0, pred_percent
    syscall
    
    # Display meaning
    li $v0, 4
    la $a0, pred_meaning_down
    syscall
    
    j pred_complete
    
pred_show_neutral_month:
    # Show neutral trend
    li $v0, 4
    la $a0, pred_trend_neutral
    syscall
    
    # Display meaning
    li $v0, 4
    la $a0, pred_meaning_neutral
    syscall
    
    j pred_complete

use_quarter_pred:
    # Get quarterly prediction percentage
    la $t3, pred_quarter
    sll $t4, $t1, 2
    add $t3, $t3, $t4
    l.s $f2, ($t3)   # Load prediction % into $f2
    
    # Calculate predicted rate: current_rate * (1 + prediction/100)
    l.s $f3, one_float  # Load 1.0
    li $t5, 100
    mtc1 $t5, $f4
    cvt.s.w $f4, $f4  # Convert 100 to float
    div.s $f5, $f2, $f4  # prediction/100
    add.s $f6, $f3, $f5  # 1 + prediction/100
    mul.s $f7, $f1, $f6  # current_rate * (1 + prediction/100)
    
    # Display prediction result - starting with divider
    li $v0, 4
    la $a0, pred_divider
    syscall
    
    # Display "Currency: "
    li $v0, 4
    la $a0, pred_result1
    syscall
    
    # Get and display currency code
    la $t3, currencies
    sll $t4, $t1, 2
    add $t3, $t3, $t4
    lw $a0, ($t3)
    li $v0, 4
    syscall
    
    # Display prediction timeframe
    li $v0, 4
    la $a0, pred_result2
    syscall
    
    li $v0, 4
    la $a0, pred_time3  # Use quarter timeframe
    syscall
    
    # Display current rate
    li $v0, 4
    la $a0, pred_from
    syscall
    
    li $v0, 2
    mov.s $f12, $f1  # Print current rate
    syscall
    
    # Display predicted rate
    li $v0, 4
    la $a0, pred_to
    syscall
    
    li $v0, 2
    mov.s $f12, $f7  # Print predicted rate
    syscall
    
    # Display trend direction and percentage
    l.s $f9, zero_float
    c.eq.s $f2, $f9
    bc1t pred_show_neutral_quarter
    c.lt.s $f2, $f9
    bc1t pred_show_down_quarter
    
    # Show rising trend
    li $v0, 4
    la $a0, pred_trend_up
    syscall
    
    # Display percentage (absolute value)
    li $v0, 2
    mov.s $f12, $f2  # Print percentage
    syscall
    
    li $v0, 4
    la $a0, pred_percent
    syscall
    
    # Display meaning
    li $v0, 4
    la $a0, pred_meaning_up
    syscall
    
    j pred_complete
    
pred_show_down_quarter:
    # Show falling trend
    li $v0, 4
    la $a0, pred_trend_down
    syscall
    
    # Display percentage (absolute value)
    li $v0, 2
    abs.s $f12, $f2  # Take absolute value of percentage
    syscall
    
    li $v0, 4
    la $a0, pred_percent
    syscall
    
    # Display meaning
    li $v0, 4
    la $a0, pred_meaning_down
    syscall
    
    j pred_complete
    
pred_show_neutral_quarter:
    # Show neutral trend
    li $v0, 4
    la $a0, pred_trend_neutral
    syscall
    
    # Display meaning
    li $v0, 4
    la $a0, pred_meaning_neutral
    syscall
    
    j pred_complete

continue_prompt:
    # Display continue message
    li $v0, 4
    la $a0, continue_msg
    syscall
    
    # Read a character to continue
    li $v0, 8
    la $a0, input_buffer
    li $a1, 100  # Buffer size
    syscall
    
    # Jump back to main menu
    j main_loop
    
exit_program:
    # Display goodbye message
    li $v0, 4
    la $a0, goodbye
    syscall
    
    # Exit program
    li $v0, 10
    syscall
    
# Validate currency number (1-8)
li $t9, 1
blt $t1, $t9, from_currency_error   # If less than 1 → error
lw $t9, num_currencies
bgt $t1, $t9, from_currency_error   # If greater than max → error


