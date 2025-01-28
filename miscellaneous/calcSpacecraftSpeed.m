function v = calcSpacecraftSpeed(sma, r, mu)

    v = sqrt(2 * mu ./ r - mu ./ sma);

end