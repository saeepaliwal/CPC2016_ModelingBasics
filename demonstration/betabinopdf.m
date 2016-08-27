function y = betabinopdf(x,n,a,b)
    y = exp(gammaln(n + 1)-gammaln(x + 1)-gammaln(n - x + 1)) .* beta((a + x),(b + n - x)) ./ beta(a,b);
end