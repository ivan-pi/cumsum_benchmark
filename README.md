# cumsum_benchmark

Some benchmarks for the cumulative sum of an array.

For a lengthier discussion see the thread at Discourse: https://fortran-lang.discourse.group/t/what-is-the-fastest-way-to-do-cumulative-sum-in-fortran-to-mimic-matlab-cumsum/1976

## C++

### GNU C++ compiler

```
g++ -Wall -O3 cumsum_benchmark.cpp -o cpp_cumsum
./cpp_cumsum > output_cpp.txt
```
### Intel C++ compiler

In contrast to Fortran, the Intel C++ compiler uses the same flags as the GNU compiler.

```
icpc -Wall -O3 cumsum_benchmark.cpp -o cpp_sumsum
./cpp_cumsum > output_cpp.txt
```

## Python

```
python cumsum_benchmark.py > output_python.txt
```

## Fortran

### Intel Fortran compiler (Classic)

```
ifort -warn all -O3 cumsum_benchmark.f90 -o f_cumsum
```

### GNU Fortran Compiler

```
gfortran -Wall -O3 cumsum_benchmark.f90 -o f_cumsum
```

Gfortran crashes on `cumsum_step3` for some unknown reason.

