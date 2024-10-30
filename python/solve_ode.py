import numpy as np
# @numba.njit
def ode45_step(f, x, t, dt, *args):
    """
    One step of 4th Order Runge-Kutta method
    """
    h = dt
    k1 = f(t, x, *args)
    k2 = f(t + 0.5*h, x + 0.5*h*k1, *args)
    k3 = f(t + 0.5*h, x + 0.5*h*k2, *args)
    k4 = f(t + h, x + h*k3, *args)
    return x + h/6 * (k1 + 2*k2 + 2*k3 + k4)

# @numba.njit(numba.float64[:](numba.float64[:], numba.float64[:], numba.float64, numba.char[:]), numba.float64[:], numba.float64[:], numba.float64, numba.char[:])
def ode45(f, t, x0, *args):
    """
    4th Order Runge-Kutta method
    """
    n = len(t)
    x = np.zeros((n, len(x0)))
    x[0] = x0
    for i in range(n-1):
        dt = t[i+1] - t[i] 
        x[i+1] = ode45_step(f, x[i], t[i], dt, *args)
    return x