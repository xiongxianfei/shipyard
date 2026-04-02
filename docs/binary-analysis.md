# Binary Analysis Environment

## Tools

| Category | Tools |
|----------|-------|
| Debugger | gdb + pwndbg |
| Disassembler / RE | radare2, r2pipe |
| Binutils | objdump, readelf, nm, strings, strip |
| Assemblers | nasm, yasm |
| Dynamic tracing | strace, ltrace, valgrind |
| Cross-arch emulation | qemu-user-static |
| Analysis platform | angr (CFG, symbolic execution) |
| Core frameworks | capstone, unicorn, keystone-engine |
| Format parsers | lief, pyelftools, pefile |
| Firmware analysis | binwalk |
| Pattern matching | yara-python |
| ROP | ROPgadget, ropper |
| Instrumentation | frida-tools |

## Quick start

```bash
make binary-analysis
cp ./target_binary binary-analysis/workspace/
```

## Static analysis

### File identification

```bash
file target_binary
strings -n 8 target_binary | less
readelf -a target_binary
objdump -d target_binary | less
```

### radare2 (main RE workflow)

```bash
r2 -A target_binary    # open and auto-analyse
```

Key commands:

| Goal | Command |
|------|---------|
| List functions | `afl` |
| Disassemble function | `pdf @ sym.main` |
| Graph view | `VV` |
| Decompile function | `pdg` (r2ghidra) |
| List strings | `iz` |
| List imports | `ii` |
| Cross-references to addr | `axt @ 0x401234` |
| Rename function | `afn new_name @ addr` |
| Search bytes | `/x deadbeef` |
| Write note/comment | `CCa @ addr your note` |

### Binary format parsing (Python)

```python
# ELF
from elftools.elf.elffile import ELFFile
with open('target', 'rb') as f:
    elf = ELFFile(f)
    for s in elf.iter_sections():
        print(s.name, hex(s['sh_addr']))

# PE (Windows)
import pefile
pe = pefile.PE('target.exe')
for entry in pe.DIRECTORY_ENTRY_IMPORT:
    print(entry.dll.decode())

# Any format (ELF/PE/Mach-O)
import lief
binary = lief.parse('target')
for func in binary.exported_functions:
    print(func.name)
```

## Dynamic analysis

### gdb + pwndbg

```bash
gdb ./target_binary
```

```
b main          # breakpoint at main
r               # run
disasm          # disassemble current location
regs            # show all registers
stack 20        # show 20 stack entries
heap            # heap overview
rop             # find ROP gadgets
```

### System call tracing

```bash
strace -f ./target_binary          # trace syscalls
ltrace ./target_binary             # trace library calls
strace -e trace=network ./target   # network syscalls only
```

## Symbolic execution with angr

```python
import angr

proj = angr.Project('./target', auto_load_libs=False)
cfg  = proj.analyses.CFGFast()

# List all functions
for addr, func in cfg.kb.functions.items():
    print(hex(addr), func.name)

# Find input that reaches a target address
sim = proj.factory.simgr()
sim.explore(find=0x401234, avoid=0x401000)
if sim.found:
    print(sim.found[0].posix.dumps(0))  # stdin
```

## Firmware analysis

```bash
binwalk firmware.bin          # identify embedded files
binwalk -e firmware.bin       # extract them
binwalk -A firmware.bin       # detect CPU architecture
```

## YARA pattern matching

```bash
cat > rule.yar << 'EOF'
rule has_shell {
    strings: $s = "/bin/sh"
    condition: $s
}
EOF
python3 -c "
import yara
r = yara.compile('rule.yar')
print(r.match('target_binary'))
"
```

## Cross-architecture emulation

```bash
# Run an ARM binary on x86
qemu-arm-static ./arm_binary

# Run a MIPS binary
qemu-mips-static ./mips_binary
```
