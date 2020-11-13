# Xport
![Swift 5.1](https://img.shields.io/badge/Swift-5.1-orange.svg) 
[![SPM](https://img.shields.io/badge/spm-compatible-brightgreen.svg?style=flat)](https://github.com/apple/swift-package-manager)

A swift script that builds your Swift project on a remote machine. 

For example, let's say you want to write some swift code on your raspberry pi, with this script you can write your code in Xcode and use this script to sync your project to your raspberry pi! This project was inspired by the [Swish](https://github.com/thomaspaulmann/Swish) script.

## Prerequisites

- Swift installed on your Raspberry Pi. For more details on how to install swift on Raspberry PI, check out [this](https://lickability.com/blog/swift-on-raspberry-pi/) blog post. 
- SSH Key Pair. See below for setup.

## Setup SSH Authentication

In order for this script to work properly, you need to setup your SSH authentication between your mac and your remote machine. How do you know if this is already setup? Perform the following steps:

1. Launch your terminal and enter the following `ssh <username>@<hostname>`.
2. If you were able to connect without entering a password, you are ready to proceed!
3. If you were prompted to enter a password, you will need to go through the process of setting up `Passwordless SSH Access`. We need to do this because when we are executing this script via Xcode, there is no means to respond to a prompt while the script is executing. [This](https://www.raspberrypi.org/documentation/remote-access/ssh/passwordless.md) article walks through the process of setting up  the connection between your mac and remote machine.

## Installation with [Mint](https://github.com/yonaskolb/mint)

```
$ mint install digimarktech/Xport
```

## Configure Xcode

Once you have installed `Xport`, it can be used to transfer the code you have written in Xcode to your remote machine or Raspberry Pi. Below are the steps necessary to get everything working.

1. Create `External Build System`.

![Create External Build System](https://user-images.githubusercontent.com/16762986/99108136-ea4a2200-25b4-11eb-8850-b1f888dfd597.png)

![Default External Build Tool Configuration](https://user-images.githubusercontent.com/16762986/99108276-1e254780-25b5-11eb-9f31-24ab10d9019f.png)

2. Add your `swift pacakage`. This is the code that you have written to execute on the raspberry pi. If you have already created a package locally, you can simply drag it in. Otherwise, you can import it via its hosted github URL or create a new package altogether.

3. Provide the values for your `External Build Tool Configuration`. Here are the fields:
- Build Tool: This is the path where `Xport` was installed. If you used [Mint](https://github.com/yonaskolb/mint) to install it, you can use the following path `/usr/local/bin/xport`
- Arguments: These are the arguments used by the `Xport` script to execute it. The first argument represents the `username` used on your Raspberry Pi. The default username is `pi`. The second argument is the `hostname` or `ip-address` used to connect to your pi.
- Directory: Here is where you specify the path of the swift package that you are copying over.

![Custom External Build Tool Configuration](https://user-images.githubusercontent.com/16762986/99109232-7c065f00-25b6-11eb-8d11-217f1c45e099.png)

![Closeup External Build Tool Configuration](https://user-images.githubusercontent.com/16762986/99109303-9b9d8780-25b6-11eb-9fc6-228506a065c9.png)

4. `CMD + B` to build and execute the script. If you want to see a log of the script use the `Report Navigator` tab in Xcode.

## Author

Marc Aupont, @digimarktech

## License

Xport is available under the MIT license. See the LICENSE file for more info.
