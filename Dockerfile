FROM debian

RUN apt-get update && apt-get install -y curl xz-utils unzip libconfig-dev build-essential cmake \
  && ln -s /lib/x86_64-linux-gnu/libncursesw.so.5  /lib/x86_64-linux-gnu/libncursesw.so.6

RUN cd ~ \
	&& curl -L -O https://github.com/joakim-noah/android/releases/download/beta/ldc2-android-arm-1.1.0-beta4-linux-x86_64.tar.xz \
	&& tar xvf ldc2-android-arm-1.1.0-beta4-linux-x86_64.tar.xz \
  && cp -s ~/ldc2-android-arm-1.1.0-beta4-linux-x86_64/bin/ldc2 /usr/bin/ldc2
