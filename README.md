# NovaOS

A hobby operating system written from scratch in **x86 assembly**, to learn how a PC boots: the BIOS, real mode, boot sectors, and disk geometry.

Right now NovaOS is a **16-bit real-mode bootloader** on a FAT12 floppy image. It sets up the segment registers and stack, prints a message through BIOS interrupts, and halts.

```text
hello novaOS!
```

## What's implemented

- **Boot sector at `0x7C00`**, 512 bytes, ending in the `0xAA55` boot signature
- **FAT12 BIOS Parameter Block and Extended Boot Record**, so the image is a valid 1.44 MB floppy (2880 sectors, 2 FATs, 224 root entries, volume label `novaOS`)
- **Real-mode setup:** `DS` / `ES` / `SS` zeroed, stack pointer at `0x7C00`
- **`puts`:** prints a null-terminated string through BIOS `int 0x10` (teletype, `AH = 0x0E`)
- **`lba_to_chs`:** converts a logical block address into cylinder / head / sector for BIOS disk reads
- **Build pipeline:** NASM builds a bootloader (sector 0) and a kernel binary (sector 1), and `dd` writes both into a blank floppy image

## Roadmap

- [ ] finish `disk_read` (BIOS `int 0x13`, with retries)
- [ ] load the kernel from the FAT12 filesystem and jump to it
- [ ] switch to 32-bit protected mode
- [ ] a basic C kernel

## Build and run

Requires `nasm`, `make` and `qemu` (Linux, macOS, or WSL on Windows).

```bash
git clone https://github.com/abdullah2036/NovaOS.git
cd NovaOS
make            # builds build/main_floppy.img
make run        # boots it in qemu-system-i386
```

## Project structure

```
NovaOS/
├── Makefile                 assembles both stages and builds the floppy image
├── src/
│   ├── bootloader/boot.asm  boot sector: FAT12 headers, puts, lba_to_chs, disk_read (WIP)
│   └── kernel/main.asm      kernel stub
└── build/                   bootloader.bin, kernel.bin, main_floppy.img
```

## Tech stack

x86 assembly (NASM) · BIOS interrupts · FAT12 · QEMU · Make

---

Built by **Abdullah Bokhary** · [Portfolio](https://abdullah.pageui.workers.dev/) · [LinkedIn](https://www.linkedin.com/in/abdullah-bokhary-840315326/) · [GitHub](https://github.com/abdullah2036)
