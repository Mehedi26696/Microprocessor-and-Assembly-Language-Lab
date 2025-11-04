import subprocess
import sys
import os

def run_nasm(file_path: str):
    
    base_name = os.path.splitext(file_path)[0]

    asm_cmd = ["nasm", "-f", "elf64", f"{base_name}.asm", "-o", f"{base_name}.o"]
    gcc_cmd = ["gcc", "-no-pie", "-o", base_name, f"{base_name}.o"]

    try:
      
        subprocess.run(asm_cmd, check=True)
        subprocess.run(gcc_cmd, check=True)
        subprocess.run([f"./{base_name}"])
    except subprocess.CalledProcessError as e:
        print(f"\nError: Command failed -> {e}")
    except FileNotFoundError as e:
        print(f"\nMissing tool: {e.filename} not found (install NASM & GCC)")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python run.py <filename.asm>")
    else:
        run_nasm(sys.argv[1])
