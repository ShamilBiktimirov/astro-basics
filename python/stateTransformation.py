import numpy as np
def kepler_E_vect(e,M):
    '''
        This function uses Newton's method to solve Kepler's
        equation E - e*sin(E) = M for the eccentric anomaly,
        given the eccentricity and the mean anomaly.
        E - eccentric anomaly (radians)
        e - eccentricity, passed from the calling program
        M - mean anomaly (radians), passed from the calling program
        pi - 3.1415926...
    '''
    # Select a starting value for E:
    E = M + ((M<np.pi) - 1/2) * e

    # Iterate on Non-linear Equation of E until E is determined to within the error tolerance:
    ratio=np.ones(len(E))
    while np.abs(ratio).max() > 1.0e-6: # error:
        ratio = (E-e*np.sin(E)-M)/(1-e*np.cos(E))
        E -= ratio
        
    return E


def oe2rv_vect(oe, **kwargs):
    # % Converts orbital elements to ECI state
    # %
    # % Input:
    # %   - orbital elements [m, rad]
    # %   - varargin, 'planetGp' in m/s^2

    # % Output:
    # %   - rv [m, m/s], column vector

    # % planetGp - planet gravitational parameter

    if 'planetGp' in kwargs:
        planetGp = np.array(kwargs['planetGp'])
    else:
        planetGp = Consts.muEarth

    sma  = oe[0] # m
    ecc  = oe[1] #  -
    inc  = oe[2] # rad
    RAAN = oe[3] # rad
    AOP  = oe[4] # rad
    MA   = oe[5] # rad



    # E = mean2ecc(MA, ecc);
    E = kepler_E_vect(ecc, MA)

    v = 2 * np.arctan(np.sqrt((1 + ecc) / (1 - ecc)) * np.tan(E / 2))
    r = sma * (1 - ecc ** 2) / (1 + ecc * np.cos(v))    

    zrs = np.zeros(v.shape)
    ons = np.ones(v.shape)
    r_pqw = r * np.vstack([np.cos(v), np.sin(v), zrs])
    v_pqw = np.sqrt(planetGp / (sma * (1 - ecc ** 2))) * np.vstack([-np.sin(v), ecc + np.cos(v), zrs])
    
    Rz_O = np.vstack([np.cos(RAAN), -np.sin(RAAN), zrs,
            np.sin(RAAN), np.cos(RAAN), zrs,
            zrs, zrs, ons]).T.reshape((v.shape[0],3,3))
    
    np.vstack([np.cos(RAAN), -np.sin(RAAN), zrs,
            np.sin(RAAN), np.cos(RAAN), zrs,
            zrs, zrs, ons]).T.reshape((v.shape[0],3,3))[0]
    
    Rx_i = np.vstack([ons, zrs, zrs,
            zrs, np.cos(inc), -np.sin(inc),
            zrs, np.sin(inc), np.cos(inc)]).T.reshape((v.shape[0],3,3))
    
    Rz_w = np.vstack([np.cos(AOP), -np.sin(AOP), zrs,
            np.sin(AOP), np.cos(AOP), zrs,
            zrs, zrs, ons]).T.reshape((v.shape[0],3,3))
    
    # R = np.matmul(np.matmul(Rz_O, Rx_i), Rz_w)
    R = Rz_O @ Rx_i @ Rz_w
    
    r_ijk = np.matmul(R, r_pqw.T.reshape((v.shape[0],3,1))).reshape((v.shape[0],3))
    v_ijk = np.matmul(R, v_pqw.T.reshape((v.shape[0],3,1))).reshape((v.shape[0],3))
    return np.hstack([r_ijk,v_ijk]).reshape((v.shape[0]*6,))


def degrees_to_dms(deg_value):
    # Extract degrees
    degrees = int(deg_value)
    # Calculate minutes from the decimal part
    minutes = int((deg_value - degrees) * 60)
    # Calculate seconds from the remaining decimal part
    seconds = (deg_value - degrees - minutes / 60) * 3600
    return [degrees, minutes, seconds]


def degrees_to_hms(deg_value):
    if deg_value < 0: 
        deg_value = 360 + deg_value  
    # Convert degrees to hours
    hours = int(deg_value / 15)
    # Calculate minutes from the remaining decimal part
    minutes = int((deg_value / 15 - hours) * 60)
    # Calculate seconds from the remaining decimal part
    seconds = ((deg_value / 15 - hours) * 60 - minutes) * 60
    return [hours, minutes, seconds]

