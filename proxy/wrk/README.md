# WRK


## Installation

```
sudo apt-get install build-essential libssl-dev git -y
git clone https://github.com/wg/wrk.git wrk 
cd wrk 
sudo make
sudo cp wrk /usr/local/bin 
```

## Run

```
./run-all.sh --duration 30 --server http://localhost
```
