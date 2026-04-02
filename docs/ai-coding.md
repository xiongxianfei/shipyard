# AI Coding Environment

## Tools

| Tool | Purpose |
|------|---------|
| Python 3.12 | Runtime |
| PyTorch (CPU) | Deep learning framework |
| torchvision, torchaudio | PyTorch ecosystem |
| transformers | Hugging Face — LLMs, NLP models |
| datasets, accelerate | Hugging Face — data and training |
| numpy, pandas, scipy | Scientific computing |
| scikit-learn | Classical ML |
| matplotlib, seaborn | Visualization |
| Jupyter Notebook + Lab | Interactive notebooks (port 8888) |

## Quick start

```bash
make ai
# Open http://localhost:8888 in your browser
```

Or for a shell instead of Jupyter:

```bash
docker compose run --rm ai-coding bash
```

## Common workflows

### Jupyter notebooks

Place notebooks in `ai-coding/workspace/` — they appear at `/workspace` in Jupyter.

### Load a model from Hugging Face

```python
from transformers import pipeline

# Text generation
gen = pipeline("text-generation", model="gpt2")
print(gen("Hello, I am", max_length=30))

# Text classification
clf = pipeline("sentiment-analysis")
print(clf("I love this!"))
```

### PyTorch quick start

```python
import torch
import torch.nn as nn

# Check device
device = 'cuda' if torch.cuda.is_available() else 'cpu'
print(f'Using {device}')

# Simple model
model = nn.Sequential(
    nn.Linear(10, 64),
    nn.ReLU(),
    nn.Linear(64, 1)
).to(device)

x = torch.randn(32, 10).to(device)
print(model(x).shape)
```

### Data analysis

```python
import pandas as pd
import matplotlib.pyplot as plt

df = pd.read_csv('/workspace/data.csv')
df.describe()
df.plot(kind='scatter', x='col1', y='col2')
plt.savefig('/workspace/plot.png')
```

## GPU support

By default, the image uses **CPU-only PyTorch wheels**. To enable GPU:

1. Edit `ai-coding/Dockerfile` — swap the base image to the commented `nvidia/cuda` line.
2. Edit `ai-coding/requirements.txt` — replace the `torch` lines with the CUDA index URL variant.
3. Uncomment the `deploy.resources.reservations` block in `docker-compose.yml`.
4. Rebuild: `make build-ai`

Requires NVIDIA driver + [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html) on the host.
