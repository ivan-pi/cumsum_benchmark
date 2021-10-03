# cumsum_benchmark
Some benchmarks for the cumulative sum of an array

## C++

```
g++ -Wall -O3 cumsum_benchmark.cpp -o cpp_cumsum
./cpp_cumsum > output_cpp.txt
```

## Python

```
python cumsum_benchmark.py > output_python.txt
```

## Fortran

### ifort

```
ifort -warn all -O3 cumsum_benchmark -o f_cumsum
```

### gfortran

Gfortran crashes on `cumsum_step3` for some unknown reason.