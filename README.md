# What-App? App Usage Detection Using Encrypted LTE/5G Traffic

> Cellular traffic fingerprinting attacks, in which an unprivileged adversary passively monitors encrypted wireless channels to infer user activities, introduce significant privacy risks by giving attackers the ability to track user behaviors, infer sensitive activities, and profile victims without authorization. Although such attacks have been discussed for LTE and 5G, many existing studies rely on idealized assumptions that fall short when faced with the complexities of real-world practical scenarios.
> In this paper, we present the first practical traffic fingerprinting attack leveraging a Man-in-the-Middle (MITM) Relay in an operational cellular network. Implemented with open-source software, our attack allows a passive adversary to identify user applications with up to 99.02% accuracy, even under noisy conditions. We evaluate our method using 40 applications across five categories on multiple COTS user equipment (UE). Our approach further demonstrates the ability to infer fine-grained user activities such as browsing, messaging, and video streaming under practical constraints, including partial traffic knowledge and app version drift. The attack also achieves cross-device and cross-network transferability, and it remains robust in open-world scenarios where only a subset of application traffic is known to the adversary.
> We additionally propose a novel traffic regularization-based defense tailored specifically for cellular networks. This defense operates as an optional, backward-compatible security layer integrated seamlessly into the existing cellular protocol stack, effectively balancing security strength with practical considerations such as latency and bandwidth overhead.

This repository provides the implementation of our mobile application fingerprinting system based on encrypted LTE/5G traffic, along with our traffic-regularization defense.

```bibtex
@inproceedings{wang2026whatapp,
  title     = {What-App? App Usage Detection Using Encrypted LTE/5G Traffic},
  author    = {Jinjin, WANG and Zishuai, Cheng and Mihai, Ordean and Baojiang, Cui},
  booktitle = {Proceedings on Privacy Enhancing Technologies (PoPETs)},
  volume    = {2026},
  issue     = {1},
  year      = {2026}
}
```

## Overview
This repository is for the artifact evalution, the ARTIFACT-APPENDIX.md described how to setup the docker container, run the attack models and evaluate our defense implementation.


The related code and dataset can be found in : 
* Associated Artifacts: 
  * https://github.com/Jinjin-Wang07/whatapp-app-fingerprinting.git
  * https://github.com/Jinjin-Wang07/whatapp-pdcp-defense.git
* Dataset: https://doi.org/10.5281/zenodo.17722145


## Environment Setup
#### 1. Clone project from github

```bash
git clone https://github.com/Jinjin-Wang07/whatapp-popets26-ae.git
cd whatapp-popets26-ae
```

#### 2. Run the setup script
To set up the full environment, run:
```bash
./1_setup.sh
```

Executing `1_setup.sh` will automatically:

1. Build the Docker container;
2. Download and place the dataset under `/dataset/raw/` inside the container;
3. Open an interactive shell within the container, positioned at `/workspaces`.

After setup, the `/workspaces` directory will contain the following structure:

```bash
/workspaces
├── 2_run_attack_models.sh
├── 3_run_defense_demo.sh
├── env_test.sh
├── fingerprinting
└── whatapp-pdcp-defense
```

The `/workspaces/fingerprinting/` directory contains all fingerprinting-related components, while the `/workspaces/whatapp-pdcp-defense/` directory contains our defense implementation.

## Running the Fingerprinting Models
### Run the CNN Model

Inside the container:

```bash
./2_run_attack_models.sh cnn
```

This will automatically:
* preprocess traffic traces
* train the CNN model
* evaluate classification accuracy

Results will print directly in the terminal.

### Run Baseline Models (SVM, KNN, MLP)
```bash
./2_run_attack_models.sh svm
./2_run_attack_models.sh knn
./2_run_attack_models.sh mlp
```

## Running the Defense Demo

We provide a runnable demonstration of our traffic-regularization defense.

Start the demo:
```bash
./3_run_defense_demo.sh
```

This launches a preconfigured working environment and guides you to execute EPC, eNB, and UE modules. You can also test throughput using `iperf3`.

The defense strength is controlled using the parameter 
`concatenating_timer_ms` in both `enb.conf` and `ue.conf`.