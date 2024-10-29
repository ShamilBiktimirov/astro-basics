import numpy as np
def calc_local_bases_axes(latitude, longitude):

    ex = np.vstack([-np.sin(longitude), np.cos(longitude), 0])
    ey = np.vstack([-np.sin(latitude) * np.cos(longitude), -np.sin(latitude) * np.sin(longitude), np.cos(latitude)])
    ez = np.vstack([np.cos(latitude) * np.cos(longitude), np.cos(latitude) * np.sin(longitude), np.sin(latitude)])
                   
    A = np.hstack([ex, ey, ez])
    A = np.transpose(A)   
                   
    return A

def calc_local_azimuth_and_declination(position_vector):
    
    x = position_vector[0]
    y = position_vector[1]
    z = position_vector[2]
    
    azimuth = np.arctan2(-x, y)
    declination = np.arctan2(z, x**2 + y**2)
    
    return azimuth, declination
    
    