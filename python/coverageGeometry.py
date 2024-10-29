from consts import Consts
import numpy as np

def calcUniformGridLatLon(gridResolution, **kwargs):

    # % Algorithm generates lat, lon for spherical Fibonnaci grid/lattice
    # % The more details available at https://www.overleaf.com/read/hsjtzhnncmfw#71ff51

    # % Input: grid resolution
    # % - gridResolution, m
    # % - kwargs - rSphere for a central body radius different from the Earth's one
    # % Output: points spherical coordinates
    # % - latArray, rad
    # % - lonArray, rad


    if 'rSphere' in kwargs:
        rSphere = np.array(kwargs['rSphere'])
    else:
        rSphere = Consts.rEarth

    epsilon = 0.5

    nNodes  = np.round(16 * rSphere**2 / gridResolution**2)
    nodesIdxArray =  np.arange(0,nNodes)

    # square lattice coordinates
    xArray = (nodesIdxArray / Consts.goldenRatio) % 1
    yArray = (nodesIdxArray + epsilon) / (nNodes + 2 * epsilon)

    latAarray = np.pi / 2 - np.arccos(1 - 2 * xArray)
    lonArray = 2 * np.pi * yArray

    return latAarray, lonArray

def calcBetaAngleGivenElevation(orbitRadius, elevation):

    # % Reference: 
    # % Biktimirov S., Satellite Formation Flying for Space Advertising:
    # % From Technically Feasible to Economically Viable, Eq. 12

    gamma = np.arcsin(Consts.rMoonEquatorial / orbitRadius * np.cos(elevation))

    return np.pi / 2 - gamma - elevation

