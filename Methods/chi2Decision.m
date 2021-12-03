function decisionVal = chi2Decision(inputVal, cdf, nDoF)
  % chi2Decision porovnava vstupnu hodnotu voci kriticke hodnote Chi2 rozdelenia
  
  % Chi kvadrat hodnota
	chi2Value = chi2Quantile(cdf, nDoF);
	
	% Porovnani
	decisionVal = (inputVal < chi2Value);
end