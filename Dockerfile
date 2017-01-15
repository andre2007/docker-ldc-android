FROM ubuntu:16.10

RUN apt-get update && apt-get install -y \
	curl \
	libconfig9 \
	libncursesw5 \
	libncursesw5-dev \
	unzip \
	xz-utils
	
RUN cd ~ \
	&& curl -L -O https://github.com/joakim-noah/android/releases/download/beta/ldc2-android-arm-1.1.0-beta4-linux-x86_64.tar.xz \
	&& tar xf ldc2-android-arm-1.1.0-beta4-linux-x86_64.tar.xz \
	&& rm ldc2-android-arm-1.1.0-beta4-linux-x86_64.tar.xz \
	&& ln -s /lib/x86_64-linux-gnu/libncursesw.so.5 /lib/x86_64-linux-gnu/libncursesw.so.6 \
	&& ln -s ~/ldc2-android-arm-1.1.0-beta4-linux-x86_64/bin/ldc2 /usr/local/bin

RUN cd ~ \
	&& mkdir -p /opt/android-sdk/ndk-bundle \
	&& curl -L -O https://dl.google.com/android/repository/android-ndk-r13b-linux-x86_64.zip \
	&& unzip -qq android-ndk-r13b-linux-x86_64.zip 'android-ndk-r13b/*' -d /opt/android-sdk/ndk-bundle \
	&& rm android-ndk-r13b-linux-x86_64.zip

ENV NDK "/opt/android-sdk/ndk-bundle/android-ndk-r13b"
ENV LDC "~/ldc2-android-arm-1.1.0-beta4-linux-x86_64"
