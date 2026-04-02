# CTF Environment

## Tools

| Category | Tools |
|----------|-------|
| Debugger | gdb + pwndbg |
| Disassembler | radare2 |
| Exploit dev | pwntools |
| ROP | ROPgadget, ropper |
| Reverse engineering | capstone, unicorn, keystone-engine |
| Crypto | pycryptodome, z3-solver |
| Network | nmap, netcat, socat |
| Binary patching | patchelf |
| Tracing | strace, ltrace |

## Quick start

```bash
make ctf
```

## Exploit development with pwntools

```python
from pwn import *

# Local binary
p = process('./vuln')

# Remote
p = remote('challenge.ctf.site', 1337)

# Send payload
payload = b'A' * 64 + p64(0xdeadbeef)
p.sendlineafter(b'Input: ', payload)
print(p.recvall())
```

### Shellcode

```python
from pwn import *
context.arch = 'amd64'

shellcode = asm(shellcraft.sh())   # /bin/sh shellcode
print(enhex(shellcode))
```

### ROP chains

```python
from pwn import *
elf = ELF('./vuln')
rop = ROP(elf)
rop.call('system', [next(elf.search(b'/bin/sh'))])
print(rop.dump())
```

## gdb + pwndbg workflow

```bash
gdb ./vuln
```

```
cyclic 200             # generate a De Bruijn pattern
r <<< $(cyclic 200)    # run with pattern as stdin
cyclic -l 0x6161616b   # find offset from crash address
```

## Networking (pwn over TCP)

```bash
# Listen for a reverse shell
nc -lvnp 4444

# Connect to a challenge
nc challenge.ctf.site 1337

# Relay stdin/stdout to a process
socat TCP:challenge.ctf.site:1337 STDIN
```

## Crypto helpers

```python
from Crypto.Util.number import *
from z3 import *

# RSA quick solve
n, e, c = ...
p, q = ...   # if factored
d = inverse(e, (p-1)*(q-1))
print(long_to_bytes(pow(c, d, n)))

# Z3 constraint solver
x = BitVec('x', 32)
s = Solver()
s.add(x * 3 + 7 == 0x1f)
if s.check() == sat:
    print(s.model()[x])
```

## Notes

- The container runs with `--privileged` and `SYS_PTRACE` — required for gdb and pwntools.
- `network_mode: host` is Linux-only. On Windows/macOS use explicit port mappings.
