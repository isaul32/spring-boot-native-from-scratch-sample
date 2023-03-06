FROM ghcr.io/graalvm/graalvm-ce:22.3.1 AS builder

# Install necessary tools
WORKDIR /tools

ENV TOOLCHAIN_DIR=/tools/x86_64-linux-musl-native
ENV UPX_DIR=/tools/upx-4.0.2-amd64_linux
ENV PATH="$TOOLCHAIN_DIR/bin:$UPX_DIR:$PATH"
ENV CC=$TOOLCHAIN_DIR/bin/gcc

# https://www.graalvm.org/latest/reference-manual/native-image/guides/build-static-executables/
RUN microdnf install -y xz \
    # Install upx
    && curl -LJO https://github.com/upx/upx/releases/download/v4.0.2/upx-4.0.2-amd64_linux.tar.xz \
    && tar -xf upx-4.0.2-amd64_linux.tar.xz \
    && rm upx-4.0.2-amd64_linux.tar.xz \
    # Install musl
    && curl http://more.musl.cc/10/x86_64-linux-musl/x86_64-linux-musl-native.tgz | tar -xz \
    # Install zlib
    && curl https://zlib.net/zlib-1.2.13.tar.gz | tar -xz \
    && cd zlib-1.2.13 \
    && ./configure --prefix=$TOOLCHAIN_DIR --static \
    && make \
    && make install \
    # Install native-image
    && gu install native-image

WORKDIR /app
COPY . .
# Cache Gradle and dependencies
RUN ./gradlew clean --no-daemon
# Compile native executable
RUN ./gradlew nativeBuild --no-daemon
# Compress executable
RUN upx --lzma --best /app/build/native/nativeCompile/native-sample

# Create run image from scratch
FROM scratch
# Temp folder is mandatory
WORKDIR /tmp
WORKDIR /
COPY --from=builder /app/build/native/nativeCompile/native-sample .
ENTRYPOINT ["/native-sample"]
