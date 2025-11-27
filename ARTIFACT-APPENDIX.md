# Artifact Appendix

Paper title: **What-App? App Usage Detection Using Encrypted LTE/5G Traffic**

Requested Badges:
  - **Available**
  - **Functional**
  - **Reproduced**

## Description

Our artifact submission includes the source code of fingerprinting models and our defense implementation, and datasets described in our paper:

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

This artifact contains two main components supporting our study of mobile application fingerprinting and defenses in encrypted LTE/5G networks. The first component is our fingerprinting framework, which includes a CNN-based classifier and several baseline models (SVM, KNN, MLP) for evaluating app and activity recognition performance on encrypted traffic. The second component is our PDCP-layer defense implemented on top of the srsRAN software stack, using configurable traffic-shaping parameters to reduce the effectiveness of fingerprinting attacks. 


### Security/Privacy Issues and Ethical Concerns

This artifact does not introduce any security or privacy risks to the machine of the person evaluating or reusing it. The fingerprinting evaluation can be performed entirely within an isolated Docker environment, using provided datasets. All datasets included in this artifact were generated in controlled experimental setups using anonymous accounts and do not contain any personally identifiable information. The dataset is strictly limited to encrypted cellular traffic traces created for research purposes and does not raise privacy concerns.

## Basic Requirements

### Hardware Requirements

To run the AE experiments, we recommend using a Linux machine with the following hardware:

#### Recommend hardware requirements (_AE experiments_)

The artifact is designed to run entirely inside Docker and does not require a discrete GPU.
It can be executed on a standard workstation or laptop. For reference, the setup used by the author is:
* CPU: AMD Ryzen 9 7950X (16 Cores and 32 Threads)
* Memory: 64 GB RAM
* GPU: Not required

#### Hardware used to produce the results in the paper
Full-scale experiments, including training on the complete dataset, require substantially more computational resources due to model size and dataset volume.
The experiments reported in the paper were conducted on a high-performance computing (HPC) server equipped with A100 GPU nodes, with the following specifications:
* GPU: NVIDIA A100 40GB
* CPU: 2 × 28-core Intel Ice Lake (x86_64) processors per node
* Memory: Approximately 490 GB RAM available per node

The artifact includes a reduced-size dataset and CPU-compatible configuration specifically so evaluators can run all required AE steps without access to specialized hardware.

### Software Requirements

We tested all the code in the following software environments:

* Linux computer:
   * OS: Ubuntu 22.04.1 LTS
   * Docker: version 28.1.1

### Estimated Time and Storage Consumption

On a AMD Ryzen 9 7950X 64GB RAM PC, the AE experiments take about 40 minutes, which includes 20 minutes for Docker build machine time and 40 minutes for artifact evaluation time.

The scaled-down experiments require about 25 GiB of disk space, including:

* about 5 GiB used to store downloaded associated artifacts;
* about 10 GiB used for extracted data and any intermediate results generated;
* about 10 GiB for dependencies installed by conda.

## Environment

### Accessibility

* Main codebase: https://github.com/Jinjin-Wang07/whatapp-popets26-ae.git
* Associated Artifacts: https://github.com/Jinjin-Wang07/whatapp-pdcp-defense.git
* Dataset: [TO_BE_UPLOADED]

### Set up the environment
#### 1. Fetch the main artifact evaluation project from github

```bash
git clone https://github.com/Jinjin-Wang07/whatapp-popets26-ae.git
cd whatapp-popets26-ae
```

#### 2. Download the dataset
Please download the dataset archive `whatapp-pdcp-dataset.tar.gz` from [TO_BE_UPLOADED], and place it directly in the root of the AE project folder `whatapp-popets26-ae`. After placing the dataset, the folder structure should look as follows:
```bash
whatapp-popets26-ae
├── 1_setup.sh
├── 2_run_attack_models.sh
├── 3_run_defense_demo.sh
├── ARTIFACT-APPENDIX.md
├── docker-compose.yml
├── env_test.sh
├── README.md
└── whatapp-pdcp-dataset.tar.gz
```

Once the dataset is in place, you can set up the Docker environment using:

```bash
./1_setup.sh
```

After running 1_setup.sh, the Docker container will be built, and you will automatically enter the container shell.


### Testing the Environment

Inside the docker container, run `env-test.sh` to verify that the dataset is correctly located, the fingerprinting and defense components compile successfully, and all required dependencies are installed:

```bash
$ cd /workspaces
$ ./env_test.sh 
=========================================
Environment Test for Artifact Evaluation
=========================================

1. Dataset Validation
Testing /dataset/raw exists ... PASS
...
✓ ALL TESTS PASSED - Environment ready for artifact evaluation
```

If you see `All TESTS PASSED`, the setup is successful.

## Artifact Evaluation

### Main Results and Claims

#### Main Result 1: The CNN model achieves high app and activity classification accuracy

Our CNN-based fingerprinting model accurately classifies app-level and activity-level behaviors from encrypted cellular traffic. As demonstrated in Section 4 of the paper, the model consistently achieves high accuracy across different applications, devices, and network conditions.

#### Main Result 2: The CNN model outperforms traditional machine-learning baselines

Compared to traditional models such as SVM, KNN, and MLP, the CNN achieves significantly higher classification accuracy.

#### Main Result 3: The defense scheme can reshape the traffic into fixed rate

