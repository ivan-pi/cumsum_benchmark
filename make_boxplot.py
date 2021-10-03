import numpy as np
import matplotlib.pyplot as plt


data_cpp = np.loadtxt("output_cpp.txt")
data_python = np.loadtxt("output_python.txt")
data_matlab = np.loadtxt("output_matlab.txt")

npw3 = np.column_stack([data_cpp[:,0],data_python[:,0],data_matlab[:,0]])
npw4 = np.column_stack([data_cpp[:,1],data_python[:,1],data_matlab[:,1]])
npw5 = np.column_stack([data_cpp[:,2],data_python[:,2],data_matlab[:,2]])
npw6 = np.column_stack([data_cpp[:,3],data_python[:,3],data_matlab[:,3]])

fig, (ax1,ax2,ax3,ax4) = plt.subplots(nrows=1,ncols=4,figsize=(12,3),sharey=True)

labels = ['C++', 'Python', 'MATLAB']

ax1.boxplot(npw3,labels=labels)
ax2.boxplot(npw4,labels=labels)
ax3.boxplot(npw5,labels=labels)
ax4.boxplot(npw6,labels=labels)

ax1.set_title("N = 1000")
ax2.set_title("N = 10000")
ax3.set_title("N = 100000")
ax4.set_title("N = 1000000")

ax1.set_ylabel("Million doubles per second")

fig.savefig("ref.png",dpi=600)

# plt.show()