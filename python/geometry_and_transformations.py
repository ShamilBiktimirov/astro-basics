import numpy as np
import matplotlib.pyplot as plt
import plotly.graph_objects as go

def cart_to_sph(position_vector):
    # TODO add rho coordinate
    phi_sph = np.arcsin(position_vector[2] / np.linalg.norm(position_vector))

    lambda_sph = np.arctan2(position_vector[1], position_vector[0])

    return phi_sph, lambda_sph

def calc_local_bases_axes(latitude, longitude):

    # find a matrix of unit vectors of local reference frame

    ex = np.vstack([-np.sin(longitude), np.cos(longitude), 0])
    ey = np.vstack([-np.sin(latitude) * np.cos(longitude), -np.sin(latitude) * np.sin(longitude), np.cos(latitude)])
    ez = np.vstack([np.cos(latitude) * np.cos(longitude), np.cos(latitude) * np.sin(longitude), np.sin(latitude)])
                   
    A = np.hstack([ex, ey, ez])
    A = np.transpose(A)   
                   
    return A

def calc_azimuth_and_elevation(r_obs_eci, r_sat_eci):

    # elevation is angle with reference plane - local horizon
    # azimuth is angle from North in clock-wise direction
    
    latitude, longitude = cart_to_sph(r_obs_eci)
    A_eci_to_local = calc_local_bases_axes(latitude, longitude)
    
    r_rel_local = np.matmul(A_eci_to_local, r_sat_eci - r_obs_eci)
    
    x = r_rel_local[0]
    y = r_rel_local[1]
    z = r_rel_local[2]
    
    sin_elev = z / np.linalg.norm(r_rel_local)
    cos_elev = (x**2 + y**2)**(1/2) / np.linalg.norm(r_rel_local)
    
    elev = np.arctan2(sin_elev, cos_elev)
    az = np.arctan2(x, y)
    
    return az, elev

def calc_ra_and_dec_topocentric(r_sat_eci, r_obs_eci):

    # Calculates topocentric celestial coordinates

    r_obs2sat = r_sat_eci - r_obs_eci

    declination_topo, right_ascension_topo = cart_to_sph(r_obs2sat)

    return right_ascension_topo, declination_topo

def calc_geocentric_radius_for_ellipsoid(lat):
    from consts import Consts
    # considers WGS84 model
    # lat is given in radians
    nom = 1 - (2 * Consts.eccEarth**2 - Consts.eccEarth**4) * np.sin(lat)**2
    denom = 1 - Consts.eccEarth**2 * np.sin(lat)**2
    
    r = Consts.rEarthEquatorial * (nom / denom)**(1/2)
    
    return r

def degrees_to_dms(deg_value):
    # input angle in deg -90 to 90
    degrees = int(deg_value)
    # Calculate minutes from the decimal part
    minutes = int((deg_value - degrees) * 60)
    # Calculate seconds from the remaining decimal part
    seconds = (deg_value - degrees - minutes / 60) * 3600
    return [degrees, minutes, seconds]

def degrees_to_hms(deg_value):
    # input angle in deg -180 to 180
    if deg_value < 0: 
        deg_value = 360 + deg_value  
    # Convert degrees to hours
    hours = int(deg_value / 15)
    # Calculate minutes from the remaining decimal part
    minutes = int((deg_value / 15 - hours) * 60)
    # Calculate seconds from the remaining decimal part
    seconds = ((deg_value / 15 - hours) * 60 - minutes) * 60
    return [hours, minutes, seconds]

def plot_sky_s(altaz_coordinates, epochs):
    
    # Set up the polar plot
    fig = plt.figure(figsize=(10, 10))
    ax = fig.add_subplot(projection='polar')
    ax.set_rlim([90, 0])
    ax.set_theta_zero_location('N')
    ticks = [0, np.deg2rad(45), np.deg2rad(90), np.deg2rad(135), np.deg2rad(180), np.deg2rad(225), np.deg2rad(270), np.deg2rad(315)]
    labels = ['N, 0°', 'NE, 45°', 'E, 90°', 'SE, 135°', 'S, 180°', 'SW, 225°', 'W, 270°', 'NW, 315°']
    plt.xticks(ticks, labels)
    ax.set_theta_direction(1)
    
    ax.plot(altaz_coordinates[:,0] * np.pi / 180, altaz_coordinates[:,1], 'bo--')

    for point_idx in range(np.size(epochs)):
        text = epochs[point_idx].strftime('%H:%M')
        ax.text(altaz_coordinates[point_idx,0] * np.pi / 180, altaz_coordinates[point_idx,1], text, ha='right', va='bottom')

    plt.show()


def plot_polar_interactive(celestial_coordinates_array_processed):
    # input:
    # celestial_coordinates_array_processed[:, 0]: time
    # celestial_coordinates_array_processed[:, 1]: right ascension 
    # celestial_coordinates_array_processed[:, 2]: declination
    # celestial_coordinates_array_processed[:, 3]: azimuth, deg
    # celestial_coordinates_array_processed[:, 3]: elevation, deg

      
    labels = []
    for i in range(len(celestial_coordinates_array_processed)):
        labels.append(f"Azimuth: {celestial_coordinates_array_processed [i, 3] % 360:.1f}°<br>Elevation: {celestial_coordinates_array_processed [i, 4]:.1f}°<br>RA: {celestial_coordinates_array_processed [i, 1]}<br>Dec: {celestial_coordinates_array_processed [i, 2]}<br>Time: {celestial_coordinates_array_processed [i, 0]}")
    
    
    # Create an interactive polar plot with Plotly
    fig = go.Figure()
    
    fig.add_trace(go.Scatterpolar(
        r=celestial_coordinates_array_processed[:, 4],
        theta=celestial_coordinates_array_processed[:, 3] % 360,
        mode='lines+markers',
        marker=dict(color='orange', size=5),
        line=dict(color='orange'),
        text=labels,  # Add labels for each point
        textposition="top center",  # Position labels at the top center of each marker
        hoverinfo="text",  # Show text on hover
        name=" Satellite Trajectory"
    ))
    
    
    # Customize layout to match previous appearance
    fig.update_layout(
        polar=dict(
            bgcolor="midnightblue",  # Dark background color
            radialaxis=dict(
                range=[90, 0],  # 90 at center (zenith), 0 at edge (horizon)
                tickvals=[30, 60, 90],  # Tick values for altitude
                ticktext=['30°', '60°', 'Zenith'],  # Altitude labels
                tickfont=dict(color="white"),
                showline=False,
                showticklabels=True,
                ticks="",
       
            ),
            angularaxis=dict(
                direction="counterclockwise",
                rotation=90,  # Rotate to start at north
                tickvals=[0, 45, 90, 135, 180, 225, 270, 315],
                # tickvals=[0, 315, 270, 225, 180, 135, 90, 45],
                ticktext=['N, 0°', 'NE, 45°', 'E, 90°', 'SE, 135°', 'S, 180°', 'SW, 225°', 'W, 270°', 'NW, 315°'],
                # ticktext=['N, 0°', 'NW, 315°', 'W, 270°', 'SW, 225°', 'S, 180°', 'SE, 135°', 'E, 90°', 'NE, 45°'],
                tickfont=dict(color="lime", size=14)
            )
        ),
        title="Satellite Trajectory Above Abu Dhabi",
        font=dict(color="white"),
        showlegend=True,
        legend=dict(font=dict(size=10, color="white")),
        paper_bgcolor="midnightblue",  # Background color for the figure
        width=1500,  # Figure width
        height=1500  # Figure height
    )
    
    fig.show()

    
