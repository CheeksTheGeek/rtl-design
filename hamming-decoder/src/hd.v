// This the code, expected data, and expected syndrome testbench has been created using the following python script:
/*
from typing import Tuple
def hamming_decoder_LE(code: str) -> Tuple[str, str]:
    s3 = str(int(code[8]) ^ int(code[9]) ^ int(code[10]) ^ int(code[11]) ^ int(code[7]))
    s2 = str(int(code[4]) ^ int(code[5]) ^ int(code[6]) ^ int(code[11]) ^ int(code[3]))
    s1 = str(int(code[2]) ^ int(code[5]) ^ int(code[6]) ^ int(code[9]) ^ int(code[10]) ^ int(code[1]))
    s0 = str(int(code[2]) ^ int(code[4]) ^ int(code[6]) ^ int(code[8]) ^ int(code[10]) ^ int(code[0]))
    syndrome = s0 + s1 + s2 + s3
    error_position = int(syndrome[::-1], 2)
    if error_position != 0 and error_position <= 12:
        corrected_code = list(code)
        corrected_code[error_position - 1] = str(int(corrected_code[error_position - 1]) ^ 1)
        code = ''.join(corrected_code)
    data_bits = ''.join([code[2], code[4], code[5], code[6], code[8], code[9], code[10], code[11]])
    return data_bits[::-1], syndrome[::-1]

with open("test_cases.txt", "w") as f:
    for code in range(4096):
        code_bits = [str(bit) for bit in f"{code:012b}"]
        data, syndrome = hamming_decoder_LE(''.join(code_bits))
        f.write(f"        code = 12'b{''.join(code_bits[::-1])}; exp_data = 8'b{''.join(data)}; exp_synd = 4'b{''.join(syndrome)};\n        #10;\n")
        for i in range(12):
            code_bits[i] = '1' if code_bits[i] == '0' else '0'
            data, syndrome = hamming_decoder_LE(''.join(code_bits))
            f.write(f"        code = 12'b{''.join(code_bits[::-1])}; exp_data = 8'b{''.join(data)}; exp_synd = 4'b{''.join(syndrome)};\n        #10;\n")
            code_bits[i] = '1' if code_bits[i] == '0' else '0'

*/
// And this script has been scored and debugged using
/*

import re
import sys


def parse_vvp_output(file_path):
    # Regex pattern to match each line of the output
    pattern = re.compile(
        r"\| Time: (\d+) ns \| Code: (\d{12}) \| Exp Data: (\d{8}) \| Exp. Syndrome: (\d{4}) \| Dec Data: (\d{8}) \| Syndrome: (\d{4}) \|"
    )

    results = []

    with open(file_path, "r") as file:
        for line in file:
            match = pattern.match(line)
            if match:
                time, code, exp_data, exp_synd, dec_data, synd = match.groups()
                results.append(
                    {
                        "time": int(time),
                        "code": code,
                        "exp_data": exp_data,
                        "exp_synd": exp_synd,
                        "dec_data": dec_data,
                        "synd": synd,
                    }
                )

    return results


def calculate_score(results):
    total_tests = len(results)
    correct_tests = 0

    for result in results:
        if (
            result["exp_data"] == result["dec_data"]
            and result["exp_synd"] == result["synd"]
        ):
            correct_tests += 1

    score = (correct_tests / total_tests) * 100
    return score


if len(sys.argv) != 2:
    print("Usage: python3 parse_vvp_output.py <vvp_output_file>")
    sys.exit(1)

file_path = sys.argv[1]
results = parse_vvp_output(file_path)

score = calculate_score(results)
print(f"Total Tests: {len(results)}")
print(
    f'Correct Tests: {sum(1 for r in results if r["exp_data"] == r["dec_data"] and r["exp_synd"] == r["synd"])}'
)
print(f"Score: {score:.2f}%")

# Create a file to store failed outputs
with open("failed_outputs.txt", "w") as file:
    for result in results:
        if (
            result["exp_data"] != result["dec_data"]
            or result["exp_synd"] != result["synd"]
        ):
            file.write(
                f"| Time: {result['time']} ns | Code: {result['code']} | Exp Data: {result['exp_data']} | Exp. Syndrome: {result['exp_synd']} | Dec Data: {result['dec_data']} | Syndrome: {result['synd']} |\n"
            )

*/
// END OF PYTHON CODE


`timescale 1ns / 1ps
module HD(
    input [11:0] code,
    output reg [7:0] data,
    output reg [3:0] syndrome
);
    reg [11:0] corr_code;
    reg [3:0] calc_check_bits, rec_check_bits;
    assign syndrome = {
                code[8] ^ code[9] ^ code[10] ^ code[11] ^ code[7],  
                code[4] ^ code[5] ^ code[6] ^ code[11] ^ code[3], 
                code[2] ^ code[5] ^ code[6] ^ code[9] ^ code[10] ^ code[1], 
                code[2] ^ code[4] ^ code[6] ^ code[8] ^ code[10] ^ code[0]
                };
    always @(*) begin
        corr_code = code;
        if (syndrome != 4'b0000) corr_code[syndrome-1'b1] = ~corr_code[syndrome-1'b1]; 
    end
    assign data = {corr_code[11], corr_code[10], corr_code[9], corr_code[8], corr_code[6], corr_code[5], corr_code[4], corr_code[2]};
endmodule


