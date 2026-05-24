# preprocess.py
import os
import numpy as np

def main(outdir):
    os.makedirs(outdir, exist_ok=True)
    data = np.linspace(0, 1, 100)
    np.savetxt(f"{outdir}/input.txt", data)
    print("Preprocess done:", outdir)

if __name__ == "__main__":
    import sys
    main(sys.argv[1])

