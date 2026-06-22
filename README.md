# CWL + Streamflow Examples

Worked examples for learning [Common Workflow Language (CWL)](https://www.commonwl.org/v1.2/) and [Streamflow](https://streamflow.di.unito.it/documentation/0.2/). Start from `01_hello_world` and work through in order.

---

## Prerequisites

```bash
pip install streamflow
```

Streamflow also requires a working CWL runner:

```bash
pip install cwltool
```

For HPC examples (04, 06, 07) you need SSH access to a cluster. Run `configure.sh` first (see below).

---

## Running an example

Each folder contains:

| File | Purpose |
|------|---------|
| `*.cwl` | Tool/workflow definition |
| `inputs.yml` | Input values for this run |
| `streamflow.yml` | Deployment configuration |
| `image.png` | Workflow diagram |

To run any example:

```bash
cd 01_hello_world
streamflow run streamflow.yml
```

File outputs declared in the CWL workflow are written to the current directory by default. Use `--outdir` to choose a destination:

```bash
streamflow run streamflow.yml --outdir ./results
```

## HPC configuration

Examples 04, 06, and 07 contain `<HPC_USER>`, `<HPC_HOST>`, `<SSH_KEY>`, and `<HPC_WORKDIR>` placeholders. Fill them in with your credentials by editing `configure.sh` and running it:

```bash
# 1. Edit the variables at the top of configure.sh
nano configure.sh

# 2. Preview what will change
./configure.sh --dry-run

# 3. Apply
./configure.sh
```

Originals are backed up as `*.bak`. The four variables:

| Variable | Meaning | Example |
|----------|---------|---------|
| `HPC_USER` | SSH login username | `tommaso.fogliobonda` |
| `HPC_HOST` | HPC hostname or address | `c3s` |
| `SSH_KEY` | Absolute path to your private key | `/home/user/.ssh/id_rsa` |
| `HPC_WORKDIR` | Working directory on the remote | `/beegfs/home/user/cwl-examples` |
| `PORT_WORKDIR` | Directory on HPC where port input files live (example 07) | `/beegfs/home/user/cwl-examples/07_streamflow_ports` |

---

## Examples

### 01 — Hello World
Minimal `CommandLineTool`: one string input, one string output captured from stdout. Start here to understand the basic CWL file structure.

### 02 — Ports
Shows all four `inputBinding` styles and how workflow-level ports wire to tool-level ports:
- **Positional** (`position: N`) — value placed at a specific argument position
- **Named flag** (`prefix: --flag`) — produces `--flag value` on the command line
- **Optional** (`type: string?`) — argument omitted entirely when not provided
- **Boolean flag** (`type: boolean?`) — flag emitted when `true`, omitted when `false`

### 03 — Files
Passing `File`-typed data between steps. Shows `outputBinding.glob`, `InitialWorkDirRequirement` for staging, and why `.basename` must be used instead of `.path` inside a tool.

### 04 — Fan-out / Fan-in (Streamflow)
One input → three parallel steps → one gather step. Streamflow `streamflow.yml` maps step1/step3 to local and the three parallel steps to a Slurm cluster.

**Requires HPC** — run `configure.sh` first.

### 05 — Scatter / Gather
CWL native scatter: one step runs N times in parallel over a `string[]` input. Each scattered step's output is automatically an array; a final gather step reduces it back to a single value.

### 06 — Scatter + Dynamic Deployment
Combines scatter with Streamflow: the scatter step is bound to Slurm with a single binding entry — Streamflow dispatches all N instances concurrently. N is determined at runtime by the input array length.

**Requires HPC** — run `configure.sh` first.

### 07 — Streamflow Port Bindings + Output Collection
Introduces `port:` bindings in `streamflow.yml`. When input files already live on the HPC, a port binding tells Streamflow where to source them — no upload from local needed. Two inputs bound to different remote directories on the same deployment.

Also demonstrates **output collection**: the `inspect` step runs on HPC and produces `summary.txt`. Declaring it as a `File` output in the CWL workflow causes Streamflow to automatically transfer it back to local when the workflow finishes. Use `--outdir ./results` to control the destination:

```bash
cd 07_streamflow_ports
streamflow run streamflow.yml --outdir ./results
# results/summary_file  ← fetched from HPC
# results/report        ← written locally
```

**Requires HPC** — run `configure.sh` first.

---

## Streamflow concepts

### `streamflow.yml` structure

```yaml
version: v1.0
workflows:
  master:
    type: cwl
    config:
      file: main.cwl        # the CWL workflow
      settings: inputs.yml  # input values
    bindings:
      - step: /step_name    # which step...
        target:
          deployment: slurm # ...runs on which deployment
      - port: /input_name   # which input file...
        target:
          deployment: hpc   # ...lives on which deployment
          workdir: /remote/path  # directory where the file is found

deployments:
  local:
    type: local
    config: {}
  hpc:
    type: ssh
    config:
      nodes: [hostname]
      username: user
      sshKey: /path/to/key
    workdir: /remote/tmp
  slurm:
    type: slurm
    wraps: hpc              # Slurm always wraps an SSH deployment
    config:
      services:
        broadwell:
          partition: broadwell
```

### Step vs port bindings

| Binding | Key | Controls |
|---------|-----|---------|
| Step | `step: /name` | Where a step **executes** |
| Port | `port: /name` | Where an input file **lives** |

`step: /` (single slash) is a wildcard that applies to all steps. More specific bindings override it.

### Deployment types

| Type | Use case |
|------|---------|
| `local` | Run on the machine executing Streamflow |
| `ssh` | Run on a remote host via SSH |
| `slurm` | Submit to a SLURM scheduler; must `wraps` an SSH deployment |
| `docker` | Wrap a step in Docker (for local steps) |
| `singularity` | Wrap in Singularity/Apptainer (for HPC where Docker is unavailable) |
