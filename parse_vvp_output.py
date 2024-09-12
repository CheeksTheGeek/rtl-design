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
