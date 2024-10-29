import numpy as np
def walkerConstellation(T, P, f, a, inc, walkerType):

    oes = np.zeros((T, 6))
    q = T/P
    e = 0
    w = 0

    if walkerType == 'star':
        delta_RAAN = 180/P
    elif walkerType == 'delta':
        delta_RAAN = 360/P;
    else:
        raise('incorrect walker type')

    # i = 0
    # for k in range(P):
    #     for j in range(int(q)):
    #         i = i + 1
    #         RAAN = np.radians( k *delta_RAAN % 360);
    #         M = np.radians( 360*j/q + 360*f*k/T % 360);
    #         oes[i-1,:] = np.array([a, e, inc, RAAN, w, M])


    # ~10 times faster
    oes[:,0] = a
    oes[:,1] = e
    oes[:,2] = inc
    oes[:,3] = np.radians( (np.arange(T)//P) *delta_RAAN % 360)
    oes[:,4] = w
    oes[:,5] = np.radians( 360*(np.arange(T)%P)/q + 360*f*(np.arange(T)//P)/T % 360)   
    
    return oes
