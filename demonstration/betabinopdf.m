function y = betabinopdf(k,n,a,b) % Directly from https://en.wikipedia.org/wiki/Beta-binomial_distribution
    y = exp(gammaln(n + 1)-gammaln(k + 1)-gammaln(n - k + 1)) .* beta((k + a),(n - k + b)) ./ beta(a,b);
end