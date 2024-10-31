import numpy as np
def calc_local_bases_axes(latitude, longitude):

    ex = np.vstack([-np.sin(longitude), np.cos(longitude), 0])
    ey = np.vstack([-np.sin(latitude) * np.cos(longitude), -np.sin(latitude) * np.sin(longitude), np.cos(latitude)])
    ez = np.vstack([np.cos(latitude) * np.cos(longitude), np.cos(latitude) * np.sin(longitude), np.sin(latitude)])
                   
    A = np.hstack([ex, ey, ez])
    A = np.transpose(A)   
                   
    return A

def calc_local_azimuth_and_elevation(r_obs_eci, r_sat_eci):
    
    longitude, latitude = calc_right_asc_and_declination(r_obs_eci) # because it simply works a cart to sph
    A_eci_to_local = calc_local_bases_axes(latitude, longitude)
    
    r_rel_local = np.matmul(A_eci_to_local, r_sat_eci - r_obs_eci)
    
    x = r_rel_local[0]
    y = r_rel_local[1]
    z = r_rel_local[2]
    
    # see to the f igure for more details on the reference frame and angles
    az, elev = calc_right_asc_and_declination(r_rel_local)    
    return az - np.pi/2, elev

def calc_right_asc_and_declination(position_vector):
    
    x = position_vector[0]
    y = position_vector[1]
    z = position_vector[2]
    
    sin_decl = z / np.linalg.norm(position_vector)
    cos_decl = (x**2 + y**2)**(1/2) / np.linalg.norm(position_vector)
    
    declination = np.arctan2(sin_decl, cos_decl)
    
    sin_ra = y / (x**2 + y**2)**(1/2)
    cos_ra = x / (x**2 + y**2)**(1/2)
    right_ascension = np.arctan2(sin_ra, cos_ra)
    
    return right_ascension, declination

    