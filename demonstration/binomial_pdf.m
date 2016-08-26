function [out] = binomial_pdf(x,k,n)
out = (factorial(n)/factorial(k)*(factorial(n-k)))*(x.^k).*((1-x).^(n-k));
out = out./sum(out);