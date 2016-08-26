function [out] = beta_pdf(x,a,b)
out = (x.^(a-1)).*((1-x).^(b-1))/beta(a,b);
out = out./sum(out);