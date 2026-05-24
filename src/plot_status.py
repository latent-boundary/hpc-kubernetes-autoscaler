import os
import pandas as pd
import matplotlib.pyplot as plt

# src/ の絶対パス
SRC_DIR = os.path.dirname(__file__)
BASE = os.path.dirname(SRC_DIR)

LOG = f"{BASE}/logs/pipeline_status.log"
OUT = f"{BASE}/result/pipeline_status.png"

df = pd.read_csv(
    LOG,
    names=["ts", "pending", "processing", "done", "result"]
)

df["time"] = df["ts"] - df["ts"].min()

plt.figure(figsize=(10,6))
plt.plot(df["time"], df["pending"], label="pending")
plt.plot(df["time"], df["processing"], label="processing")
plt.plot(df["time"], df["done"], label="done")
plt.plot(df["time"], df["result"], label="result")

plt.xlabel("time (s)")
plt.ylabel("count")
plt.title("Pipeline Status Over Time")
plt.legend()
plt.grid(True)
plt.tight_layout()

# HPC では show() ではなく savefig()
plt.savefig(OUT)
print(f"Saved: {OUT}")

