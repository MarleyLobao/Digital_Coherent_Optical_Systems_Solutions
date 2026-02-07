function f = maxwell_dist_pdf(tau, a)
    sq_tau = tau.^2;
    f = (sqrt(2/pi)/a^3) .* sq_tau .* exp(-sq_tau/(2*a^2));
end