# train.py
import numpy as np
import os

def main(indir, outdir):
    os.makedirs(outdir, exist_ok=True)
    data = np.loadtxt(f"{indir}/input.txt")
    result = data * 2
    np.savetxt(f"{outdir}/result.txt", result)
    print("Train done:", outdir)

if __name__ == "__main__":
    import sys
    main(sys.argv[1], sys.argv[2])

