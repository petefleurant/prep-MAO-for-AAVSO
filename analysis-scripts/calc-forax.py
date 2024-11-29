#
# calc-forax.py
#
# 06 Aug 2024
#
# 
# 
# 
import sys
import math
import numpy as np
from tkinter import *
from PIL import ImageTk, Image
import matplotlib
matplotlib.use('TkAgg')
import matplotlib.pyplot as plt

def calc_forax():
    # Define the function and range
    x = np.linspace(0, 1, 400)
    y = x**(1-x)

    # Create the plot
    plt.figure(figsize=(8, 6))
    plt.plot(x, y, label=r'$x^{1-x}$')
    plt.title(r'Plot of $x^{1-x}$ from $x=0$ to $x=1$')
    plt.xlabel('x')
    plt.ylabel(r'$x^{1-x}$')
    plt.legend()
    plt.grid(True)
    plt.show()


if __name__ == "__main__":
    calc_forax()
