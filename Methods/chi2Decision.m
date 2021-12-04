function decisionVal = chi2Decision(inputVal, cdf, nDoF)
  % CHI2DECISION porovnava vstupnu hodnotu voci kritickej hodnote chi2 rozdelenia
  
  % Chi kvadrat hodnota
	chi2Value = chi2Quantile(cdf, nDoF);
	
	% Porovnanie
	decisionVal = (inputVal < chi2Value);
end