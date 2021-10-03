import numpy as np
from time import time

ntrials = 7
nrep = 1000
n = [1000,10000,100000,1000000]
for trials in range(ntrials):
    elapsed = []
    for i, ni in enumerate(n):
        a = np.random.random_sample((ni,1))

        start = time()
        for rep in range(nrep):
            b = np.cumsum(a)
        elapsed.append(time() - start)

    print("{:0.6g} {:0.6g} {:0.6g} {:0.6g}".format(*elapsed))