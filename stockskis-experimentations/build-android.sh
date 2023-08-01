echo "Building StockŠkis for platform Android. Using Android NDK compiler."
export GOOS=android
export GOARCH=arm64
export CC=$ANDROID_NDK/toolchains/llvm/prebuilt/linux-x86_64/bin/aarch64-linux-android30-clang
./build.sh
echo "Done compiling StockŠkis for Android."
