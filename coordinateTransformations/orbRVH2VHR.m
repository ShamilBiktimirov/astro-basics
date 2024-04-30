function rv_orb_VHR = orbRVH2VHR(rv_orb_RVH)

    rv_orb_VHR(1:3, 1) = [rv_orb_RVH(2); rv_orb_RVH(3); rv_orb_RVH(1)];
    rv_orb_VHR(4:6, 1) = [rv_orb_RVH(5); rv_orb_RVH(6); rv_orb_RVH(4)];
end