# INT_Detector

Today's network scale and complexity are constantly rising, bringing tremendous challenges to network operation and maintenance. Network anomaly detection plays a significant role in maintaining large-scale computer networks. It aims to discover abnormal behaviors in network traffic and achieve accurate yet rapid failure detection and root positioning. In network anomaly detection, how to obtain the network status and implement the detection algorithm is the main consideration. To address this problem, we propose INT-Detector, an automated network anomaly detection system combining In-band Network Telemetry (INT) and Deep learning (DL). We first build an INT-based telemetry platform, which enables fine-grained monitoring by acquiring hop-by-hop device information. We then introduce Generative Adversarial Active Learning (GAAL) into the anomaly detection module, which can automatically detect anomalies without over reliance on manual work or expert experience. It also solves the problem of the lack of prior information on volatile network traffic patterns. Besides, in order to reduce the disturbance from traffic jitters on accurate anomaly detection, we use Low Pass Filter (LPF) for data preprocessing to filter out the fluctuations and achieve more precise anomaly detection. The extensive evaluation suggests that the INT-Detector with GAAL achieves 0.944 Area Under Curve (AUC). And the system with GAAL and LPF further reaches 0.969 AUC.

The major contributions are summarized as follows:

1. 	By defining the interactions and interfaces between the network monitoring infrastructure and data analysis intelligence, to our best knowledge, we propose the first closed-loop automated network anomaly detection architecture INT-Detector with INT and ML integrated.

3. We introduce GAAL into the INT-Detector system, which achieves automating rapid network anomaly detection with high efficiency. And for further improving the detection effect, we use Low Pass Filter to distinguish between normal fluctuations and abnormal fluctuations. 
 
3. We implement an INT-Detector prototype available at the git repository. The extensive evaluation proves that INT-Detector is suitable for anomaly detection. INT-Detector achieves 0.944 AUC with GAAL; it further achieves 0.969 AUC with GAAL and LPF.

# Include

This is a demo for INT_Detector. The program mainly includes three modules: monitor, detector, and controller.

## monitor

Perform network monitoring based on INT and P4.

### p4src
Define the packet processing logic of the switches.

### topo
Build the experimental network with mininet.

## detector

Anomaly detection based on GAAL.

### gaal.py
Perform abnormal detection with GAAL.

### filter.py
Perform low pass filtering for data.

## controller

Implement network control, parse the INT metadata, maintain a database of telemetry data. 

### int_data.sql
Create a table for data storage

### hdr.py
Header definitions for sending.

### send.py
Send probing packet.

### receive.py
Receive probing packet.

### decode.py
Decode the received packet.

### upload.py
Upload the parsing data to the table.


## Install dependences:

- [tensorflow](https://tensorflow.google.cn/)
- [Mininet](http://mininet.org/download/)
- [BMv2](https://github.com/p4lang/behavioral-model)
- [p4c](https://github.com/p4lang/p4c)
- [python](https://www.python.org/)
- [pyod](https://github.com/yzhao062/pyod)

### Perform network monitoring:

1. Get the JSON file:

```
sudo p4c-bm2-ss --p4v 16 -o json/int.json p4src/int.p4
```

2. Take the JSON file as input and bring up mininet:
	
```
sudo python topo/FattreeTopo.py --json int.json
```

3. Set up forwarding rules in other terminal:

```
sh topo/FattreeCommands.sh
```

### Perform network anomaly detection：

1. open tensorflow environment you created:

```
activate tensorflow(environment name)
```

2. perform detection demo:

```
python gaal.py
```