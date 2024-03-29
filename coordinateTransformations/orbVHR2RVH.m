function rv_orb_RVH = orbVHR2RVH(rv_orb_VHR)

    rv_orb_RVH(1:3, 1) = [rv_orb_VHR(3); rv_orb_VHR(1:2)];
    rv_orb_RVH(4:6, 1) = [rv_orb_VHR(6); rv_orb_VHR(4:5)];

end