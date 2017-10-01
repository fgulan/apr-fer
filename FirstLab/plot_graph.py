import scipy as sp
import matplotlib.pyplot as plt
import sys

def plot_graph(N):
    time = sp.loadtxt("time" + str(N) +".txt")
    x0 = sp.loadtxt("x0" + str(N) +".txt")
    x1 = sp.loadtxt("x1" + str(N) +".txt")

    plt.plot(time, x0, label='X1')
    plt.plot(time, x1, label='X2')
    plt.legend()
    plt.show()

if len(sys.argv) < 2:
    plot_graph(1)
    plot_graph(2)
else:
    N = sys.argv[1]
    plot_graph(N)
