FROM ubuntu:16.10

RUN apt-get update && apt-get install -y curl build-essential git cmake unzip libconfig-dev libcurl4-openssl-dev python3
RUN cd ~ \
	&& curl -L -O http://downloads.dlang.org/releases/2.x/2.072.2/dmd_2.072.2-0_amd64.deb \
	&& dpkg -i dmd_2.072.2-0_amd64.deb
	
RUN mkdir -p /opt/android-sdk/ndk-bundle \
	&& curl -L -O https://dl.google.com/android/repository/android-ndk-r13b-linux-x86_64.zip \
	&& unzip -qq android-ndk-r13b-linux-x86_64.zip 'android-ndk-r13b/*' -d /opt/android-sdk/ndk-bundle

ENV DMD "/usr/bin/dmd"
ENV NDK "/opt/android-sdk/ndk-bundle/android-ndk-r13b"

RUN curl -L -O http://releases.llvm.org/3.9.1/llvm-3.9.1.src.tar.xz \
	&& tar xf llvm-3.9.1.src.tar.xz \
	&& cd llvm-3.9.1.src/ \
	&& curl -O https://gist.githubusercontent.com/joakim-noah/1fb23fba1ba5b7e87e1a/raw/ff54ecbe824b5f45669ea3a86f136ded16b1dd91/android_tls \
	&& git apply android_tls \
	&& mkdir build \
	&& cd build/ \
	&& cmake .. -DCMAKE_BUILD_TYPE=Release -DLLVM_TARGETS_TO_BUILD=ARM -DLLVM_DEFAULT_TARGET_TRIPLE=armv7-none-linux-android \
	&& make -j5

RUN cd ~ \
	&& git clone --recursive https://github.com/ldc-developers/ldc.git \
	&& cd ldc/ \
	&& git checkout 1155379b2 \
	&& git submodule update \
	&& curl -O https://gist.githubusercontent.com/joakim-noah/f475b0be37b3834b4e50d68996b6ee1d/raw/aced85f7d586a3ef2fa05c9b75d7bff218f021c1/ldc_1.1.0_android_arm \
	&& git apply ldc_1.1.0_android_arm \
	&& mkdir build \
	&& cd build/ \
	&& cmake .. -DLLVM_CONFIG=../../llvm-3.9.1.src/build/bin/llvm-config \
	&& make ldc2 -j5

RUN cd ~/ldc/runtime/druntime/ \
	&& curl -O https://gist.githubusercontent.com/joakim-noah/849e411f66266bcb9fea3e21f7024bc6/raw/45d9ef5648fca216f4385bcae36f5c5dce6b7dc0/druntime_1.1.0_ldc_arm \
	&& git apply druntime_1.1.0_ldc_arm \
	&& cd ../phobos/ \
	&& curl -O https://gist.githubusercontent.com/joakim-noah/7db9da3c76f76ffd3be9f57f45864cdb/raw/82b0c95bb47a75a0fe1d42bc60cdbd617006c21f/phobos_1.1.0_ldc_arm \
	&& git apply phobos_1.1.0_ldc_arm \
	&& cd ../../build/ \
	&& make druntime-ldc phobos2-ldc -j5 \
	&& ln -s ~/llvm-3.9.1.src/build/bin/ldc2 /usr/local/bin
