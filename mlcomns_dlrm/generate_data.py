
import os
import argparse
import pathlib
import numpy as np


CATEGORY_RANGES = [10000000,    38985,    17278,     7418,    20242,        3,
           7120,     1543,       63,  9999978,  2642264,   397262,
             10,     2208,    11931,      155,        4,      976,
             14, 10000000,  9832963, 10000000,   573162,    12969,
            108,       36]


def generate_data_dlrm_bin(output_path, desired_size): 
    total_size = 0
    while total_size < desired_size: 
        fn = f"{output_path}/terabyte_processed_train.bin"
        with open(fn, 'ab') as output_file:
            num_instance = 6548660
            X_int = np.random.randint(2557264, size = (num_instance, 13))
            X_cat = np.random.randint(0, CATEGORY_RANGES, size = (num_instance, 26))
            y = np.random.randint(2, size=num_instance)
            np_data = np.concatenate([y.reshape(-1, 1), X_int, X_cat], axis=1)
            np_data = np_data.astype(np.int32)
            output_file.write(np_data.tobytes())
            output_file.flush()
        total_size = os.path.getsize(fn)
        print("current size", total_size)


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--output_path", dest="output_path", type=pathlib.Path)
    parser.add_argument("--desired_size", dest="desired_size", type=float)
    args = parser.parse_args()

    if args.desired_size < 0:
        print("ERROR: Desired size cannot be negative!")
        exit(-1)

    pathlib.Path(args.output_path).mkdir(exist_ok=True, parents=True)

    generate_data_dlrm_bin(args.output_path, args.desired_size)