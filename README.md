# docker-ldc-android

This dockerfile contains following software
- Android 1.1.0 beta (LDC with Android support) from here https://github.com/joakim-noah/android/releases
- android-ndk-r13b-linux-x86_64 from here https://dl.google.com/android/repository/

To start execute following command:
docker run --rm -it -v c:/D/projects:/projects andre2007/ldc-android sh

The command will pull the image and execute a shell within the container in interactive mode.
In addition the path c:\D\projects will be mounted.
On linux/mac you have to adapt the mount path.
