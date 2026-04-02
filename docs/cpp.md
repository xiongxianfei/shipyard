# C++ Development Environment

## Tools

| Tool | Purpose |
|------|---------|
| GCC 13, G++ | GNU compiler |
| Clang 17, clang-format, clang-tidy | LLVM compiler and analysis |
| CMake, Make, Ninja | Build systems |
| GDB, Valgrind | Debugger and memory analysis |
| cppcheck | Static analysis |
| Conan 2.x | Package manager |
| vcpkg | Package manager (Microsoft) |
| Boost, OpenSSL, zlib | Common libraries |

## Quick start

```bash
make cpp
```

## Common workflows

### CMake project

```bash
mkdir /workspace/myapp && cd /workspace/myapp

# Create CMakeLists.txt
cat > CMakeLists.txt << 'EOF'
cmake_minimum_required(VERSION 3.20)
project(myapp)
set(CMAKE_CXX_STANDARD 23)
add_executable(myapp main.cpp)
EOF

mkdir build && cd build
cmake .. -G Ninja
ninja
./myapp
```

### Conan dependencies

```bash
# Create conanfile.txt
cat > conanfile.txt << 'EOF'
[requires]
fmt/10.2.1
nlohmann_json/3.11.3

[generators]
CMakeDeps
CMakeToolchain
EOF

conan install . --build=missing -of build
cd build && cmake .. -G Ninja -DCMAKE_TOOLCHAIN_FILE=conan_toolchain.cmake
ninja
```

### vcpkg dependencies

```bash
vcpkg install fmt nlohmann-json
# then integrate with CMake via -DCMAKE_TOOLCHAIN_FILE=$VCPKG_ROOT/scripts/buildsystems/vcpkg.cmake
```

### Clang-format and tidy

```bash
clang-format -i src/*.cpp src/*.h   # format in-place
clang-tidy src/*.cpp -- -std=c++23  # static analysis
```

### Memory analysis with Valgrind

```bash
valgrind --leak-check=full --show-leak-kinds=all ./myapp
```

### Address Sanitizer (faster than Valgrind)

```bash
cmake .. -DCMAKE_CXX_FLAGS="-fsanitize=address,undefined"
ninja && ./myapp
```

## Tips

- The `.clang-format` config at `cpp/.clang-format` (Google style, indent=4) is
  copied to `/root/.clang-format` in the container — clang-format picks it up automatically.
- vcpkg bootstrap adds ~3 min to the initial build. Remove the vcpkg block from
  `cpp/Dockerfile` if you only use Conan.
