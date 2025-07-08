module Encrypt #(parameter nr=14,parameter nk=8)(
    input wire clk,
    input wire reset,
    input wire start,
    input wire [127:0] in,
    input wire [255:0] key,
    output reg [127:0] out,
    output reg done
);


    reg [3:0] round; //contorizam runda
    reg [1:0] current_state; 
    reg [127:0] state; //bloc de stare dupa fiecare duna
    localparam IDLE = 2'd0, INIT = 2'd1, ROUND = 2'd2, FINAL = 2'd3; 
    //IDLE asteapta start, 
    //INIT executa ARK pt prima runda,
    //ROUND parcurge rundele 1-13
    //FINAL ultima runda

 
    wire [0:(128*(nr+1))-1] expanded_keys; //chei expandate
    wire [127:0] ark_start_out; //rezultat dupa primul ark
    wire [127:0] round_out; //iesirea unei runde
    wire [127:0] final_sb_out; //iesirea SubByte din runda finala
    wire [127:0] final_sr_out;//iesirea ShiftRows din runda finala
    wire [127:0] final_out;//iesirea dupa ark din runda finala

   //legam keyexp, stocam rezultatul in expanded_keys 
    KeyExpansion #(.nk(nk), .nr(nr)) keyexp (
        .key(key),
        .wrds(expanded_keys)
    );

//legam primul ark, prima cheie si la iesire punem ark_start_out
    AddRoundKey ark_start (
        .in(in),
        .round_key(expanded_keys[0:127]),
        .out(ark_start_out)
    );

  //selectarea cheii de runda corespunzatoare 
    reg [127:0] current_round_key; 
    always @(*) begin
        case (round)
            4'd1:  current_round_key = expanded_keys[128:255];
            4'd2:  current_round_key = expanded_keys[256:383];
            4'd3:  current_round_key = expanded_keys[384:511];
            4'd4:  current_round_key = expanded_keys[512:639];
            4'd5:  current_round_key = expanded_keys[640:767];
            4'd6:  current_round_key = expanded_keys[768:895];
            4'd7:  current_round_key = expanded_keys[896:1023];
            4'd8:  current_round_key = expanded_keys[1024:1151];
            4'd9:  current_round_key = expanded_keys[1152:1279];
            4'd10: current_round_key = expanded_keys[1280:1407];
            4'd11: current_round_key = expanded_keys[1408:1535];
            4'd12: current_round_key = expanded_keys[1536:1663];
            4'd13: current_round_key = expanded_keys[1664:1791];
            default: current_round_key = 128'd0;
        endcase
    end
//runda de criptare, intrarea e blocul de stare, cheia o alegi de mai sus, round_out la iesire.
    RoundEncrypt round_enc (
        .in(state),
        .key(current_round_key),
        .out(round_out)
    );
//subbyte din ultima runda, legam state cu fin_sb_out la iesire 
    SubByte sub_bytes (
        .in(state),
        .out(final_sb_out)
    );
//shiftrows din ultima runda,legal iesirea lui sb la in, iesire fin_sr_out
    ShiftRows shift_rows (
        .in(final_sb_out),
        .out(final_sr_out)
    );
//arm din ultima runda, iesirea lui sr la in, ultima cheie la rk si fin_out la iesire.
    AddRoundKey ark_final (
        .in(final_sr_out),
        .round_key(expanded_keys[1792:1919]),
        .out(final_out)
    );

 //FSM
    always @(posedge clk or posedge reset) begin
        if (reset) begin //resetam la 0 toate valorile daca se apasa reset.
            current_state <= IDLE;
            done <= 1'b0;
            round <= 4'd0;
            state <= 128'd0;
            out  <= 128'd0;
        end else begin
            case (current_state)
                IDLE: begin //ramane in starea IDLE pana cand se apasa comanda start
                    done <= 1'b0; //automat, nu e gata
                    if (start) begin //apasa start, incepe initializarea
                        
                        current_state <= INIT; //initializeazxa criptarea 
                        round <= 4'd0;//aratam ca suntem la prima runda
                    end
                end

                INIT: begin //prima runda, aplica ark si memoreaza in state.
                    state <= ark_start_out;
                    round <= 4'd1; //pregatim urmatoarea runda
                    current_state <= ROUND;//intram in rundele de criptare
                end

                ROUND: begin //incepe RoundEncrypt
                    state <= round_out;
                    if (round == 4'd13) begin
                        current_state <= FINAL; //transfer la runda finala
                    end else begin //altfel se continua contorizarea 
                        round <= round + 1'b1;
                        //ramane in starea ROUND pentru urmatoarea runda
                        current_state <= ROUND; //ramanem la faza de runda de criptare
                    end
                end

                FINAL: begin //incepe runda finala
                    // Runda 14: SubByte, ShiftRows, AddRoundKey 
                    state <= final_out;
                    out   <= final_out; //rezultat final
                    done  <= 1'b1; //semn ca e gata
                    // Revine la IDLE
                    current_state <= IDLE; //inchidem algoritmul
                end
            endcase
        end
    end

endmodule