Our PDCP-layer defense successfully regularizes cellular traffic by enforcing fixed-size packet transmission at constant intervals. By adjusting the traffic-shaping parameter, specifically, the time interval between consecutive PDCP packets, the output data rate of both the eNB and UE becomes fixed. A shorter interval produces a higher regulated throughput, while a longer interval reduces the effective data rate.


### Experiments

Following experiment scripts should be run inside the Docker container built in the section [Set up the environment](#set-up-the-environment).

#### Experiment 1: Running CNN model on 5 applications
In this experiment, we demonstrate the processing workflow for raw application traffic data, followed by the training of our CNN model and its fingerprinting accuracy. Considering the time complexity of model training, we selected only five applications for demonstration.

- Time: 5 human-minutes + 5 compute-minutes.
- Storage: ~10GB.

To start the CNN pipeline (preprocessing, training, testing), run:
```bash
./2_run_attack_models.sh cnn
```

After completion, the classification accuracy will be printed in the terminal.

#### Experiment 2: Running compared (SVM, KNN, MLP) models
This experiment demonstrates the processing workflow for the three traditional baselines: SVM, KNN, and MLP.

- Time: 10 human-minutes + 10 compute-minutes.

Run the following commands to evaluate each model:

```bash
./2_run_attack_models.sh svm
./2_run_attack_models.sh knn
./2_run_attack_models.sh mlp
```

For each model, the classification results will be displayed in the terminal after execution.

#### Experiment 3: Demonstrating the Defense Implementation

- Time: 5 human-minutes + 5 compute-minutes.

This experiment demonstrates the operation of our PDCP-layer defense implementation. A preconfigured `tmux` session is used to automatically split the terminal into multiple panes and place you in the correct working directory with pre-filled commands.

Launch the `tmux` session:
  ```bash
  ./3_run_defense_demo.sh
  ```

After launching, a 5-pane `tmux` window will appear, and the working directory will be set to: `/workspaces/what-app-defense/config_defense`

Then you should run the following commands in order, each in the corresponding pane.

1. Start the 4G EPC
  ```bash
  ./launch.sh epc
  ```
2. Start the eNB:
  ```bash
  ./launch.sh enb_zmq
  ```
3. Start the UE:
  ```bash
  ./launch.sh ue_zmq
  ```

Once the UE successfully attaches to the eNB, the UE pane will show output similar to:
```bash
$./launch.sh ue_zmq
Executing code for UE with ZeroMQ
Active RF plugins: libsrsran_rf_uhd.so libsrsran_rf_zmq.so
Inactive RF plugins: 
Reading configuration file /workspaces/whatapp-pdcp-defense/confg_defense/ue.conf...
...
Attaching UE...
Current sample rate is 1.92 MHz with a base rate of 23.04 MHz (x12 decimation)
Current sample rate is 1.92 MHz with a base rate of 23.04 MHz (x12 decimation)
.
Found Cell:  Mode=FDD, PCI=1, PRB=100, Ports=1, CP=Normal, CFO=-0.2 KHz
Current sample rate is 23.04 MHz with a base rate of 23.04 MHz (x1 decimation)
Current sample rate is 23.04 MHz with a base rate of 23.04 MHz (x1 decimation)
Found PLMN:  Id=00101, TAC=1
Random Access Transmission: seq=35, tti=341, ra-rnti=0x2
RRC Connected
Random Access Complete.     c-rnti=0x46, ta=0
Network attach successful. IP: 172.16.0.2
Software Radio Systems RAN (srsRAN) 27/11/2025 21:8:42 TZ:0
```

##### Testing the Data Rate
After the UE is connected, you can evaluate throughput under the defense configuration.
1. Launch the iperf3 server (EPC side):
  ```bash
  iperf3 -s
  ```
2. Launch the iperf3 client (inside the UE namespace)
  ```bash
  ip netns exec ue1 iperf3 -c 172.16.0.1 -b 1M -i 1 -t 60
  ```

##### Adjusting the Defense Rate
The output data rate can be modified by changing the following parameter in both `enb.conf` and `ue.conf`: `concatenating_timer_ms`
  
## Limitations
Due to the large size of the dataset and the computational cost of training CNN models, we do not demonstrate the CNN pipeline on the entire dataset within the artifact evaluation. Instead, we use a representative subset that allows reviewers to reproduce the complete data-processing workflow. This workflow is identical to the one used for the full dataset in the paper.

For the demonstration of our defense implementation, we prioritized using ZMQ (Virtual Physical Link) to connect UE and ENB, although we have tested our implementation using radio equipment (USRP) and confirmed its feasibility, due to the inherent characteristics of radio signal, we cannot guarantee that this component can be reproduced under different setup.

For the defense demonstration, we use ZeroMQ to emulate the physical link between the UE and eNB. Although we have tested the defense with real radio hardware (USRP) and verified its feasibility, the reproducibility of radio-based experiments cannot be guaranteed across different hardware setups, environments, or interference conditions. Therefore, the AE package focuses on a reliable ZMQ-based demonstration.


## Notes on Reusability
The dataset we collected across a diverse set of mobile applications can be reused directly in future research on traffic fingerprinting. It enables researchers to explore improved classification models, compare against established baselines, or study new fingerprinting techniques without requiring their own data-collection infrastructure.

Similarly, our regularization-based defense, implemented as the first PDCP-layer countermeasure for cellular traffic fingerprinting, provides a practical and extensible baseline for evaluating the effectiveness of future defenses. Researchers may adapt or extend our implementation by modifying shaping parameters, integrating new regularization strategies, or assessing the defense under additional datasets, system configurations, or network conditions.