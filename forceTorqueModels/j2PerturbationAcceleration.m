function aJ2 = j2PerturbationAcceleration(rv)

            %% Vectorized j2 perturbation acceleration
            % input rv [6, nSats], consts

            % output aJ2 [3, nSats]

            %%
            R     = Consts.rEarthEquatorial;
            J2    = Consts.earthJ2;
            mu    = Consts.muEarth;
            delta = 3 / 2 * J2 * mu * R^2;

            nSats = size(rv, 2);
            r_norm = vecnorm(rv(1:3, :));

            % J2 perturbation
            aJ2  = delta ./ (r_norm.^5) .* rv(1:3, :) .* (5 * rv(3, :).^2 ./ r_norm.^2 - 1) - ...
                    2 * delta ./ r_norm.^5 .* [zeros(1, nSats); zeros(1, nSats); rv(3, :)];

end
