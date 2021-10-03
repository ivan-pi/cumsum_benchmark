import numpy as np
from time import time

def millions_doubles_per_sec(n,nreps,elapsed):
    return (n / (elapsed/nreps)) * 1.e-6

ntrials = 7
nreps= 1000
n = [1000,10000,100000,1000000]
for trials in range(ntrials):
    elapsed = []
    for i, ni in enumerate(n):
        a = np.random.random_sample((ni,1))

        start = time()
        for rep in range(nreps):
            b = np.cumsum(a)
        elapsed.append(time() - start)


    mdps = [millions_doubles_per_sec(ni,nreps,ei) for (ni,ei) in zip(n,elapsed)]

    print("{:0.6g} {:0.6g} {:0.6g} {:0.6g}".format(*mdps))